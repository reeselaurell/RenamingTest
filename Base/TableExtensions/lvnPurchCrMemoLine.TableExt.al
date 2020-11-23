tableextension 14135123 "lvnPurchCrMemoLine" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;
        }
        field(14135102; lvnReasonCode; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code".Code;
        }
        field(14135109; lvnDeliveryState; Code[20])
        {
            Caption = 'Delivery State';
            DataClassification = CustomerContent;
            TableRelation = lvnState;
        }
        field(14135110; lvnComment; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(14135116; lvnUseSalesTax; Boolean)
        {
            Caption = 'Use Sales Tax';
            DataClassification = CustomerContent;
        }
    }
}