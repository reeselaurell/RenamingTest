page 14135100 "lvngLoanVisionSetup"
{

    PageType = Card;
    SourceTable = lvngLoanVisionSetup;
    Caption = 'Loan Vision Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(FundedReasonCode; lvngFundedReasonCode)
                {
                    ApplicationArea = All;
                }

                field(SoldReasonCode; lvngSoldReasonCode)
                {
                    ApplicationArea = All;
                }

                field(ServicedReasonCode; lvngServicedReasonCode)
                {
                    ApplicationArea = All;
                }

                field(lvngSearchNameTemplate; lvngSearchNameTemplate)
                {
                    ApplicationArea = All;
                    ToolTip = '%1 - First Name, %2 - Last Name, %3 - Middle Name';
                }

                field(MaintenanceMode; lvngMaintenanceMode)
                {
                    ApplicationArea = All;
                }

                field(lvngApplicationId; lvngApplicationId)
                {
                    Editable = false;
                    ApplicationArea = All;
                }

            }
            group(Dimensions)
            {
                group(GeneralDimensions)
                {
                    Caption = 'General';
                    field(CostCenter; lvngCostCenterDimensionCode)
                    {
                        ApplicationArea = All;
                    }

                    field(PropertyStateCode; lvngPropertyStateDimensionCode)
                    {
                        ApplicationArea = All;
                    }

                    field(LoanTypeCode; lvngLoanTypeDimensionCode)
                    {
                        ApplicationArea = All;
                    }

                    field(LoanOfficerCode; lvngLoanOfficerDimensionCode)
                    {
                        ApplicationArea = All;
                    }

                    field(LoanPurposeCode; lvngLoanPurposeDimensionCode)
                    {
                        ApplicationArea = All;
                    }
                }
                group(HierarchyLevelsGroup)
                {
                    Caption = 'Hierarchy Levels';

                    field(HierarchyLevels; lvngHierarchyLevels)
                    {
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel1; lvngLevel1)
                    {
                        Editable = lvngHierarchyLevels > 0;
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel2; lvngLevel2)
                    {
                        Editable = lvngHierarchyLevels > 1;
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel3; lvngLevel3)
                    {
                        Editable = lvngHierarchyLevels > 2;
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel4; lvngLevel4)
                    {
                        Editable = lvngHierarchyLevels > 3;
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel5; lvngLevel5)
                    {
                        Editable = lvngHierarchyLevels > 4;
                        ApplicationArea = All;
                    }
                }
            }
        }
        //You might want to add fields here

    }

    actions
    {
        area(Processing)
        {
            action(lvngAssignApplicationId)
            {
                Caption = 'Assign Application Id';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Evaluate(lvngApplicationId, ApplicationGuidLbl);
                    Modify();
                end;
            }
        }
    }

    var
        ApplicationGuidLbl: Label '{bed3dc2e-9757-4353-b184-fe5b7dae9fb4}';

    trigger OnOpenPage()
    begin
        InsertIfNotExists();
    end;

    local procedure InsertIfNotExists()
    begin
        reset;
        if not get then begin
            Init();
            EVALUATE(lvngApplicationId, ApplicationGuidLbl);
            Insert();
        end;
    end;

}
