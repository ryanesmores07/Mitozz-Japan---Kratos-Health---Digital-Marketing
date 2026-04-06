# 2026-04 Shopify Lifecycle Update For Jay

## Summary

We moved the Mitozz Shopify retention setup from partial setup into a functional first lifecycle system. The store can now capture email subscribers, deliver the welcome offer automatically, recover abandoned checkouts, and send basic reorder and winback emails through Shopify's native stack.

## What Is Now Live

- Email signup capture is in place through both a popup form and an inline form.
- Checkout email consent is enabled so high-intent customers can be added properly during checkout.
- The branded sender identity is configured through `Kratos Health - support@kratoshealth.io`, which matches the current storefront branding.
- A welcome email flow now sends the `WELCOME10` first-order offer to new subscribers.
- An abandoned checkout recovery email is configured and firing properly.
- Reorder and winback emails are now connected to their eligibility segments and can send when customers enter those groups.

## Why This Matters

- Mitozz now has a working first-party audience capture layer instead of relying only on one-off traffic or public discount exposure.
- The first-order offer is being treated as a subscriber benefit rather than a sitewide public code, which is better aligned to the premium brand positioning.
- The store now has a basic retention structure across the customer lifecycle: welcome, checkout recovery, reorder, and winback.
- This gives us a more credible owned-channel foundation before deciding whether a larger platform such as Klaviyo is necessary later.

## Setup Decisions

- We kept the implementation native first using `Shopify Forms`, `Shopify Messaging`, and `Shopify Flow`.
- The welcome and lifecycle emails were written in a softer, premium tone rather than pushy sales language.
- Abandoned checkout was treated differently from newsletter-style flows and set up more broadly because it is a high-intent recovery message.
- Reorder and winback were connected to customer-segment logic so they send based on real eligibility rather than generic blasts.

## Current Status

- Core lifecycle structure is implemented.
- The main remaining task is full end-to-end QA across welcome, checkout recovery, reorder eligibility, and winback eligibility.
- Birthday collection and birthday automation were intentionally deferred until the field strategy is defined more clearly.

## Recommended Next Step

- Run a full live test pass across all lifecycle paths and confirm code behavior, email delivery, and customer-segment updates before treating the system as fully locked.
