table 14135403 lvngBranchUserMapping
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            NotBlank = true;
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;

        }
        field(2; Type; Option)
        {
            OptionMembers = ,"Level 1","Level 2","Level 3","Level 4","Level 5";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if xRec.Type <> Type then
                    Code := '';
            end;
        }
        field(3; Code; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                BusinessUnit: Record "Business Unit";
                DimensionValue: Record "Dimension Value";
                HierarchyLevel: Enum lvngHierarchyLevels;
            begin
                RetrieveMetricLookup();
                if LevelMetricLookup[Type] = HierarchyLevel::lvngBusinessUnit then begin
                    BusinessUnit.Reset();
                    if Page.RunModal(0, BusinessUnit) = Action::LookupOK then
                        Code := BusinessUnit.Code;
                end else begin
                    DimensionValue.Reset();
                    DimensionValue.SetRange("Global Dimension No.", LevelMetricLookup[Type].AsInteger());
                    if Page.RunModal(0, DimensionValue) = Action::LookupOK then
                        Code := DimensionValue.Code;
                end;
            end;
        }
        field(10; Sequence; Integer) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "User ID", Type, Code) { Clustered = true; }
        key(Sequence; Sequence) { }
    }

    var
        LevelMetricLookup: array[5] of Enum lvngHierarchyLevels;
        LevelMetricRetrieved: Boolean;

    local procedure RetrieveMetricLookup()
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
    begin
        if not LevelMetricRetrieved then begin
            LevelMetricRetrieved := true;
            LoanVisionSetup.Get();
            LevelMetricLookup[1] := LoanVisionSetup."Level 1";
            LevelMetricLookup[2] := LoanVisionSetup."Level 2";
            LevelMetricLookup[3] := LoanVisionSetup."Level 3";
            LevelMetricLookup[4] := LoanVisionSetup."Level 4";
            LevelMetricLookup[5] := LoanVisionSetup."Level 5";
        end;
    end;
}