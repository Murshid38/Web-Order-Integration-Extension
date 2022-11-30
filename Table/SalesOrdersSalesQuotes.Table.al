table 50100 "Sales Orders / Sales Quotes"
{
    Caption = 'Sales Orders / Sales Quotes';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(6; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(9; Qty; Decimal)
        {
            Caption = 'Qty';
            DataClassification = CustomerContent;
        }
        field(10; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
        }
        field(11; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            DataClassification = CustomerContent;
        }
        field(12; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(13; "Order/Quote Created"; Boolean)
        {
            Caption = 'Order/Quote Created';
            DataClassification = CustomerContent;
        }
        field(14; "Order/Quote Created User"; Code[50])
        {
            Caption = 'Order/Quote Created User';
            DataClassification = CustomerContent;
        }
        field(15; "Order/Quote Created Date"; Date)
        {
            Caption = 'Order/Quote Created Date';
            DataClassification = CustomerContent;
        }
        field(16; "Order/Quote Created Time"; Time)
        {
            Caption = 'Order/Quote Created Time';
            DataClassification = CustomerContent;
        }
        field(17; "Imported User"; Code[50])
        {
            Caption = 'Imported User';
            DataClassification = CustomerContent;
        }
        field(18; "Imported Date"; Date)
        {
            Caption = 'Imported Date';
            DataClassification = CustomerContent;
        }
        field(19; "Imported Time"; Time)
        {
            Caption = 'Imported Time';
            DataClassification = CustomerContent;
        }
        field(20; "SO Posting Command"; Boolean)
        {
            Caption = 'SO Posting Command';
            DataClassification = CustomerContent;
        }
        field(21; "SO Posted"; Boolean)
        {
            Caption = 'SO Posted';
            DataClassification = CustomerContent;
        }
        field(22; "Posted Invoice No."; Code[20])
        {
            Caption = 'Posted Invoice No.';
            DataClassification = CustomerContent;
        }
        field(23; "Posted Shipment No."; Code[20])
        {
            Caption = 'Posted Shipment No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
