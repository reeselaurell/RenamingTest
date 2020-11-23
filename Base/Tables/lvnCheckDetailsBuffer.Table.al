table 14135252 "lvnCheckDetailsBuffer"
{
    Caption = 'Check Details Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Guid)
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(11; Address; Text[50])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(12; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(13; "City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(14; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(15; County; Text[30])
        {
            Caption = 'County';
            DataClassification = CustomerContent;
        }
        field(16; "Check Description"; Text[250])
        {
            Caption = 'Check Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}