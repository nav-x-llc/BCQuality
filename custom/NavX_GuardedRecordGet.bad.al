/// <summary>
/// Demonstrates unguarded database reads - the anti-pattern.
/// </summary>
codeunit 99902 "NAVX Guarded Record Get Bad"
{
    Access = Internal;

    // BAD: return value of Get() is discarded; blank fields used silently on miss.
    local procedure GetPostingGroup(GLAccountNo: Code[20]): Code[20]
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Get(GLAccountNo); // BAD - unguarded Get
        exit(GLAccount."Gen. Prod. Posting Group"); // BAD - blank string when not found
    end;

    // BAD: FindFirst() return value ignored; Modify targets whatever row was last in buffer.
    internal procedure StampCustomField(CustomerNo: Code[20])
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.FindFirst(); // BAD - no check; wrong row stamped if set is empty

        GeneralLedgerSetup.Get(); // BAD - unguarded; errors in companies with no GL Setup
        CustLedgerEntry.Description :=
            CopyStr(GeneralLedgerSetup."Apply Jnl. Template Name", 1, MaxStrLen(CustLedgerEntry.Description));

        CustLedgerEntry.Modify(true);
    end;
}
