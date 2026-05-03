// Subscriber injects custom discount logic without touching the template
codeunit 50072 "NAVX Volume Discount Subscriber"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"NAVX Price Calc. Template", OnAfterCalculatePrice, '', false, false)]
    local procedure ApplyVolumeDiscount(var SalesLine: Record "Sales Line")
    begin
        if SalesLine.Quantity >= 100 then
            SalesLine."Line Discount %" += 5;
    end;
}
