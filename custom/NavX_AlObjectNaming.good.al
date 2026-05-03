codeunit 50010 "NAVX Comm. Mgt."
{
    procedure ProcessEntry(EntryNo: Integer)
    var
        CommissionEntry: Record "NAVX Commission Entry";
        TotalAmount: Decimal;
        ProcessingLbl: Label 'Processing entry %1.', Comment = '%1 = Entry No.';
    begin
        CommissionEntry.SetLoadFields(Amount, Status);
        if not CommissionEntry.Get(EntryNo) then
            exit;
        TotalAmount := CommissionEntry.Amount;
        Message(ProcessingLbl, EntryNo);
    end;
}
