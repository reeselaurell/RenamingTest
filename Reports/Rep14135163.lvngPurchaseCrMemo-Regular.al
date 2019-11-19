report 14135163 "lvngPurchaseCrMemo-Regular"
{
    Caption = 'Purchase Credit Memo - Regular';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135163.rdl';

    dataset
    {
        dataitem(lvngPurchCrMemoHdr; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(Logo; CompanyInformation.Picture)
            {

            }
            column(DocumentNo; lvngPurchCrMemoHdr."No.")
            {

            }
            column(BillToCustomerNo; lvngPurchCrMemoHdr."Pay-to Vendor No.")
            {

            }
            column(PostingDate; lvngPurchCrMemoHdr."Posting Date")
            {

            }
            column(LoanNo; lvngPurchCrMemoHdr."Loan No.")
            {

            }
            column(ExternalDocumentNo; DelChr(lvngPurchCrMemoHdr."Vendor Cr. Memo No.", '<>', ''))
            {

            }
            column(DueDate; lvngPurchCrMemoHdr."Due Date")
            {

            }
            column(BranchName; BranchName)
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
            dataitem(lnvgPurchCrMemoLine; "Purch. Cr. Memo Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> ' '));
                DataItemLink = "Document No." = field("No.");
                column(AccNo; lnvgPurchCrMemoLine."No.")
                {

                }
                column(Description; lnvgPurchCrMemoLine.Description)
                {

                }
                column(Description2; lnvgPurchCrMemoLine."Description 2")
                {

                }
                column(LineLoanNo; lnvgPurchCrMemoLine."Loan No.")
                {

                }
                column(Amount; lnvgPurchCrMemoLine."Amount Including VAT")
                {

                }
                column(LineBorrowerName; BorrowerName)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    Clear(BorrowerName);
                    if lnvgPurchCrMemoLine."Loan No." <> '' then begin
                        if Loan.Get(lnvgPurchCrMemoLine."Loan No.") then
                            BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Co-Borrower Last Name";
                    end;
                    if "No." = UpperCase(Description) then begin
                        if Type = Type::"G/L Account" then begin
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
                if lvngPurchCrMemoHdr."Loan No." <> '' then begin
                    if DefaultDimension.Get(Database::lvngLoan, lvngPurchCrMemoHdr."Loan No.", LoanVisionSetup."Cost Center Dimension Code") then begin
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then begin
                            BranchName := DimensionValue.Name;
                        end;
                    end;
                    if DefaultDimension.Get(Database::lvngLoan, lvngPurchCrMemoHdr."Loan No.", LoanVisionSetup."Cost Center Dimension Code") then begin
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then begin
                            LoanOfficerName := DimensionValue.Name;
                        end;
                    end;
                end;
                Clear(BillToAddress);
                FormatAddress.PurchCrMemoPayTo(BillToAddress, lvngPurchCrMemoHdr);
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
        LoanVisionSetup.Get();
        CompanyInformation.Get();
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
        LoanOfficerName: Text;
        CompanyAddress: Array[8] of Text[50];
        BillToAddress: Array[8] of Text[50];
        BorrowerName: Text;
}