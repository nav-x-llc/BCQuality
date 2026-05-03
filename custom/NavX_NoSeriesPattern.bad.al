procedure AssignEntryNoBad(var Entry: Record "MyFeature Entry")
var
    Setup: Record "MyFeature Setup";
    NoSeriesMgt: Codeunit NoSeriesManagement; // BAD: deprecated, removed in BC 26+
begin
    Setup.Get();
    NoSeriesMgt.InitSeries(Setup."Entry Nos.", '', WorkDate(), Entry."Entry No.", Entry."No. Series");
end;
