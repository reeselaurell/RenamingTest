report 14135161 lvngSalesCrMemoRegular
{
    Caption = 'Sales Credit Memo - Regular';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135161.rdl';

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(Logo; CompanyInformation.Picture) { }
            column(DocumentNo; "Sales Cr.Memo Header"."No.") { }
            column(PostingDate; "Sales Cr.Memo Header"."Posting Date") { }
            column(LoanNo; "Sales Cr.Memo Header"."Loan No.") { }
            column(BillToCustomerNo; "Sales Cr.Memo Header"."Bill-to Customer No.") { }
            column(ExternalDocumentNo; DelChr("Sales Cr.Memo Header"."External Document No.", '<>', '')) { }
            column(BranchName; BranchName) { }
            column(BorrowerName; BorrowerName) { }
            column(DueDate; "Sales Cr.Memo Header"."Due Date") { }
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

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> ' '));
                DataItemLink = "Document No." = field("No.");

                column(AccNo; "Sales Cr.Memo Line"."No.") { }
                column(Description; "Sales Cr.Memo Line".Description) { }
                column(Description2; "Sales Cr.Memo Line"."Description 2") { }
                column(LineLoanNo; "Sales Cr.Memo Line"."Loan No.") { }
                column(Amount; "Sales Cr.Memo Line"."Amount Including VAT") { }
                column(LineBorrowerName; LineBorrowerName) { }

                trigger OnAfterGetRecord()
                begin
                    BorrowerName := '';
                    if "Sales Cr.Memo Line"."Loan No." <> '' then
                        if Loan.Get("Sales Cr.Memo Line"."Loan No.") then
                            LineBorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
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
                if "Sales Cr.Memo Header"."Loan No." <> '' then begin
                    if DefaultDimension.Get(Database::lvngLoan, "Sales Cr.Memo Header"."Loan No.", LoanVisionSetup."Cost Center Dimension Code") then
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                            BranchName := DimensionValue.Name;
                    if DefaultDimension.Get(Database::lvngLoan, "Sales Cr.Memo Header"."Loan No.", LoanVisionSetup."Loan Officer Dimension Code") then
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                            LoanOfficerName := DimensionValue.Name;
                    if Loan.Get("Sales Cr.Memo Line"."Loan No.") then
                        BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
                end;
                Clear(BillToAddress);
                FormatAddress.SalesCrMemoBillTo(BillToAddress, "Sales Cr.Memo Header");
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
        LoanOfficerName: Text[50];
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        LineBorrowerName: Text;
        BorrowerName: Text;

    trigger OnPreReport()
    begin
        LoanVisionSetup.Get;
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
        FormatAddress.Company(CompanyAddress, CompanyInformation);
    end;
}