table 14135156 "lvngCommissionBuffer"
{
    DataClassification = CustomerContent;
    Caption = 'Commission Buffer';

    fields
    {
        field(1; lvngLoanNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
        }
        field(11; lvngBaseAmount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base Amount';
        }
        field(12; lvngGrossCommission; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Commission';
        }
        field(13; lvngNetCommission; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Commission';
        }
        field(14; lvngAdjustmentsAmount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Adjustments Amount';
        }
        field(15; lvngLoanAmount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Amount';
        }
        field(20; lvngCommissionPaid; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Commission Paid';
        }
        field(21; lvngCommissionDue; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Commission Due';
        }
        field(22; lvngBorrowerName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Borrower Name';
        }
        field(23; lvngDateFunded; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Funded';
        }
        field(24; lvngCalculatedBps; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculated Bps';
        }
        field(26; lvngBaseBps; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base Bps';
        }
        field(27; lvngLoanOfficerTypeCode; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Officer Type Code';
        }
        field(28; lvngProfileCode; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Profile Code';
            //TableRelation = lvngCommissionProfile.Code;
        }
        field(29; lvngCollectLoans; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Collect Loans';
        }
        field(30; lvngDescription; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(40; lvngFee1Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Fee 1 Amount';
        }
        field(41; lvngFee2Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Fee 2 Amount';
        }
        field(42; lvngFee3Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Fee 3 Amount';
        }
        field(43; lvngFee4Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Fee 4 Amount';
        }
        field(44; lvngFee5Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Fee 5 Amount';
        }
        field(45; lvngFee6Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Fee 6 Amount';
        }
    }

    keys
    {
        key(PK; lvngLoanNo)
        {
            Clustered = true;
        }
        key(SK; lvngDateFunded)
        {

        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}