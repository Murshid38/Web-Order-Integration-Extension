codeunit 50101 "Generate Sales Orders"
{
    trigger OnRun()
    begin
        Generate();
    end;

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
}
