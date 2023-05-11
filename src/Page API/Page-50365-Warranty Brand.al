page 50365 "Warranty Brand"
{
    APIGroup = 'Warranty';
    APIPublisher = 'Pacific';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'warrantyBrand';
    DelayedInsert = true;
    EntityName = 'WarrantyBrand';
    EntitySetName = 'WarrantyBrands';
    PageType = API;
    SourceTable = "Warranty Barnd Master";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(brandCode; Rec."Brand Code")
                {
                    Caption = 'Brand Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
            }
        }
    }
}
