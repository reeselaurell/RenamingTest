table 14135305 "lvnCommissionProfile"
{
    Caption = 'Commission Profile';
    DataClassification = CustomerContent;
    DataCaptionFields = Code, Name;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            begin
                GetLoanVisionSetup();
                DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Code);
                Name := DimensionValue.Name;
                "Additional Code" := DimensionValue.lvnAdditionalCode;
            end;

            trigger OnLookup()
            begin
                GetLoanVisionSetup();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", LoanVisionSetup."Loan Officer Dimension Code");
                if Page.RunModal(Page::lvnLoanOfficerDimensions, DimensionValue) = Action::LookupOK then
                    Validate(Code, DimensionValue.Code);
            end;
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(11; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            begin
                GetLoanVisionSetup();
                DimensionValue.Get(LoanVisionSetup."Cost Center Dimension Code", "Cost Center Code");
            end;

            trigger OnLookup()
            begin
                GetLoanVisionSetup();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", LoanVisionSetup."Cost Center Dimension Code");
                if Page.RunModal(Page::"Dimension Value List", DimensionValue) = Action::LookupOK then
                    Validate("Cost Center Code", DimensionValue.Code);
            end;
        }
        field(12; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(13; "Default Accrual Dimensions"; Code[20])
        {
            Caption = 'Default Accrual Dimensions';
            DataClassification = CustomerContent;
            TableRelation = lvnAccrualRules;
        }
        field(14; "Additional Code"; Code[50])
        {
            Caption = 'Additional Code';
            DataClassification = CustomerContent;
        }
        field(500; "Debt Log Calculation"; Boolean)
        {
            Caption = 'Debt Log Calculation';
            DataClassification = CustomerContent;
        }
        field(501; "Minimum Advance"; Decimal)
        {
            Caption = 'Minimum Advance';
            DataClassification = CustomerContent;
        }
        field(502; "Max. Advance Balance"; Decimal)
        {
            Caption = 'Max. Advance Balance';
            DataClassification = CustomerContent;
        }
        field(503; "Debt Log LO Type"; Enum lvnDebtLogLOType)
        {
            Caption = 'Debt Log Loan Officer Type';
            DataClassification = CustomerContent;
        }
        field(504; "Max. Reduction Cap"; Decimal)
        {
            Caption = 'Max. Reduction Cap';
            DataClassification = CustomerContent;
        }
        field(505; "Commission Identifier Filter"; Code[250])
        {
            Caption = 'Commission Identifier Filter';
            DataClassification = CustomerContent;
        }
        field(506; "Current Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum(lvnDebtLogValueEntry.Amount where("Profile Code" = field(Code)));
        }
        field(2000; "Creation DateTime"; DateTime)
        {
            Caption = 'Creation Date/Time';
            DataClassification = CustomerContent;
        }
        field(2001; "Modification DateTime"; DateTime)
        {
            Caption = 'Modification Date/Time';
            DataClassification = CustomerContent;
        }
        field(2002; "Updated By"; Code[50])
        {
            Caption = 'Updated By';
            DataClassification = CustomerContent;
        }
        field(14135999; "Document GUID"; Guid)
        {
            Caption = 'Document GUID';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Name) { }
    }

    trigger OnInsert()
    begin
        "Creation DateTime" := CurrentDateTime;
        "Modification DateTime" := "Creation DateTime";
        "Updated By" := UserId;
    end;

    trigger OnModify()
    begin
        "Modification DateTime" := CurrentDateTime;
        "Updated By" := UserId;
    end;

    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        DimensionValue: Record "Dimension Value";
        LoanVisionSetupRetrieved: Boolean;

    local procedure GetLoanVisionSetup()
    var
        Dimension: Record Dimension;
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetup.Get();
            LoanVisionSetup.TestField("Loan Officer Dimension Code");
            Dimension.Get(LoanVisionSetup."Loan Officer Dimension Code");
            LoanVisionSetupRetrieved := true;
        end;
    end;
}