---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- setup table
- singleton
- configuration
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

NAV-X extensions use a singleton setup table per feature area to hold configuration.
The setup table always has a single record with `Primary Key` as the key field.
Access is always via `GetRecordOnce` or `Get` with an `if not ... then` guard.

## Best Practice

Define a `GetRecordOnce` procedure on the setup table that initialises a default
record if none exists. Call `Get` only when you need to enforce that configuration
exists. Never insert setup records from user-facing code — use the Setup page.
Always add the setup table to the feature's permission set.

```al
table 50000 "MyFeature Setup"
{
    DataClassification = CustomerContent;
    Caption = 'My Feature Setup';

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; }
        field(2; Enabled; Boolean) { Caption = 'Enabled'; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    procedure GetRecordOnce()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
```

## Anti Pattern

Hard-coding setup values, accessing setup via `FindFirst` without handling the
empty-table case, or creating multiple setup records.

```al
// WRONG — FindFirst may return false; no default initialisation
if SetupRec.FindFirst() then
    DoSomething(SetupRec.Enabled);
```
