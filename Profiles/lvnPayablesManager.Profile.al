profile "lvnPayablesManager"
{
    Caption = 'Payables Manager';
    Description = 'Payables Manager';
    RoleCenter = lvnPayablesRoleCenter;
    Customizations = lvnPurchInvSubform, lvnPurchCrMemoSubform, lvnSalesInvoiceSubform, lvnSalesCrMemoSubform;
}