---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- ApplicationArea
- ToolTip
- table field
- page field
- field properties
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

AL has a strict split between table-level and page-level field properties.
`ApplicationArea` and `ToolTip` are page properties — placing them on a table
field causes a compile error. This is among the most common mistakes AI models
make when generating AL code.

## Best Practice

**Table / table extension fields:** `Caption`, `FieldClass`, `CalcFormula`,
`Editable`, `BlankZero`, `InitValue`, `DataClassification`, `trigger`.
**Page / page extension fields:** `ApplicationArea`, `ToolTip`, `Visible`,
`Editable`, `StyleExpr`, `trigger`.

```al
// Table field — Caption only, no ApplicationArea/ToolTip
field(10; "Commission Rate"; Decimal)
{
    Caption = 'Commission Rate';
    DataClassification = CustomerContent;
    BlankZero = true;
}
```

```al
// Page field — ApplicationArea + ToolTip
field("Commission Rate"; Rec."Commission Rate")
{
    ApplicationArea = All;
    ToolTip = 'Specifies the commission rate applied to this line.';
}
```

## Anti Pattern

Placing `ApplicationArea` or `ToolTip` on a table field definition.

```al
// WRONG — ApplicationArea and ToolTip are NOT valid on table fields
field(10; "Commission Rate"; Decimal)
{
    Caption = 'Commission Rate';
    ApplicationArea = All;   // compile error
    ToolTip = 'Rate.';       // compile error
}
```
