---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- event subscriber
- integration event
- event publisher
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

AL event subscribers are the primary extension point in Business Central. Incorrect
subscriber declarations silently fail at runtime — the subscriber is never called
without any compile-time error.

## Best Practice

Always verify event names against the BCApps source before writing a subscriber.
Use `[EventSubscriber(ObjectType::Codeunit, Codeunit::<Name>, '<EventName>', '', false, false)]`.
Never quote the event name — use the bare identifier.
Set `SingleInstance = true` on every subscriber codeunit.
Pass record parameters by reference (`var Rec: Record <Name>`).
Add `var IsHandled: Boolean` to integration events so downstream code can short-circuit.

```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::SalesPost, OnBeforePostSalesDoc, '', false, false)]
local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
begin
    if IsHandled then
        exit;
    // implementation
end;
```

## Anti Pattern

Quoting event names, subscribing to non-existent events, or subscribing to the `OnInsert`/
`OnModify`/`OnDelete` table triggers (these disable `InsertAll`/`ModifyAll`/`DeleteAll`).

```al
// WRONG — quoted event name, OnInsert table trigger, no IsHandled
[EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnInsert', '', false, false)]
local procedure OnInsertSalesHeader(var Rec: Record "Sales Header")
begin
    Rec.MyField := 'x';
end;
```
