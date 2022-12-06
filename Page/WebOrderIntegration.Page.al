page 50100 "Web Order Integration"
{
    ApplicationArea = All;
    Caption = 'Web Order Integration';
    PageType = List;
    SourceTable = "Sales Orders / Sales Quotes";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Qty; Rec.Qty)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amount field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }

                field("Order/Quote Created"; Rec."Order/Quote Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order/Quote Created field.';
                }
                field("Order/Quote Created User"; Rec."Order/Quote Created User")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order/Quote Created User field.';
                }
                field("Order/Quote Created Date"; Rec."Order/Quote Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order/Quote Created Date field.';
                }
                field("Order/Quote Created Time"; Rec."Order/Quote Created Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order/Quote Created Time field.';
                }
                field("Imported User"; Rec."Imported User")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imported User  field.';
                }
                field("Imported Date"; Rec."Imported Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imported Date field.';
                }
                field("Imported Time"; Rec."Imported Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imported Time field.';
                }
                field("SO Posting Command"; Rec."SO Posting Command")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SO Posting Command field.';
                }
                field("SO Posted"; Rec."SO Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SO Posted field.';
                }
                field("Posted Invoice No."; Rec."Posted Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Invoice No. field.';
                }
                field("Posted Shipment No."; Rec."Posted Shipment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Shipment No. field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportWebOrders)
            {
                ApplicationArea = All;
                Caption = 'Import Web Orders';
                Image = Import;
                ToolTip = 'Import Web Orders';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    UserSetupRec: Record "User Setup";
                // ImportFromExcelCodeunit: Codeunit "Import From Excel";
                //Assigning User Setup to table to a record variable
                begin
                    UserSetupRec.Get(UserId);
                    //now the UserSetupRec points to only one record(which is the current user)

                    if UserSetupRec."Import Web Order Permission" then
                        //checking the "Import Web Order Permission" of the Record
                        ImportWebOrdersFromExcel()
                    else
                        Error('You do not have a permission to import!');
                end;
            }

            action(GenerateSOSQ)
            {
                ApplicationArea = All;
                Promoted = true;
                Caption = 'Generate Sales Orders / Sales Quotes';
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Create;
                ToolTip = 'Generate Sales Orders / Sales Quotes';

                trigger OnAction()
                var
                    UserSetupRec: Record "User Setup";
                // GenerateOrderCodeunit: codeunit "Generate SO / SQ";
                //Assigning User Setup to table to a record variable
                begin
                    UserSetupRec.Get(UserId);
                    //now the UserSetupRec points to only one record(which is the current user)

                    if UserSetupRec."Create Web Order Permission" then
                        //checking the "Import Web Order Permission" of the Record
                        Generate()
                    else
                        Error('You do not have a permission to import!');
                end;
            }
        }
    }

    local procedure Generate()
    var
        webOrder: Record "Sales Orders / Sales Quotes";
        webOrder2: Record "Sales Orders / Sales Quotes";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Doctype: Enum "Document Type";
        GroupDoc: Code[20];
        Window: Dialog;
        Inx: Integer;
    begin
        Window.Open('Processing Web Orders...\Document No. #1#######\Line No. #2#######\Loop #3#######\Count #4#######');
        Clear(webOrder);
        webOrder.SetCurrentKey("Document Type", "Document No.", "Line No.");
        webOrder.SetRange("Order/Quote Created", false);
        Window.Update(4, webOrder.Count);
        if webOrder.FindSet() then
            repeat begin
                Inx += 1;
                Window.Update(1, webOrder."Document No.");
                Window.Update(2, webOrder."Line No.");
                Window.Update(3, Inx);
                if GroupDoc <> webOrder."Document No." then begin
                    GroupDoc := webOrder."Document No.";
                    SalesHeader.Init();
                    if webOrder."Document Type" = webOrder."Document Type"::Order then
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Order
                    else
                        if webOrder."Document Type" = webOrder."Document Type"::Quote then
                            SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
                    SalesHeader."No." := webOrder."Document No.";
                    SalesHeader.Insert();
                    SalesHeader.Validate("Sell-to Customer No.", webOrder."Customer No.");
                    SalesHeader.Validate("Location Code", webOrder."Location Code");
                    SalesHeader.Validate("Posting Date", webOrder."Document Date");
                    SalesHeader.Ship := true;
                    SalesHeader.Invoice := true;
                    SalesHeader.Modify();
                end;

                SalesLine.Init();
                if webOrder."Document Type" = webOrder."Document Type"::Order then
                    SalesLine."Document Type" := SalesLine."Document Type"::Order
                else
                    if webOrder."Document Type" = webOrder."Document Type"::Quote then
                        SalesLine."Document Type" := SalesLine."Document Type"::Quote;
                SalesLine."Document No." := webOrder."Document No.";
                SalesLine."Line No." := webOrder."Line No.";
                if SalesLine.Insert() then begin
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.", webOrder."Item No.");
                    SalesLine.Description := webOrder.Description;
                    SalesLine.Validate(Quantity, webOrder.Qty);
                    SalesLine.Validate("Qty. to Ship", webOrder.Qty);
                    SalesLine.Validate("Qty. to Invoice", webOrder.Qty);
                    SalesLine.Validate("Unit Price", webOrder."Unit Price");
                    SalesLine.Validate("Line Discount Amount", webOrder."Discount Amount");
                    SalesLine.Validate(Amount, webOrder.Amount);
                    SalesLine.Modify();
                    webOrder."Order/Quote Created" := true;
                    webOrder."Order/Quote Created Date" := Today;
                    webOrder."Order/Quote Created Time" := Time;
                    webOrder."Order/Quote Created User" := UserId;
                    webOrder.Modify();
                end;
            end
            until webOrder.Next() = 0;
        Window.Close();

        Clear(webOrder);
        webOrder.SetCurrentKey("Document Type", "Document No.", "Line No.");
        webOrder.SetRange("Document Type", webOrder."Document Type"::Order);
        webOrder.SetRange("Order/Quote Created", true);
        webOrder.SetRange("SO Posted", false);
        webOrder.SetRange("SO Posting Command", true);
        // webOrder.SetCurrentKey("Document Type", "Document No.", "Line No.");
        // if webOrder.FindFirst() then
        //     repeat
        //         if GroupDoc <> webOrder."Document No." then begin
        //             GroupDoc := webOrder."Document No.";
        //             clear(SalesHeader);
        //             SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        //             SalesHeader.SetRange("No.", webOrder."Document No.");
        //             if SalesHeader.FindFirst() then
        //                 if Codeunit.Run(Codeunit::"Sales-Post") then begin
        //                     webOrder."SO Posted" := true;
        //                     webOrder."SO Posting Command" := false;
        //                     webOrder.Modify();
        //                     // WebOrderIntegrataion."Posted Shipment No." := postedsalesIn."No.";
        //                     // WebOrderIntegrataion."Posted Invoice No." := postedsalesIn."No.";
        //                     Message('Generate Sales order post it Successfully !\')
        //                 end;
        //     until webOrder.Next() = 0;
        //         end;
        webOrder.SetCurrentKey("Document Type", "Document No.", "Line No.");
        if webOrder.FindFirst() then
            repeat
                if GroupDoc <> webOrder."Document No." then begin
                    GroupDoc := webOrder."Document No.";

                    clear(SalesHeader);
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("No.", webOrder."Document No.");
                    if SalesHeader.FindFirst() then
                        if SalesHeader.SendToPosting(80) then begin
                            Clear(webOrder2);
                            webOrder2.SetRange("Document Type", webOrder2."Document Type"::Order);
                            webOrder2.SetRange("Document No.", webOrder."Document No.");
                            webOrder2.ModifyAll("SO Posted", true);
                            webOrder2.ModifyAll("SO Posting Command", false);
                        end;
                end;
            until webOrder.Next() = 0;
    end;

    procedure ImportWebOrdersFromExcel()
    var
        WebOrderIntegrataion: Record "Sales Orders / Sales Quotes";
        WebOrderIntegrataion2: Record "Sales Orders / Sales Quotes";
        CustomerMaster: Record Customer;
        DateVariant: Variant;
        DateCheck: Boolean;
        Inx: Integer;
        WebOrderType: Enum "Document Type";
    begin

        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        DialogCaption := 'Select File to upload';
        UploadResult := UploadIntoStream(DialogCaption, '', '', Name, NVInStream);
        Sheetname := 'Sheet1';
        if not UploadResult then
            exit;

        // Message(Sheetname);
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.OpenBookStream(NVInStream, Sheetname); //SheetName
        Rec_ExcelBuffer.ReadSheet();
        Commit();

        //finding total number of Rows to Import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Column No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Rows := Rows + 1;
            until Rec_ExcelBuffer.Next() = 0;

        //Finding total number of columns to import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Row No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until Rec_ExcelBuffer.Next() = 0;

        //for loop starts here
        for RowNo := 2 to Rows do begin
            if GetValueAtIndex(RowNo, 1) = 'Order' then
                WebOrderType := WebOrderType::Order
            else
                if GetValueAtIndex(RowNo, 1) = 'Quote' then
                    WebOrderType := WebOrderType::Quote;

            Clear(WebOrderIntegrataion2);
            if not WebOrderIntegrataion2.Get(WebOrderType, GetValueAtIndex(RowNo, 2), GetValueAtIndex(RowNo, 3)) then begin
                WebOrderIntegrataion.Init();
                WebOrderIntegrataion."Document Type" := WebOrderType;
                Evaluate(WebOrderIntegrataion."Document No.", GetValueAtIndex(RowNo, 2));
                Evaluate(WebOrderIntegrataion."Line No.", GetValueAtIndex(RowNo, 3));
                Evaluate(WebOrderIntegrataion."Document Date", GetValueAtIndex(RowNo, 5));
                Evaluate(WebOrderIntegrataion.Description, GetValueAtIndex(RowNo, 8));
                Evaluate(WebOrderIntegrataion.Qty, GetValueAtIndex(RowNo, 9));
                Evaluate(WebOrderIntegrataion."Unit Price", GetValueAtIndex(RowNo, 10));
                Evaluate(WebOrderIntegrataion."Discount Amount", GetValueAtIndex(RowNo, 11));
                Evaluate(WebOrderIntegrataion.Amount, GetValueAtIndex(RowNo, 12));
                WebOrderIntegrataion."Imported User" := UserId;
                WebOrderIntegrataion."Imported Date" := Today;
                WebOrderIntegrataion."Imported Time" := Time;
                WebOrderIntegrataion.Validate("Item No.", GetValueAtIndex(RowNo, 7));
                WebOrderIntegrataion.Validate("Customer No.", GetValueAtIndex(RowNo, 6));
                WebOrderIntegrataion.Validate("Location Code", GetValueAtIndex(RowNo, 4));
                if WebOrderIntegrataion.Insert(true) then
                    Inx += 1;
            end;
        end;
        //for loop ends here

        if Inx > 0 then
            Message('%1 of Web Orders has been Imported Successfully!\', Inx)
        else
            Error('Nothing to process.');
    end;

    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
        Rec_ExcelBuffer: Record "Excel Buffer";
    begin
        Rec_ExcelBuffer.Reset();
        if Rec_ExcelBuffer.Get(RowNo, ColNo) then exit(Rec_ExcelBuffer."Cell Value as Text");
    end;

    var
        Rec_ExcelBuffer: Record "Excel Buffer";
        TimeDataUpload: Record "Sales Orders / Sales Quotes";
        Rows: Integer;
        Columns: Integer;
        Fileuploaded: Boolean;
        UploadIntoStream: InStream;
        FileName: Text;
        Sheetname: Text;
        UploadResult: Boolean;
        DialogCaption: Text;
        Name: Text;
        NVInStream: InStream;
        RowNo: Integer;
        TxtDate: Text; // DocumentDate: Date;
        LineNo: Integer;
}
