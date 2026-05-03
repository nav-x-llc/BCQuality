codeunit 50095 "NAVX Temp Table Usage Good"
{
    local procedure SummariseSalesLines(SalesHeader: Record "Sales Header"): Decimal
    var
        TempAccum: Record "NAVX Accumulator" temporary;  // in-memory only
        SalesLine: Record "Sales Line";
    begin
        TempAccum.Reset();
        TempAccum.DeleteAll();

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                TempAccum.Init();
                TempAccum."Entry No." := SalesLine."Line No.";
                TempAccum.Amount := SalesLine."Line Amount";
                TempAccum.Insert();  // stays in memory
            until SalesLine.Next() = 0;

        TempAccum.CalcSums(Amount);
        exit(TempAccum.Amount);
    end;
}
