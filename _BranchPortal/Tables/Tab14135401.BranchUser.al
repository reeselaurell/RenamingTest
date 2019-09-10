table 14135401 lvngBranchUser
{
    LookupPageId = lvngBranchUsers;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UserMgmt.ValidateUserID("User ID");
            end;

            trigger OnLookup()
            begin
                UserMgmt.LookupUserID("User ID");
            end;
        }
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
        field(100; "Show Loan Funding Report"; Boolean) { DataClassification = CustomerContent; }
        field(101; "Loan Level Report Schema Code"; Code[20]) { DataClassification = CustomerContent; }
        field(102; "Hide General Ledger"; Boolean) { DataClassification = CustomerContent; }
        field(103; "Hide KPI"; Boolean) { DataClassification = CustomerContent; }
        field(104; "Hide Performance Worksheet"; Boolean) { DataClassification = CustomerContent; }
        field(105; "Show Account Schedule"; Boolean) { DataClassification = CustomerContent; }
        field(200; "Show Corporate Tile"; Boolean) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "User ID") { Clustered = true; }
    }

    var
        UserMgmt: Codeunit "User Management";
}