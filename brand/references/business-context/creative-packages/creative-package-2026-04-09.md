# Creative Package - 2026-04-09

Purpose:

- create a native-interaction-led Story poll that gathers quick engagement after the April 8 trust feed
- turn the audience's purchase-attention axis into one clean self-recognition moment
- keep the April 8 trust family mood, but shift to a faster, more interactive Story format

Locked variant decisions:

- `visual_engine`: `dual-image story`
- `anchor_set`: `Set A selector behavior + Set E image-offset framing + April 8 trust-story continuity`
- `dominant_set_behavior`: `image opener + image-backed poll-safe action frame`
- `variation_strategy`: `keep the April 8 warm trust palette and calmer premium mood, but remove feed-like explanation and reduce the Story to one opener plus one poll decision frame`
- `selected_set_images`:
  - `brand/references/business-context/visual/reference-pack/style-anchors/Set A/Screenshot 2026-03-29 at 16.43.30.png`
  - `brand/references/business-context/visual/reference-pack/style-anchors/Set E/Screenshot 2026-03-29 at 16.53.31.png`
  - `output/instagram/stories/2026-04-08-story-premium-trust-mini-guide-v01/current/frame-01.png`
- `variant_scope`: `design-only`
- `palette_variant`: `warm_editorial`
- `type_profile`: `humanist_sans`
- `source_lane`: `Nano-Banana-source-image`
- `source_strategy`: `generate two separate 9:16 Nano Banana plates: frame 1 as an object-led or hands-led trust opener with a protected upper-left text zone, frame 2 as a soft editorial background with a centered sticker-safe zone and no competing focal object`
- `fallback_source`: `fallback to a text-led body frame only if the frame 2 generated plate blocks the native sticker-safe zone`
- `icon_strategy`: `none`
- `generated_visual_role`: `hero visual + poll support plate`

Creative direction:

- treat the Story as a quick buying-judgment prompt, not another trust explainer
- frame 1 should feel like a soft recognition opener: calm, premium, and self-reflective
- frame 2 should feel like a clean decision surface, not a fake poll UI
- use the native Instagram poll sticker as the only real interaction component
- keep all visible text minimal and deliberate
- do not add any on-canvas wording that is not locked below

Production layout:

1. image-backed opener with the purchase-attention question and one short invitation line
2. generated editorial background with a clear middle poll-safe zone, short headline/support copy above, and one compact route-back card below

Story copy lock:

- `frame 1`
  - left meta: `信頼の入口`
  - right meta: `1問だけ`
  - headline:
    - `購入前に気になるのは、`
    - `成分ですか。`
    - `ブランドですか。`
  - body:
    - `まず近いほうを、`
    - `気軽に選んでみてください。`

- `frame 2`
  - left meta: `今日の質問`
  - right meta: `投票`
  - headline:
    - `購入前にまず見るのは`
    - `どちらですか。`
  - body:
    - `近いほうを、`
    - `ひとつ選んでください。`
  - route-back note:
    - title: `今日の投稿を見る`
    - body:
      - `見た目だけではない`
      - `信頼の見方を整理しています。`

Native sticker lock:

- `sticker_type`: `instagram-native-poll`
- `sticker_question_ja`: `先に安心するのは？`
- `sticker_options_ja`:
  - `成分`
  - `ブランド姿勢`
- `sticker_positioning`: `frame 2 only, centered horizontally inside the dedicated middle frosted panel; keep the top edge below the body copy and keep the full sticker group above the bottom route-back card`
- `render_sticker_ui_in_asset`: `false`

Source-image direction:

- `frame 1 plate`
  - warm curtain light
  - premium Japanese wellness-evaluation mood
  - avoid another repeated right-facing portrait; use a hands-led or partial-figure tabletop moment instead
  - subtle tabletop objects only: notebook, clean cup, one or two plain packaging boxes
  - protect a large upper-left and mid-left text zone
  - no readable text, logos, labels, or UI anywhere in frame

- `frame 2 plate`
  - soft editorial lifestyle background, slightly more abstract and quieter than frame 1
  - keep the center visually open for the native poll sticker
  - move visual interest to the far edges and lower corners only
  - no hard focal subject under the future sticker area
  - no readable text, logos, labels, or UI anywhere in frame

Story rules:

- do not generate fake poll UI
- do not render sticker placement instructions or internal execution notes on-canvas
- do not repeat the option labels outside the native sticker unless the brief explicitly changes
- keep top and bottom safe zones intact
- preserve April 8 family continuity through tone, type rhythm, and panel softness, not by repeating the feed structure
