codeunit 50002 "MyFeature Mgt."
{
    procedure IsEnabled(): Boolean
    var
        Setup: Record "MyFeature Setup";
    begin
        Setup.GetRecordOnce();
        exit(Setup.Enabled);
    end;
}
