---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: performance
keywords:
- SetLoadFields
- partial records
- performance
- database
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

By default, a `FindSet`/`Get` call loads every field of the record. On large tables
(Item, Customer, Sales Line, G/L Entry) this transfers far more data than needed,
causing significant performance degradation in SaaS BC environments.

## Best Practice

Call `SetLoadFields(Field1, Field2, ...)` before every database read that does not
need all fields. This is especially important inside loops, background tasks, and
any code that runs on large record sets.

```al
procedure SumLineAmounts(DocNo: Code[20]): Decimal
var
    SalesLine: Record "Sales Line";
    Total: Decimal;
begin
    SalesLine.SetLoadFields(Amount);
    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
    SalesLine.SetRange("Document No.", DocNo);
    if SalesLine.FindSet() then
        repeat
            Total += SalesLine.Amount;
        until SalesLine.Next() = 0;
    exit(Total);
end;
```

## Anti Pattern

Reading full records in loops or when only one or two fields are needed.

```al
// WRONG — loads all 100+ fields of Sales Line in a tight loop
SalesLine.SetRange("Document No.", DocNo);
if SalesLine.FindSet() then
    repeat
        Total += SalesLine.Amount;
    until SalesLine.Next() = 0;
```
