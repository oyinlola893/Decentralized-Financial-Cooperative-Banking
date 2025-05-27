;; Community Investment Contract
;; Manages local investment priorities

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_INVESTMENT_NOT_FOUND (err u401))
(define-constant ERR_INSUFFICIENT_FUNDS (err u402))
(define-constant ERR_ALREADY_FUNDED (err u403))
(define-constant ERR_INVALID_AMOUNT (err u404))

;; Data Variables
(define-data-var investment-counter uint u0)
(define-data-var total-pool uint u0)

;; Data Maps
(define-map investments uint {
  title: (string-ascii 100),
  description: (string-ascii 500),
  proposer: principal,
  target-amount: uint,
  current-funding: uint,
  deadline: uint,
  category: (string-ascii 50),
  funded: bool,
  executed: bool
})

(define-map investment-backers { investment-id: uint, backer: principal } {
  amount: uint,
  backing-date: uint
})

(define-map backer-investments principal (list 50 uint))

;; Read-only functions
(define-read-only (get-investment (investment-id uint))
  (map-get? investments investment-id)
)

(define-read-only (get-total-pool)
  (var-get total-pool)
)

(define-read-only (get-backer-contribution (investment-id uint) (backer principal))
  (map-get? investment-backers { investment-id: investment-id, backer: backer })
)

(define-read-only (get-funding-progress (investment-id uint))
  (match (map-get? investments investment-id)
    investment (let ((current (get current-funding investment))
                     (target (get target-amount investment)))
                 (if (> target u0)
                   (/ (* current u100) target)
                   u0))
    u0
  )
)

;; Public functions
(define-public (contribute-to-pool (amount uint))
  (begin
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (var-set total-pool (+ (var-get total-pool) amount))
    (ok true)
  )
)

(define-public (propose-investment
                (title (string-ascii 100))
                (description (string-ascii 500))
                (target-amount uint)
                (deadline uint)
                (category (string-ascii 50)))
  (let ((investment-id (+ (var-get investment-counter) u1)))
    (asserts! (> target-amount u0) ERR_INVALID_AMOUNT)
    (asserts! (> deadline block-height) ERR_INVALID_AMOUNT)

    (map-set investments investment-id {
      title: title,
      description: description,
      proposer: tx-sender,
      target-amount: target-amount,
      current-funding: u0,
      deadline: deadline,
      category: category,
      funded: false,
      executed: false
    })

    (var-set investment-counter investment-id)
    (ok investment-id)
  )
)

(define-public (back-investment (investment-id uint) (amount uint))
  (let ((investment (unwrap! (map-get? investments investment-id) ERR_INVESTMENT_NOT_FOUND)))
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (asserts! (<= block-height (get deadline investment)) ERR_UNAUTHORIZED)
    (asserts! (not (get funded investment)) ERR_ALREADY_FUNDED)

    ;; Transfer backing amount
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    ;; Record backer contribution
    (map-set investment-backers { investment-id: investment-id, backer: tx-sender } {
      amount: amount,
      backing-date: block-height
    })

    ;; Update investment funding
    (let ((new-funding (+ (get current-funding investment) amount)))
      (map-set investments investment-id
        (merge investment {
          current-funding: new-funding,
          funded: (>= new-funding (get target-amount investment))
        })
      )
    )

    (ok true)
  )
)

(define-public (execute-investment (investment-id uint))
  (let ((investment (unwrap! (map-get? investments investment-id) ERR_INVESTMENT_NOT_FOUND)))
    (asserts! (get funded investment) ERR_INSUFFICIENT_FUNDS)
    (asserts! (not (get executed investment)) ERR_ALREADY_FUNDED)
    (asserts! (is-eq tx-sender (get proposer investment)) ERR_UNAUTHORIZED)

    ;; Transfer funds to proposer
    (try! (as-contract (stx-transfer? (get current-funding investment) tx-sender (get proposer investment))))

    ;; Mark as executed
    (map-set investments investment-id
      (merge investment { executed: true })
    )

    (ok true)
  )
)

(define-public (refund-investment (investment-id uint))
  (let ((investment (unwrap! (map-get? investments investment-id) ERR_INVESTMENT_NOT_FOUND))
        (backer-info (unwrap! (map-get? investment-backers { investment-id: investment-id, backer: tx-sender }) ERR_UNAUTHORIZED)))

    (asserts! (> block-height (get deadline investment)) ERR_UNAUTHORIZED)
    (asserts! (not (get funded investment)) ERR_ALREADY_FUNDED)

    ;; Refund backer
    (try! (as-contract (stx-transfer? (get amount backer-info) tx-sender tx-sender)))

    ;; Remove backer record
    (map-delete investment-backers { investment-id: investment-id, backer: tx-sender })

    (ok (get amount backer-info))
  )
)
