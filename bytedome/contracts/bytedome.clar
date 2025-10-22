;; Tokenized Data Marketplace
;; Enables the buying, selling, and licensing of data sets with
;; privacy controls and usage tracking

;; Define SIP-010 token trait (using a more generic approach)
(define-trait sip-010-trait
  (
    (transfer (uint principal principal (optional (buff 34))) (response bool uint))
    (get-name () (response (string-ascii 32) uint))
    (get-symbol () (response (string-ascii 32) uint))
    (get-decimals () (response uint uint))
    (get-balance (principal) (response uint uint))
    (get-total-supply () (response uint uint))
    (get-token-uri () (response (optional (string-utf8 256)) uint))
  ))

;; Constants
(define-constant OWNER tx-sender)
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-INVALID-PARAMS (err u102))
(define-constant ERR-ALREADY-EXISTS (err u103))
(define-constant ERR-INSUFFICIENT-FUNDS (err u104))
(define-constant ERR-EXPIRED (err u105))
(define-constant ERR-DISPUTED (err u106))
(define-constant ERR-INACTIVE (err u107))

;; Data asset registry
(define-map assets
  { aid: uint }
  {
    name: (string-utf8 128),
    details: (string-utf8 1024),
    holder: principal,
    established-at: uint,
    type: (string-ascii 32),
    category: (string-ascii 64),
    sample-url: (optional (string-utf8 256)),
    meta-loc: (string-utf8 256),
    example-url: (optional (string-utf8 256)),
    schema-url: (optional (string-utf8 256)),
    size-bytes: uint,
    hash: (buff 64),
    security: (string-ascii 32),
    refresh: (string-ascii 32),
    modified-at: uint,
    rating: (optional uint),
    validated: bool,
    enabled: bool,
    tx-count: uint,
    earnings: uint,
    commission: uint
  })

;; Data use licenses
(define-map licenses
  { lid: uint }
  {
    title: (string-utf8 64),
    details: (string-utf8 512),
    author: principal,
    established-at: uint,
    commercial: bool,
    derivatives: bool,
    credit-req: bool,
    reciprocal: bool,
    cancelable: bool,
    geo-restricted: bool,
    std-id: (optional (string-ascii 16)),
    url: (string-utf8 256),
    usage-terms: (string-utf8 512),
    liability-terms: (string-utf8 512),
    confidentiality: (string-utf8 512),
    enabled: bool
  })

;; Asset marketplace listings
(define-map listings
  { oid: uint }
  {
    aid: uint,
    vendor: principal,
    established-at: uint,
    cost: uint,
    currency: (string-ascii 8),
    token-addr: (optional principal),
    lid: uint,
    delivery: (string-ascii 16),
    period: (optional uint),
    buyer-limit: (optional uint),
    geo-limits: (list 10 (string-ascii 2)),
    enabled: bool,
    featured: bool,
    min-rep: (optional uint),
    deposit-pct: uint
  })

;; Data purchases
(define-map purchases
  { pid: uint }
  {
    oid: uint,
    buyer: principal,
    completed-at: uint,
    amount: uint,
    lid: uint,
    key-hash: (buff 32),
    key-encrypted: (buff 256),
    expires-at: (optional uint),
    status: (string-ascii 16),
    accessed-at: (optional uint),
    access-cnt: uint,
    auto-renew: (optional bool),
    cancel-reason: (optional (string-utf8 256))
  })

;; Data access logs
(define-map logs
  { pid: uint, eid: uint }
  {
    buyer: principal,
    logged-at: uint,
    method: (string-ascii 16),
    search-params: (optional (string-utf8 256)),
    subset: (optional (string-utf8 256)),
    addr-hash: (optional (buff 32)),
    op-hash: (buff 32),
    completed: bool,
    error-msg: (optional (string-utf8 256))
  })

;; Reputation scores
(define-map reputation
  { account: principal }
  {
    vendor-score: uint,
    buyer-score: uint,
    quality-score: uint,
    disputes-filed: uint,
    disputes-lost: uint,
    tx-count: uint,
    purchase-count: uint,
    avg-quality: uint,
    review-count: uint,
    verified: bool
  })

;; Reviews
(define-map feedback
  { reviewer: principal, aid: uint }
  {
    score: uint,
    comment: (string-utf8 512),
    posted-at: uint,
    pid: uint,
    quality-rating: uint,
    accuracy-rating: uint,
    completeness-rating: uint,
    usefulness-rating: uint,
    verified-purchase: bool,
    upvotes: uint,
    downvotes: uint
  })

;; Data disputes
(define-map disputes
  { did: uint }
  {
    pid: uint,
    claimant: principal,
    defendant: principal,
    filed-at: uint,
    reason: (string-utf8 512),
    proof-hash: (buff 32),
    status: (string-ascii 16),
    resolution: (optional (string-utf8 512)),
    resolved-at: (optional uint),
    arbitrator: (optional principal),
    refund-pct: (optional uint),
    appeal-deadline: (optional uint),
    appealed: bool
  })

;; Escrow funds
(define-map escrow
  { pid: uint }
  {
    amount: uint,
    vendor: principal,
    buyer: principal,
    conditions: (string-utf8 256),
    release-at: (optional uint),
    released: bool,
    disputed: bool
  })

;; Data validators
(define-map validators
  { val: principal }
  {
    title: (string-utf8 64),
    details: (string-utf8 512),
    expertise: (list 10 (string-ascii 32)),
    commission: uint,
    assessments: uint,
    avg-rating: uint,
    joined-at: uint,
    enabled: bool
  })

;; Validation reports
(define-map reports
  { aid: uint, val: principal }
  {
    doc-hash: (buff 32),
    filed-at: uint,
    quality-score: uint,
    accuracy-score: uint,
    completeness-score: uint,
    reliability-score: uint,
    methodology: (string-utf8 256),
    issues: (list 10 (string-utf8 128)),
    recommendations: (string-utf8 512),
    level: (string-ascii 16),
    valid-until: (optional uint)
  })

;; Data categories
(define-map categories
  { cid: uint }
  {
    title: (string-ascii 64),
    details: (string-utf8 256),
    parent: (optional uint),
    established-at: uint,
    asset-count: uint,
    popularity: uint,
    trending: bool
  })

;; Next available IDs
(define-data-var next-aid uint u1)
(define-data-var next-lid uint u1)
(define-data-var next-oid uint u1)
(define-data-var next-pid uint u1)
(define-data-var next-did uint u1)
(define-data-var next-cid uint u1)
(define-map next-eid { pid: uint } { id: uint })

;; Protocol configuration
(define-data-var fee-pct uint u250)
(define-data-var fee-addr principal OWNER)
(define-data-var dispute-fee uint u5000000)
(define-data-var escrow-period uint u1440)
(define-data-var min-rep-threshold uint u30)

;; Input validation functions
(define-private (validate-string-length (str (string-utf8 1024)) (max-len uint))
  (if (<= (len str) max-len)
    (ok true)
    ERR-INVALID-PARAMS
  ))

(define-private (validate-ascii-length (str (string-ascii 64)) (max-len uint))
  (if (<= (len str) max-len)
    (ok true)
    ERR-INVALID-PARAMS
  ))

(define-private (validate-buffer-length (buf (buff 256)) (max-len uint))
  (if (<= (len buf) max-len)
    (ok true)
    ERR-INVALID-PARAMS
  ))

(define-private (validate-percentage (pct uint))
  (if (<= pct u10000)
    (ok true)
    ERR-INVALID-PARAMS
  ))

(define-private (validate-rating (r uint))
  (if (and (>= r u1) (<= r u5))
    (ok true)
    ERR-INVALID-PARAMS
  ))

(define-private (validate-score (s uint))
  (if (<= s u100)
    (ok true)
    ERR-INVALID-PARAMS
  ))

(define-private (validate-uint-range (val uint) (min-v uint) (max-v uint))
  (if (and (>= val min-v) (<= val max-v))
    (ok true)
    ERR-INVALID-PARAMS
  ))

(define-private (validate-non-zero (val uint))
  (if (> val u0)
    (ok true)
    ERR-INVALID-PARAMS
  ))

;; Update reputation based on review
(define-private (update-reputation-from-review (vendor principal) (q-rating uint))
  (let
    ((curr-rep (default-to
                    {
                     vendor-score: u50,
                     buyer-score: u50,
                     quality-score: u50,
                     disputes-filed: u0,
                     disputes-lost: u0,
                     tx-count: u0,
                     purchase-count: u0,
                     avg-quality: u0,
                     review-count: u0,
                     verified: false
                   }
                   (map-get? reputation { account: vendor }))))
    
    (let
      ((rev-cnt (+ (get review-count curr-rep) u1))
       (new-avg (if (> (get review-count curr-rep) u0)
                          (/ (+ (* (get avg-quality curr-rep) (get review-count curr-rep))
                                (* q-rating u20))
                             rev-cnt)
                          (* q-rating u20))))
      
      (map-set reputation
        { account: vendor }
        (merge curr-rep
          {
            avg-quality: new-avg,
            review-count: rev-cnt,
            quality-score: new-avg
          }
        )
      )
      
      (ok true)
    )
  ))

;; Update reputations based on dispute outcome
(define-private (update-reputation-from-dispute
                (buyer principal)
                (vendor principal)
                (refund-pct uint))
  (let
    ((buyer-rep (default-to
                  {
                   vendor-score: u50,
                   buyer-score: u50,
                   quality-score: u50,
                   disputes-filed: u0,
                   disputes-lost: u0,
                   tx-count: u0,
                   purchase-count: u0,
                   avg-quality: u0,
                   review-count: u0,
                   verified: false
                 }
                 (map-get? reputation { account: buyer })))
     (vendor-rep (default-to
                   {
                    vendor-score: u50,
                    buyer-score: u50,
                    quality-score: u50,
                    disputes-filed: u0,
                    disputes-lost: u0,
                    tx-count: u0,
                    purchase-count: u0,
                    avg-quality: u0,
                    review-count: u0,
                    verified: false
                  }
                  (map-get? reputation { account: vendor }))))
    
    (map-set reputation
      { account: buyer }
      (merge buyer-rep
        {
          disputes-filed: (+ (get disputes-filed buyer-rep) u1),
          disputes-lost: (if (< refund-pct u5000)
                           (+ (get disputes-lost buyer-rep) u1)
                          (get disputes-lost buyer-rep))
        }
      )
    )
    
    (map-set reputation
      { account: vendor }
      (merge vendor-rep
        {
          disputes-lost: (if (> refund-pct u5000)
                          (+ (get disputes-lost vendor-rep) u1)
                          (get disputes-lost vendor-rep))
        }
      )
    )
    
    (ok true)
  ))

;; Create an escrow for a purchase
(define-private (create-escrow
                (pid uint)
                (vendor principal)
                (buyer principal)
                (amt uint))
  (begin
    (asserts! (> pid u0) ERR-INVALID-PARAMS)
    (asserts! (> amt u0) ERR-INVALID-PARAMS)
    
    (map-set escrow
      { pid: pid }
      {
        amount: amt,
        vendor: vendor,
        buyer: buyer,
        conditions: u"Automatic release after escrow period if no disputes",
        release-at: (some (+ block-height (var-get escrow-period))),
        released: false,
        disputed: false
      }
    )
    
    (ok true)
  ))

;; Resolve escrow based on dispute resolution
(define-private (resolve-escrow (pid uint) (refund-pct uint))
  (let
    ((esc (unwrap! (map-get? escrow { pid: pid }) ERR-NOT-FOUND)))
    
    (asserts! (> pid u0) ERR-INVALID-PARAMS)
    (asserts! (<= refund-pct u10000) ERR-INVALID-PARAMS)
    
    (let
      ((buyer-amt (/ (* (get amount esc) refund-pct) u10000))
       (vendor-amt (- (get amount esc) buyer-amt)))
      
      (if (> buyer-amt u0)
          (unwrap! (as-contract (stx-transfer? buyer-amt tx-sender (get buyer esc))) ERR-INVALID-PARAMS)
          true
      )
      
      (if (> vendor-amt u0)
          (unwrap! (as-contract (stx-transfer? vendor-amt tx-sender (get vendor esc))) ERR-INVALID-PARAMS)
          true
      )
      
      (map-set escrow
        { pid: pid }
        (merge esc { released: true })
      )
      
      (ok true)
    )
  ))

;; Register a new data asset
(define-public (register-data-asset
                (name (string-utf8 128))
                (details (string-utf8 1024))
                (type (string-ascii 32))
                (category (string-ascii 64))
                (meta-loc (string-utf8 256))
                (sample-url (optional (string-utf8 256)))
                (example-url (optional (string-utf8 256)))
                (schema-url (optional (string-utf8 256)))
                (size-bytes uint)
                (hash (buff 64))
                (security (string-ascii 32))
                (refresh (string-ascii 32))
                (commission uint))
  (let
    ((aid (var-get next-aid))
     (v-name (begin (try! (validate-string-length name u128)) name))
     (v-details (begin (try! (validate-string-length details u1024)) details))
     (v-type (begin (try! (validate-ascii-length type u32)) type))
     (v-category (begin (try! (validate-ascii-length category u64)) category))
     (v-meta-loc (begin (try! (validate-string-length meta-loc u256)) meta-loc))
     (v-hash (begin (try! (validate-buffer-length hash u64)) hash))
     (v-security (begin (try! (validate-ascii-length security u32)) security))
     (v-refresh (begin (try! (validate-ascii-length refresh u32)) refresh))
     (v-commission (begin (try! (validate-uint-range commission u0 u3000)) commission))
     (v-size-bytes (begin (try! (validate-non-zero size-bytes)) size-bytes)))
    
    (asserts! (is-valid-type v-type) ERR-INVALID-PARAMS)
    (asserts! (is-valid-security v-security) ERR-INVALID-PARAMS)
    (asserts! (is-valid-refresh v-refresh) ERR-INVALID-PARAMS)
    
    (match sample-url
      url (try! (validate-string-length url u256))
      true
    )
    (match example-url
      url (try! (validate-string-length url u256))
      true
    )
    (match schema-url
      url (try! (validate-string-length url u256))
      true
    )
    
    (map-set assets
      { aid: aid }
      {
        name: v-name,
        details: v-details,
        holder: tx-sender,
        established-at: block-height,
        type: v-type,
        category: v-category,
        sample-url: sample-url,
        meta-loc: v-meta-loc,
        example-url: example-url,
        schema-url: schema-url,
        size-bytes: v-size-bytes,
        hash: v-hash,
        security: v-security,
        refresh: v-refresh,
        modified-at: block-height,
        rating: none,
        validated: false,
        enabled: true,
        tx-count: u0,
        earnings: u0,
        commission: v-commission
      }
    )
    
    (var-set next-aid (+ aid u1))
    
    (ok aid)
  ))

;; Check if data type is valid
(define-private (is-valid-type (type (string-ascii 32)))
  (or (is-eq type "dataset")
      (or (is-eq type "api")
          (or (is-eq type "stream")
              (or (is-eq type "model")
                  (is-eq type "algorithm"))))))

;; Check if encryption type is valid
(define-private (is-valid-security (security (string-ascii 32)))
  (or (is-eq security "none")
      (or (is-eq security "symmetric")
          (or (is-eq security "asymmetric")
              (is-eq security "hybrid")))))

;; Check if update frequency is valid
(define-private (is-valid-refresh (refresh (string-ascii 32)))
  (or (is-eq refresh "static")
      (or (is-eq refresh "daily")
          (or (is-eq refresh "weekly")
              (or (is-eq refresh "monthly")
                  (is-eq refresh "realtime"))))))

;; Create a license type
(define-public (create-license-type
                (title (string-utf8 64))
                (details (string-utf8 512))
                (commercial bool)
                (derivatives bool)
                (credit-req bool)
                (reciprocal bool)
                (cancelable bool)
                (geo-restricted bool)
                (std-id (optional (string-ascii 16)))
                (url (string-utf8 256))
                (usage-terms (string-utf8 512))
                (liability-terms (string-utf8 512))
                (confidentiality (string-utf8 512)))
  (let
    ((lid (var-get next-lid))
     (v-title (begin (try! (validate-string-length title u64)) title))
     (v-details (begin (try! (validate-string-length details u512)) details))
     (v-url (begin (try! (validate-string-length url u256)) url))
     (v-usage-terms (begin (try! (validate-string-length usage-terms u512)) usage-terms))
     (v-liability-terms (begin (try! (validate-string-length liability-terms u512)) liability-terms))
     (v-confidentiality (begin (try! (validate-string-length confidentiality u512)) confidentiality)))
    
    (match std-id
      code (try! (validate-ascii-length code u16))
      true
    )
    
    (map-set licenses
      { lid: lid }
      {
        title: v-title,
        details: v-details,
        author: tx-sender,
        established-at: block-height,
        commercial: commercial,
        derivatives: derivatives,
        credit-req: credit-req,
        reciprocal: reciprocal,
        cancelable: cancelable,
        geo-restricted: geo-restricted,
        std-id: std-id,
        url: v-url,
        usage-terms: v-usage-terms,
        liability-terms: v-liability-terms,
        confidentiality: v-confidentiality,
        enabled: true
      }
    )
    
    (var-set next-lid (+ lid u1))
    
    (ok lid)
  ))

;; Create a marketplace listing
(define-public (create-listing
                (aid uint)
                (cost uint)
                (currency (string-ascii 8))
                (token-addr (optional principal))
                (lid uint)
                (delivery (string-ascii 16))
                (period (optional uint))
                (buyer-limit (optional uint))
                (geo-limits (list 10 (string-ascii 2)))
                (min-rep (optional uint))
                (deposit-pct uint))
  (let
    ((asset (unwrap! (map-get? assets { aid: aid }) ERR-NOT-FOUND))
     (license (unwrap! (map-get? licenses { lid: lid }) ERR-NOT-FOUND))
     (oid (var-get next-oid))
     (vendor-rep (get-vendor-reputation tx-sender))
     (v-aid (begin (try! (validate-non-zero aid)) aid))
     (v-cost (begin (try! (validate-non-zero cost)) cost))
     (v-lid (begin (try! (validate-non-zero lid)) lid))
     (v-deposit-pct (begin (try! (validate-percentage deposit-pct)) deposit-pct)))
    
    (asserts! (is-eq tx-sender (get holder asset)) ERR-UNAUTHORIZED)
    (asserts! (get enabled asset) ERR-INACTIVE)
    (asserts! (get enabled license) ERR-INACTIVE)
    (asserts! (is-valid-currency currency) ERR-INVALID-PARAMS)
    (asserts! (or (is-eq currency "STX") (is-some token-addr)) ERR-INVALID-PARAMS)
    (asserts! (is-valid-delivery delivery) ERR-INVALID-PARAMS)
    (asserts! (>= vendor-rep (var-get min-rep-threshold)) ERR-UNAUTHORIZED)
    
    (asserts! (<= (len geo-limits) u10) ERR-INVALID-PARAMS)
    
    (map-set listings
      { oid: oid }
      {
        aid: v-aid,
        vendor: tx-sender,
        established-at: block-height,
        cost: v-cost,
        currency: currency,
        token-addr: token-addr,
        lid: v-lid,
        delivery: delivery,
        period: period,
        buyer-limit: buyer-limit,
        geo-limits: geo-limits,
        enabled: true,
        featured: false,
        min-rep: min-rep,
        deposit-pct: v-deposit-pct
      }
    )
    
    (var-set next-oid (+ oid u1))
    
    (ok oid)
  ))

;; Get seller reputation score
(define-private (get-vendor-reputation (vendor principal))
  (default-to u0 (get vendor-score (map-get? reputation { account: vendor }))))

;; Check if token type is valid
(define-private (is-valid-currency (currency (string-ascii 8)))
  (or (is-eq currency "STX")
      (is-eq currency "SIP010")))

;; Check if access type is valid
(define-private (is-valid-delivery (delivery (string-ascii 16)))
  (or (is-eq delivery "direct")
      (or (is-eq delivery "stream")
          (or (is-eq delivery "api")
              (is-eq delivery "compute")))))

;; Purchase a data asset with STX
(define-public (purchase-data-stx (oid uint) (key-hash (buff 32)))
  (let
    ((listing (unwrap! (map-get? listings { oid: oid }) ERR-NOT-FOUND))
     (asset (unwrap! (map-get? assets { aid: (get aid listing) }) ERR-NOT-FOUND))
     (license (unwrap! (map-get? licenses { lid: (get lid listing) }) ERR-NOT-FOUND))
     (pid (var-get next-pid))
     (cost (get cost listing))
     (buyer-rep (get-purchaser-reputation tx-sender))
     (v-oid (begin (try! (validate-non-zero oid)) oid))
     (v-key-hash (begin (try! (validate-buffer-length key-hash u32)) key-hash)))
    
    (asserts! (get enabled listing) ERR-INACTIVE)
    (asserts! (get enabled asset) ERR-INACTIVE)
    (asserts! (is-eq (get currency listing) "STX") ERR-INVALID-PARAMS)
    (asserts! (not (is-eq tx-sender (get vendor listing))) ERR-UNAUTHORIZED)
    
    (match (get min-rep listing)
      min-r (asserts! (>= buyer-rep min-r) ERR-UNAUTHORIZED)
      true
    )
    
    (let
      ((svc-fee (/ (* cost (var-get fee-pct)) u10000))
       (deposit-amt (/ (* cost (get deposit-pct listing)) u10000))
       (immediate-amt (- (- cost svc-fee) deposit-amt)))
      
      (asserts! (>= cost (+ svc-fee deposit-amt)) ERR-INSUFFICIENT-FUNDS)
      
      (try! (stx-transfer? cost tx-sender (as-contract tx-sender)))
      
      (try! (as-contract (stx-transfer? svc-fee tx-sender (var-get fee-addr))))
      
      (let
        ((expires-at (match (get period listing)
                      p (some (+ block-height p))
                      none)))
        
        (map-set purchases
          { pid: pid }
          {
            oid: v-oid,
            buyer: tx-sender,
            completed-at: block-height,
            amount: cost,
            lid: (get lid listing),
            key-hash: v-key-hash,
            key-encrypted: 0x,
            expires-at: expires-at,
            status: "active",
            accessed-at: none,
            access-cnt: u0,
            auto-renew: none,
            cancel-reason: none
          }
        )
        
        (begin
          (if (> deposit-amt u0)
              (unwrap! (create-escrow pid (get vendor listing) tx-sender deposit-amt) ERR-INVALID-PARAMS)
              true
          )
          
          (if (> immediate-amt u0)
              (unwrap! (as-contract (stx-transfer? immediate-amt tx-sender (get vendor listing))) ERR-INVALID-PARAMS)
              true
          )
          
          (map-set next-eid { pid: pid } { id: u0 })
          
          (map-set assets
            { aid: (get aid listing) }
            (merge asset 
              {
                tx-count: (+ (get tx-count asset) u1),
                earnings: (+ (get earnings asset) cost)
              }
            )
          )
          
          (var-set next-pid (+ pid u1))
          
          (ok pid)
        )
      )
    )
  ))

;; Get buyer reputation score
(define-private (get-purchaser-reputation (buyer principal))
  (default-to u0 (get buyer-score (map-get? reputation { account: buyer }))))

;; Provide access key for purchased data
(define-public (provide-access-key
                (pid uint)
                (key-encrypted (buff 256)))
  (let
    ((purchase (unwrap! (map-get? purchases { pid: pid }) ERR-NOT-FOUND))
     (listing (unwrap! (map-get? listings { oid: (get oid purchase) }) ERR-NOT-FOUND))
     (v-pid (begin (try! (validate-non-zero pid)) pid))
     (v-key-encrypted (begin (try! (validate-buffer-length key-encrypted u256)) key-encrypted)))
    
    (asserts! (is-eq tx-sender (get vendor listing)) ERR-UNAUTHORIZED)
    (asserts! (is-eq (get status purchase) "active") ERR-INVALID-PARAMS)
    
    (map-set purchases
      { pid: v-pid }
      (merge purchase { key-encrypted: v-key-encrypted })
    )
    
    (ok true)
  ))

;; Log data access
(define-public (log-data-access
                (pid uint)
                (method (string-ascii 16))
                (search-params (optional (string-utf8 256)))
                (subset (optional (string-utf8 256)))
                (addr-hash (optional (buff 32)))
                (op-hash (buff 32))
                (completed bool)
                (error-msg (optional (string-utf8 256))))
  (let
    ((purchase (unwrap! (map-get? purchases { pid: pid }) ERR-NOT-FOUND))
     (listing (unwrap! (map-get? listings { oid: (get oid purchase) }) ERR-NOT-FOUND))
     (asset (unwrap! (map-get? assets { aid: (get aid listing) }) ERR-NOT-FOUND))
     (log-ctr (unwrap! (map-get? next-eid { pid: pid }) ERR-NOT-FOUND))
     (eid (get id log-ctr))
     (v-pid (begin (try! (validate-non-zero pid)) pid))
     (v-op-hash (begin (try! (validate-buffer-length op-hash u32)) op-hash)))
    
    (asserts! (or (is-eq tx-sender (get buyer purchase))
                 (is-eq tx-sender (get vendor listing))) ERR-UNAUTHORIZED)
    (asserts! (is-eq (get status purchase) "active") ERR-INVALID-PARAMS)
    (asserts! (is-valid-method method) ERR-INVALID-PARAMS)
    
    (match search-params
      p (try! (validate-string-length p u256))
      true
    )
    (match subset
      s (try! (validate-string-length s u256))
      true
    )
    (match addr-hash
      h (try! (validate-buffer-length h u32))
      true
    )
    (match error-msg
      m (try! (validate-string-length m u256))
      true
    )
    
    (match (get expires-at purchase)
      exp (asserts! (< block-height exp) ERR-EXPIRED)
      true
    )
    
    (map-set logs
      { pid: v-pid, eid: eid }
      {
        buyer: (get buyer purchase),
        logged-at: block-height,
        method: method,
        search-params: search-params,
        subset: subset,
        addr-hash: addr-hash,
        op-hash: v-op-hash,
        completed: completed,
        error-msg: error-msg
      }
    )
    
    (map-set purchases
      { pid: v-pid }
      (merge purchase 
        {
          accessed-at: (some block-height),
          access-cnt: (+ (get access-cnt purchase) u1)
        }
      )
    )
    
    (map-set next-eid
      { pid: v-pid }
      { id: (+ eid u1) }
    )
    
    (ok eid)
  ))

;; Check if access method is valid
(define-private (is-valid-method (method (string-ascii 16)))
  (or (is-eq method "download")
      (or (is-eq method "api")
          (or (is-eq method "stream")
              (is-eq method "compute")))))

;; Submit a review for a data asset
(define-public (submit-review
                (aid uint)
                (score uint)
                (comment (string-utf8 512))
                (pid uint)
                (quality-rating uint)
                (accuracy-rating uint)
                (completeness-rating uint)
                (usefulness-rating uint))
  (let
    ((asset (unwrap! (map-get? assets { aid: aid }) ERR-NOT-FOUND))
     (purchase (unwrap! (map-get? purchases { pid: pid }) ERR-NOT-FOUND))
     (v-aid (begin (try! (validate-non-zero aid)) aid))
     (v-score (begin (try! (validate-rating score)) score))
     (v-comment (begin (try! (validate-string-length comment u512)) comment))
     (v-pid (begin (try! (validate-non-zero pid)) pid))
     (v-quality-rating (begin (try! (validate-rating quality-rating)) quality-rating))
     (v-accuracy-rating (begin (try! (validate-rating accuracy-rating)) accuracy-rating))
     (v-completeness-rating (begin (try! (validate-rating completeness-rating)) completeness-rating))
     (v-usefulness-rating (begin (try! (validate-rating usefulness-rating)) usefulness-rating)))
    
    (asserts! (is-eq tx-sender (get buyer purchase)) ERR-UNAUTHORIZED)
    
    (asserts! (is-none (map-get? feedback { reviewer: tx-sender, aid: v-aid })) ERR-ALREADY-EXISTS)
    
    (map-set feedback
      { reviewer: tx-sender, aid: v-aid }
      {
        score: v-score,
        comment: v-comment,
        posted-at: block-height,
        pid: v-pid,
        quality-rating: v-quality-rating,
        accuracy-rating: v-accuracy-rating,
        completeness-rating: v-completeness-rating,
        usefulness-rating: v-usefulness-rating,
        verified-purchase: true,
        upvotes: u0,
        downvotes: u0
      }
    )
    
    (unwrap! (update-reputation-from-review (get holder asset) v-quality-rating) ERR-INVALID-PARAMS)
    
    (ok true)
  ))

;; Register as a data validator
(define-public (register-validator
                (title (string-utf8 64))
                (details (string-utf8 512))
                (expertise (list 10 (string-ascii 32)))
                (commission uint))
  (let
    ((v-title (begin (try! (validate-string-length title u64)) title))
     (v-details (begin (try! (validate-string-length details u512)) details))
     (v-commission (begin (try! (validate-uint-range commission u0 u3000)) commission)))
    
    (asserts! (> (len expertise) u0) ERR-INVALID-PARAMS)
    (asserts! (<= (len expertise) u10) ERR-INVALID-PARAMS)
    
    (asserts! (is-none (map-get? validators { val: tx-sender })) ERR-ALREADY-EXISTS)
    
    (map-set validators
      { val: tx-sender }
      {
        title: v-title,
        details: v-details,
        expertise: expertise,
        commission: v-commission,
        assessments: u0,
        avg-rating: u0,
        joined-at: block-height,
        enabled: true
      }
    )
    
    (ok true)
  ))

;; Submit validation report
(define-public (submit-validation-report
                (aid uint)
                (doc-hash (buff 32))
                (quality-score uint)
                (accuracy-score uint)
                (completeness-score uint)
                (reliability-score uint)
                (methodology (string-utf8 256))
                (issues (list 10 (string-utf8 128)))
                (recommendations (string-utf8 512))
                (level (string-ascii 16))
                (valid-until (optional uint)))
  (let
    ((asset (unwrap! (map-get? assets { aid: aid }) ERR-NOT-FOUND))
     (validator-data (unwrap! (map-get? validators { val: tx-sender }) ERR-UNAUTHORIZED))
     (v-aid (begin (try! (validate-non-zero aid)) aid))
     (v-doc-hash (begin (try! (validate-buffer-length doc-hash u32)) doc-hash))
     (v-quality-score (begin (try! (validate-score quality-score)) quality-score))
     (v-accuracy-score (begin (try! (validate-score accuracy-score)) accuracy-score))
     (v-completeness-score (begin (try! (validate-score completeness-score)) completeness-score))
     (v-reliability-score (begin (try! (validate-score reliability-score)) reliability-score))
     (v-methodology (begin (try! (validate-string-length methodology u256)) methodology))
     (v-recommendations (begin (try! (validate-string-length recommendations u512)) recommendations)))
    
    (asserts! (get enabled validator-data) ERR-INACTIVE)
    (asserts! (is-valid-level level) ERR-INVALID-PARAMS)
    (asserts! (<= (len issues) u10) ERR-INVALID-PARAMS)
    
    (map-set reports
      { aid: v-aid, val: tx-sender }
      {
        doc-hash: v-doc-hash,
        filed-at: block-height,
        quality-score: v-quality-score,
        accuracy-score: v-accuracy-score,
        completeness-score: v-completeness-score,
        reliability-score: v-reliability-score,
        methodology: v-methodology,
        issues: issues,
        recommendations: v-recommendations,
        level: level,
        valid-until: valid-until
      }
    )
    
    (map-set assets
      { aid: v-aid }
      (merge asset 
        {
          rating: (some v-quality-score),
          validated: true
        }
      )
    )
    
    (map-set validators
      { val: tx-sender }
      (merge validator-data 
        { assessments: (+ (get assessments validator-data) u1) }
      )
    )
    
    (ok true)
  ))

;; Check if certification level is valid
(define-private (is-valid-level (level (string-ascii 16)))
  (or (is-eq level "basic")
      (or (is-eq level "standard")
          (is-eq level "premium"))))

;; File a dispute for a data purchase
(define-public (file-dispute
                (pid uint)
                (reason (string-utf8 512))
                (proof-hash (buff 32)))
  (let
    ((purchase (unwrap! (map-get? purchases { pid: pid }) ERR-NOT-FOUND))
     (listing (unwrap! (map-get? listings { oid: (get oid purchase) }) ERR-NOT-FOUND))
     (did (var-get next-did))
     (esc (map-get? escrow { pid: pid }))
     (v-pid (begin (try! (validate-non-zero pid)) pid))
     (v-reason (begin (try! (validate-string-length reason u512)) reason))
     (v-proof-hash (begin (try! (validate-buffer-length proof-hash u32)) proof-hash)))
    
    (asserts! (is-eq tx-sender (get buyer purchase)) ERR-UNAUTHORIZED)
    (asserts! (is-eq (get status purchase) "active") ERR-INVALID-PARAMS)
    
    (try! (stx-transfer? (var-get dispute-fee) tx-sender (var-get fee-addr)))
    
    (map-set disputes
      { did: did }
      {
        pid: v-pid,
        claimant: tx-sender,
        defendant: (get vendor listing),
        filed-at: block-height,
        reason: v-reason,
        proof-hash: v-proof-hash,
        status: "open",
        resolution: none,
        resolved-at: none,
        arbitrator: none,
        refund-pct: none,
        appeal-deadline: none,
        appealed: false
      }
    )
    
    (match esc
      e (map-set escrow
                    { pid: v-pid }
                    (merge e { disputed: true })
                  )
      true
    )
    
    (map-set purchases
      { pid: v-pid }
      (merge purchase { status: "disputed" })
    )
    
    (var-set next-did (+ did u1))
    
    (ok did)
  ))

;; Resolve a dispute (simplified arbitration)
(define-public (resolve-dispute
                (did uint)
                (resolution (string-utf8 512))
                (refund-pct uint))
  (let
    ((dispute (unwrap! (map-get? disputes { did: did }) ERR-NOT-FOUND))
     (pid (get pid dispute))
     (purchase (unwrap! (map-get? purchases { pid: pid }) ERR-NOT-FOUND))
     (esc (map-get? escrow { pid: pid }))
     (v-did (begin (try! (validate-non-zero did)) did))
     (v-resolution (begin (try! (validate-string-length resolution u512)) resolution))
     (v-refund-pct (begin (try! (validate-percentage refund-pct)) refund-pct)))
    
    (asserts! (is-eq tx-sender OWNER) ERR-UNAUTHORIZED)
    (asserts! (is-eq (get status dispute) "open") ERR-INVALID-PARAMS)
    
    (map-set disputes
      { did: v-did }
      (merge dispute 
        {
          status: "resolved",
          resolution: (some v-resolution),
          resolved-at: (some block-height),
          arbitrator: (some tx-sender),
          refund-pct: (some v-refund-pct),
          appeal-deadline: (some (+ block-height u1440))
        }
      )
    )
    
    (match esc
      e (unwrap! (resolve-escrow pid v-refund-pct) ERR-INVALID-PARAMS)
      true
    )
    
    (map-set purchases
      { pid: pid }
      (merge purchase 
        { status: (if (is-eq v-refund-pct u10000) "revoked" "active") }
      )
    )
    
    (unwrap! (update-reputation-from-dispute
             (get claimant dispute)
             (get defendant dispute)
             v-refund-pct) ERR-INVALID-PARAMS)
    
    (ok true)
  ))

;; Release escrow funds (after deadline if no disputes)
(define-public (release-escrow (pid uint))
  (let
    ((esc (unwrap! (map-get? escrow { pid: pid }) ERR-NOT-FOUND))
     (v-pid (begin (try! (validate-non-zero pid)) pid)))
    
    (asserts! (not (get released esc)) ERR-INVALID-PARAMS)
    (asserts! (not (get disputed esc)) ERR-DISPUTED)
    (asserts! (is-some (get release-at esc)) ERR-INVALID-PARAMS)
    (asserts! (>= block-height (unwrap-panic (get release-at esc))) ERR-INVALID-PARAMS)
    
    (try! (as-contract (stx-transfer? (get amount esc) tx-sender (get vendor esc))))
    
    (map-set escrow
      { pid: v-pid }
      (merge esc { released: true })
    )
    
    (ok true)
  ))

;; Update a data asset
(define-public (update-data-asset
                (aid uint)
                (name (string-utf8 128))
                (details (string-utf8 1024))
                (meta-loc (string-utf8 256))
                (hash (buff 64))
                (size-bytes uint))
  (let
    ((asset (unwrap! (map-get? assets { aid: aid }) ERR-NOT-FOUND))
     (v-aid (begin (try! (validate-non-zero aid)) aid))
     (v-name (begin (try! (validate-string-length name u128)) name))
     (v-details (begin (try! (validate-string-length details u1024)) details))
     (v-meta-loc (begin (try! (validate-string-length meta-loc u256)) meta-loc))
     (v-hash (begin (try! (validate-buffer-length hash u64)) hash))
     (v-size-bytes (begin (try! (validate-non-zero size-bytes)) size-bytes)))
    
    (asserts! (is-eq tx-sender (get holder asset)) ERR-UNAUTHORIZED)
    (asserts! (get enabled asset) ERR-INACTIVE)
    
    (map-set assets
      { aid: v-aid }
      (merge asset 
        {
          name: v-name,
          details: v-details,
          meta-loc: v-meta-loc,
          hash: v-hash,
          size-bytes: v-size-bytes,
          modified-at: block-height,
          validated: false,
          rating: none
        }
      )
    )
    
    (ok true)
  ))

;; Read-only functions

;; Get data asset details
(define-read-only (get-data-asset (aid uint))
  (ok (unwrap! (map-get? assets { aid: aid }) ERR-NOT-FOUND)))

;; Get license details
(define-read-only (get-license (lid uint))
  (ok (unwrap! (map-get? licenses { lid: lid }) ERR-NOT-FOUND)))

;; Get marketplace listing
(define-read-only (get-listing (oid uint))
  (ok (unwrap! (map-get? listings { oid: oid }) ERR-NOT-FOUND)))

;; Get purchase details
(define-read-only (get-purchase (pid uint))
  (ok (unwrap! (map-get? purchases { pid: pid }) ERR-NOT-FOUND)))

;; Get validation report
(define-read-only (get-validation-report (aid uint) (val principal))
  (ok (unwrap! (map-get? reports { aid: aid, val: val }) ERR-NOT-FOUND)))

;; Get user reputation
(define-read-only (get-reputation (account principal))
  (ok (default-to
        {
         vendor-score: u50,
         buyer-score: u50,
         quality-score: u50,
         disputes-filed: u0,
         disputes-lost: u0,
         tx-count: u0,
         purchase-count: u0,
         avg-quality: u0,
         review-count: u0,
         verified: false
       }
       (map-get? reputation { account: account })
     )
  ))

;; Get validator details
(define-read-only (get-validator (val principal))
  (ok (unwrap! (map-get? validators { val: val }) ERR-NOT-FOUND)))

;; Get dispute details
(define-read-only (get-dispute (did uint))
  (ok (unwrap! (map-get? disputes { did: did }) ERR-NOT-FOUND)))

;; Get escrow details
(define-read-only (get-escrow (pid uint))
  (ok (unwrap! (map-get? escrow { pid: pid }) ERR-NOT-FOUND)))

;; Get review details
(define-read-only (get-review (reviewer principal) (aid uint))
  (ok (unwrap! (map-get? feedback { reviewer: reviewer, aid: aid }) ERR-NOT-FOUND)))

;; Get access log
(define-read-only (get-access-log (pid uint) (eid uint))
  (ok (unwrap! (map-get? logs { pid: pid, eid: eid }) ERR-NOT-FOUND)))

;; Check if a user has access to a specific data asset
(define-read-only (has-data-access (account principal) (aid uint))
  (ok false))

;; Get platform configuration
(define-read-only (get-platform-config)
  (ok {
    fee-pct: (var-get fee-pct),
    fee-addr: (var-get fee-addr),
    dispute-fee: (var-get dispute-fee),
    escrow-period: (var-get escrow-period),
    min-rep-threshold: (var-get min-rep-threshold)
  }))

;; Admin functions (only contract owner)

;; Update platform fee
(define-public (set-platform-fee (new-fee uint))
  (let
    ((v-new-fee (begin (try! (validate-uint-range new-fee u0 u1000)) new-fee)))
    
    (asserts! (is-eq tx-sender OWNER) ERR-UNAUTHORIZED)
    (var-set fee-pct v-new-fee)
    (ok true)
  ))

;; Update fee recipient
(define-public (set-fee-recipient (new-recipient principal))
  (begin
    (asserts! (is-eq tx-sender OWNER) ERR-UNAUTHORIZED)
    (var-set fee-addr new-recipient)
    (ok true)
  ))

;; Update dispute resolution fee
(define-public (set-dispute-fee (new-fee uint))
  (let
    ((v-new-fee (begin (try! (validate-non-zero new-fee)) new-fee)))
    
    (asserts! (is-eq tx-sender OWNER) ERR-UNAUTHORIZED)
    (var-set dispute-fee v-new-fee)
    (ok true)
  ))

;; Deactivate a data asset (emergency function)
(define-public (deactivate-asset (aid uint))
  (let
    ((asset (unwrap! (map-get? assets { aid: aid }) ERR-NOT-FOUND))
     (v-aid (begin (try! (validate-non-zero aid)) aid)))
    
    (asserts! (is-eq tx-sender OWNER) ERR-UNAUTHORIZED)
    
    (map-set assets
      { aid: v-aid }
      (merge asset { enabled: false })
    )
    
    (ok true)
  ))

;; Deactivate a validator (emergency function)
(define-public (deactivate-validator (val principal))
  (let
    ((validator-data (unwrap! (map-get? validators { val: val }) ERR-NOT-FOUND)))
    
    (asserts! (is-eq tx-sender OWNER) ERR-UNAUTHORIZED)
    
    (map-set validators
      { val: val }
      (merge validator-data { enabled: false })
    )
    
    (ok true)
  ))