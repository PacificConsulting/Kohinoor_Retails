page 50358 "Warranty Master List"
{
    ApplicationArea = All;
    Caption = 'Warranty Master List';
    PageType = List;
    SourceTable = "Warranty Master";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Brand; Rec.Brand)
                {
                    ToolTip = 'Specifies the value of the Brand field.';
                }
                field(Months; Rec.Months)
                {
                    ToolTip = 'Specifies the value of the Months field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("From Value"; Rec."From Value")
                {
                    ToolTip = 'Specifies the value of the From Value field.';
                }
                field("To Value"; Rec."To Value")
                {
                    ToolTip = 'Specifies the value of the To Value field.';
                }

                field("EW Prices"; Rec."EW Prices")
                {
                    ToolTip = 'Specifies the value of the EW Prices field.';
                }
            }
        }
    }
}
