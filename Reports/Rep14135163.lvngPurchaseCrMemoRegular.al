report 14135163 lvngPurchaseCrMemoRegular
{
    Caption = 'Purchase Credit Memo - Regular';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135163.rdl';

    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(Logo; CompanyInformation.Picture) { }
            column(DocumentNo; "Purch. Cr. Memo Hdr."."No.") { }
            column(BillToCustomerNo; "Purch. Cr. Memo Hdr."."Pay-to Vendor No.") { }
            column(PostingDate; "Purch. Cr. Memo Hdr."."Posting Date") { }
            column(LoanNo; "Purch. Cr. Memo Hdr."."Loan No.") { }
            column(ExternalDocumentNo; DelChr("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.", '<>', '')) { }
            column(DueDate; "Purch. Cr. Memo Hdr."."Due Date") { }
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

            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> ' '));
                DataItemLink = "Document No." = field("No.");

                column(AccNo; "Purch. Cr. Memo Line"."No.") { }
                column(Description; "Purch. Cr. Memo Line".Description) { }
                column(Description2; "Purch. Cr. Memo Line"."Description 2") { }
                column(LineLoanNo; "Purch. Cr. Memo Line"."Loan No.") { }
                column(Amount; "Purch. Cr. Memo Line"."Amount Including VAT") { }
                column(LineBorrowerName; BorrowerName) { }

                trigger OnAfterGetRecord()
                begin
                    BorrowerName := '';
                    if "Purch. Cr. Memo Line"."Loan No." <> '' then
                        if Loan.Get("Purch. Cr. Memo Line"."Loan No.") then
                            BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Co-Borrower Last Name";
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
                if "Purch. Cr. Memo Hdr."."Loan No." <> '' then begin
                    if DefaultDimension.Get(Database::lvngLoan, "Purch. Cr. Memo Hdr."."Loan No.", LoanVisionSetup."Cost Center Dimension Code") then
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                            BranchName := DimensionValue.Name;
                    if DefaultDimension.Get(Database::lvngLoan, "Purch. Cr. Memo Hdr."."Loan No.", LoanVisionSetup."Cost Center Dimension Code") then
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then
                            LoanOfficerName := DimensionValue.Name;
                end;
                Clear(BillToAddress);
                FormatAddress.PurchCrMemoPayTo(BillToAddress, "Purch. Cr. Memo Hdr.");
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