codeunit 50102 "Get Invoice and Shipment No"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure GetInvoiceAndShipNo(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20])
    var
        WebOrdersRecord: Record "Web Orders";
    begin
        Clear(WebOrdersRecord);
        WebOrdersRecord.SetCurrentKey("Document Type", "Document No.", "Line No.");
        WebOrdersRecord.SetRange("Document Type", WebOrdersRecord."Document Type"::Order);
        WebOrdersRecord.SetRange("Document No.", SalesHeader."No.");
        WebOrdersRecord.ModifyAll("Posted Invoice No.", SalesInvHdrNo);
        WebOrdersRecord.ModifyAll("Posted Shipment No.", SalesShptHdrNo);
    end;
}

