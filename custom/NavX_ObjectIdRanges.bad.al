// BAD: hardcoded 50000 — almost certainly collides with an existing object
codeunit 50000 "NAVX Commission Calc."
{
    procedure Calculate(): Decimal
    begin
        exit(0);
    end;
}
