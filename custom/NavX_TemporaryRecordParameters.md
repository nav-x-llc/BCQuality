---
bc-version:
  - 22.0
  - 23.0
  - 24.0
  - 25.0
domain: data-access
keywords:
  - temporary
  - parameter
  - record
  - IsTemporary
  - table extension
technologies:
  - AL
countries:
  - W1
application-area: All
---

## Description

When a procedure accepts a `Record` parameter that is expected to be a temporary instance,
declare it with the `temporary` modifier (`var Rec: Record "X" temporary`). Omitting the
modifier allows callers to pass a real database record, which causes event subscribers that
test `IsTemporary()` to skip processing, and procedures that call `Modify()` to write back
to the live table unexpectedly. Apply the same discipline to `[EventSubscriber]` procedures
that forward temporary records — mis-matching the modifier silently drops the `temporary`
attribute and breaks callers that depend on isolation.

## Best Practice

```al
// Declare the temporary modifier so callers and the compiler both enforce isolation.
procedure TransferFromPVSJob(
    var PVSJob: Record "PVS Job";
    var TrackingEntry: Record "Reservation Entry" temporary;
    OutstandingQty: Decimal;
    FinishedQty: Decimal)
begin
    // Safe: TrackingEntry is guaranteed to be temporary; no accidental DB write.
end;

// In an event subscriber, guard against the record being temporary when the event
// fires on non-table-trigger paths that reach temporary instances.
[EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
local procedure SalesLineNoOnAfterValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
begin
    if Rec.IsTemporary() then
        exit;
    // ... real logic ...
end;
```

## Anti Pattern

```al
// BAD: temporary modifier omitted — compiler cannot enforce isolation.
procedure TransferFromPVSJob(
    var PVSJob: Record "PVS Job";
    var TrackingEntry: Record "Reservation Entry"; // BAD - missing 'temporary'
    OutstandingQty: Decimal;
    FinishedQty: Decimal)
begin
    // Caller may pass a real Reservation Entry; accidental Modify() writes to DB.
end;

// BAD: no IsTemporary() guard — subscriber acts on temporary records it should skip.
[EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
local procedure SalesLineNoOnAfterValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
begin
    // BAD - fires on temporary instances too; unintended side-effects in what-if scenarios.
    Rec."NAVX Custom Field" := 'X';
end;
```
