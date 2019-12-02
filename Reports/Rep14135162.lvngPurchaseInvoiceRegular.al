report 14135162 lvngPurchaseInvoiceRegular
{
    Caption = 'Purchase Invoice - Regular';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135162.rdl';

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(Logo; CompanyInformation.Picture) { }
            column(DocumentNo; "Purch. Inv. Header"."No.") { }
            column(BillToCustomerNo; "Purch. Inv. Header"."Pay-to Vendor No.") { }
            column(PostingDate; "Purch. Inv. Header"."Posting Date") { }
            column(LoanNo; "Purch. Inv. Header"."Loan No.") { }
            column(ExternalDocumentNo; DelChr("Purch. Inv. Header"."Vendor Invoice No.", '<>', ' ')) { }
            column(DueDate; "Purch. Inv. Header"."Due Date") { }
            column(BranchName; BranchName) { }
            column(LoanOfficerName; LoanOfficerName) { }
            column(CompanyAddress1; CompanyAddress[1]) { }
            column(CompanyAddress2; CompanyAddress[2]) { }
            column(CompanyAddress3; CompanyAddress[3]) { }
            column(CompanyAddress4; CompanyAddress[4]) { }
            column(CompanyAddress5; CompanyAddress[5]) { }
            column(CompanyAddress6; CompanyAddress[6]) { }
            column(BillToAddress1; BillToAddress[1]) { }
            column(BillToAddress2; BillToAddress[2]) { }
            column(BillToAddress3; BillToAddress[3]) { }
            column(BillToAddress4; BillToAddress[4]) { }
            column(BillToAddress5; BillToAddress[5]) { }
            column(BillToAddress6; BillToAddress[6]) { }
            column(BillToAddress7; BillToAddress[7]) { }

            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> " "));
                DataItemLink = "Document No." = field("No.");

                column(AccNo; "Purch. Inv. Line"."No.") { }
                column(Description; "Purch. Inv. Line".Description) { }
                column(Description2; "Purch. Inv. Line"."Description 2") { }
                column(LineLoanNo; "Purch. Inv. Line"."Loan No.") { }
                column(Amount; "Purch. Inv. Line".Amount) { }
                column(LineBorrowerName; BorrowerName) { }

                trigger OnAfterGetRecord()
                begin
                    BorrowerName := '';
                    if "Purch. Inv. Line"."Loan No." <> '' then
                        if Loan.Get("Purch. Inv. Line"."Loan No.") then
                            BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
                    if "No." = UpperCase(Description) then
                        if Type = Type::"G/L Account" then
                            if GLAccount.Get("No.") then
                                Description := GLAccount.Name;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                BranchName := '';
                LoanOfficerName := '';
                if "Purch. Inv. Header"."Loan No." <> '' then begin
                    if DefaultDimension.Get(Database::lvngLoan, "Purch. Inv. Header"."Loan No.", LoanVisionSetup."Cost Center Dimension Code") then
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                            BranchName := DimensionValue.Name;
                    if DefaultDimension.Get(Database::lvngLoan, "Purch. Inv. Header"."Loan No.", LoanVisionSetup."Loan Officer Dimension Code") then
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                            LoanOfficerName := DimensionValue.Name;
                end;
                Clear(BillToAddress);
                FormatAddress.PurchInvPayTo(BillToAddress, "Purch. Inv. Header");
            end;
        }
    }

    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        DefaultDimension: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";
        CompanyInformation: Record "Company Information";
        Loan: Record lvngLoan;
        GLAccount: Record "G/L Account";
        FormatAddress: Codeunit "Format Address";
        BranchName: Text;
        LoanOfficerName: Text;
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        BorrowerName: Text;

    trigger OnPreReport()
    begin
        LoanVisionSetup.Get();
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
        FormatAddress.Company(CompanyAddress, CompanyInformation)
    end;
}