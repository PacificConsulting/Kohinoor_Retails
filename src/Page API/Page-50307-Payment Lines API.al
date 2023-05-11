page 50307 "Payment Lines API"
{
    APIGroup = 'PaymentGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v4.0';
    ApplicationArea = All;
    Caption = 'paymentLinesAPI';
    DelayedInsert = true;
    EntityName = 'PaymentLine';
    EntitySetName = 'PaymentLines';
    PageType = API;
    SourceTable = "Payment Lines";
    ODataKeyFields = SystemId;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(approvalCode; Rec."Approval Code")
                {
                    Caption = 'Approval Code';
                }
                field(approvalDate; Rec."Approval Date")
                {
                    Caption = 'Approval Date';
                }
                field(cardExpiryDate; Rec."Card Expiry Date")
                {
                    Caption = 'Card Expiry Date';
                }
                field(cardType; Rec."Card Type")
                {
                    Caption = 'Card Type';
                }
                field(chequeNo6Digit; Rec."Cheque No 6 Digit")
                {
                    Caption = 'Cheque No 6 Digit';
                }
                field(creditCardNoLast4Digit; Rec."Credit Card No. Last 4 digit")
                {
                    Caption = 'Owner Name';
                }
                field(doNumber; Rec."DO Number")
                {
                    Caption = 'DO Number';
                }
                field(deliverOrderCopyUpload; Rec."Deliver Order Copy Upload")
                {
                    Caption = 'Deliver Order Copy Upload';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                // field(lineNo; Rec."Line No.")
                // {
                //     Caption = 'Line No.';
                // }
                field(mfrSubToBeBornByDealer; Rec."MFR Sub. to be born by Dealer")
                {
                    Caption = 'MFR Subvention Borne to be born by Dealer';
                }
                field(ownerName; Rec."Owner Name")
                {
                    Caption = 'Owner Name';
                }
                field(paymentMethodCode; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                }
                field(posted; Rec.Posted)
                {
                    Caption = 'Posted';
                }
                field(subventionByDealer; Rec."Subvention by Dealer")
                {
                    Caption = 'Subvention by Dealer';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
