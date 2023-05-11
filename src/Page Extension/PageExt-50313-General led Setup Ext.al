pageextension 50313 "General led Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Tax Information")
        {
            Group("Bank Drop")
            {
                field("Bank Drop Batch"; Rec."Bank Drop Batch")
                {
                    ApplicationArea = all;
                    Caption = 'Bank Drop Batch';
                }
            }
            group("Slab Approval Users")
            {
                field("Slab Approval User 1"; Rec."Slab Approval User 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Slab Approval User 1 field.';
                }
                field("Slab Approval User 2"; Rec."Slab Approval User 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Slab Approval User 2 field.';
                }
                field("Slab Approval User 3"; Rec."Slab Approval User 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Slab Approval User 3 field.';
                }

            }
        }
    }
}
