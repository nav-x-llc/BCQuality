---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- Commit
- transaction
- database
- partial save
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

`Commit()` in AL permanently writes the current transaction to the database and
starts a new one. Calling it inside a loop or a procedure that may be called
from within a larger transaction is one of the most common sources of data
integrity bugs. A subsequent error cannot roll back data that was already committed.

## Best Practice

Avoid `Commit()` inside loops entirely. If a step-by-step process genuinely
requires interim commits (e.g. a Job Queue processor that should not roll back
all previous items on a single failure), structure the work as separate Job
Queue Entries or use a status-flag pattern where each item is committed
individually with its own status record.

Only call `Commit()` at the outermost level of a top-level codeunit (e.g. a
`Codeunit.Run` wrapper), never deep inside shared library procedures.

```al
// Acceptable: top-level JQE runner commits after each item
codeunit 50090 "NAVX Batch Processor"
{
    TableNo = "NAVX Batch Item";

    trigger OnRun()
    begin
        Rec.Status := Rec.Status::Processing;
        Rec.Modify();
        Commit(); // safe — this codeunit IS the transaction boundary

        ExecuteItem(Rec);

        Rec.Status := Rec.Status::Completed;
        Rec.Modify();
    end;
}
```

## Anti Pattern

Calling `Commit()` inside a loop, or inside a shared procedure that may be
called from arbitrary contexts.

```al
// WRONG — Commit inside loop; a later error cannot roll back earlier items
for i := 1 to ItemList.Count do begin
    ProcessItem(ItemList.Get(i));
    Commit(); // if item 7 errors, items 1-6 are already committed
end;
```
