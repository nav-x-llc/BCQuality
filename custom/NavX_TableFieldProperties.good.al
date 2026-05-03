// Table extension: table-level properties only
tableextension 50020 "NAVX Item Commission Ext." extends Item
{
    fields
    {
        field(50020; "NAVX Commission Rate"; Decimal)
        {
            Caption = 'Commission Rate';
            DataClassification = CustomerContent;
            BlankZero = true;
        }
    }
}

// Page extension: page-level properties
pageextension 50020 "NAVX Item Card Ext." extends "Item Card"
{
    layout
    {
        addlast(General)
        {
            field("NAVX Commission Rate"; Rec."NAVX Commission Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the commission rate for this item.';
            }
        }
    }
}
