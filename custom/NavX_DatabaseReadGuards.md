---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- Get
- FindSet
- FindFirst
- SetLoadFields
- error handling
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

Every database read in AL can return false or raise a runtime error if the record
does not exist. Unguarded reads are among the most common causes of production errors
in Business Central extensions.

## Best Practice

Wrap every `Get`, `FindFirst`, `FindLast`, and `FindSet` in `if ... then`.
Use `SetLoadFields` before reads to load only the fields you need — this is
critical for performance on large tables.
Use `SetRange` / `SetFilter` before `FindSet` to limit the result set.

```al
var
    Item: Record Item;
begin
    Item.SetLoadFields(Description, "Unit Price");
    if Item.Get(ItemNo) then
        ProcessItem(Item);
end;
```

```al
var
    SalesLine: Record "Sales Line";
begin
    SalesLine.SetLoadFields("No.", Quantity);
    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
    SalesLine.SetRange("Document No.", DocNo);
    if SalesLine.FindSet() then
        repeat
            ProcessLine(SalesLine);
        until SalesLine.Next() = 0;
end;
```

## Anti Pattern

Unguarded `Get` or `FindFirst` that can throw a runtime error, or reading all fields
when only one or two are needed.

```al
// WRONG — unguarded Get; throws if item not found
Item.Get(ItemNo);
DoWork(Item.Description);

// WRONG — loads all fields on a large table
SalesLine.FindSet();
```
