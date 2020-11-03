table 14135141 "lvnForm1098Entry"
{
    Caption = 'Form 1098 Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;

            trigger OnValidate()
            var
                Loan: Record lvnLoan;
                LoanValue: Record lvnLoanValue;
                EncryptedData: Record lvnEncryptedData;
                LoanAddress: Record lvnLoanAddress;
                DefaultDimension: Record "Default Dimension";
                AddressType: Enum lvnAddressType;
                Address1: Text;
                Address2: Text;
            begin
                GetLoanVisionSetup();
                Loan.Get("Loan No.");
                if LoanValue.Get("Loan No.", LoanVisionSetup."Borrower E-Mail Field No.") then
                    "Borrower E-Mail" := LoanValue."Field Value";
                "Box 3" := Loan."Date Funded";
                "Borrower Name" := CopyStr(lvnLoanManagement.GetBorrowerName(Loan), 1, MaxStrLen("Borrower Name"));
                "Co-Borrower Name" := CopyStr(lvnLoanManagement.GetCoBorrowerName(Loan), 1, MaxStrLen("Co-Borrower Name"));
                "Borrower SSN" := Loan."Borrower SSN";
                "Co-Borrower SSN" := Loan."Co-Borrower SSN";
                if EncryptedData.Get(Loan."Borrower SSN Key") then
                    "Borrower SSN" := EncryptedData.DecryptValue();
                if EncryptedData.Get(Loan."Co-Borrower SSN Key") then
                    "Co-Borrower SSN" := EncryptedData.DecryptValue();
                if LoanAddress.Get("Loan No.", AddressType::Mailing) then
                    if LoanAddress.Address <> '' then begin
                        "Borrower Mailing Address" := LoanAddress.Address;
                        "Borrower Mailing City" := LoanAddress.City;
                        "Borrower State" := LoanAddress.State;
                        "Borrower ZIP Code" := LoanAddress."ZIP Code";
                    end;
                if "Borrower Mailing Address" = '' then
                    if LoanAddress.Get("Loan No.", AddressType::Borrower) then
                        if LoanAddress.Address <> '' then begin
                            "Borrower Mailing Address" := LoanAddress.Address;
                            "Borrower Mailing City" := LoanAddress.City;
                            "Borrower State" := LoanAddress.State;
                            "Borrower ZIP Code" := LoanAddress."ZIP Code";
                        end;
                "Borrower Mailing Address" := DelChr("Borrower Mailing Address", '<>', ' ');
                "Borrower Mailing City" := DelChr("Borrower Mailing City", '<>', ' ');
                "Borrower State" := DelChr("Borrower State", '<>', ' ');
                "Borrower ZIP Code" := DelChr("Borrower ZIP Code", '<>', ' ');
                Address1 := "Borrower Mailing Address";
                if LoanAddress.Get("Loan No.", AddressType::Property) then
                    Address2 := DelChr(LoanAddress.Address, '<>', ' ')
                else
                    Address2 := '';
                "Box 7" := UpperCase(Address1) = UpperCase(Address2);
                "Box 8" := '';
                "Box 9" := '';
                if not "Box 7" then begin
                    if LoanVisionSetup."Loan Purpose Dimension Code" <> '' then
                        if LoanVisionSetup."Construction Purpose Code" <> '' then begin
                            DefaultDimension.Reset();
                            DefaultDimension.SetRange("Table ID", Database::lvnLoan);
                            DefaultDimension.SetRange("No.", Loan."No.");
                            DefaultDimension.SetRange("Dimension Code", LoanVisionSetup."Loan Purpose Dimension Code");
                            if DefaultDimension.FindFirst() then
                                if DefaultDimension."Dimension Value Code" = LoanVisionSetup."Construction Purpose Code" then
                                    "Box 9" := Loan.GetLoanAddress(AddressType::Property);
                        end;
                    if "Box 9" = '' then
                        "Box 8" := Loan.GetLoanAddress(AddressType::Property);
                end;
            end;
        }
        field(10; "Borrower Name"; Text[100]) { Caption = 'Borrower Name'; DataClassification = CustomerContent; }
        field(11; "Borrower SSN"; Text[20]) { Caption = 'Borrower SSN'; DataClassification = CustomerContent; }
        field(12; "Co-Borrower Name"; Text[100]) { Caption = 'Co-Borrower Name'; DataClassification = CustomerContent; }
        field(13; "Co-Borrower SSN"; Text[20]) { Caption = 'Co-Borrower SSN'; DataClassification = CustomerContent; }
        field(14; "Borrower Mailing Address"; Text[250]) { Caption = 'Borrower Mailing Address'; DataClassification = CustomerContent; }
        field(15; "Borrower Mailing City"; Text[100]) { Caption = 'Borrower Mailing City'; DataClassification = CustomerContent; }
        field(16; "Borrower State"; Code[50]) { Caption = 'Borrower State'; DataClassification = CustomerContent; }
        field(17; "Borrower ZIP Code"; Code[100]) { Caption = 'Borrower ZIP Code'; DataClassification = CustomerContent; }
        field(18; "Borrower E-Mail"; Text[100]) { Caption = 'Borrower E-Mail'; DataClassification = CustomerContent; }
        field(19; "Box 1"; Decimal) { Caption = 'Box 1'; DataClassification = CustomerContent; }
        field(20; "Box 2"; Decimal) { Caption = 'Box 2'; DataClassification = CustomerContent; }
        field(21; "Box 3"; Date) { Caption = 'Box 3'; DataClassification = CustomerContent; }
        field(22; "Box 4"; Decimal) { Caption = 'Box 4'; DataClassification = CustomerContent; }
        field(23; "Box 5"; Decimal) { Caption = 'Box 5'; DataClassification = CustomerContent; }
        field(24; "Box 6"; Decimal) { Caption = 'Box 6'; DataClassification = CustomerContent; }
        field(25; "Box 7"; Boolean) { Caption = 'Box 7'; DataClassification = CustomerContent; }
        field(26; "Box 8"; Text[250]) { Caption = 'Box 8'; DataClassification = CustomerContent; }
        field(27; "Box 9"; Text[250]) { Caption = 'Box 9'; DataClassification = CustomerContent; }
        field(28; "Box 10"; Decimal) { Caption = 'Box 10'; DataClassification = CustomerContent; }
        field(29; "Not Eligible"; Boolean) { Caption = 'Not Eligible'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Loan No.") { Clustered = true; }
    }

    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        lvnLoanManagement: Codeunit lvnLoanManagement;
        GotLoanVisionSetup: Boolean;

    trigger OnDelete()
    var
        Form1098Details: Record lvnForm1098Details;
    begin
        Form1098Details.Reset();
        Form1098Details.SetRange("Loan No.", "Loan No.");
        Form1098Details.DeleteAll();
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not GotLoanVisionSetup then begin
            LoanVisionSetup.Get();
            GotLoanVisionSetup := true;
        end;
    end;
}