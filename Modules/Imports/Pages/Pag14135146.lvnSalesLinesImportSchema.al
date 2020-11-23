page 14135146 "lvnSalesLinesImportSchema"
{
    PageType = Card;
    SourceTable = lvnFileImportSchema;
    Caption = 'Sales Journal Import';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                group(Accounts)
                {
                    Caption = 'Accounts Management';

                    field("Account Mapping Type"; Rec."Account Mapping Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Default Account No."; Rec."Default Account No.")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Misc)
                {
                    Caption = 'Misc.';

                    field("Reason Code"; Rec."Reason Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Loan No. Validation Rule"; Rec."Loan No. Validation Rule")
                    {
                        ApplicationArea = All;
                    }
                    field("Reverse Amount Sign"; Rec."Reverse Amount Sign")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';

                field("Dimension Validation Rule"; Rec."Dimension Validation Rule")
                {
                    ApplicationArea = All;
                }
                field("Use Dimension Hierarchy"; Rec."Use Dimension Hierarchy")
                {
                    ApplicationArea = All;
                }
                field("Dimension 1 Mapping Type"; Rec."Dimension 1 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field("Dimension 1 Mandatory"; Rec."Dimension 1 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field("Default Dimension 1 Code"; Rec."Default Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field("Dimension 2 Mapping Type"; Rec."Dimension 2 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field("Dimension 2 Mandatory"; Rec."Dimension 2 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field("Default Dimension 2 Code"; Rec."Default Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field("Dimension 3 Mapping Type"; Rec."Dimension 3 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field("Dimension 3 Mandatory"; Rec."Dimension 3 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field("Default Dimension 3 Code"; Rec."Default Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field("Dimension 4 Mapping Type"; Rec."Dimension 4 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field("Dimension 4 Mandatory"; Rec."Dimension 4 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field("Default Dimension 4 Code"; Rec."Default Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field("Dimension 5 Mapping Type"; Rec."Dimension 5 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field("Dimension 5 Mandatory"; Rec."Dimension 5 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field("Default Dimension 5 Code"; Rec."Default Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field("Dimension 6 Mapping Type"; Rec."Dimension 6 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field("Dimension 6 Mandatory"; Rec."Dimension 6 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field("Default Dimension 6 Code"; Rec."Default Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field("Dimension 7 Mapping Type"; Rec."Dimension 7 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field("Dimension 7 Mandatory"; Rec."Dimension 7 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field("Default Dimension 7 Code"; Rec."Default Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field("Dimension 8 Mapping Type"; Rec."Dimension 8 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field("Dimension 8 Mandatory"; Rec."Dimension 8 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field("Default Dimension 8 Code"; Rec."Default Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
            }
            part(SalesImportSchemaLines; lvnSalesImportSchemaLines)
            {
                Caption = 'Columns Mapping';
                SubPageLink = Code = field(Code);
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}