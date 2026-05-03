---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- DeleteAll
- temporary record
- batch delete
- triggers
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

`DeleteAll(true)` runs the `OnDelete` trigger and all `OnBeforeDeleteEvent` /
`OnAfterDeleteEvent` subscribers for every record. On large tables this is
extremely slow. `DeleteAll(false)` (or no argument) skips triggers entirely.
Use `false` for batch deletes of temporary records or when triggers are not
needed. Never call `DeleteAll` without considering which variant is correct.

## Best Practice

For temporary records (used as buffers): always use `DeleteAll(false)` —
there are no subscribers that need to fire on a temp table.
For permanent records where cascade cleanup is not needed: use `DeleteAll(false)`
and handle any cleanup explicitly before the call.
For permanent records where `OnDelete` cleanup is required (e.g. deleting a
header and all its lines via triggers): use `DeleteAll(true)` but only after
confirming the table's trigger logic is safe to run in bulk.

```al
// Clearing a temp buffer — no triggers needed
TempBuffer.DeleteAll(false);

// Batch-deleting archived entries — no cascade needed
ArchivedEntry.SetRange(Status, ArchivedEntry.Status::Processed);
ArchivedEntry.SetRange("Processed Date", 0D, CalcDate('<-1Y>', Today()));
ArchivedEntry.DeleteAll(false);
```

## Anti Pattern

Using `DeleteAll(true)` on large permanent tables when triggers are not needed,
or using `DeleteAll` on a table that has `OnDelete` subscribers that perform
expensive work (HTTP calls, additional DB writes) for every record.

```al
// WRONG — DeleteAll(true) fires OnDelete for every row; catastrophic on large tables
LogEntry.SetRange("Created Date", 0D, CalcDate('<-1Y>', Today()));
LogEntry.DeleteAll(true); // runs OnDelete N times; use false for log cleanup
```
