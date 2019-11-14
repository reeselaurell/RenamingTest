report 14135162 "lvngPurchaseInvoice-Regular"
{
    Caption = 'Purchase Invoice - Regular';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135162.rdl';

    dataset
    {
        dataitem(lvngPurchInvHeader; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(Logo; CompanyInformation.Picture)
            {

            }
            column(DocumentNo; lvngPurchInvHeader."No.")
            {

            }
            column(BillToCustomerNo; lvngPurchInvHeader."Pay-to Vendor No.")
            {

            }
            column(PostingDate; lvngPurchInvHeader."Posting Date")
            {

            }
            column(LoanNo; lvngPurchInvHeader.lvngLoanNo)
            {

            }
            column(ExternalDocumentNo; DelChr(lvngPurchInvHeader."Vendor Invoice No.", '<>', ''))
            {

            }
            column(DueDate; lvngPurchInvHeader."Due Date")
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
            dataitem(lvngPurchInvLine; "Purch. Inv. Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> ' '));
                DataItemLink = "Document No." = field("No.");
                column(AccNo; lvngPurchInvLine."No.")
                {

                }
                column(Description; lvngPurchInvLine.Description)
                {

                }
                column(Description2; lvngPurchInvLine."Description 2")
                {

                }
                column(LineLoanNo; lvngPurchInvLine.lvngLoanNo)
                {

                }
                column(Amount; lvngPurchInvLine.Amount)
                {

                }
                column(LineBorrowerName; BorrowerName)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    Clear(BorrowerName);
                    if lvngPurchInvLine.lvngLoanNo <> '' then begin
                        if Loan.Get(lvngPurchInvLine.lvngLoanNo) then
                            BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
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
                if lvngPurchInvHeader.lvngLoanNo <> '' then begin
                    if DefaultDimension.Get(Database::lvngLoan, lvngPurchInvHeader.lvngLoanNo, LoanVisionSetup."Cost Center Dimension Code") then begin
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then begin
                            BranchName := DimensionValue.Name;
                        end;
                    end;
                    if DefaultDimension.Get(Database::lvngLoan, lvngPurchInvHeader.lvngLoanNo, LoanVisionSetup."Loan Officer Dimension Code") then begin
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then begin
                            LoanOfficerName := DimensionValue.Name;
                        end;
                    end;
                end;
                Clear(BillToAddress);
                FormatAddress.PurchInvPayTo(BillToAddress, lvngPurchInvHeader);
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
        FormatAddress.Company(CompanyAddress, CompanyInformation)
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