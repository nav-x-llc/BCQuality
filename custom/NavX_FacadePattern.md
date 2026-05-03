---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: design-pattern
keywords:
- facade
- codeunit
- encapsulation
- single responsibility
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

The Façade pattern wraps complex business logic in a single management codeunit
(`<Feature>Mgt.` or `<Feature>Management`). External callers use only the façade —
never internal helper codeunits directly. This is the standard NAV-X architecture
for any feature with more than one AL object.

## Best Practice

Create one `<FeatureName>Mgt.` codeunit as the public API of the feature.
All subscriber codeunits, helper codeunits, and internal logic remain `local` or
`internal` and are called only by the management codeunit.
The management codeunit raises `IsHandled` integration events for the most
important operations so other extensions can intercept.

```al
codeunit 50030 "NAVX Commission Mgt."
{
    procedure CalculateCommission(var SalesLine: Record "Sales Line"): Decimal
    var
        IsHandled: Boolean;
        CommissionAmount: Decimal;
    begin
        OnBeforeCalculateCommission(SalesLine, CommissionAmount, IsHandled);
        if IsHandled then
            exit(CommissionAmount);

        CommissionAmount := RunInternalCalculation(SalesLine);

        OnAfterCalculateCommission(SalesLine, CommissionAmount);
        exit(CommissionAmount);
    end;

    local procedure RunInternalCalculation(var SalesLine: Record "Sales Line"): Decimal
    begin
        // implementation detail hidden from callers
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateCommission(var SalesLine: Record "Sales Line";
        var CommissionAmount: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateCommission(var SalesLine: Record "Sales Line";
        var CommissionAmount: Decimal)
    begin
    end;
}
```

## Anti Pattern

Scattering business logic across multiple codeunits with no single entry point, or
calling internal helper codeunits directly from event subscribers.
