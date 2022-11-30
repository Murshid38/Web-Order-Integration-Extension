pageextension 50100 "User Setup Page Extension" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Create Web Order Permission"; Rec."Create Web Order Permission")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Value of Create Web Order Permission';
            }
            field("Import Web Order Permission"; Rec."Import Web Order Permission")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Value of Import Web Order Permission';
            }
            field("Web Order Posting Permission"; Rec."Web Order Posting Permission")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Value of Web Order Posting Permission';
            }
        }
    }
}
