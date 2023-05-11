page 50303 "Menu List"
{
    PageType = List;
    Caption = 'Menu List';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Menu Header";
    CardPageId = "Menu Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control001)
            {

                field("Menu ID"; Rec."Menu ID")
                {
                    ToolTip = 'Specifies the value of the Menu ID field.';
                }
                field("Menu Name"; Rec."Menu Name")
                {
                    ToolTip = 'Specifies the value of the Menu Name field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                    Editable = false;
                }
                field("Creation ID"; Rec."Creation ID")
                {
                    ToolTip = 'Specifies the value of the Creation ID field.';
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    Editable = false;
                }



            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}