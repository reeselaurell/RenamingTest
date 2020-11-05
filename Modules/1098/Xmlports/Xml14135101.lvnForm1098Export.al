xmlport 14135101 "lvnForm1098Export"
{
    Caption = 'Form 1098 Export';
    Direction = Export;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(FormEntry; lvnForm1098Entry)
            {
                SourceTableView = sorting("Loan No.");
                RequestFilterFields = "Not Eligible";

                fieldelement(LoanNo; FormEntry."Loan No.")
                {
                }
                textelement(LenderName)
                {
                }
                textelement(LenderAddress)
                {
                }
                textelement(LenderCity)
                {
                }
                textelement(LenderState)
                {
                }
                textelement(LenderCountry)
                {
                }
                textelement(LenderZIPCode)
                {
                }
                textelement(LenderPhone)
                {
                }
                textelement(LenderFedID)
                {
                }
                textelement(BorrowerSSN)
                {
                    trigger OnBeforePassVariable()
                    var
                        Len: Integer;
                    begin
                        Len := StrLen(FormEntry."Borrower SSN");
                        if Len < 4 then
                            Error(WrongSSNErr, FormEntry."Loan No.");
                        if EncryptSSN then
                            BorrowerSSN := StrSubstNo(SSNMaskTxt, CopyStr(FormEntry."Borrower SSN", Len - 3))
                        else
                            BorrowerSSN := FormEntry."Borrower SSN";
                    end;
                }
                fieldelement(Name; FormEntry."Borrower Name")
                {
                }
                fieldelement(Address; FormEntry."Borrower Mailing Address")
                {
                }
                fieldelement(City; FormEntry."Borrower Mailing City")
                {
                }
                fieldelement(State; FormEntry."Borrower State")
                {
                }
                fieldelement(ZIP; FormEntry."Borrower ZIP Code")
                {
                }
                fieldelement(State2; FormEntry."Borrower State")
                {
                }
                textelement(Other)
                {
                }
                fieldelement(LoanNo2; FormEntry."Loan No.")
                {
                }
                fieldelement(Interest; FormEntry."Box 1")
                {
                }
                fieldelement(OutstandingPrincipalBalance; FormEntry."Box 2")
                {
                }
                fieldelement(DateFunded; FormEntry."Box 3")
                {
                }
                fieldelement(RefundInterest; FormEntry."Box 4")
                {
                }
                fieldelement(InsurancePremium; FormEntry."Box 5")
                {
                }
                fieldelement(PointsPaid; FormEntry."Box 6")
                {
                }
                textelement(Box7)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if FormEntry."Box 7" then
                            Box7 := 'TRUE'
                        else
                            Box7 := 'FALSE';
                    end;
                }
                fieldelement(Box8; FormEntry."Box 8")
                {
                }
                fieldelement(Box9; FormEntry."Box 9")
                {
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Parameters)
                {
                    Caption = 'Parameters';

                    field(EncryptSSN; EncryptSSN) { Caption = 'Mask SSN'; ApplicationArea = All; }
                }
            }
        }
    }

    trigger OnPreXmlPort()
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        LenderName := CompanyInformation.Name;
        LenderAddress := CompanyInformation.Address;
        LenderCity := CompanyInformation.City;
        LenderState := CompanyInformation.County;
        LenderZIPCode := CompanyInformation."Post Code";
        LenderPhone := CompanyInformation."Phone No.";
        LenderFedID := CompanyInformation."Federal ID No.";
    end;

    var
        EncryptSSN: Boolean;
        WrongSSNErr: Label 'Wrong SSN for Loan No. %1';
        SSNMaskTxt: Label '***-**-%1';
}