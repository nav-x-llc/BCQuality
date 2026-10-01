/// <summary>
/// Demonstrates correct use of the 'temporary' parameter modifier and IsTemporary() guard.
/// </summary>
codeunit 99906 "NAVX Temp Record Params Good"
{
    Access = Internal;

    /// <summary>
    /// The 'temporary' modifier on TrackingEntry enforces that only a temporary
    /// Reservation Entry may be passed; real records are rejected at compile time.
    /// </summary>
    procedure TransferFromPVSJob(
        var PVSJob: Record "Purchase Header";         // stand-in for PVS Job
        var TrackingEntry: Record "Reservation Entry" temporary;
        OutstandingQty: Decimal;
        FinishedQty: Decimal)
    begin
        // Safe: modifications to TrackingEntry cannot reach the database.
        TrackingEntry.Init();
        TrackingEntry."Entry No." := 1;
        TrackingEntry.Insert();
    end;

    /// <summary>
    /// Subscriber exits immediately for temporary records so what-if scenarios
    /// in planning engines are unaffected.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
    local procedure SalesLineNoOnAfterValidate(
        var Rec: Record "Sales Line";
        var xRec: Record "Sales Line";
        CurrFieldNo: Integer)
    begin
        if Rec.IsTemporary() then
            exit;
        // Real-record logic only below this point.
    end;
}
