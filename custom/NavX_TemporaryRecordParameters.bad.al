/// <summary>
/// Demonstrates missing 'temporary' modifier and absent IsTemporary() guard — anti-pattern.
/// </summary>
codeunit 99907 "NAVX Temp Record Params Bad"
{
    Access = Internal;

    // BAD: 'temporary' modifier omitted — a real Reservation Entry can be passed.
    procedure TransferFromPVSJob(
        var PVSJob: Record "Purchase Header";
        var TrackingEntry: Record "Reservation Entry"; // BAD - missing 'temporary'
        OutstandingQty: Decimal;
        FinishedQty: Decimal)
    begin
        TrackingEntry.Init();
        TrackingEntry."Entry No." := 1;
        TrackingEntry.Insert(); // BAD - writes to DB when caller passes a real record
    end;

    // BAD: no IsTemporary() guard — fires on temporary records inside planning engine.
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
    local procedure SalesLineNoOnAfterValidate(
        var Rec: Record "Sales Line";
        var xRec: Record "Sales Line";
        CurrFieldNo: Integer)
    begin
        // BAD - no Rec.IsTemporary() check; logic runs on planning/what-if temp records.
        Rec."No." := Rec."No."; // BAD - side-effect on temporary records
    end;
}
