permissionset 50100 "Web Orders"
{
    Assignable = true;
    Caption = 'Permission for SO/SQ ', MaxLength = 30;
    Permissions =
        table "Web Orders" = X,
        tabledata "Web Orders" = RMID;
}
