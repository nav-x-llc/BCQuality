// BAD: duplicated algorithm in a separate codeunit — two codebases to maintain
codeunit 50073 "NAVX Price Calc. Volume"
{
    procedure CalculatePrice(var SalesLine: Record "Sales Line")
    begin
        // Copy of the base algorithm...
        ApplyBasePrice(SalesLine);
        ApplyDiscounts(SalesLine);
        // ...plus the extra bit
        if SalesLine.Quantity >= 100 then
            SalesLine."Line Discount %" += 5;
    end;

    local procedure ApplyBasePrice(var SalesLine: Record "Sales Line") begin end;
    local procedure ApplyDiscounts(var SalesLine: Record "Sales Line") begin end;
}
