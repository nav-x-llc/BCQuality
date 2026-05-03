// Caller always goes through the management facade
codeunit 50031 "NAVX Commission Subscriber"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "No.", false, false)]
    local procedure OnAfterValidateItemNo(var Rec: Record "Sales Line")
    var
        CommissionMgt: Codeunit "NAVX Commission Mgt.";
    begin
        Rec."NAVX Commission Amount" := CommissionMgt.CalculateCommission(Rec);
    end;
}
