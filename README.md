# Bytedome

## Overview

**Bytedome** is a **tokenized data marketplace** built in **Clarity** for the Stacks blockchain.
It enables **secure, decentralized buying, selling, licensing, and validation of datasets** with **privacy controls, escrow protection, and reputation tracking**.
Bytedome establishes a full-fledged **data economy protocol** for structured data, APIs, streams, and machine learning models.

---

## Core Components

### 1. **Data Asset Registry (`information-assets`)**

Stores metadata and ownership information for datasets or digital resources.

Each record contains:

* Name, description, classification, and metadata links
* Hash of the content for verification
* Security and refresh frequency type
* Rating and validation details
* Commission, transaction count, and earnings tracking

**Registered using:**

```clarity
(register-data-asset (name ...) (details ...) ... )
```

---

### 2. **Licensing System (`agreement-types`)**

Defines reusable **data license templates** specifying usage rights and restrictions.
These govern how data assets can be consumed, redistributed, or modified.

Each license includes:

* Commercial usage flag
* Modification, attribution, and reciprocity clauses
* Regional restrictions
* Legal URL reference and detailed restrictions

**Created with:**

```clarity
(create-license-type (title ...) (details ...) ... )
```

---

### 3. **Marketplace Listings (`market-listings`)**

Vendors can publish data assets for sale or subscription.
Listings define:

* Pricing, currency type (`STX` or `SIP010` tokens)
* Linked license agreement
* Delivery method (`direct`, `api`, `stream`, or `compute`)
* Buyer reputation requirements
* Escrow deposit percentage

**Created with:**

```clarity
(create-listing (resource-id ...) (cost ...) ... )
```

---

### 4. **Data Transactions (`transactions`)**

Tracks purchase events and key delivery details.
Each record stores:

* Buyer and vendor principals
* Licensing agreement reference
* Encrypted access key and hash
* Expiration, access count, and renewal options

Purchases can occur via **STX** or **SIP-010 tokens**, depending on listing configuration.

**Triggered via:**

```clarity
(purchase-data-stx (offer-id uint) (key-hash (buff 32)))
```

---

### 5. **Escrow and Settlement (`held-funds`)**

Implements secure payment handling with **automatic escrow**.
Funds are held until either:

* The escrow period expires without dispute, or
* A dispute is resolved via `resolve-escrow`.

**Internal Functions:**

```clarity
(create-escrow (transaction-id uint) (vendor principal) (purchaser principal) (sum uint))
(resolve-escrow (transaction-id uint) (purchaser-refund-percentage uint))
```

---

### 6. **Reputation & Feedback System (`credibility-scores` & `feedback`)**

Tracks both vendor and purchaser credibility using a **100-point scale**.
Reputation is updated via:

* **Reviews**: Weighted by data quality and completeness.
* **Disputes**: Adjust credibility for both buyer and seller outcomes.

**Private functions:**

```clarity
(update-reputation-from-review (vendor principal) (quality-rating uint))
(update-reputation-from-dispute (purchaser principal) (vendor principal) (refund uint))
```

---

### 7. **Validation Layer (`information-validators` & `assessment-reports`)**

Registers independent **data validators** who review data quality.
Validators can submit **assessment reports** that contribute to the dataset’s verified status and quality rating.

Each report includes:

* Document hash
* Precision, coverage, and reliability scores
* Approval tier (`basic`, `standard`, `premium`)

---

### 8. **Dispute Resolution (`information-disputes`)**

Provides an **on-chain dispute system** for resolving purchase conflicts.
Each dispute contains:

* Filing parties (claimant/defendant)
* Justification and proof hash
* Mediation outcome and refund percentage
* Optional deadlines and challenge flags

---

### 9. **Usage Logging (`usage-logs`)**

Monitors access events per transaction (downloads, API hits, etc.) to ensure compliance and transparency.
Each log captures:

* Timestamp and method
* Operation hash
* Access result (success/failure)

---

### 10. **Categorization (`information-categories`)**

Organizes data assets into structured categories for discoverability.
Each classification can track:

* Resource count
* Popularity/interest score
* Hierarchical parent links

---

## Token Integration

Bytedome supports both **STX** and **SIP-010 tokens** for purchases.
The SIP-010 trait interface allows any compliant fungible token to be used as payment.

```clarity
(define-trait sip-010-trait (...))
```

---

## Governance Parameters

| Variable                      | Purpose                    | Default            |
| ----------------------------- | -------------------------- | ------------------ |
| `service-fee-percentage`      | Platform fee rate          | `u250` (2.5%)      |
| `conflict-resolution-fee`     | Cost to initiate dispute   | `u5000000` (5 STX) |
| `standard-deposit-period`     | Escrow duration (blocks)   | `u1440`            |
| `min-credibility-for-listing` | Minimum reputation to list | `u30`              |

---

## Error Codes

| Code   | Constant                 | Description                |
| ------ | ------------------------ | -------------------------- |
| `u100` | `ERR-UNAUTHORIZED`       | Unauthorized caller        |
| `u101` | `ERR-NOT-FOUND`          | Missing record             |
| `u102` | `ERR-INVALID-PARAMS`     | Invalid input              |
| `u103` | `ERR-ALREADY-EXISTS`     | Duplicate entry            |
| `u104` | `ERR-INSUFFICIENT-FUNDS` | Insufficient balance       |
| `u105` | `ERR-EXPIRED`            | Operation expired          |
| `u106` | `ERR-DISPUTED`           | Conflict or active dispute |
| `u107` | `ERR-INACTIVE`           | Resource disabled          |

---

## Workflow Summary

1. **Vendor registers** a data asset via `register-data-asset`.
2. **Vendor creates** a license type through `create-license-type`.
3. **Vendor lists** the asset on the marketplace using `create-listing`.
4. **Buyer purchases** the data with `purchase-data-stx`.
5. **Escrow** automatically locks payment until conditions are met.
6. **Validator or buyer** submits feedback or dispute if necessary.
7. **Funds are released** or refunded through `resolve-escrow`.
8. **Reputation scores** update dynamically based on outcome.

---

## Summary

**Bytedome** delivers a **modular, auditable framework for data monetization**, combining:

* Trustless payments
* Licensing automation
* Reputation & validation
* Privacy-preserving access logging
* Full dispute resolution

It enables a **self-regulating, tokenized data marketplace** where users can confidently trade digital information assets under transparent, enforceable terms.
