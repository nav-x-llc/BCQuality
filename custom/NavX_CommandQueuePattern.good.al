// Command table
table 50040 "NAVX Sync Command"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Source No."; Code[20]) { }
        field(3; Status; Enum "NAVX Sync Command Status") { }
        field(4; "Created At"; DateTime) { }
        field(5; "Error Message"; Text[2048]) { }
    }
    keys { key(PK; "Entry No.") { Clustered = true; } }
}

// Processor codeunit (run by Job Queue)
codeunit 50041 "NAVX Sync Command Processor"
{
    TableNo = "NAVX Sync Command";

    trigger OnRun()
    begin
        Rec.Status := Rec.Status::Processing;
        Rec.Modify();
        Commit();
        ProcessCommand(Rec);
        Rec.Status := Rec.Status::Completed;
        Rec.Modify();
    end;

    local procedure ProcessCommand(var Command: Record "NAVX Sync Command")
    begin
        // safe to call external system here — outside the original transaction
    end;
}
