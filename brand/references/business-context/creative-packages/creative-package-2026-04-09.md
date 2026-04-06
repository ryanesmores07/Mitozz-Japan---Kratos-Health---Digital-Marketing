# Creative Package - 2026-04-09

Purpose:

- create a native-interaction-led Story poll that gathers quick engagement after the April 8 trust feed
- make the audience choose their purchase-attention axis without turning the Story into another explainer
- keep the visual family tied to April 8 while giving the native poll sticker clean breathing room

Locked variant decisions:

- `visual_engine`: `image-led opener + native poll support`
- `anchor_set`: `anchor-portrait-trust + anchor-editorial-whitespace + Set A`
- `dominant_set_behavior`: `portrait-trust opener + clean native-interaction poll frame`
- `variation_strategy`: `use the April 8 trust family mood, but shift the structure to a faster 2-frame engagement Story with one opener and one poll-safe action frame`
- `selected_set_images`: `anchor-portrait-trust-01.png`, `anchor-editorial-whitespace-01.png`
- `variant_scope`: `design-only`
- `palette_variant`: `warm_editorial`
- `type_profile`: `humanist_sans`
- `source_lane`: `Nano-Banana-source-image`
- `source_strategy`: `fresh Nano Banana opener plate with a protected upper-left text zone and a calm lower-third safe area for later Story UI`
- `fallback_source`: `fallback to a text-led opener only if the generated plate fails readability or the poll-safe-zone requirement`
- `icon_strategy`: `none`
- `generated_visual_role`: `hero-visual opener`

Creative direction:

- treat the Story as a soft buying-judgment prompt, not another lesson
- ask the question in a calm premium tone: what draws attention first before purchase
- make frame 2 the true interaction frame with a generous native poll sticker zone
- merge the route-back into frame 2 instead of spending a separate close frame on it
- avoid repeating the feed's proof-card logic inside the Story

Production layout:

1. image-backed opener with the purchase-axis question
2. centered poll frame with protected native sticker space, one viewer-facing support line, and one compact route-back note to the April 8 feed

Story copy lock:

- `frame 1`
  - left meta: `購入前の視点`
  - right meta: `軽いアンケート`
  - headline:
    - `購入前に気になるのは、`
    - `成分ですか。`
    - `ブランドですか。`
  - body:
    - `まず目が向くほうを、`
    - `気軽に選んでみてください。`

- `frame 2`
  - left meta: `今日の質問`
  - right meta: `投票してください`
  - headline:
    - `最初に安心感を持つのは`
    - `どちらに近いですか。`
  - support line:
    - `まずは近いほうを`
    - `気軽に選んでみてください。`
  - option support:
    - `成分を見る`
    - `ブランド姿勢を見る`
  - route-back note:
    - title: `今日の投稿を見る`
    - body:
      - `信頼の見方を、`
      - `やさしく整理しています。`

Story rules:

- do not generate fake poll UI
- frame 2 must leave a clean centered zone for the native Instagram poll sticker
- frame 2 can name the two options on-canvas only as supportive labels, not as a fake voting component
- keep top and bottom safe zones intact
- make the opener image calm and trust-led, not product-ad-like
