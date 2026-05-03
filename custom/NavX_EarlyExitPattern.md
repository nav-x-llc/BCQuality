---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- early exit
- guard clause
- FindFirst
- if not find
- exit
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

The "if not find — exit" (guard clause) pattern exits a procedure immediately
when its preconditions are not met, rather than wrapping the entire body in a
nested `if` block. This reduces nesting depth and makes the happy path obvious.
It is the standard alguidelines.dev best practice for AL procedures.

## Best Practice

Place all precondition checks at the top of the procedure and `exit` when they
fail. The main logic then runs without extra indentation.

```al
procedure ProcessSalesLines(DocNo: Code[20])
var
    SalesLine: Record "Sales Line";
begin
    SalesLine.SetLoadFields("No.", Quantity, Amount);
    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
    SalesLine.SetRange("Document No.", DocNo);
    if not SalesLine.FindSet() then
        exit;

    repeat
        ProcessLine(SalesLine);
    until SalesLine.Next() = 0;
end;
```

## Anti Pattern

Wrapping the entire procedure body inside `if FindSet() then ... end;`, which
adds one level of unnecessary nesting for every guard.

```al
// WRONG — body is nested inside the if; grows deeper with each guard
procedure ProcessSalesLinesBad(DocNo: Code[20])
var
    SalesLine: Record "Sales Line";
begin
    SalesLine.SetRange("Document No.", DocNo);
    if SalesLine.FindSet() then begin
        repeat
            if SalesLine.Quantity > 0 then begin
                if SalesLine.Amount > 0 then begin
                    ProcessLine(SalesLine);
                end;
            end;
        until SalesLine.Next() = 0;
    end;
end;
```
