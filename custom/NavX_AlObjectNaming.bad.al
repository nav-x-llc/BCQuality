codeunit 50011 "Commission Management" // BAD: no prefix, exceeds 30 chars if extended
{
    procedure ProcessEntry(EntryNo: Integer)
    var
        Type: Option ,Direct,Indirect; // BAD: reserved word as variable name
        Record: Record "NAVX Commission Entry"; // BAD: reserved word as variable name
    begin
        Record.Get(EntryNo);
        Message('Processing entry ' + Format(EntryNo)); // BAD: hardcoded string
    end;
}
