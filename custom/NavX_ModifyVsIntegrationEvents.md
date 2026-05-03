---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- Modify
- RunTrigger
- OnAfterModify
- integration event
- trigger
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

`Rec.Modify(true)` fires the table's `OnBeforeModify` and `OnAfterModify` triggers and all
subscribers. `Rec.Modify(false)` skips those triggers entirely. This distinction is one of
the most commonly misunderstood in AL and is a frequent source of missed audit entries, sync
failures, and silent data divergence when `Modify(false)` is used without intention.

## Best Practice

Use `Modify(true)` (the default) for all user-facing data changes where other extensions or
base-app logic may need to react. Only call `Modify(false)` for deliberate internal
bookkeeping updates — status flags, timestamps — where triggering subscribers would be
correctly wrong. Every `Modify(false)` call must have a comment explaining why.

For logic that must always execute regardless of how a record is saved — audit logging,
external sync, cross-table updates — publish a dedicated integration event and subscribe to
it. Do not rely on `OnAfterModify` for cross-extension coordination.

```al
// Correct: data change — trigger must cascade
Rec.Description := NewDescription;
Rec.Modify(true);

// Correct: internal status flag — deliberately no cascade; document why
Rec."Processing Status" := Rec."Processing Status"::Completed;
Rec.Modify(false);  // status-only; subscribers react via OnAfterStatusChanged event
```

## Anti Pattern

Using `Modify(false)` as a performance shortcut on real data changes, or subscribing to
`OnAfterModify` for critical cross-extension logic that will silently break if any caller
uses `Modify(false)`.

```al
// WRONG: Modify(false) used for speed on a data field — audit subscriber never fires
Rec.Amount := CalculatedAmount;
Rec.Modify(false);  // audit log silently skipped

// WRONG: cross-extension sync via OnAfterModify — breaks silently when Modify(false) is called
[EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
local procedure SyncToExternal(var Rec: Record "Sales Header")
begin
    ExternalSync.Push(Rec);  // will not fire if any code uses Modify(false)
end;
```
