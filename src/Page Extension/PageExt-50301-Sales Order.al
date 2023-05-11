pageextension 50301 "Sales Order Payment Ext" extends "Sales Order"
{
    layout
    {

        addafter(SalesLines)
        {
            part(PaymentLine; "Payment Lines Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
                Editable = True;//IsPaymentLineeditable; Temp code comment after that we can remove 
            }
        }
        addafter(Status)
        {
            field("Amount To Customer"; Rec."Amount To Customer")
            {
                ApplicationArea = all;
                Editable = false;
            }
            group(POS)
            {
                field("Store No."; Rec."Store No.")
                {
                    ApplicationArea = all;
                }
                field("Staff Id"; Rec."Staff Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff Id field.';
                }
                field("POS Released Date"; Rec."POS Released Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Released Date field.';
                }

            }
        }

    }

    actions
    {

        modify(Statistics)
        {
            Trigger OnAfterAction()
            begin
                clear(TotalGSTAmount1);
                Clear(TotalTCSAmt);
                Clear(TotalAmt);
                GetGSTAmountTotal(Rec, TotalGSTAmount1);
                GetTCSAmountTotal(Rec, TotalTCSAmt);
                GetSalesorderStatisticsAmount(Rec, TotalAmt);
                Rec."Amount To Customer" := ROUND(TotalAmt + TotalGSTAmount1 + TotalTCSAmt);
                Rec.Modify();
                CurrPage.Update(true);
            end;
        }
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                SL: Record "Sales Line";
            begin
                // SL.Reset();
                // SL.SetRange("Document No.", rec."No.");
                // SL.SetRange(Type, SL.Type::Item);
                // IF SL.FindFirst() then
                //     repeat
                //         SL.Validate("Qty. to Ship", 0);
                //         SL.Modify();
                //     until SL.Next() = 0;

            end;
        }



        addafter(Post)
        {
            action("Payment Post")
            {
                ApplicationArea = all;
                Image = PostedPayment;
                Caption = 'Payment Post';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PaymentLine: Record "Payment Lines";
                    TotalPayemtamt: Decimal;
                    SalesHdr: Record 36;
                    SaleLine: Record 37;
                begin
                    if Confirm('Do you want to post payment receipt', true) then begin
                        rec.TestField("Store No.");
                        rec.TestField("Staff Id");
                        clear(TotalGSTAmount1);
                        Clear(TotalTCSAmt);
                        Clear(TotalAmt);

                        PaymentLine.Reset();
                        PaymentLine.SetRange("Document No.", Rec."No.");
                        PaymentLine.SetRange(Posted, true);
                        if PaymentLine.FindFirst() then
                            Error('Payment Post already done');

                        SaleLine.Reset();
                        SaleLine.SetRange("Document No.", Rec."No.");
                        SaleLine.SetRange(Type, SaleLine.Type::Item);
                        IF SaleLine.FindSet() then
                            repeat
                                SaleLine.TestField("Salesperson Code");
                            until SaleLine.Next() = 0;

                        SaleLine.Reset();
                        SaleLine.SetRange("Document No.", rec."No.");
                        SaleLine.SetRange("Approval Status", SaleLine."Approval Status"::"Pending for Approval");
                        IF Saleline.FindFirst() then
                            error('You can not post when line is under approval');

                        GetGSTAmountTotal(Rec, TotalGSTAmount1);
                        GetTCSAmountTotal(Rec, TotalTCSAmt);
                        GetSalesorderStatisticsAmount(Rec, TotalAmt);
                        Rec."Amount To Customer" := Round(TotalAmt + TotalGSTAmount1 + TotalTCSAmt);
                        Rec.Modify();


                        Clear(TotalPayemtamt);
                        PaymentLine.Reset();
                        PaymentLine.SetRange("Document No.", Rec."No.");
                        if PaymentLine.FindSet() then
                            repeat
                                TotalPayemtamt := PaymentLine.Amount;
                            until PaymentLine.Next() = 0;

                        IF TotalPayemtamt <> Rec."Amount To Customer" then
                            Error('Sales Order amount is not match with Payment amount')
                        else begin
                            BankPayentReceiptAutoPost(Rec);
                            SalesHdr.Reset();
                            SalesHdr.SetRange("No.", rec."No.");
                            If SalesHdr.FindFirst() then begin
                                SalesHdr.Status := SalesHdr.Status::Released;
                                SalesHdr."POS Released Date" := today;
                                SalesHdr.Modify();
                            end;
                        end;

                    end;
                end;
            }
            action("Call Function")
            {
                ApplicationArea = all;
                Image = PostedPayment;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SH: Record 36;
                    SL: Record 37;
                    SL1: Record 37;
                    NoSer: Codeunit NoSeriesManagement;
                    result: Text;
                    No: code[20];
                    CU: Codeunit 50303;
                    POS: Codeunit 50302;

                begin
                    Message('hi');
                    // result := POS.POSAction('KTPLSO23240091', 0, 'INVLINE', '', '', '');
                    result := CU.OrderConfirmationforWH(rec."No.");
                    // SL.Reset();
                    // sl.SetRange("Approval Status", sl."Approval Status"::"Pending for Approval");
                    // IF SL.FindFirst() then;
                    // Hyperlink(GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Slab Approval List", SL));
                    // result := GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Slab Approval List", SL);
                    Message(result);

                end;
            }
            action("POS Function Test")
            {
                Caption = 'POS Function Test';
                ApplicationArea = all;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                Image = Email;
                trigger OnAction()
                var
                    CU: Codeunit 50303;
                    POS: Codeunit 50302;
                    result: Text;
                begin
                    //result := POS.POSAction('KTPLSO23240091', 10000, 'INVLINE', '1', '', '');
                    result := cu.OrderConfirmationforWH(rec."No.");
                    //result := Cu.OrderConfirmationforDelivery(rec."No.");
                    Message(result);
                end;
            }
            action("Send PAGE Mail")
            {
                Caption = 'Send Mail';
                ApplicationArea = all;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                Image = Email;
                trigger OnAction()
                var
                    txtFile: Text[100];
                    Window: Dialog;
                    txtFileName: Text[100];
                    Char: Char;
                    recSalesInvHdr: Record 112;
                    Recref: RecordRef;
                    recCust: Record 18;
                    TempBlob: Codeunit "Temp Blob";
                    OutStr: OutStream;
                    Instr: InStream;
                    EMail: Codeunit Email;
                    Emailmessage: Codeunit "Email Message";
                    DecryptedValue: Text;
                    CU: Codeunit 50303;
                    POS: Codeunit 50302;
                    result: Text;
                begin
                    Message('hi');
                    result := POS.POSAction('KTPLSO23240091', 0, 'INVLINE', '', '', '');
                    result := CU.InvoiceLine('KTPLSO23240019', 0, '', '');
                    //if recCust.get
                    DecryptedValue := GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Slab Approval List");
                    Window.OPEN(
                     'Sending Mail              #1######\');

                    Emailmessage.Create('niwagh16@gmail.com', 'Approval Slab', '', true);
                    Emailmessage.AppendToBody('<p><font face="Georgia">Dear <B>Sir,</B></font></p>');
                    Char := 13;
                    Emailmessage.AppendToBody(FORMAT(Char));
                    Emailmessage.AppendToBody('<p><font face="Georgia"> <B>!!!Greetings!!!</B></font></p>');
                    Emailmessage.AppendToBody(FORMAT(Char));
                    Emailmessage.AppendToBody(FORMAT(Char));
                    Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Please find below Approval Link Approve Date</BR></font></p>');
                    Emailmessage.AppendToBody(FORMAT(Char));
                    Emailmessage.AppendToBody(FORMAT(Char));
                    Emailmessage.AppendToBody('<a href=' + DecryptedValue + '/">Web Link!</a>');
                    Emailmessage.AppendToBody(FORMAT(Char));
                    Emailmessage.AppendToBody(FORMAT(Char));
                    Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Thanking you,</BR></font></p>');
                    Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Warm Regards,</BR></font></p>');
                    Emailmessage.AppendToBody('<p><font face="Georgia"><BR><B>For K-TECH (INDIA) LIMITED</B></BR></font></p>');

                    Window.UPDATE(1, STRSUBSTNO('%1', 'Mail Sent'));
                    EMail.Send(Emailmessage, Enum::"Email Scenario"::Default);
                    Window.CLOSE;

                    //Hyperlink(GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Slab Approval List"));

                end;
            }
        }

    }





    procedure GetGSTAmountTotal(
      SalesHeader: Record 36;
      var GSTAmount: Decimal)
    var
        SalesLine: Record 37;
    begin
        Clear(GSTAmount);
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount11(SalesLine.RecordId());
            until SalesLine.Next() = 0;
    end;

    local procedure GetGSTAmount11(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then begin
            TaxTransactionValue.CalcSums(Amount);
            TaxTransactionValue.CalcSums(Percent);

        end;
        exit(TaxTransactionValue.Amount);
    end;

    procedure GetTCSAmountTotal(
           SalesHeader: Record 36;
           var TCSAmount: Decimal)
    var
        SalesLine: Record 37;
        TCSManagement: Codeunit "TCS Management";
        i: Integer;
        RecordIDList: List of [RecordID];
    begin
        Clear(TCSAmount);
        // Clear(TCSPercent);

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
            until SalesLine.Next() = 0;

        for i := 1 to RecordIDList.Count() do begin
            TCSAmount += GetTCSAmount(RecordIDList.Get(i));
        end;

        TCSAmount := TCSManagement.RoundTCSAmount(TCSAmount);
    end;

    local procedure GetTCSAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TCSSetup: Record "TCS Setup";
    begin
        if not TCSSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then
            TaxTransactionValue.CalcSums(Amount);

        exit(TaxTransactionValue.Amount);
    end;

    procedure GetSalesorderStatisticsAmount(
            SalesHeader: Record 36;
            var TotalInclTaxAmount: Decimal)
    var
        SalesLine: Record 37;
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        TCSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
                TotalInclTaxAmount += SalesLine.Amount;
            until SalesLine.Next() = 0;


        TotalInclTaxAmount := TotalInclTaxAmount + GSTAmount + TCSAmount;
    end;

    local procedure BankPayentReceiptAutoPost(Salesheader: Record "Sales Header")
    var
        GenJourLine: Record 81;
        NoSeriesMgt: Codeunit 396;
        BankAcc: Record 270;
        PaymentLine: Record 50301;
        GenJourLineInit: Record 81;
        ComInfo: record "Company Information";
        PaymentMethod: record "Payment Method";
        SR: record "Sales & Receivables Setup";
        RecLocation: record Location;
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        SR.Get();
        IF RecLocation.Get(rec."Location Code") then begin
            RecLocation.TestField("Payment Journal Template Name");
            RecLocation.TestField("Payment Journal Batch Name");
        end;

        ComInfo.Get();
        PaymentLine.Reset();
        PaymentLine.SetRange("Document Type", Rec."Document Type");
        PaymentLine.SetRange("Document No.", Rec."No.");
        if PaymentLine.FindSet() then
            repeat
                GenJourLine.Reset();
                GenJourLine.SetRange("Journal Template Name", RecLocation."Payment Journal Template Name");
                GenJourLine.SetRange("Journal Batch Name", RecLocation."Payment Journal Batch Name");
                GenJourLineInit.Init();
                GenJourLineInit."Journal Template Name" := RecLocation."Payment Journal Template Name";
                GenJourLineInit."Journal Batch Name" := RecLocation."Payment Journal Batch Name";
                GenJourLineInit."Document No." := Salesheader."No.";
                GenJourLineInit.Validate("Posting Date", Today);
                IF GenJourLine.FindLast() then
                    GenJourLineInit."Line No." := GenJourLine."Line No." + 10000
                else
                    GenJourLineInit."Line No." := 10000;


                //*******Condition Add on With Payment Method code*********
                IF PaymentMethod.Get(PaymentLine."Payment Method Code") then begin
                    GenJourLineInit."Account Type" := PaymentMethod."Bal. Account Type";
                    GenJourLineInit.validate("Account No.", PaymentMethod."Bal. Account No.");
                end;

                GenJourLineInit."Bal. Account Type" := GenJourLine."Bal. Account Type"::Customer;
                GenJourLineInit.Validate("Bal. Account No.", Salesheader."Sell-to Customer No.");

                GenJourLineInit."GST Group Code" := 'Goods';
                GenJourLineInit.validate(Amount, PaymentLine.Amount);
                GenJourLineInit.Validate("Shortcut Dimension 1 Code", Salesheader."Shortcut Dimension 1 Code");
                GenJourLineInit.Validate("Shortcut Dimension 2 Code", Salesheader."Shortcut Dimension 2 Code");
                GenJourLineInit.Comment := 'Auto Post';
            //GenJourLineInit.Insert(); //This Line Will Comment when auto post below codeunit Call
            Until PaymentLine.Next() = 0;
        GenJnlPostBatch.Run(GenJourLine);
        //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJourLineInit);
        PaymentLine.Reset();
        PaymentLine.SetRange("Document Type", Rec."Document Type");
        PaymentLine.SetRange("Document No.", Rec."No.");
        if PaymentLine.FindSet() then
            repeat
                PaymentLine.Posted := True;
                PaymentLine.Modify();
                IsPaymentLineeditable := PaymentLine.PaymentLinesEditable()
            Until PaymentLine.Next() = 0;
        //end;
    end;


    trigger OnAfterGetRecord()
    begin

    end;

    var

        AmountToCust: decimal;
        TotalGSTAmount1: Decimal;
        TotalAmt: Decimal;
        TotalTCSAmt: Decimal;
        IsPaymentLineeditable: Boolean;
        POS: Codeunit "POS Procedure";
}