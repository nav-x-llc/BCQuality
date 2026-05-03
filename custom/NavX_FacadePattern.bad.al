// BAD: subscriber calls internal helper directly, bypassing the facade
codeunit 50032 "NAVX Commission Bad Sub."
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "No.", false, false)]
    local procedure OnAfterValidateItemNo(var Rec: Record "Sales Line")
    var
        InternalCalc: Codeunit "NAVX Commission Internal Calc."; // BAD: bypasses facade
    begin
        Rec."NAVX Commission Amount" := InternalCalc.Calc(Rec);
    end;
}
