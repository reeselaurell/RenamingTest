page 14135154 lvngServicingCrMemo
{
    Caption = 'Servicing Credit Memo';
    PageType = Document;
    SourceTable = lvngServiceHeader;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; "No.") { ApplicationArea = All; }
                field("Borrower Customer No."; "Borrower Customer No.") { ApplicationArea = All; }
                field("Loan No."; "Loan No.") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Due Date"; "Due Date") { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; }

                group(Dimensions)
                {
                    Caption = 'Dimensions';

                    field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                    field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                    field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { Importance = Additional; ApplicationArea = All; Visible = DimensionVisible3; }
                    field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { Importance = Additional; ApplicationArea = All; Visible = DimensionVisible4; }
                    field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { Importance = Additional; ApplicationArea = All; Visible = DimensionVisible5; }
                    field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { Importance = Additional; ApplicationArea = All; Visible = DimensionVisible6; }
                    field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { Importance = Additional; ApplicationArea = All; Visible = DimensionVisible7; }
                    field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { Importance = Additional; ApplicationArea = All; Visible = DimensionVisible8; }
                    field("Business Unit Code"; "Business Unit Code") { Importance = Additional; ApplicationArea = All; }
                }
            }

            part(ServicingCrMemoSubform; lvngServicingCrMemoSubform)
            {
                Caption = 'Lines';
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
                var
                    ImplMgmt: Codeunit lvngImplementationManagement;
                begin
                    ImplMgmt.ThrowNotImplementedError();
                end;
            }
        }
    }

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;
}