// BAD: ApplicationArea and ToolTip on table field — compile errors
tableextension 50021 "NAVX Item Bad Ext." extends Item
{
    fields
    {
        field(50021; "NAVX Commission Rate"; Decimal)
        {
            Caption = 'Commission Rate';
            ApplicationArea = All;      // ERROR: not valid on table fields
            ToolTip = 'Commission rate'; // ERROR: not valid on table fields
        }
    }
}
