page 14135153 "lvnPostedServicingCrMemo"
{
    Caption = 'Posted Servicing Credit Memo';
    PageType = Document;
    SourceTable = lvnServiceHeader;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Borrower Customer No."; Rec."Borrower Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';

                    field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible1;
                    }
                    field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible2;
                    }
                    field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible3;
                    }
                    field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible4;
                    }
                    field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible5;
                    }
                    field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible6;
                    }
                    field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible7;
                    }
                    field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                        Visible = DimensionVisible8;
                    }
                    field("Business Unit Code"; Rec."Business Unit Code")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                }
            }
            part(ServicingCrMemoSubform; lvnPostedServCrMemoSubform)
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Servicing Document Type" = field("Servicing Document Type"), "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Error('Not Implemented');
                end;
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