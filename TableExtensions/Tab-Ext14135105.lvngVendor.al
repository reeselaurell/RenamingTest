tableextension 14135105 "lvngVendor" extends Vendor//MyTargetTableId
{
    fields
    {
        field(14135100; lvngLegalName; Text[100])
        {
            Caption = 'Legal Name';
            DataClassification = CustomerContent;
        }
        field(14135101; lvngAddress; Text[50])
        {
            Caption = 'Legal Address';
            DataClassification = CustomerContent;
        }
        field(14135102; lvngAddress2; Text[50])
        {
            Caption = 'Legal Address 2';
            DataClassification = CustomerContent;
        }
        field(14135103; lvngCity; Text[30])
        {
            Caption = 'Legal City';
            DataClassification = CustomerContent;

        }
        field(14135104; lvngState; Text[30])
        {
            Caption = 'Legal State';
            DataClassification = CustomerContent;
        }

        field(14135105; lvngZIPCode; Code[20])
        {
            Caption = 'Legal ZIP Code';
            DataClassification = CustomerContent;
        }

    }

}