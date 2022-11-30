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
                //Assigning User Setup to table to a record variable
                begin
                    UserSetupRec.Get(UserId);
                    //now the UserSetupRec points to only one record

                    if UserSetupRec."Import Web Order Permission" then
                        //
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
                begin
                    Message('Hello World!');
                end;
            }
        }
    }

    procedure ImportWebOrdersFromExcel()
    var
        WebOrderIntegrataion: Record "Sales Orders / Sales Quotes";
        WebOrderIntegrataion2: Record "Sales Orders / Sales Quotes";
        DateVariant: Variant;
        DateCheck: Boolean;
        Inx: Integer;
        WebOrderType: Enum "Document Type";
        CustomerMaster: Record Customer;
    begin

        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        DialogCaption := 'Select File to upload';
        UploadResult := UploadIntoStream(DialogCaption, '', '', Name, NVInStream);
        Sheetname := 'Sheet1';

        // Message(Sheetname);
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.OpenBookStream(NVInStream, Sheetname); //SheetName
        Rec_ExcelBuffer.ReadSheet();
        Commit();

        //finding total number of Rows to Import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Column No.", 1);
        If Rec_ExcelBuffer.FindFirst() then
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
        if Inx > 0 then
            Message('%1 of Web Orders has been Imported Successfully!\', Inx)
        else
            Error('Nothing to process.');
    end;

    local procedure GetValueAtIndex(RowNo: Integer;
   ColNo: Integer): Text
    var
        Rec_ExcelBuffer: Record "Excel Buffer";
    begin
        Rec_ExcelBuffer.Reset();
        if Rec_ExcelBuffer.Get(RowNo, ColNo) then exit(Rec_ExcelBuffer."Cell Value as Text");
    end;

    var
        Rec_ExcelBuffer: Record "Excel Buffer";
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
        TxtDate: Text;
        DocumentDate: Date;
        TimeDataUpload: Record "Sales Orders / Sales Quotes";
        LineNo: Integer;
}
