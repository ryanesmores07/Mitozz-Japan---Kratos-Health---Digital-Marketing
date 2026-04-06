# Mitozz Shopify Lifecycle System - Internal Reference

## Purpose

This document records the current native Shopify lifecycle setup for Mitozz so the system can be reviewed, maintained, extended, or rebuilt later without relying on memory.

## Active Stack

- `Shopify Forms`
- `Shopify Messaging`
- `Shopify Flow`

This implementation assumes `subscription` means `email marketing subscription`, not a recurring product subscription.

## Lifecycle Goal

Capture first-party email subscribers, deliver the welcome offer automatically, recover high-intent abandoned checkouts, and run basic reorder and winback lifecycle messaging from native Shopify before considering a more advanced ESP.

## Implemented Components

### 1. Welcome Capture Layer

- Created one popup form for welcome capture.
- Created one inline form for lower-friction signup.
- Positioning intentionally keeps `WELCOME10` as a subscriber benefit rather than a public sitewide promo.

### 2. Consent Layer

- Checkout email consent was turned on in Shopify checkout settings.
- Approach favors explicit email consent rather than aggressive prechecked collection.

### 3. Sender Setup

- Sender currently uses `Kratos Health - support@kratoshealth.io`.
- This is acceptable because the storefront header already presents `Kratos Health` as the visible company/distributor identity.
- Email body and offer language stay product-led around `Mitozz`.

### 4. Welcome Automation

- Built in Shopify Messaging / Flow.
- Trigger: `Customer subscribed to email marketing`
- Condition: exclude checkout-based subscription path when applicable
- Action: send welcome marketing email
- Offer delivered: `WELCOME10`

### 5. Abandoned Checkout Automation

- Built and confirmed firing correctly.
- Audience set to `All customers` rather than subscribers only.
- Reason: abandoned checkout is a high-intent recovery message and can reasonably be broader than newsletter-style lifecycle sends.
- Current test note: preview/mock links in editor are not real checkout restoration links; end-to-end testing must use a real abandoned checkout event.

### 6. Reorder Automation

- Built in Shopify Flow.
- Trigger: `Customer joined segment`
- Current segment used: reorder segment for subscribed customers with one order and reorder-age eligibility
- Offer delivered: `REORDER10`

### 7. Winback Automation

- Built in Shopify Flow.
- Trigger: `Customer joined segment`
- Segment logic targets subscribed lapsed customers who qualify for winback
- Offer delivered: `WINBACK10`

## Current Offer Architecture

- `WELCOME10`
  - Intended for first-time email subscribers / first-order welcome use
- `REORDER10`
  - Intended for eligible repeat-order encouragement
- `WINBACK10`
  - Intended for subscribed prior customers who have gone inactive long enough to qualify

Do not place these codes into generic public-facing newsletter banners or broad sitewide promo surfaces unless strategy changes.

## Storefront Messaging Rules

- Do not show `WELCOME10` in a public announcement bar.
- Product-page microcopy should be soft and subscriber-led.
- Footer signup remains brand-calm and low pressure.
- Tone should stay premium, thoughtful, and non-urgent.

Avoid:

- countdown language
- aggressive discount framing
- “huge sale” style copy
- making the welcome code feel like a public coupon

## Japanese Copy Direction Used

### Popup

- Title: `初回のご注文が10%OFFになります`
- Description: `Mitozzのメールリストにご登録いただくと、ウェルネス情報や商品のお知らせ、初回限定10%OFFコードをお届けします。`
- Teaser: `初回注文10%OFF`
- Field label: `メールアドレス`
- Button: `10%OFFコードを受け取る`
- Disclaimer: `ご登録により、Mitozzからのメール配信に同意したものとみなされます。いつでも配信停止できます。`
- Success title: `10%OFFコードをご用意しました`
- Success content: `チェックアウト時に「WELCOME10」をご利用ください。メールでもご案内しています。`

### Inline Form

- Title: `Mitozzのメールリストに登録する`
- Description: `商品情報やお知らせ、初回限定10%OFFコードをお届けします。`
- Field label: `メールアドレス`
- Button: `登録する`
- Disclaimer: `ご登録により、Mitozzからのメール配信に同意したものとみなされます。いつでも配信停止できます。`
- Success title: `登録が完了しました`
- Success content: `ウェルカムコードは「WELCOME10」です。メールでもご案内していますのでご確認ください。`

## Email Direction Used

### Welcome Email

- Main role: deliver `WELCOME10`
- Sender identity: `Kratos Health`
- Product-facing headline stays `Mitozz`
- Tone: welcome + calm brand intro + code delivery + one CTA

### Abandoned Checkout

- Audience: `All customers`
- Tone: reminder, not pressure
- No extra rescue discount added at this stage

### Reorder

- Segment-driven
- Tone: calm continuation / routine support
- Code: `REORDER10`

### Winback

- Segment-driven
- Tone: warm return invitation
- Code: `WINBACK10`

## Operational Notes

- Shopify preview/test emails for abandoned checkout can use a mock link such as `https://shopify/abandonment/mock`, which is not a real recovery URL.
- Real checkout-recovery testing must be done with a live abandoned checkout event on the storefront.
- Reorder and winback are best handled through segment-entry triggers so customers only receive the emails when they truly become eligible.

## Recommended Maintenance Rules

- Keep welcome, reorder, and winback sends subscriber-only unless strategy changes.
- Keep abandoned checkout as the one broader recovery email unless compliance guidance changes.
- Do not add birthday until birthday collection, storage, and segmentation are defined.
- Revisit timing and creative after observing real customer behavior and deliverability.

## Open Validation Checklist

- Confirm popup renders well on desktop and mobile.
- Confirm popup submission marks the customer as subscribed.
- Confirm popup success state shows `WELCOME10`.
- Confirm welcome email arrives and the code is accurate.
- Confirm `WELCOME10` works for the intended first-order case and does not behave like a reusable public code.
- Confirm abandoned checkout restore link works from a real trigger.
- Confirm reorder segment membership is updating correctly.
- Confirm winback segment membership is updating correctly.
- Confirm emails and storefront messaging feel brand-consistent between `Kratos Health` and `Mitozz`.

## Suggested Next Improvements

- Complete end-to-end testing for all lifecycle paths.
- Refine visual hierarchy in lifecycle emails if needed.
- Decide whether Japanese-only remains sufficient or whether English variants should be created.
- Reassess whether native Shopify remains sufficient once volume and segmentation complexity grow.
