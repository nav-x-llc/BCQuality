---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: general
keywords:
- begin
- end
- if statement
- code style
- readability
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

AL allows single-statement `if` bodies without `begin`/`end`, but omitting them
is a common source of bugs when additional statements are added later. NAV-X
requires `begin`/`end` on every `if`, `else`, `for`, `while`, and `repeat` body,
even when it contains only one statement.

## Best Practice

Always wrap `if`, `else`, `for`, `while`, and `with` bodies in `begin`/`end`.
This prevents the "dangling else" class of bugs and makes diffs easier to read.

```al
if Customer.Get(CustomerNo) then begin
    ProcessCustomer(Customer);
    LogAccess(Customer."No.");
end else begin
    Error(CustomerNotFoundErr, CustomerNo);
end;
```

```al
for i := 1 to 10 do begin
    ProcessItem(i);
end;
```

## Anti Pattern

Omitting `begin`/`end` on single-statement if bodies, which breaks silently when
a second statement is added.

```al
// WRONG — second statement is NOT inside the if, despite the indentation
if Customer.Get(CustomerNo) then
    ProcessCustomer(Customer);
    LogAccess(Customer."No.");  // always runs, even when Get fails
```
