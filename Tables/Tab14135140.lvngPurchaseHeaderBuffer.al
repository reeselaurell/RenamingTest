table 14135140 lvngPurchaseHeaderBuffer
{
    DataClassification = CustomerContent;
    Caption = 'Purchase Header Buffer';

    fields
    {
        field(1; "Document Type"; Option) { DataClassification = CustomerContent; Caption = 'Document Type'; OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"; }
        field(2; "Buy-from Vendor No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Buy-from Vendor No.'; TableRelation = Vendor; }
        field(3; "No."; Code[20]) { DataClassification = CustomerContent; Caption = 'No.'; }
        field(4; "Pay-to Vendor No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Pay-to Vendor No.'; NotBlank = true; TableRelation = Vendor; }
        field(10; "Vendor Invoice No."; Code[35]) { DataClassification = CustomerContent; Caption = 'Vendor Invoice No.'; }
        field(11; "Document Total (Check)"; Decimal) { DataClassification = CustomerContent; Caption = 'Document Total (Check)'; BlankZero = true; }
        field(12; "Posting Description"; Text[100]) { DataClassification = CustomerContent; Caption = 'Posting Description'; }
        field(13; "Pay-to Contact"; Text[100]) { DataClassification = CustomerContent; Caption = 'Pay-to Contact'; }
        field(14; "Document Date"; Date) { DataClassification = CustomerContent; Caption = 'Document Date'; }
        field(15; "Vendor Cr. Memo No."; Code[35]) { DataClassification = CustomerContent; Caption = 'Vendor Cr. Memo No.'; }
        field(16; "Pay-to Name"; Text[100]) { DataClassification = CustomerContent; Caption = 'Pay-to Name'; TableRelation = Vendor; ValidateTableRelation = false; }
        field(17; "Pay-to Name 2"; Text[50]) { DataClassification = CustomerContent; Caption = 'Pay-to Name 2'; }
        field(18; "Pay-to Address"; Text[100]) { DataClassification = CustomerContent; Caption = 'Pay-to Address'; }
        field(19; "Pay-to Address 2"; Text[50]) { DataClassification = CustomerContent; Caption = 'Pay-to Address 2'; }
        field(20; "Pay-to City"; Text[30]) { DataClassification = CustomerContent; Caption = 'Pay-to City'; }
        field(21; "Pay-to Post Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'ZIP Code'; }
        field(22; "Pay-to County"; Text[30]) { DataClassification = CustomerContent; Caption = 'State'; }
        field(23; "Pay-to Country/Region Code"; Code[50]) { DataClassification = CustomerContent; Caption = 'Country/Region Code'; }
        field(24; "Applies-to Doc. No."; Code[20]) { DataClassification = CustomerContent; Caption = 'Applies-to Doc. No.'; }
    }

    keys
    {
        key(PK; "Document Type") { Clustered = true; }
    }
}