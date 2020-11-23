profile "lvnLoanProcessor"
{
    Caption = 'Loan Processor';
    ProfileDescription = 'Loan Processor Profile';
    RoleCenter = lvnLoanProcessorRolecenter;
    Customizations = lvnSalesInvoiceSubform, lvnSalesCrMemoSubform, lvnPurchInvSubform, lvnPurchCrMemoSubform;
}