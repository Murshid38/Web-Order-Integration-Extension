codeunit 50103 "Import From Excel"
{
    trigger OnRun()
    begin
        ImportWebOrdersRecordsFromExcel();
    end;

    procedure ImportWebOrdersRecordsFromExcel()
    var
        WebOrdersRecordsRecord: Record "Web Orders";
        WebOrdersTempRecord: Record "Web Orders";
        Inx: Integer;
        WebOrdersRecordType: Enum "Document Type";
    begin

        ExcelBufferRecord.DeleteAll();
        Rows := 0;
        Columns := 0;
        DialogCaption := 'Select File to upload';
        UploadResult := UploadIntoStream(DialogCaption, '', '', Name, NVInStream);
        Sheetname := 'Sheet1';
        if not UploadResult then
            exit;

        // Message(Sheetname);
        ExcelBufferRecord.Reset();
        ExcelBufferRecord.OpenBookStream(NVInStream, Sheetname); //SheetName //this is where ExcelBufferRecord getting values of 4, 12
        ExcelBufferRecord.ReadSheet();
        Commit();

        //finding total number of Rows to Import
        ExcelBufferRecord.Reset();
        ExcelBufferRecord.SetRange("Column No.", 1);
        if ExcelBufferRecord.FindFirst() then
            repeat
                Rows := Rows + 1;
            until ExcelBufferRecord.Next() = 0;

        //Finding total number of columns to import
        ExcelBufferRecord.Reset();
        ExcelBufferRecord.SetRange("Row No.", 1);
        if ExcelBufferRecord.FindFirst() then
            repeat
                Columns := Columns + 1;
            until ExcelBufferRecord.Next() = 0;

        //for loop starts here
        for RowNo := 2 to Rows do begin
            if GetValueAtIndex(RowNo, 1) = 'Order' then
                WebOrdersRecordType := WebOrdersRecordType::Order
            else
                if GetValueAtIndex(RowNo, 1) = 'Quote' then
                    WebOrdersRecordType := WebOrdersRecordType::Quote;

            Clear(WebOrdersTempRecord);
            if not WebOrdersTempRecord.Get(WebOrdersRecordType, GetValueAtIndex(RowNo, 2), GetValueAtIndex(RowNo, 3)) then begin
                WebOrdersRecordsRecord.Init();
                WebOrdersRecordsRecord."Document Type" := WebOrdersRecordType;
                Evaluate(WebOrdersRecordsRecord."Document No.", GetValueAtIndex(RowNo, 2));
                Evaluate(WebOrdersRecordsRecord."Line No.", GetValueAtIndex(RowNo, 3));
                Evaluate(WebOrdersRecordsRecord."Document Date", GetValueAtIndex(RowNo, 5));
                Evaluate(WebOrdersRecordsRecord.Description, GetValueAtIndex(RowNo, 8));
                Evaluate(WebOrdersRecordsRecord.Qty, GetValueAtIndex(RowNo, 9));
                Evaluate(WebOrdersRecordsRecord."Unit Price", GetValueAtIndex(RowNo, 10));
                Evaluate(WebOrdersRecordsRecord."Discount Amount", GetValueAtIndex(RowNo, 11));
                Evaluate(WebOrdersRecordsRecord.Amount, GetValueAtIndex(RowNo, 12));
                WebOrdersRecordsRecord."Imported User" := UserId;
                WebOrdersRecordsRecord."Imported Date" := Today;
                WebOrdersRecordsRecord."Imported Time" := Time;
                WebOrdersRecordsRecord.Validate("Item No.", GetValueAtIndex(RowNo, 7));
                WebOrdersRecordsRecord.Validate("Customer No.", GetValueAtIndex(RowNo, 6));
                WebOrdersRecordsRecord.Validate("Location Code", GetValueAtIndex(RowNo, 4));
                if WebOrdersRecordsRecord.Insert(true) then
                    Inx += 1;
            end;
        end;
        //for loop ends here

        if Inx > 0 then
            Message('%1 of Web Orders has been Imported Successfully!\', Inx)
        else
            Error('Nothing to process.');
    end;

    local procedure GetValueAtIndex(Row: Integer; Col: Integer): Text
    var
        ExcelBufferTempRecord: Record "Excel Buffer";
    begin
        ExcelBufferTempRecord.Reset();
        if ExcelBufferTempRecord.Get(Row, Col) then exit(ExcelBufferTempRecord."Cell Value as Text");
    end;

    var
        ExcelBufferRecord: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        Sheetname: Text;
        UploadResult: Boolean;
        DialogCaption: Text;
        Name: Text;
        NVInStream: InStream;
        RowNo: Integer;
}
