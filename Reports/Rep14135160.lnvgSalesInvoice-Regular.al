report 14135160 "lvngSalesInvoice-Regular"
{
    Caption = 'Sales Invoice - Regular';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135160.rdl';
    dataset
    {
        dataitem(lvngSalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            column(Logo; CompanyInformation.Picture)
            {

            }
            column(DocumentNo; lvngSalesInvoiceHeader."No.")
            {

            }
            column(BillToCustomerNo; lvngSalesInvoiceHeader."Bill-to Customer No.")
            {

            }
            column(PostingDate; lvngSalesInvoiceHeader."Posting Date")
            {

            }
            column(LoanNo; lvngSalesInvoiceHeader.lvngLoanNo)
            {

            }
            column(BorrowerName; BorrowerName)
            {

            }
            column(ExternalDocumentNo; DelChr(lvngSalesInvoiceHeader."External Document No.", '<>', ''))
            {

            }
            column(DueDate; lvngSalesInvoiceHeader."Due Date")
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
            column(BillToAddress4; BillToAddress[5])
            {

            }
            column(BillToAddress6; BillToAddress[6])
            {

            }
            column(BillToAddress7; BillToAddress[7])
            {

            }
            dataitem(lnvgSalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> ' '));
                DataItemLink = "Document No." = field("No.");
                column(AccNo; lnvgSalesInvoiceLine."No.")
                {

                }
                column(Description; lnvgSalesInvoiceLine.Description)
                {

                }
                column(Description2; lnvgSalesInvoiceLine."Description 2")
                {

                }
                column(LineLoanNo; lnvgSalesInvoiceLine.lvngLoanNo)
                {

                }
                column(Amount; lnvgSalesInvoiceLine."Amount Including VAT")
                {

                }
                column(LineBorrowerName; BorrowerName)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    Clear(BorrowerName);
                    if lnvgSalesInvoiceLine.lvngLoanNo <> '' then begin
                        if Loan.Get(lnvgSalesInvoiceLine.lvngLoanNo) then
                            BorrowerName := Loan.lvngBorrowerFirstName + ' ' + Loan.lvngBorrowerMiddleName + ' ' + Loan.lvngBorrowerLastName;
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
                if lvngSalesInvoiceHeader.lvngLoanNo <> '' then begin
                    if DefaultDimension.Get(Database::lvngLoan, lvngSalesInvoiceHeader.lvngLoanNo, LoanVisionSetup.lvngCostCenterDimensionCode) then begin
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then begin
                            BranchName := DimensionValue.Name;
                        end;
                    end;
                    if DefaultDimension.Get(Database::lvngLoan, lvngSalesInvoiceHeader.lvngLoanNo, LoanVisionSetup.lvngLoanOfficerDimensionCode) then begin
                        if DimensionValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") then begin
                            LoanOfficerName := DimensionValue.Name;
                        end;
                    end;
                end;
                Clear(BillToAddress);
                FormatAddress.SalesInvBillTo(BillToAddress, lvngSalesInvoiceHeader);
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