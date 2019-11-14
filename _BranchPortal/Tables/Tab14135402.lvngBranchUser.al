table 14135402 lvngBranchUser
{
    LookupPageId = lvngBranchUsers;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            NotBlank = true;
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;

        }
        field(10; "Show Performance Worksheet"; Enum lvngDefaultBoolean) { DataClassification = CustomerContent; }
        field(11; "Show KPI"; Enum lvngDefaultBoolean) { DataClassification = CustomerContent; }
        field(12; "Show General Ledger"; Enum lvngDefaultBoolean) { DataClassification = CustomerContent; }
        field(13; "Show Loan Level Report"; Enum lvngDefaultBoolean) { DataClassification = CustomerContent; }
        field(14; "Show Corporate Tile"; Enum lvngDefaultBoolean) { DataClassification = CustomerContent; }
        field(15; "Block Data From Date"; Date) { DataClassification = CustomerContent; }
        field(16; "Block Data To Date"; Date) { DataClassification = CustomerContent; }
        field(17; "Initial Dashboard Period"; Enum lvngInitialDashboardPeriod) { DataClassification = CustomerContent; }
        /*
        field(10; "Super User"; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Super User" then begin
                    "Regenerate Permissions" := false;
                    "Level 1 Filter Prefix" := '';
                    "Level 2 Filter Prefix" := '';
                    "Level 3 Filter Prefix" := '';
                    "Level 4 Filter Prefix" := '';
                    "Level 5 Filter Prefix" := '';
                end else
                    "Regenerate Permissions" := true;
            end;
        }
        field(11; "E-Mail"; Text[100]) { DataClassification = CustomerContent; }
        field(12; "Regenerate Permissions"; Boolean) { DataClassification = CustomerContent; }
        field(20; "Level 1 Filter Prefix"; Code[10]) { DataClassification = CustomerContent; TableRelation = lvngPortalFilterPrefix."Prefix Code" where (Type = const ("Level 1")); }
        field(21; "Level 2 Filter Prefix"; Code[10]) { DataClassification = CustomerContent; TableRelation = lvngPortalFilterPrefix."Prefix Code" where (Type = const ("Level 2")); }
        field(22; "Level 3 Filter Prefix"; Code[10]) { DataClassification = CustomerContent; TableRelation = lvngPortalFilterPrefix."Prefix Code" where (Type = const ("Level 3")); }
        field(23; "Level 4 Filter Prefix"; Code[10]) { DataClassification = CustomerContent; TableRelation = lvngPortalFilterPrefix."Prefix Code" where (Type = const ("Level 4")); }
        field(24; "Level 5 Filter Prefix"; Code[10]) { DataClassification = CustomerContent; TableRelation = lvngPortalFilterPrefix."Prefix Code" where (Type = const ("Level 5")); }
        */
    }

    keys
    {
        key(PK; "User ID") { Clustered = true; }
    }
}