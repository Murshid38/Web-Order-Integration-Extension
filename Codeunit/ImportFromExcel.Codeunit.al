codeunit 50103 "Import From Excel"
{
    trigger OnRun()
    begin
        ImportWebOrdersFromExcel();
    end;

    procedure ImportWebOrdersFromExcel()
    var
        WebOrderIntegrataion: Record "Sales Orders / Sales Quotes";
        WebOrderIntegrataion2: Record "Sales Orders / Sales Quotes";
        // CustomerMaster: Record Customer;
        // DateVariant: Variant;
        // DateCheck: Boolean;
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
        Rec_ExcelBuffer.OpenBookStream(NVInStream, Sheetname); //SheetName //this is where Rec_ExcelBuffer getting values of 4, 12
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
        // TimeDataUpload: Record "Sales Orders / Sales Quotes";
        Rows: Integer;
        Columns: Integer;
        // Fileuploaded: Boolean;
        // UploadIntoStream: InStream;
        // FileName: Text;
        Sheetname: Text;
        UploadResult: Boolean;
        DialogCaption: Text;
        Name: Text;
        NVInStream: InStream;
        RowNo: Integer;
    // TxtDate: Text; // DocumentDate: Date;
    // LineNo: Integer;
}
