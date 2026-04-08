# Mitozz Japan Agent Guide

This file defines workspace-level agent behavior for this repository.

It is intentionally not a replacement for `.agents/skills/`.
Those skill folders remain the single source of truth for role-specific execution logic.

Use this file for:

- shared routing rules
- repository-wide constraints
- handoff expectations between agents or work phases
- artifact and naming conventions
- global quality gates

Do not use this file to duplicate detailed instructions that already live in:

- `.agents/skills/mitozz-instagram-strategist/`
- `.agents/skills/mitozz-content-calendar/`
- `.agents/skills/mitozz-creatives-director/`
- `.agents/skills/mitozz-prompt-engineer/`
- `.agents/skills/nano-banana-instagram/`
- `.agents/skills/mitozz-compositor-executor/`
- `.agents/skills/mitozz-posting-copy-optimizer/`
- `.agents/skills/mitozz-icon-sourcing/`
- `.agents/skills/mitozz-stock-image-sourcing/`
- `.agents/skills/drive-delivery/`
- `.agents/skills/retainer-reporting/`
- `.agents/skills/jay-invoice-sheets/`
- `.agents/skills/shopify-blog-seo/`

## Project Mission

This workspace exists to run Mitozz Japan's premium, science-led organic content system with high reuse and low ambiguity.

The core objective is not just to make assets. It is to maintain a reliable production system for:

- Instagram strategy
- monthly planning
- creative packaging
- prompt generation
- source-image generation
- design-first composition
- posting copy
- delivery and reporting

Agents working in this repo should optimize for:

- brand consistency
- Japanese-market-safe messaging
- reusable production logic
- low re-interpretation between stages
- durable artifacts that help future months move faster

## Working Style

All agent outputs in this project should be:

- strategic
- professional
- lean
- execution-oriented
- grounded in actual project context

Default communication rules:

- use bold headings and flat bullets when structure improves clarity
- keep responses concise and high-signal
- justify recommendations with project artifacts, data, or current repo context when available
- avoid speculative ideas, filler, or theoretical detours
- recommend proven best practices and practical next steps over clever but fragile solutions

Do not overengineer deliverables, explanations, or process.

## Source Of Truth

Default source-of-truth order:

1. explicit user instruction
2. attached files or directly supplied user materials for the current task
3. approved repo-local skill instructions in `.agents/skills/`
4. current workflow docs in `workflows/`
5. approved brand and strategy docs in `brand/references/business-context/`
6. current production assets and prompt examples in `prompts/`, `design-system/`, and `output/`
7. this file for global coordination rules

If two sources conflict, prefer the more specific and more recent project artifact.
Do not invent missing facts when the attached files or repo artifacts do not support them.

## What This File Owns

This file owns only cross-cutting rules.

It does own:

- how to route work to the right existing skill
- what must be decided before moving to the next stage
- what counts as complete at the workspace level
- which folders hold which artifacts
- naming and handoff discipline
- repository-wide safety rules

It does not own:

- account strategy details already defined by `mitozz-instagram-strategist`
- calendar schema logic already defined by `mitozz-content-calendar`
- asset-brief structure already defined by `mitozz-creatives-director`
- prompt-schema specifics already defined by `mitozz-prompt-engineer`
- generation behavior already defined by `nano-banana-instagram`
- compositor rules already defined by `mitozz-compositor-executor`
- delivery, reporting, invoice, SEO, icon, or stock-photo procedure details already defined by their respective skills

## Operating Principle

Move work forward through the existing production chain instead of improvising new lanes.

Default chain:

1. strategy decision
2. calendar row
3. creative package
4. prompt or source plan
5. source generation or sourcing
6. final composition
7. posting copy
8. delivery
9. reporting

Do not skip upstream decisions unless the relevant artifact already exists and is clearly approved.

## Skill Routing

Route by job type, not by convenience.

- Account direction, prioritization, sequencing, or growth decisions -> `mitozz-instagram-strategist`
- Monthly or near-term content planning -> `mitozz-content-calendar`
- Asset-level concept, layout, copy direction, story mode, or reel shot plan -> `mitozz-creatives-director`
- Nano Banana JSON authoring or refinement -> `mitozz-prompt-engineer`
- Nano Banana execution -> `nano-banana-instagram`
- Final asset build from approved inputs -> `mitozz-compositor-executor`
- Caption, hashtag, and publishing copy pack -> `mitozz-posting-copy-optimizer`
- Intentional icon selection -> `mitozz-icon-sourcing`
- Explicit stock-photo lane or reference scouting -> `mitozz-stock-image-sourcing`
- Manual Google Drive upload and receipt -> `drive-delivery`
- Retainer log or monthly summary maintenance -> `retainer-reporting`
- Jay invoice-sheet work -> `jay-invoice-sheets`
- Shopify blog SEO packaging -> `shopify-blog-seo`

When a request spans multiple stages, use the minimum set of existing skills needed in sequence.
Do not create a synthetic hybrid role when the repo already has a stable handoff path.

## Non-Overlap Rule

Before adding new agent guidance anywhere in the repo, check whether the behavior already belongs in an existing skill.

If the instruction is:

- role-specific
- stage-specific
- output-shape-specific
- tool-procedure-specific

then it should usually be added to the relevant `SKILL.md`, not to this file.

Only add guidance to this file when it applies across multiple skills or across the full project system.

## Shared Brand Constraints

All agents in this repo should preserve these project-wide truths unless a newer approved file overrides them:

- Mitozz Japan is premium, calm, science-led, and mitochondria-first.
- Instagram is an education-first and trust-first channel before it is a conversion channel.
- Messaging must remain safe for Japan general-food communication.
- Avoid direct medical, anti-aging, guaranteed-result, or body-transformation claims.
- Prefer clarity, restraint, premium tone, and durable structure over trend-chasing.

These are global constraints. Detailed messaging and format decisions still belong to the relevant existing skills.

## Client Context

Use this context when it is relevant and supported by the task:

- Client: Jay Revels
- Audience relationship: client-facing communication should stay professional, concise, and easy to act on
- Business: Mitozz Japan is a startup selling a mitochondria and epicatechin supplement
- Website: `https://mitozzjp.myshopify.com/`

Do not overuse this context when the task is purely internal production work.

## Client-Facing Message Rule

When writing a client-facing message, especially for WhatsApp:

- sound authoritative, confident, friendly, and approachable
- keep the message concise and action-oriented
- align recommendations to Mitozz's current goals and project context
- avoid hedging, overexplaining, or brainstorming in front of the client
- present the next step clearly

For internal project work, prefer direct operational clarity over polished client tone.

## Shared Repository Map

Use these folders consistently:

- `.agents/skills/` -> project-local skills and their helpers
- `brand/references/business-context/` -> strategy, audience, planning, creative packages, reporting, and visual guidance
- `design-system/instagram/` -> reusable HTML/CSS design-first asset system
- `prompts/instagram/` -> execution-ready prompt JSON files
- `workflows/` -> lean operating checklists and handoff patterns
- `tools/` -> local scripts and production helpers
- `output/instagram/` -> rendered and generated asset history

Do not scatter durable project instructions into ad hoc temp files when they belong in one of the folders above.

## Handoff Rules

Every stage should leave the next stage with a usable artifact, not just commentary.

Expected handoffs:

- strategy -> updated decision or calendar direction
- calendar -> concrete row(s) usable by creative direction
- creative direction -> decisive creative package or equivalent brief
- prompt engineering -> named prompt JSON files or explicit source-plan notes
- generation -> saved source outputs tied back to the prompt
- composition -> final render assets in canonical output folders
- posting copy -> production-ready caption package
- delivery -> uploaded approved assets plus delivery receipt
- reporting -> updated monthly log or summary artifact

If a stage is incomplete, say exactly what is missing instead of implying the next stage can proceed.

## Canonical Naming

Preserve the repo's date-first naming system.

- Feed prompt: `ig-feed-YYYY-MM-DD-theme-vNN.json`
- Story prompt: `ig-story-YYYY-MM-DD-theme-vNN.json`
- Reel shot prompt: `ig-feed-reel-YYYY-MM-DD-theme-shot-NN-vNN.json`
- Output folders: `YYYY-MM-DD-feed-slug-vNN`, `YYYY-MM-DD-story-slug-vNN`, `YYYY-MM-DD-reel-slug-vNN`

Do not introduce alternative folder patterns unless a project-wide migration is deliberate and documented.

## Design-First Rule

This workspace supports both source-image generation and design-first assembly.

Agents should prefer the established design-system lane when:

- typography and spacing need to stay precise
- the asset is text-led
- the layout grammar already exists
- Nano Banana is only needed for plates, backgrounds, or support imagery

Do not force whole-card image generation when the approved lane is clearly compositor-first.

## Approval And Promotion Rule

Generation success is not approval.
Render success is not approval.
A file existing on disk is not approval.

Before calling an asset ready, verify that:

- the upstream brief or prompt exists and is coherent
- the output matches the approved lane
- viewer-facing copy is resolved
- the latest render or generation pass was actually checked
- feed and reel assets have posting-copy follow-through before being treated as fully ship-ready

Only approved or current assets should move into delivery or durable reference lanes.

## Reporting Rule

Meaningful retainer work should leave a reporting trace.

When work materially changes:

- strategy
- planning
- creative direction
- prompts
- production system behavior
- delivery readiness
- reporting quality

then the monthly retainer log should be updated through the existing reporting skill or workflow.

This is a workspace expectation, not a substitute for the `retainer-reporting` skill.

## Change Discipline

Prefer improving reusable systems over cloning one-off variants.

Good examples:

- update a shared template instead of copying a near-duplicate template
- refine a workflow doc instead of keeping the fix only in chat
- update the relevant skill when the rule is stage-specific
- update this file only when the rule is truly cross-cutting

Avoid:

- duplicating instructions across multiple skills
- storing core process decisions only in output folders
- inventing alternate pipelines that bypass the current production chain without a documented reason

## When To Create New Skills

Creating a new skill should be rare.

A new skill is justified only when the work:

- is durable and recurring
- has a distinct responsibility not already covered
- needs its own references, scripts, or workflow
- would otherwise overload an existing skill with unrelated concerns

Do not create a new skill for:

- a one-off asset
- a temporary campaign variation
- a rule that belongs in this file
- a refinement that clearly belongs inside an existing skill

## Definition Of Done

Work in this repo is done when:

- the correct existing lane was used
- the durable artifact was actually created or updated
- the next stage is unblocked
- naming and storage conventions were respected
- no role overlap or duplicated instruction set was introduced

If a task changes the project system itself, done also means the change was written back to the correct durable place:

- the relevant `SKILL.md`
- a workflow doc
- a shared template
- this file, but only if the rule is truly workspace-wide

## Maintenance Rule For This File

Keep this file lean.

If it starts reading like a copy of the skill library, it is too broad.
If it stops helping agents route work correctly across the repo, it is too thin.

The target is simple:

- global coordination here
- role logic in skills
- detailed steps in workflows
- durable project truth in brand and design-system artifacts
