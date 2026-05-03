codeunit 50080 "NAVX Audit Logger"
{
    procedure LogChange(RecRef: RecordRef; FieldNo: Integer; OldValue: Text; NewValue: Text)
    var
        AuditEntry: Record "NAVX Audit Entry";
    begin
        AuditEntry.Init();
        AuditEntry."Table No." := RecRef.Number;
        AuditEntry."Record ID" := RecRef.RecordId;
        AuditEntry."Field No." := FieldNo;
        AuditEntry."Old Value" := CopyStr(OldValue, 1, MaxStrLen(AuditEntry."Old Value"));
        AuditEntry."New Value" := CopyStr(NewValue, 1, MaxStrLen(AuditEntry."New Value"));
        AuditEntry."Changed At" := CurrentDateTime();
        AuditEntry.Insert(true);
    end;

    procedure LogCustomerChange(Customer: Record Customer; FieldNo: Integer; OldValue: Text; NewValue: Text)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Customer);
        LogChange(RecRef, FieldNo, OldValue, NewValue);
    end;
}
