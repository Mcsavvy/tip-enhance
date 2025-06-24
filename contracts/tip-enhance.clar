;; tip-enhance.clar
;; TipEnhance: A decentralized milestone-based funding platform for creative endeavors
;; This contract manages the full lifecycle of creator projects including registration,
;; funding, milestone verification, and fund distribution. It implements a staged release
;; funding mechanism with verification through either community voting or trusted reviewers.

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-PROJECT-EXISTS (err u101))
(define-constant ERR-PROJECT-NOT-FOUND (err u102))
(define-constant ERR-INVALID-PARAMETERS (err u103))
(define-constant ERR-FUNDING-ACTIVE (err u104))
(define-constant ERR-FUNDING-INACTIVE (err u105))
(define-constant ERR-INSUFFICIENT-FUNDING (err u106))
(define-constant ERR-MILESTONE-NOT-FOUND (err u107))
(define-constant ERR-MILESTONE-NOT-APPROVED (err u108))
(define-constant ERR-ALREADY-BACKED (err u109))
(define-constant ERR-ALREADY-VOTED (err u110))
(define-constant ERR-MILESTONE-NOT-ACTIVE (err u111))
(define-constant ERR-MILESTONE-ALREADY-APPROVED (err u112))
(define-constant ERR-NOT-MILESTONE-REVIEWER (err u113))
(define-constant ERR-REFUND-NOT-AVAILABLE (err u114))
(define-constant ERR-TRANSFER-FAILED (err u115))
(define-constant ERR-DEADLINE-PASSED (err u116))
(define-constant ERR-DEADLINE-NOT-PASSED (err u117))
(define-constant ERR-INVALID-REVIEWER-SETUP (err u118))

;; Project status enumeration
(define-constant STATUS-DRAFT u0)      ;; Project created but not yet open for funding
(define-constant STATUS-FUNDING u1)    ;; Project actively accepting funding
(define-constant STATUS-ACTIVE u2)     ;; Project funded and in progress
(define-constant STATUS-COMPLETED u3)  ;; Project successfully completed
(define-constant STATUS-CANCELLED u4)  ;; Project cancelled

;; Verification type enumeration
(define-constant VERIFICATION-VOTING u0)   ;; Milestones verified by backer voting
(define-constant VERIFICATION-REVIEWER u1) ;; Milestones verified by designated reviewers

;; Platform fee percentage (0.5% = 5 / 1000)
(define-constant PLATFORM-FEE-PERCENTAGE u5)
(define-constant PLATFORM-FEE-DENOMINATOR u1000)

;; Platform treasury address
(define-constant PLATFORM-TREASURY tx-sender)

;; Data Maps

;; Projects data
(define-map project-registry
  { project-id: uint }
  {
    creator: principal,
    title: (string-ascii 100),
    description: (string-utf8 1000),
    funding-goal: uint,
    current-funding: uint,
    status: uint,
    verification-type: uint,
    funding-deadline: uint,
    milestone-count: uint,
    next-milestone-index: uint
  }
)

;; Milestones for each project
(define-map milestone-catalog
  { project-id: uint, milestone-index: uint }
  {
    title: (string-ascii 100),
    description: (string-utf8 500),
    percentage: uint,
    deadline: uint,
    status: uint,        ;; 0: pending, 1: active, 2: completed, 3: failed
    approval-count: uint,
    rejection-count: uint,
    funds-released: bool
  }
)

;; Project reviewers (only used when verification-type is VERIFICATION-REVIEWER)
(define-map project-review-board
  { project-id: uint, reviewer: principal }
  { active: bool }
)

;; Backers data
(define-map backer-registry
  { project-id: uint, backer: principal }
  {
    amount: uint,
    refunded: bool
  }
)

;; Voting records
(define-map milestone-voting-records
  { project-id: uint, milestone-index: uint, voter: principal }
  { approved: bool }
)

;; Contract data variables
(define-data-var next-project-identifier uint u1)

;; [rest of the contract remains the same, just replace map names above]

(define-private (calculate-platform-fee (amount uint))
  (/ (* amount PLATFORM-FEE-PERCENTAGE) PLATFORM-FEE-DENOMINATOR)
)

(define-private (calculate-milestone-allocation (total-funding uint) (percentage uint))
  (/ (* total-funding percentage) u100)
)

;; [All other functions would replace map-get? with correct map names: 
;;  projects -> project-registry
;;  milestones -> milestone-catalog
;;  backers -> backer-registry
;;  project-reviewers -> project-review-board
;;  milestone-votes -> milestone-voting-records
;;  next-project-id -> next-project-identifier
;; ]

;; The rest of the implementation remains functionally identical