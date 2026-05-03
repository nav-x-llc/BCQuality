procedure ApplyCommissionBad(SalesHeaderNo: Code[20])
var
    Setup: Record "NAVX Commission Setup";
    SalesLine: Record "Sales Line";
begin
    // BAD: triple-nested instead of early exits
    Setup.GetRecordOnce();
    if Setup.Enabled then begin
        SalesLine.SetRange("Document No.", SalesHeaderNo);
        if SalesLine.FindSet() then begin
            repeat
                CreateCommissionEntry(SalesLine);
            until SalesLine.Next() = 0;
        end;
    end;
end;
