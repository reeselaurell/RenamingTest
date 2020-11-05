page 14135140 "lvnGenJnlImportSchema"
{
    PageType = Card;
    SourceTable = lvnFileImportSchema;
    Caption = 'General Journal Import';

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

                    field("Gen. Jnl. Account Type"; Rec."Gen. Jnl. Account Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Account Mapping Type"; Rec."Account Mapping Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Default Account No."; Rec."Default Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Subs. G/L With Bank Acc."; Rec."Subs. G/L With Bank Acc.")
                    {
                        ApplicationArea = All;
                    }
                    field("Use Bal. Account"; Rec."Use Bal. Account")
                    {
                        ApplicationArea = All;
                    }
                    field("Gen. Jnl. Bal. Account Type"; Rec."Gen. Jnl. Bal. Account Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Bal. Account Mapping Type"; Rec."Bal. Account Mapping Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Default Bal. Account No."; Rec."Default Bal. Account No.")
                    {
                        ApplicationArea = All;
                    }
                }
                group(DocumentNo)
                {
                    Caption = 'Document No. Management';

                    field("Document Type"; Rec."Document Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Document Type Option"; Rec."Document Type Option")
                    {
                        ApplicationArea = All;
                    }
                    field("Document No. Series"; Rec."Document No. Series")
                    {
                        ApplicationArea = All;
                    }
                    field("Document No. Filling"; Rec."Document No. Filling")
                    {
                        ApplicationArea = All;
                    }
                    field("Document No. Prefix"; Rec."Document No. Prefix")
                    {
                        ApplicationArea = All;
                    }
                    field("Use Single Document No."; Rec."Use Single Document No.")
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
                    field("Posting Group"; Rec."Posting Group")
                    {
                        ApplicationArea = All;
                    }
                    field("Bank Payment Type"; Rec."Bank Payment Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Applies-To Doc. Type"; Rec."Applies-To Doc. Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Reverse Amount Sign"; Rec."Reverse Amount Sign")
                    {
                        ApplicationArea = All;
                    }
                }
                group(RecurringJournal)
                {
                    Caption = 'Recurring Journal';

                    field("Recurring Method"; Rec."Recurring Method")
                    {
                        ApplicationArea = All;
                    }
                    field("Recurring Frequency"; Rec."Recurring Frequency")
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
            part(GenJnlImportSchemaLines; lvnGenJnlImportSchemaLines)
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