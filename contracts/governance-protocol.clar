;; Governance Protocol Contract
;; Manages democratic decision-making

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_PROPOSAL_NOT_FOUND (err u201))
(define-constant ERR_ALREADY_VOTED (err u202))
(define-constant ERR_VOTING_CLOSED (err u203))
(define-constant ERR_INSUFFICIENT_STAKE (err u204))

;; Data Variables
(define-data-var proposal-counter uint u0)
(define-data-var voting-period uint u1440) ;; ~10 days in blocks

;; Data Maps
(define-map proposals uint {
  title: (string-ascii 100),
  description: (string-ascii 500),
  proposer: principal,
  start-block: uint,
  end-block: uint,
  yes-votes: uint,
  no-votes: uint,
  total-stake-voted: uint,
  executed: bool
})

(define-map votes { proposal-id: uint, voter: principal } {
  vote: bool,
  stake-weight: uint
})

;; Read-only functions
(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals proposal-id)
)

(define-read-only (get-vote (proposal-id uint) (voter principal))
  (map-get? votes { proposal-id: proposal-id, voter: voter })
)

(define-read-only (has-voted (proposal-id uint) (voter principal))
  (is-some (map-get? votes { proposal-id: proposal-id, voter: voter }))
)

;; Public functions
(define-public (create-proposal (title (string-ascii 100)) (description (string-ascii 500)))
  (let ((proposal-id (+ (var-get proposal-counter) u1))
        (start-block block-height)
        (end-block (+ block-height (var-get voting-period))))

    ;; Check if member (assuming member verification contract)
    (asserts! (> (len title) u0) ERR_UNAUTHORIZED)

    (map-set proposals proposal-id {
      title: title,
      description: description,
      proposer: tx-sender,
      start-block: start-block,
      end-block: end-block,
      yes-votes: u0,
      no-votes: u0,
      total-stake-voted: u0,
      executed: false
    })

    (var-set proposal-counter proposal-id)
    (ok proposal-id)
  )
)

(define-public (vote (proposal-id uint) (vote-yes bool) (stake-weight uint))
  (let ((proposal (unwrap! (map-get? proposals proposal-id) ERR_PROPOSAL_NOT_FOUND)))
    (asserts! (<= block-height (get end-block proposal)) ERR_VOTING_CLOSED)
    (asserts! (is-none (map-get? votes { proposal-id: proposal-id, voter: tx-sender })) ERR_ALREADY_VOTED)
    (asserts! (> stake-weight u0) ERR_INSUFFICIENT_STAKE)

    ;; Record vote
    (map-set votes { proposal-id: proposal-id, voter: tx-sender } {
      vote: vote-yes,
      stake-weight: stake-weight
    })

    ;; Update proposal vote counts
    (let ((updated-proposal
           (if vote-yes
             (merge proposal {
               yes-votes: (+ (get yes-votes proposal) u1),
               total-stake-voted: (+ (get total-stake-voted proposal) stake-weight)
             })
             (merge proposal {
               no-votes: (+ (get no-votes proposal) u1),
               total-stake-voted: (+ (get total-stake-voted proposal) stake-weight)
             }))))
      (map-set proposals proposal-id updated-proposal)
    )

    (ok true)
  )
)

(define-public (execute-proposal (proposal-id uint))
  (let ((proposal (unwrap! (map-get? proposals proposal-id) ERR_PROPOSAL_NOT_FOUND)))
    (asserts! (> block-height (get end-block proposal)) ERR_VOTING_CLOSED)
    (asserts! (not (get executed proposal)) ERR_UNAUTHORIZED)
    (asserts! (> (get yes-votes proposal) (get no-votes proposal)) ERR_UNAUTHORIZED)

    ;; Mark as executed
    (map-set proposals proposal-id
      (merge proposal { executed: true })
    )

    (ok true)
  )
)
