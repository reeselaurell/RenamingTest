tableextension 14135105 lvngVendor extends Vendor
{
    fields
    {
        field(14135100; "Legal Name"; Text[100]) { Caption = 'Legal Name'; DataClassification = CustomerContent; }
        field(14135101; "Legal Address"; Text[50]) { Caption = 'Legal Address'; DataClassification = CustomerContent; }
        field(14135102; "Legal Address 2"; Text[50]) { Caption = 'Legal Address 2'; DataClassification = CustomerContent; }
        field(14135103; "Legal City"; Text[30]) { Caption = 'Legal City'; DataClassification = CustomerContent; }
        field(14135104; "Legal State"; Text[30]) { Caption = 'Legal State'; DataClassification = CustomerContent; }
        field(14135105; "Legal ZIP Code"; Code[20]) { Caption = 'Legal ZIP Code'; DataClassification = CustomerContent; }
    }
}