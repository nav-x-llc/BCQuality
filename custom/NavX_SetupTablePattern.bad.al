codeunit 50003 "MyFeature Bad Mgt."
{
    procedure IsEnabled(): Boolean
    var
        Setup: Record "MyFeature Setup";
    begin
        // BAD: no guard, will error if table is empty
        Setup.Get();
        exit(Setup.Enabled);
    end;
}
