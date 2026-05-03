codeunit 50096 "NAVX Temp Table Usage Bad"
{
    local procedure SummariseSalesLinesBad(SalesHeader: Record "Sales Header"): Decimal
    var
        WorkRecord: Record "NAVX Work Buffer";  // BAD: not marked temporary — writes to database
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                WorkRecord.Init();
                WorkRecord."Entry No." := SalesLine."Line No.";
                WorkRecord.Amount := SalesLine."Line Amount";
                WorkRecord.Insert();  // BAD: persists to real table
            until SalesLine.Next() = 0;

        WorkRecord.CalcSums(Amount);
        // BAD: if error thrown above, DeleteAll never runs — orphan rows remain
        WorkRecord.DeleteAll();
        exit(WorkRecord.Amount);
    end;
}
