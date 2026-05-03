codeunit 50081 "NAVX Audit Logger Bad"
{
    // BAD: duplicated logic for every table — must be maintained in sync
    procedure LogCustomerChange(Customer: Record Customer; FieldNo: Integer; OldValue: Text; NewValue: Text)
    var
        AuditEntry: Record "NAVX Audit Entry";
    begin
        AuditEntry.Init();
        AuditEntry."Table No." := 18;
        AuditEntry."Record ID" := Customer.RecordId;
        AuditEntry."Field No." := FieldNo;
        AuditEntry."Old Value" := CopyStr(OldValue, 1, MaxStrLen(AuditEntry."Old Value"));
        AuditEntry."New Value" := CopyStr(NewValue, 1, MaxStrLen(AuditEntry."New Value"));
        AuditEntry.Insert(true);
    end;

    procedure LogItemChange(Item: Record Item; FieldNo: Integer; OldValue: Text; NewValue: Text)
    var
        AuditEntry: Record "NAVX Audit Entry";
    begin
        // BAD: identical to LogCustomerChange except table number
        AuditEntry.Init();
        AuditEntry."Table No." := 27;
        AuditEntry."Record ID" := Item.RecordId;
        AuditEntry."Field No." := FieldNo;
        AuditEntry."Old Value" := CopyStr(OldValue, 1, MaxStrLen(AuditEntry."Old Value"));
        AuditEntry."New Value" := CopyStr(NewValue, 1, MaxStrLen(AuditEntry."New Value"));
        AuditEntry.Insert(true);
    end;
}
