page 50100 "Web Order Integration"
{
    ApplicationArea = All;
    Caption = 'Web Order Integration';
    PageType = List;
    SourceTable = "Sales Orders / Sales Quotes";
    UsageCategory = Lists;

    layout
    {
        area(Content)
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
                //button will be in promoted section only in the ribbon. 
                PromotedCategory = Process;

                trigger OnAction()
                var
                    UserSetupRec: Record "User Setup";
                    ImportFromExcelCodeunit: Codeunit "Import From Excel";
                //Assigning User Setup to table to a record variable
                begin
                    UserSetupRec.Get(UserId);
                    //now the UserSetupRec points to only one record(which is the current user)

                    if UserSetupRec."Import Web Order Permission" then
                        //checking the "Import Web Order Permission" of the Record
                        ImportFromExcelCodeunit.Run()
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
                    GenerateSalesOrdersCodeunit: Codeunit "Generate Sales Orders";
                //Assigning User Setup to table to a record variable
                begin
                    UserSetupRec.Get(UserId);
                    //now the UserSetupRec points to only one record(which is the current user)

                    if UserSetupRec."Create Web Order Permission" then
                        //checking the "Import Web Order Permission" of the Record
                        GenerateSalesOrdersCodeunit.Run()
                    else
                        Error('You do not have a permission to import!');
                end;
            }
        }
    }
}
