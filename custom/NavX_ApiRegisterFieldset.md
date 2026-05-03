---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: design-pattern
keywords:
- API
- register fieldset
- field list
- extensibility
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

The API Register Fieldset pattern allows other extensions to declare which fields
they need exposed on an API page or a dataset. Instead of hardcoding fields, the
publisher raises an event that subscribers use to register additional fields.
This keeps the base API clean while remaining extensible without modification.

## Best Practice

Declare a `TempFieldBuffer` or a simple list procedure that collects field numbers.
Raise an `[IntegrationEvent]` so other extensions (or test code) can add fields.
The API page or report dataset includes only fields returned by the registration.

```al
codeunit 50060 "NAVX Customer API Fields"
{
    procedure GetFields(var FieldList: List of [Integer])
    begin
        FieldList.Add(1);   // No.
        FieldList.Add(2);   // Name
        FieldList.Add(21);  // Customer Posting Group
        OnAfterGetCustomerApiFields(FieldList);
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterGetCustomerApiFields(var FieldList: List of [Integer])
    begin
    end;
}
```

## Anti Pattern

Hardcoding all fields on every API page, requiring modification of the base
extension to expose additional fields from a dependent extension.

```al
// WRONG — field list is static, cannot be extended without modifying this file
page 50060 "NAVX Customer API"
{
    SourceTable = Customer;
    PageType = API;
    layout
    {
        area(Content)
        {
            field(no; Rec."No.") { }
            field(name; Rec.Name) { }
            // Adding a field requires editing this page directly
        }
    }
}
```
