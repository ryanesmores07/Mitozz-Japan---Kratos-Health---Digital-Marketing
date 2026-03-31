# Retainer Reporting System

Use this folder to capture meaningful retainer work as it happens so monthly reporting to Jay is fast, accurate, and easy to defend.

## Goal

This system should answer three questions clearly at the end of each month:

1. What meaningful work did we do?
2. Why did it matter to the retainer scope?
3. What changed, shipped, improved, or got unblocked because of it?

## Folder Structure

- `monthly-action-logs/`: running logs of significant actions taken during each month
- `monthly-summary-reports/`: draft and final monthly summaries for Jay
- `instagram-metrics/`: normalized monthly Instagram performance snapshots used as a reusable decision layer
- `delivery-receipts/`: upload receipts for manual Google Drive delivery runs
- `templates/`: reusable templates for both logs and summaries
- `templates/jay-monthly-invoice-data-template.json`: local JSON starter for salary and expense sheet payloads
- `jay-invoice-recurring-defaults.json`: recurring monthly invoice defaults for Jay, including salary placeholder and ongoing expense lines

## What To Log

Log an action when it is significant and within the retainer scope.

Good examples:

- monthly calendar planning or revision
- creative package creation or major revision
- meaningful user prompts or requests that materially changed direction, priorities, or deliverables
- performance snapshot creation or interpretation that changes planning or execution
- prompt system upgrades
- generation workflow improvements
- approved production batch completion
- QA, consistency, or process fixes that reduce future errors
- tooling or MCP improvements that affect delivery quality, speed, or reliability
- strategic recommendations that changed execution

Do not log minor noise on its own:

- trivial wording edits
- duplicate retries with no meaningful change
- exploratory work that did not affect direction
- small housekeeping unless it materially improved production

## Significance Gate

Before logging an action, check these three questions:

1. Did this change delivery quality, delivery speed, strategy, creative direction, system reliability, or client readiness in a meaningful way?
2. Would it sound credible and useful in a monthly retainer summary to Jay?
3. Is there a concrete outcome, artifact, decision, or improvement we can point to?

If the answer is `yes` to at least two of the three, log it.

## Logging Rule

Each entry should be outcome-oriented, not activity-oriented.

Bad:

- "Worked on prompts"

Good:

- "Standardized the Nano Banana MCP launcher so all future image runs default to Nano Banana 2 instead of the Pro package"

## Entry Standard

Every logged action should include:

- `Date`
- `Workstream`
- `Request / prompt context`
- `Action`
- `Why it matters`
- `Artifacts updated`
- `Outcome / impact`
- `Status`
- `Notes for monthly summary`

## Default Logging Workflow

1. Treat logging as the default for significant retainer work, not an optional follow-up step.
2. Add a new entry to the current month's action log as soon as a meaningful retainer action is completed.
3. When a user prompt or request materially triggered the work, capture that context inside the entry so later monthly reporting can trace why the work happened.
4. Do not wait for the user to explicitly ask for logging when the action clearly passes the significance gate.
5. Keep entries short but concrete.
6. At month end, group entries into a clean client-facing summary under:
   - strategy and planning
   - creative and production
   - systems and process improvements
   - recommendations and next steps

## Operating Cadence

- During the month: append meaningful actions to the current log as soon as the work lands, and include the triggering request context when it materially shaped the work.
- At week checkpoints: clean wording if needed so entries stay client-readable and outcome-led.
- At month end: convert the log into one concise summary for Jay instead of rebuilding the month from memory.

## Instagram Metrics Workflow

When Instagram insights, screenshots, or exports are provided:

1. normalize them into `instagram-metrics/YYYY-MM-instagram-metrics-snapshot.md`
2. preserve the useful numbers and interpretation in a durable text file instead of leaving them only in screenshots
3. summarize what the data suggests about discovery, profile curiosity, engagement, conversion, and format strength
4. use the latest snapshot as a live input for strategy, calendar planning, creative direction, and monthly reporting

Keep the interpretation directional, not overconfident. Use metrics to sharpen the next decisions, not to overreact to one post.

## Skill Support

Use the project skill `retainer-reporting` when you want Codex to:

- decide whether something should count toward the retainer report
- append a new entry to the current month log
- clean up an existing log for client-ready reporting
- draft the monthly summary for Jay from the action log

Use the project skill `drive-delivery` when you want Codex to:

- verify a Google Drive destination before upload
- run a dry delivery check on approved files
- upload approved story, reel, feed, or caption assets to Drive
- create a delivery receipt after a manual upload run

Use the project skill `jay-invoice-sheets` when you want Codex to:

- inspect the existing invoice Google Sheets in Jay's Drive folder
- copy the latest or selected invoice sheet into a new month
- write normalized salary and expense data into a helper tab
- keep the monthly salary and expense sheet workflow repeatable

## Naming Convention

- monthly action log: `YYYY-MM-retainer-action-log.md`
- monthly summary report: `YYYY-MM-monthly-summary-for-jay.md`
- instagram metrics snapshot: `YYYY-MM-instagram-metrics-snapshot.md`

## Current Operating Rule

If we finish a significant action in this workspace, we should add it to the current month's action log before moving on whenever practical.

For Jay retainer work, the default expectation is:

- significant completed actions are logged automatically without needing a user reminder
- significant project-related prompts and requests are folded into those log entries when they materially shaped the work
- the current monthly action log should stay current enough that month-end reporting can be built from it directly
- only low-signal or clearly non-retainer noise should be skipped
