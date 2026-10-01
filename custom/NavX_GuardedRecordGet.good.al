/// <summary>
/// Demonstrates guarded database reads: every Get / FindFirst result is checked
/// before the record fields are consumed.
/// </summary>
codeunit 99901 "NAVX Guarded Record Get Good"
{
    Access = Internal;

    var
        GLAccountNotFoundErr: Label 'G/L Account %1 does not exist.', Comment = '%1 - G/L Account No.';
        CustLedgEntryNotFoundErr: Label 'No open Cust. Ledger Entry found for customer %1.', Comment = '%1 - Customer No.';
        GeneralLedgerSetupNotFoundErr: Label 'General Ledger Setup record was not found.';

    /// <summary>
    /// Returns the Gen. Prod. Posting Group of a G/L account.
    /// Raises a clear error when the account does not exist.
    /// </summary>
    local procedure GetPostingGroup(GLAccountNo: Code[20]): Code[20]
    var
        GLAccount: Record "G/L Account";
    begin
        if not GLAccount.Get(GLAccountNo) then
            Error(GLAccountNotFoundErr, GLAccountNo);
        exit(GLAccount."Gen. Prod. Posting Group");
    end;

    /// <summary>
    /// Returns true and populates the ledger entry when an open entry exists;
    /// returns false without touching the record otherwise.
    /// </summary>
    local procedure TryGetFirstOpenEntry(CustomerNo: Code[20]; var CustLedgerEntry: Record "Cust. Ledger Entry"): Boolean
    begin
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetLoadFields("Entry No.", "Remaining Amount", "Customer No.");
        exit(CustLedgerEntry.FindFirst());
    end;

    /// <summary>
    /// Stamps a custom field on the first open ledger entry for a customer.
    /// Guards both the FindFirst and the conditional GL Setup read.
    /// </summary>
    internal procedure StampCustomField(CustomerNo: Code[20])
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if not TryGetFirstOpenEntry(CustomerNo, CustLedgerEntry) then
            Error(CustLedgEntryNotFoundErr, CustomerNo);

        if GeneralLedgerSetup.Get() then
            if GeneralLedgerSetup."Apply Jnl. Template Name" <> '' then
                CustLedgerEntry.Description :=
                    CopyStr(GeneralLedgerSetup."Apply Jnl. Template Name", 1, MaxStrLen(CustLedgerEntry.Description));

        CustLedgerEntry.Modify(true);
    end;
}
