---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- naming
- object name
- prefix
- PascalCase
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

Consistent object and variable naming is required across all NAV-X extensions.
Object names must not exceed 30 characters. AL reserved words must never be used
as variable or parameter names.

## Best Practice

**Object names:** `<Prefix><FeatureName> <Type>` — e.g. `"NAVX Comm. Reg. Codeunit"`.
Max 30 characters; abbreviate freely when needed.
**Variables:** PascalCase. Avoid AL reserved words: `Key`, `Value`, `Field`,
`System`, `Type`, `Action`, `Record`, `Page`, `Table`, `Codeunit`, `Report`.
**File names:** `<ObjectName>.<ObjectType>.al` — e.g. `CommissionMgt.Codeunit.al`.
**Labels:** All user-visible text must be Label variables — never hardcoded strings.

```al
// Good: descriptive, PascalCase, no reserved words
var
    CommissionEntry: Record "NAVX Commission Entry";
    TotalAmount: Decimal;
    EntryDescription: Text[100];
    IsProcessed: Boolean;
    ProcessingLbl: Label 'Processing entry %1.', Comment = '%1 = Entry No.';
```

## Anti Pattern

Using reserved words as variable names, hardcoding user-visible strings, or naming
objects with generic names that don't include the feature prefix.

```al
// WRONG — reserved word 'Type' as variable, hardcoded string
var
    Type: Option ,Direct,Indirect;
begin
    Message('Processing entry ' + Format(EntryNo));
end;
```
