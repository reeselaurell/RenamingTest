table 14135305 "lvngCommissionProfile"
{
    Caption = 'Commission Profile';
    DataClassification = CustomerContent;
    DataCaptionFields = lvngCode, lvngName;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            begin
                GetLoanVisionSetup();
                DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", lvngCode);
                lvngName := DimensionValue.Name;
            end;

            trigger OnLookup()
            begin
                GetLoanVisionSetup();
                DimensionValue.reset;
                DimensionValue.SetRange("Dimension Code", LoanVisionSetup."Loan Officer Dimension Code");
                if Page.RunModal(page::lvngLoanOfficerDimensions, DimensionValue) = Action::LookupOK then begin
                    Validate(lvngCode, DimensionValue.Code);
                end;
            end;
        }

        field(10; lvngName; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(11; lvngCostCenterCode; Code[20])
        {
            Caption = 'Cost Center Code';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            begin
                GetLoanVisionSetup();
                DimensionValue.Get(LoanVisionSetup."Cost Center Dimension Code", lvngCostCenterCode);
            end;

            trigger OnLookup()
            begin
                GetLoanVisionSetup();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", LoanVisionSetup."Cost Center Dimension Code");
                if Page.RunModal(page::"Dimension Value List", DimensionValue) = Action::LookupOK then begin
                    Validate(lvngCostCenterCode, DimensionValue.Code);
                end;
            end;
        }
        field(12; lvngBlocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(13; lvngDefaultAccrualDimensions; Code[20])
        {
            Caption = 'Default Acctual Dimensions';
            DataClassification = CustomerContent;
            TableRelation = lvngAccrualRules;
        }

        field(2000; lvngCreationTimestamp; DateTime)
        {
            Caption = 'Creation Date/Time';
            DataClassification = CustomerContent;
        }
        field(2001; lvngModificationTimestamp; DateTime)
        {
            Caption = 'Modification Date/Time';
            DataClassification = CustomerContent;
        }
        field(2002; lvngUpdatedBy; Code[50])
        {
            Caption = 'Updated By';
            DataClassification = CustomerContent;
        }

    }


    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; lvngCode, lvngName) { }
    }

    var
        LoanVisionSetup: Record lvngLoanVisionSetup;

        DimensionValue: Record "Dimension Value";
        lvngLoanVisionSetupRetrieved: Boolean;

    trigger OnInsert()
    begin
        lvngCreationTimestamp := CurrentDateTime;
        lvngUpdatedBy := UserId;
    end;

    trigger OnModify()
    begin
        lvngModificationTimestamp := CurrentDateTime;
        lvngUpdatedBy := UserId;
    end;

    local procedure GetLoanVisionSetup()
    var
        Dimension: Record Dimension;
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            LoanVisionSetup.Get();
            LoanVisionSetup.TestField("Loan Officer Dimension Code");
            Dimension.Get(LoanVisionSetup."Loan Officer Dimension Code");
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

}