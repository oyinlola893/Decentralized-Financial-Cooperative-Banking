# Decentralized Financial Cooperative Banking

A comprehensive blockchain-based cooperative banking system built on Stacks using Clarity smart contracts. This system enables democratic financial governance, profit sharing, community investment, and mutual support among cooperative members.

## 🏦 System Overview

The Decentralized Financial Cooperative Banking system consists of five interconnected smart contracts that work together to create a fully functional cooperative banking platform:

### Core Contracts

1. **Member Verification Contract** (`member-verification.clar`)
    - Validates and manages cooperative bank members
    - Handles membership applications and endorsements
    - Manages member stakes and reputation scores

2. **Governance Protocol Contract** (`governance-protocol.clar`)
    - Facilitates democratic decision-making
    - Manages proposal creation and voting
    - Implements stake-weighted voting system

3. **Profit Sharing Contract** (`profit-sharing.clar`)
    - Distributes cooperative benefits to members
    - Calculates profit shares based on member stakes
    - Manages distribution periods and claims

4. **Community Investment Contract** (`community-investment.clar`)
    - Manages local investment priorities
    - Facilitates community-driven funding
    - Handles investment proposals and backing

5. **Mutual Support Contract** (`mutual-support.clar`)
    - Enables member mutual assistance
    - Manages emergency fund contributions
    - Facilitates peer-to-peer support requests

## 🚀 Features

### Member Management
- **Stake-based Membership**: Members must stake a minimum amount to join
- **Endorsement System**: Existing members endorse new applications
- **Reputation Tracking**: Dynamic reputation scores for members
- **Democratic Approval**: Community-driven membership approval process

### Democratic Governance
- **Proposal System**: Members can create and vote on proposals
- **Stake-weighted Voting**: Voting power proportional to member stakes
- **Time-bound Voting**: Proposals have defined voting periods
- **Execution Framework**: Approved proposals can be executed

### Profit Distribution
- **Automated Calculation**: Profit shares calculated based on member stakes
- **Periodic Distribution**: Regular profit distribution cycles
- **Claim System**: Members claim their profit shares individually
- **Transparent Tracking**: Full visibility into profit distributions

### Community Investment
- **Investment Proposals**: Members propose community investments
- **Crowdfunding**: Community backing for investment projects
- **Category-based Organization**: Investments organized by categories
- **Deadline Management**: Time-bound investment campaigns
- **Refund Mechanism**: Automatic refunds for unfunded projects

### Mutual Support
- **Support Requests**: Members can request financial assistance
- **Peer Support**: Community members provide mutual aid
- **Emergency Fund**: Collective emergency assistance fund
- **Support History**: Tracking of support given and received
- **Urgent Requests**: Priority handling for urgent needs

## 📋 Contract Functions

### Member Verification Contract

#### Read-Only Functions
- `is-member(member)` - Check if address is a verified member
- `get-member-info(member)` - Get member details and stats
- `get-min-stake()` - Get minimum stake requirement

#### Public Functions
- `apply-for-membership(stake-amount)` - Apply for cooperative membership
- `endorse-application(applicant)` - Endorse a membership application
- `approve-membership(applicant)` - Approve membership (owner only)
- `update-reputation(member, new-score)` - Update member reputation

### Governance Protocol Contract

#### Read-Only Functions
- `get-proposal(proposal-id)` - Get proposal details
- `get-vote(proposal-id, voter)` - Get specific vote information
- `has-voted(proposal-id, voter)` - Check if member has voted

#### Public Functions
- `create-proposal(title, description)` - Create new governance proposal
- `vote(proposal-id, vote-yes, stake-weight)` - Vote on proposal
- `execute-proposal(proposal-id)` - Execute approved proposal

### Profit Sharing Contract

#### Read-Only Functions
- `get-total-profits()` - Get current profit pool
- `get-distribution-info(period)` - Get distribution period details
- `calculate-member-share(stake, total-stakes, profits)` - Calculate profit share

#### Public Functions
- `deposit-profits(amount)` - Deposit profits for distribution
- `initiate-distribution(total-stakes)` - Start profit distribution period
- `claim-profit-share(period, member-stake)` - Claim profit share

### Community Investment Contract

#### Read-Only Functions
- `get-investment(investment-id)` - Get investment details
- `get-funding-progress(investment-id)` - Get funding percentage
- `get-total-pool()` - Get community investment pool

#### Public Functions
- `propose-investment(title, description, target, deadline, category)` - Propose investment
- `back-investment(investment-id, amount)` - Back an investment
- `execute-investment(investment-id)` - Execute funded investment

### Mutual Support Contract

#### Read-Only Functions
- `get-support-request(request-id)` - Get support request details
- `get-member-history(member)` - Get member support history
- `get-emergency-fund()` - Get emergency fund balance

#### Public Functions
- `create-support-request(title, description, amount, deadline, category, urgent)` - Request support
- `support-member(request-id, amount, message)` - Provide support
- `emergency-assistance(member, amount, reason)` - Emergency fund assistance

## 🔧 Installation & Deployment

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Stacks wallet for testing

### Deployment Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd defi-cooperative-banking
   ```

2. **Deploy contracts in order**
   ```bash
   # Deploy member verification first
   clarinet deploy contracts/member-verification.clar
   
   # Deploy other contracts
   clarinet deploy contracts/governance-protocol.clar
   clarinet deploy contracts/profit-sharing.clar
   clarinet deploy contracts/community-investment.clar
   clarinet deploy contracts/mutual-support.clar
   ```

3. **Initialize the system**
    - Set minimum stake requirements
    - Configure voting periods
    - Initialize emergency fund

## 🧪 Testing

The system includes comprehensive tests using Vitest. Run tests with:

```bash
npm test
```

Test coverage includes:
- Member verification workflows
- Governance proposal lifecycle
- Profit distribution mechanics
- Investment funding cycles
- Mutual support operations

## 🔐 Security Features

- **Access Control**: Role-based permissions for sensitive operations
- **Stake Requirements**: Financial commitment ensures member alignment
- **Time Locks**: Voting periods prevent rushed decisions
- **Validation**: Input validation and error handling
- **Emergency Controls**: Owner emergency functions for critical situations

## 🤝 Usage Examples

### Becoming a Member
1. Apply for membership with required stake
2. Get endorsements from existing members
3. Wait for approval from governance
4. Start participating in cooperative activities

### Creating a Proposal
1. Draft proposal with clear title and description
2. Submit through governance contract
3. Campaign for votes during voting period
4. Execute if approved by majority

### Requesting Support
1. Create detailed support request
2. Set reasonable deadline and amount
3. Community members provide backing
4. Withdraw funds when target is met

## 📊 Economic Model

The cooperative operates on principles of:
- **Shared Ownership**: Members own stake in the cooperative
- **Democratic Control**: One member, one vote (stake-weighted)
- **Profit Sharing**: Benefits distributed based on participation
- **Community Investment**: Local economic development focus
- **Mutual Aid**: Members support each other in times of need

## 🛣️ Roadmap

- [ ] Integration with DeFi protocols
- [ ] Mobile application interface
- [ ] Advanced governance mechanisms
- [ ] Cross-chain compatibility
- [ ] Regulatory compliance tools

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests for any improvements.

## 📞 Support

For questions and support, please open an issue in the GitHub repository or contact the development team.
