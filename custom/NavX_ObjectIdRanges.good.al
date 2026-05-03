// Good: ID obtained from Ninja, within declared range from app.json
// app.json idRanges: [{"from": 50000, "to": 59999}]
// Ninja returned 50007 as the next available ID
codeunit 50007 "NAVX Commission Calc."
{
    procedure Calculate(): Decimal
    begin
        exit(0);
    end;
}
