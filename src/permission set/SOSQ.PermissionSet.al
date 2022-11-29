permissionset 50100 "SO/SQ"
{
    Assignable = true;
    Caption = 'Permission for SO/SQ ', MaxLength = 30;
    Permissions =
        table "Sales Orders / Sales Quotes" = X,
        tabledata "Sales Orders / Sales Quotes" = RMID;
}
