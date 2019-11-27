report 14135160 lvngSalesInvoiceRegular
{
    Caption = 'Sales Invoice - Regular';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135160.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");

            column(Logo; CompanyInformation.Picture) { }
            column(DocumentNo; "Sales Invoice Header"."No.") { }
            column(BillToCustomerNo; "Sales Invoice Header"."Bill-to Customer No.") { }
            column(PostingDate; "Sales Invoice Header"."Posting Date") { }
            column(LoanNo; "Sales Invoice Header"."Loan No.") { }
            column(BorrowerName; BorrowerName) { }
            column(ExternalDocumentNo; DelChr("Sales Invoice Header"."External Document No.", '<>', '')) { }
            column(DueDate; "Sales Invoice Header"."Due Date") { }
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

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> ' '));
                DataItemLink = "Document No." = field("No.");

                column(AccNo; "Sales Invoice Line"."No.") { }
                column(Description; "Sales Invoice Line".Description) { }
                column(Description2; "Sales Invoice Line"."Description 2") { }
                column(LineLoanNo; "Sales Invoice Line"."Loan No.") { }
                column(Amount; "Sales Invoice Line"."Amount Including VAT") { }
                column(LineBorrowerName; BorrowerName) { }

                trigger OnAfterGetRecord()
                begin
                    BorrowerName := '';
                    if "Sales Invoice Line"."Loan No." <> '' then
                        if Loan.Get("Sales Invoice Line"."Loan No.") then
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
                if "Sales Invoice Header"."Loan No." <> '' then begin
                    if DefaultDimension.Get(Database::lvngLoan, "Sales Invoice Header"."Loan No.", LoanVisionSetup."Cost Center Dimension Code") then
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                            BranchName := DimensionValue.Name;
                    if DefaultDimension.Get(Database::lvngLoan, "Sales Invoice Header"."Loan No.", LoanVisionSetup."Loan Officer Dimension Code") then
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                            LoanOfficerName := DimensionValue.Name;
                end;
                Clear(BillToAddress);
                FormatAddress.SalesInvBillTo(BillToAddress, "Sales Invoice Header");
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
        FormatAddress.Company(CompanyAddress, CompanyInformation);
    end;
}