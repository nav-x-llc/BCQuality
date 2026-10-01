---
bc-version:
  - 22.0
  - 23.0
  - 24.0
  - 25.0
domain: data-access
keywords:
  - Get
  - FindFirst
  - error handling
  - guarded read
  - database
technologies:
  - AL
countries:
  - W1
application-area: All
---

## Description

Every call to `Record.Get()`, `Record.FindFirst()`, or `Record.FindSet()` must check the
Boolean return value before accessing the record's fields. An unguarded call that silently
continues when no record exists reads default (zero/blank) field values, producing incorrect
results or posting corrupt data without any runtime error. Always branch on the return value
or raise a descriptive error so the failure surface is explicit and the data path is safe.

## Best Practice

```al
// Guard every database read and surface a clear error when the record is absent.
local procedure GetPostingSetup(GLAccountNo: Code[20]): Code[20]
var
    GLAccount: Record "G/L Account";
    GLAccountNotFoundErr: Label 'G/L Account %1 does not exist.', Comment = '%1 - G/L Account No.';
begin
    if not GLAccount.Get(GLAccountNo) then
        Error(GLAccountNotFoundErr, GLAccountNo);
    exit(GLAccount."Gen. Prod. Posting Group");
end;

// Guard FindFirst and handle the not-found case explicitly.
local procedure GetFirstOpenEntry(CustomerNo: Code[20]; var CustLedgerEntry: Record "Cust. Ledger Entry"): Boolean
begin
    CustLedgerEntry.SetRange("Customer No.", CustomerNo);
    CustLedgerEntry.SetRange(Open, true);
    CustLedgerEntry.SetLoadFields("Entry No.", "Remaining Amount");
    exit(CustLedgerEntry.FindFirst());
end;
```

## Anti Pattern

```al
// BAD: return value of Get() is ignored; fields are read even when no record exists.
local procedure GetPostingSetup(GLAccountNo: Code[20]): Code[20]
var
    GLAccount: Record "G/L Account";
begin
    GLAccount.Get(GLAccountNo); // BAD - unguarded, silently continues on miss
    exit(GLAccount."Gen. Prod. Posting Group"); // BAD - blank when record not found
end;

// BAD: FindFirst() return value ignored; subsequent field access reads defaults.
local procedure StampLedgerEntry(CustomerNo: Code[20])
var
    CustLedgerEntry: Record "Cust. Ledger Entry";
begin
    CustLedgerEntry.SetRange("Customer No.", CustomerNo);
    CustLedgerEntry.FindFirst(); // BAD - no check; wrong entry used if not found
    CustLedgerEntry."NAVX Custom Field" := 'X';
    CustLedgerEntry.Modify();
end;
```
