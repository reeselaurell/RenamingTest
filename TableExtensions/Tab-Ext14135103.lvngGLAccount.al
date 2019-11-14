tableextension 14135103 "lvngGLAccount" extends "G/L Account"
{
    fields
    {
        field(14135100; lvngReportingAccountName; Text[50])
        {
            Caption = 'Reporting Account Name';
            DataClassification = CustomerContent;
        }
        field(14135102; lvngLoanNoMandatory; Boolean)
        {
            Caption = 'Loan No. Mandatory';
            DataClassification = CustomerContent;
        }
        field(14135103; lvngLinkedBankAccountNo; Code[20])
        {
            Caption = 'Linked Bank Account No.';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account"."No.";
        }
        field(14135104; lvngReconciliationFieldNo; Integer)
        {
            Caption = 'Reconciliation Field No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanFieldsConfiguration."Field No." where("Value Type" = const(lvngDecimal));

        }
        field(14135105; lvngReportGrouping; Option)
        {
            Caption = 'Report Grouping';
            DataClassification = CustomerContent;
            OptionMembers = " ",Loan;
        }
        field(14135106; lvngShortcutDimension3Filter; Code[20]) { CaptionClass = '1,4,3'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(14135107; lvngShortcutDimension4Filter; Code[20]) { CaptionClass = '1,4,4'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(14135108; lvngShortcutDimension5Filter; Code[20]) { CaptionClass = '1,4,5'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(14135109; lvngShortcutDimension6Filter; Code[20]) { CaptionClass = '1,4,6'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(14135110; lvngShortcutDimension7Filter; Code[20]) { CaptionClass = '1,4,7'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(14135111; lvngShortcutDimension8Filter; Code[20]) { CaptionClass = '1,4,8'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
    }

}