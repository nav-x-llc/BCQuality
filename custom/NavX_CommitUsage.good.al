// Each item is a separate JQE invocation — Commit is at the boundary
codeunit 50090 "NAVX Batch Processor"
{
    TableNo = "NAVX Batch Item";

    trigger OnRun()
    begin
        Rec.Status := Rec.Status::Processing;
        Rec.Modify();
        Commit(); // committed before processing so status survives a crash

        ExecuteItem(Rec);

        Rec.Status := Rec.Status::Completed;
        Rec.Modify();
    end;

    local procedure ExecuteItem(var Item: Record "NAVX Batch Item")
    begin
        // no Commit() here
    end;
}
