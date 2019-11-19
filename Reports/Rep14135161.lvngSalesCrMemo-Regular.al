report 14135161 "lvngSalesCrMemo-Regular"
{
    Caption = 'Sales Credit Memo - Regular';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135161.rdl';
    dataset
    {
        dataitem(lvngSalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            DataItemTableView = Sorting("No.");
            RequestFilterFields = "No.";
            column(Logo; CompanyInformation.Picture)
            {

            }
            column(DocumentNo; lvngSalesCrMemoHeader."No.")
            {

            }
            column(PostingDate; lvngSalesCrMemoHeader."Posting Date")
            {

            }
            column(LoanNo; lvngSalesCrMemoHeader."Bill-to Customer No.")
            {

            }
            column(ExternalDocumentNo; DelChr(lvngSalesCrMemoHeader."External Document No.", '<>', ''))
            {

            }
            column(BranchName; BranchName)
            {

            }
            column(LoanOfficerName; LoanOfficerName)
            {

            }
            column(CompanyAddress1; CompanyAddress[1])
            {

            }
            column(CompanyAddress2; CompanyAddress[2])
            {

            }
            column(CompanyAddress3; CompanyAddress[3])
            {

            }
            column(CompanyAddress4; CompanyAddress[4])
            {

            }
            column(CompanyAddress5; CompanyAddress[5])
            {

            }
            column(CompanyAddress6; CompanyAddress[6])
            {

            }
            column(BillToAddress1; BillToAddress[1])
            {

            }
            column(BillToAddress2; BillToAddress[2])
            {

            }
            column(BillToAddress3; BillToAddress[3])
            {

            }
            column(BillToAddress4; BillToAddress[4])
            {

            }
            column(BillToAddress5; BillToAddress[5])
            {

            }
            column(BillToAddress6; BillToAddress[6])
            {

            }
            column(BillToAddress7; BillToAddress[7])
            {

            }
            dataitem(lvngSalesCrMemoLine; "Sales Cr.Memo Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") WHERE(Type = FILTER(<> ' '));
                DataItemLink = "Document No." = Field("No.");
                column(AccNo; lvngSalesCrMemoLine."No.")
                {

                }
                column(Description; lvngSalesCrMemoLine.Description)
                {

                }
                column(Description2; lvngSalesCrMemoLine."Description 2")
                {

                }
                column(LineLoanNo; lvngSalesCrMemoLine."Loan No.")
                {

                }
                column(Amount; lvngSalesCrMemoLine."Amount Including VAT")
                {

                }
                column(LineBorrowerName; BorrowerName)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    Clear(BorrowerName);
                    if lvngSalesCrMemoLine."Loan No." <> '' then begin
                        if Loan.Get(lvngSalesCrMemoLine."Loan No.") then
                            BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
                    end;
                    if "No." = UpperCase(Description) then begin
                        IF Type = Type::"G/L Account" then begin
                            if GLAccount.Get("No.") then
                                Description := GLAccount.Name;
                        end;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(BranchName);
                Clear(LoanOfficerName);
                if lvngSalesCrMemoHeader."Loan No." <> '' then begin
                    if DefaultDimension.Get(Database::lvngLoan, lvngSalesCrMemoHeader."Loan No.", LoanVisionSetup."Cost Center Dimension Code") then begin
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then begin
                            BranchName := DimensionValue.Name;
                        end;
                    end;
                    if DefaultDimension.Get(Database::lvngLoan, lvngSalesCrMemoHeader."Loan No.", LoanVisionSetup."Loan Officer Dimension Code") then begin
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then begin
                            LoanOfficerName := DimensionValue.Name;
                        end;
                    end;
                end;
                Clear(BillToAddress);
                FormatAddress.SalesCrMemoBillTo(BillToAddress, lvngSalesCrMemoHeader);
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
    }
    trigger OnPreReport()
    begin
        LoanVisionSetup.Get;
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
        FormatAddress.Company(CompanyAddress, CompanyInformation);
    end;

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
        CompanyAddress: Array[8] of Text[50];
        BillToAddress: Array[8] of Text[50];
        BorrowerName: Text;
}