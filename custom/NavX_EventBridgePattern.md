---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: design-pattern
keywords:
- event bridge
- integration event
- decoupling
- module boundary
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

The Event Bridge pattern re-publishes a Base Application or NAV-X Library event
as a feature-specific integration event. This decouples the feature's subscribers
from the originating object, making the feature portable and easier to test.
Subscribers always listen to the bridge event, never to the raw base app event.

## Best Practice

Create one bridge codeunit per feature that subscribes to base app events and
immediately raises a feature-owned `[IntegrationEvent]`. All other feature
codeunits subscribe to the feature event, not the base app event.

```al
codeunit 50050 "NAVX Comm. Event Bridge"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::SalesPost, OnAfterPostSalesDoc, '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    begin
        OnAfterSalesInvoicePosted(SalesHeader);
    end;

    [IntegrationEvent(false, false)]
    internal procedure OnAfterSalesInvoicePosted(var SalesHeader: Record "Sales Header")
    begin
    end;
}
```

## Anti Pattern

Multiple codeunits all subscribing directly to the same base app event, creating
hidden coupling and making it impossible to test the feature in isolation.

```al
// WRONG — three codeunits all coupling directly to SalesPost
// If SalesPost event signature changes, all three break independently
[EventSubscriber(ObjectType::Codeunit, Codeunit::SalesPost, OnAfterPostSalesDoc, '', ...)]
local procedure HandlePost1(...) begin end;
// repeated in CommissionCalc.Codeunit.al, CommissionEntry.Codeunit.al, etc.
```
