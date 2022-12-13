codeunit 50101 "Generate Sales Orders"
{
    trigger OnRun()
    begin
        Generate();
    end;

    local procedure Generate()
    var
        WebOrdersRecord: Record "Web Orders";
        WebOrdersTempRecord: Record "Web Orders";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        GroupDoc: Code[20];
        WindowDialog: Dialog;
        Inx: Integer;
    begin
        WindowDialog.Open('Processing Web Orders...\Document No. #1#######\Line No. #2#######\Loop #3#######\Count #4#######');
        Clear(WebOrdersRecord);
        WebOrdersRecord.SetCurrentKey("Document Type", "Document No.", "Line No.");
        WebOrdersRecord.SetRange("Order/Quote Created", false);
        WindowDialog.Update(4, WebOrdersRecord.Count);
        if WebOrdersRecord.FindSet() then
            repeat begin
                Inx += 1;
                WindowDialog.Update(1, WebOrdersRecord."Document No.");
                WindowDialog.Update(2, WebOrdersRecord."Line No.");
                WindowDialog.Update(3, Inx);
                if GroupDoc <> WebOrdersRecord."Document No." then begin
                    GroupDoc := WebOrdersRecord."Document No.";
                    SalesHeader.Init();
                    if WebOrdersRecord."Document Type" = WebOrdersRecord."Document Type"::Order then
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Order
                    else
                        if WebOrdersRecord."Document Type" = WebOrdersRecord."Document Type"::Quote then
                            SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
                    SalesHeader."No." := WebOrdersRecord."Document No.";
                    SalesHeader.Insert();
                    SalesHeader.Validate("Sell-to Customer No.", WebOrdersRecord."Customer No.");
                    SalesHeader.Validate("Location Code", WebOrdersRecord."Location Code");
                    SalesHeader.Validate("Posting Date", WebOrdersRecord."Document Date");
                    SalesHeader.Ship := true;
                    SalesHeader.Invoice := true;
                    SalesHeader.Modify();
                end;

                SalesLine.Init();
                if WebOrdersRecord."Document Type" = WebOrdersRecord."Document Type"::Order then
                    SalesLine."Document Type" := SalesLine."Document Type"::Order
                else
                    if WebOrdersRecord."Document Type" = WebOrdersRecord."Document Type"::Quote then
                        SalesLine."Document Type" := SalesLine."Document Type"::Quote;
                SalesLine."Document No." := WebOrdersRecord."Document No.";
                SalesLine."Line No." := WebOrdersRecord."Line No.";
                if SalesLine.Insert() then begin
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.", WebOrdersRecord."Item No.");
                    SalesLine.Description := WebOrdersRecord.Description;
                    SalesLine.Validate(Quantity, WebOrdersRecord.Qty);
                    SalesLine.Validate("Qty. to Ship", WebOrdersRecord.Qty);
                    SalesLine.Validate("Qty. to Invoice", WebOrdersRecord.Qty);
                    SalesLine.Validate("Unit Price", WebOrdersRecord."Unit Price");
                    SalesLine.Validate("Line Discount Amount", WebOrdersRecord."Discount Amount");
                    SalesLine.Validate(Amount, WebOrdersRecord.Amount);
                    SalesLine.Modify();
                    WebOrdersRecord."Order/Quote Created" := true;
                    WebOrdersRecord."Order/Quote Created Date" := Today;
                    WebOrdersRecord."Order/Quote Created Time" := Time;
                    WebOrdersRecord."Order/Quote Created User" := UserId;
                    WebOrdersRecord.Modify();
                end;
            end
            until WebOrdersRecord.Next() = 0;
        WindowDialog.Close();

        Clear(WebOrdersRecord);
        WebOrdersRecord.SetCurrentKey("Document Type", "Document No.", "Line No.");
        WebOrdersRecord.SetRange("Document Type", WebOrdersRecord."Document Type"::Order);
        WebOrdersRecord.SetRange("Order/Quote Created", true);
        WebOrdersRecord.SetRange("SO Posted", false);
        WebOrdersRecord.SetRange("SO Posting Command", true);

        WebOrdersRecord.SetCurrentKey("Document Type", "Document No.", "Line No.");
        if WebOrdersRecord.FindFirst() then
            repeat
                if GroupDoc <> WebOrdersRecord."Document No." then begin
                    GroupDoc := WebOrdersRecord."Document No.";

                    clear(SalesHeader);
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("No.", WebOrdersRecord."Document No.");
                    if SalesHeader.FindFirst() then
                        if SalesHeader.SendToPosting(80) then begin
                            Clear(WebOrdersTempRecord);
                            WebOrdersTempRecord.SetRange("Document Type", WebOrdersTempRecord."Document Type"::Order);
                            WebOrdersTempRecord.SetRange("Document No.", WebOrdersRecord."Document No.");
                            WebOrdersTempRecord.ModifyAll("SO Posted", true);
                            WebOrdersTempRecord.ModifyAll("SO Posting Command", false);
                        end;
                end;
            until WebOrdersRecord.Next() = 0;
    end;
}
