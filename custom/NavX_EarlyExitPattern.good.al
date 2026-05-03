procedure ApplyCommission(SalesHeaderNo: Code[20])
var
    Setup: Record "NAVX Commission Setup";
    SalesLine: Record "Sales Line";
begin
    Setup.GetRecordOnce();
    if not Setup.Enabled then
        exit;

    SalesLine.SetLoadFields("No.", Amount);
    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
    SalesLine.SetRange("Document No.", SalesHeaderNo);
    if not SalesLine.FindSet() then
        exit;

    repeat
        CreateCommissionEntry(SalesLine);
    until SalesLine.Next() = 0;
end;
