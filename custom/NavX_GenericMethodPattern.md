---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: design-pattern
keywords:
- generic method
- variant
- overload
- reuse
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

The Generic Method pattern implements shared logic once using a `Variant` or
`RecordRef` parameter, then provides strongly-typed wrapper procedures that
convert to/from the generic form. This avoids duplicating identical logic for
each record type while keeping the public API type-safe.

## Best Practice

Write the core algorithm against `RecordRef` or use `Variant` for value-typed
data. Expose public wrapper procedures with concrete types that delegate to the
generic implementation.

```al
procedure LogChange(RecRef: RecordRef; FieldNo: Integer; OldValue: Text; NewValue: Text)
begin
    // one implementation handles any table
    WriteAuditEntry(RecRef.Number, RecRef.RecordId, FieldNo, OldValue, NewValue);
end;

procedure LogCustomerChange(Customer: Record Customer; FieldNo: Integer; Old: Text; New: Text)
var
    RecRef: RecordRef;
begin
    RecRef.GetTable(Customer);
    LogChange(RecRef, FieldNo, Old, New);
end;

procedure LogItemChange(Item: Record Item; FieldNo: Integer; Old: Text; New: Text)
var
    RecRef: RecordRef;
begin
    RecRef.GetTable(Item);
    LogChange(RecRef, FieldNo, Old, New);
end;
```

## Anti Pattern

Copy-pasting the same algorithm once per record type, differing only in the
table reference.

```al
// WRONG — same logic duplicated for every supported table
procedure LogCustomerChange(Customer: Record Customer; ...) begin
    WriteAuditEntry(18, Customer.RecordId, ...);
end;
procedure LogItemChange(Item: Record Item; ...) begin
    WriteAuditEntry(27, Item.RecordId, ...); // identical except table number
end;
```
