table 14135309 "lvngLoanCommissionBuffer"
{
    Caption = 'Loan Commission Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngEntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(11; lvngCommissionProfileCode; Code[20])
        {
            Caption = 'Commission Profile Code';
            DataClassification = CustomerContent;
        }
        field(12; lvngCommissionProfileLineNo; Integer)
        {
            Caption = 'Commission Profile Line No.';
            DataClassification = CustomerContent;
        }
        field(13; lvngCommissionBaseAmount; Decimal)
        {
            Caption = 'Commission Base Amount';
            DataClassification = CustomerContent;
        }
        field(14; lvngCommissionAmount; Decimal)
        {
            Caption = 'Commission Amount';
            DataClassification = CustomerContent;
        }
        field(15; lvngCommissionBps; Decimal)
        {
            Caption = 'Bps';
            DataClassification = CustomerContent;
        }
        field(16; lvngCommissionDate; Date)
        {
            Caption = 'Commission Date';
            DataClassification = CustomerContent;
        }
        field(17; lvngValueEntry; Boolean)
        {
            Caption = 'Value Entry';
            DataClassification = CustomerContent;
        }
        field(18; lvngCalculationOnly; Boolean)
        {
            Caption = 'Calculation Only';
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; lvngEntryNo)
        {
            Clustered = true;
        }
        key(BufferSorting1; lvngCommissionProfileCode, lvngCommissionDate, lvngCommissionProfileLineNo)
        {
            SumIndexFields = lvngCommissionBaseAmount;
        }
    }

}