---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: design-pattern
keywords:
- template method
- algorithm skeleton
- override
- extensibility
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

The Template Method pattern defines the skeleton of an algorithm in a base
codeunit, deferring variation points to integration events or virtual-style
procedures. Callers invoke the template, which calls extension points at the
right moments, without the caller knowing the implementation details.

## Best Practice

Publish `[IntegrationEvent]` hooks at the start, middle, and end of the
algorithm. Use `IsHandled` at the start to let subscribers short-circuit the
default implementation entirely.

```al
codeunit 50070 "NAVX Price Calc. Template"
{
    procedure CalculatePrice(var SalesLine: Record "Sales Line")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCalculatePrice(SalesLine, IsHandled);
        if IsHandled then
            exit;

        ApplyBasePrice(SalesLine);
        ApplyDiscounts(SalesLine);

        OnAfterCalculatePrice(SalesLine);
    end;

    local procedure ApplyBasePrice(var SalesLine: Record "Sales Line") begin end;
    local procedure ApplyDiscounts(var SalesLine: Record "Sales Line") begin end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculatePrice(var SalesLine: Record "Sales Line"; var IsHandled: Boolean) begin end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculatePrice(var SalesLine: Record "Sales Line") begin end;
}
```

## Anti Pattern

Copying the algorithm into each variant codeunit with minor tweaks, or using
`if-then-else` chains in a single procedure to handle all variants.

```al
// WRONG — copy-paste variant; changes must be applied in N places
codeunit 50071 "NAVX Price Calc. For Group A"
{
    procedure CalculatePrice(var SalesLine: Record "Sales Line")
    begin
        // identical to Template except one line
    end;
}
```
