---
name: retainer-reporting
description: Maintain Jay retainer action logs and monthly summaries. Use when the user asks to log meaningful retainer work, decide whether work should count toward the retainer, clean up the monthly action log, or draft the monthly summary report for Jay.
---

# Retainer Reporting

Use this skill to keep a clean running record of meaningful retainer work and turn that record into concise monthly summaries for Jay.

## Read These First

1. `brand/references/business-context/reporting/README.md`
2. `brand/references/business-context/reporting/monthly-action-logs/YYYY-MM-retainer-action-log.md` for the relevant month if it exists
3. `brand/references/business-context/reporting/templates/retainer-action-log-template.md`
4. `brand/references/business-context/reporting/templates/monthly-summary-for-jay-template.md`
5. `brand/references/business-context/reporting/templates/instagram-metrics-snapshot-template.md` when performance data is being normalized

## When To Use

Use this skill when the user asks to:

- record meaningful work completed under the retainer
- decide whether a completed action is significant enough to log
- clean up, deduplicate, or tighten a monthly action log
- turn Instagram insights, screenshots, or exported metrics into a monthly performance snapshot
- turn a monthly action log into a Jay-ready summary report

Also use this skill automatically whenever a significant Jay retainer action has just been completed, even if the user did not explicitly ask for a log entry in that moment. The same applies when a meaningful user prompt or request materially shaped project direction, deliverables, priorities, or scope, so that request context is preserved inside the monthly record.

## Significance Rule

Log work when it is meaningfully within retainer scope and has a defensible outcome.

Default to logging when the action:

- changed strategy, planning, creative direction, prompts, production, QA, tooling, delivery systems, or reporting quality
- was materially triggered by a user request or prompt that changed project direction, deliverables, or priorities
- created or materially revised a durable artifact
- improved speed, reliability, clarity, consistency, or client readiness

Do not log trivial noise on its own.

## Logging Standard

Each log entry should be outcome-led, concise, and written so it can later be reused in client-facing reporting with minimal rewrite.

Every entry should include:

- `Date`
- `Workstream`
- `Request / prompt context`
- `Action`
- `Why it matters`
- `Artifacts updated`
- `Outcome / impact`
- `Status`
- `Notes for monthly summary`

## Operating Workflow

1. Identify the relevant month from the work date.
2. Open the current monthly action log or create it from the template if missing.
3. If the user supplied Instagram performance data, normalize it into `brand/references/business-context/reporting/instagram-metrics/YYYY-MM-instagram-metrics-snapshot.md` before summarizing it elsewhere.
4. Decide whether the action passes the significance rule.
5. If the work was materially triggered by a user request or prompt, capture that request context inside the entry.
6. Add one concise entry per meaningful completed action as part of the normal completion workflow, not as a separate optional step.
7. Keep language outcome-oriented and easy to roll up into a monthly report.
8. When asked for a monthly summary, group the month into a few client-facing themes instead of dumping raw entries.

## Default Behavior

For Jay retainer work, assume significant completed actions should be logged automatically unless there is a clear reason not to.

Do not rely on the user to remember to ask for logging each time, including prompt logging when the request materially shaped the work.
Do not leave metrics only in screenshot form when a clean monthly snapshot would materially help future planning or reporting.

## Summary Writing Rule

Monthly summaries for Jay should:

- stay concise and credible
- emphasize what changed, improved, shipped, or got unblocked
- avoid low-signal operational noise
- convert internal detail into clear business-facing progress
