---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- temporary
- IsTemporary
- table
- performance
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

Temporary tables (`IsTemporary = true` or declared as `temporary` in a procedure variable)
hold records only in memory for the lifetime of the codeunit or variable scope. They do not
write to the database and do not fire record-level triggers on `Insert` / `Modify` / `Delete`.
Misusing temporary tables — or using real tables for transient work — causes data pollution
and performance problems.

## Best Practice

Declare temporary table variables explicitly with the `temporary` keyword. Use them for
intermediate sorting, filtering, or accumulation before writing final results to a persistent
table. Always call `Reset()` and `DeleteAll()` before re-populating a temporary table that
may have been used in a previous loop iteration.

Do not rely on record-level triggers (`OnInsert`, `OnModify`, `OnDelete`) firing when you
write to a temporary table — those triggers do not run on the in-memory copy.

```al
// Correct: accumulate in temp table, then write once to real table
local procedure CommitResults(var TempBuffer: Record "NAVX Work Buffer" temporary)
var
    FinalRecord: Record "NAVX Result Entry";
begin
    TempBuffer.Reset();
    if TempBuffer.FindSet() then
        repeat
            FinalRecord.Init();
            FinalRecord.TransferFields(TempBuffer);
            FinalRecord.Insert(true);
        until TempBuffer.Next() = 0;
end;
```

## Anti Pattern

Using a real (persistent) table as scratch space for transient processing. Any error before
cleanup leaves orphan rows; performance is worse due to unnecessary I/O.

```al
// WRONG — real table used as scratch; rows persist if an error occurs before DeleteAll
var
    WorkRecord: Record "NAVX Work Buffer";  // not temporary
begin
    WorkRecord.Init();
    WorkRecord."Entry No." := GetNextEntryNo();
    WorkRecord.Insert();  // writes to database
    // ... if an error is thrown here, WorkRecord row is never cleaned up
    WorkRecord.DeleteAll();
end;
```
