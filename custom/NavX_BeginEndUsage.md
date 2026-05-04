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

AL single-statement `if`, `else`, `for`, `while`, and `repeat` bodies
must be placed on the **next line, indented** — no `begin`/`end` wrapper.
`begin`/`end` is only required when the body contains two or more statements.

Placing the statement on the same line as `then` (or `do`) makes it invisible
at a glance and is a common source of bugs.

## Best Practice

Single statement — next line, indented, no `begin`/`end`:

```al
if not Customer.Get(CustomerNo) then
    exit;

if (Rec.Type <> Rec.Type::Item) or (Rec."No." = '') then
    exit;

for i := 1 to Count do
    ProcessItem(i);
```

Multi-statement body — always wrap in `begin`/`end`:

```al
if Customer.Get(CustomerNo) then begin
    ProcessCustomer(Customer);
    LogAccess(Customer."No.");
end else begin
    Error(CustomerNotFoundErr, CustomerNo);
end;
```

## Anti Pattern

**Statement on the same line as `then`/`do` (hard to read, easy to mis-read):**

```al
// BAD
if not Customer.Get(CustomerNo) then exit;
for i := 1 to Count do ProcessItem(i);
```

**Unnecessary `begin`/`end` around a single statement (verbose, not required):**

```al
// BAD
if (Rec.Type <> Rec.Type::Item) or (Rec."No." = '') then begin
    exit;
end;
```
