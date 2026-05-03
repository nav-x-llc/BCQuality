procedure AssignEntryNo(var Entry: Record "MyFeature Entry")
var
    Setup: Record "MyFeature Setup";
    NoSeries: Codeunit "No. Series";
begin
    if Entry."Entry No." <> '' then
        exit;
    Setup.GetRecordOnce();
    Setup.TestField("Entry Nos.");
    Entry."Entry No." := NoSeries.GetNextNo(Setup."Entry Nos.", WorkDate(), true);
end;
