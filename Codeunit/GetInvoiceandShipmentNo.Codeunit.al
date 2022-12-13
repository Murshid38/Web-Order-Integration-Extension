codeunit 50102 "Get Invoice and Shipment No"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure GetInvoiceAndShipNo(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20])
    var
        WebOrdersRecordsRecord: Record "Web Orders";
    begin
        Clear(WebOrdersRecordsRecord);
        WebOrdersRecordsRecord.SetCurrentKey("Document Type", "Document No.", "Line No.");
        WebOrdersRecordsRecord.SetRange("Document Type", WebOrdersRecordsRecord."Document Type"::Order);
        WebOrdersRecordsRecord.SetRange("Document No.", SalesHeader."No.");
        WebOrdersRecordsRecord.ModifyAll("Posted Invoice No.", SalesInvHdrNo);
        WebOrdersRecordsRecord.ModifyAll("Posted Shipment No.", SalesShptHdrNo);
    end;
}

