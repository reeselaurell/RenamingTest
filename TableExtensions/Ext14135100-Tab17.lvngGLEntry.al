tableextension 14135100 lvngGLEntry extends "G/L Entry"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(14135102; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(14135103; "Shortcut Dimension 5 Code"; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(14135104; "Shortcut Dimension 6 Code"; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(14135105; "Shortcut Dimension 7 Code"; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(14135106; "Shortcut Dimension 8 Code"; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(14135107; "Entry Date"; Date) { Caption = 'Entry Date'; DataClassification = CustomerContent; }
        field(14135108; "Servicing Type"; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135109; "Source Name"; Text[50]) { }
        field(14135150; "Warehouse Line Code"; Code[50]) { Caption = 'Warehouse Line Code'; Editable = false; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Warehouse Line Code" where("No." = field("Loan No."))); }
        field(14135151; "Borrower Search Name"; Code[100]) { Caption = 'Borrower Search Name'; Editable = false; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Search Name" where("No." = field("Loan No."))); }
        field(14135220; "Global Dimension 1 Name"; Text[50]) { Caption = 'Global Dimension 1 Name'; CaptionClass = GetDimensionName(1); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(1), Code = field("Global Dimension 1 Code"))); }
        field(14135221; "Global Dimension 2 Name"; Text[50]) { Caption = 'Global Dimension 2 Name'; CaptionClass = GetDimensionName(2); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(2), Code = field("Global Dimension 2 Code"))); }
        field(14135222; "Shortcut Dimension 3 Name"; Text[50]) { Caption = 'Shortcut Dimension 3 Name'; CaptionClass = GetDimensionName(3); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(3), Code = field("Shortcut Dimension 3 Code"))); }
        field(14135223; "Shortcut Dimension 4 Name"; Text[50]) { Caption = 'Shortcut Dimension 4 Name'; CaptionClass = GetDimensionName(4); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(4), Code = field("Shortcut Dimension 4 Code"))); }
        field(14135224; "Shortcut Dimension 5 Name"; Text[50]) { Caption = 'Shortcut Dimension 5 Name'; CaptionClass = GetDimensionName(5); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(5), Code = field("Shortcut Dimension 5 Code"))); }
        field(14135225; "Shortcut Dimension 6 Name"; Text[50]) { Caption = 'Shortcut Dimension 6 Name'; CaptionClass = GetDimensionName(6); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(6), Code = field("Shortcut Dimension 6 Code"))); }
        field(14135226; "Shortcut Dimension 7 Name"; Text[50]) { Caption = 'Shortcut Dimension 7 Name'; CaptionClass = GetDimensionName(7); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(7), Code = field("Shortcut Dimension 7 Code"))); }
        field(14135227; "Shortcut Dimension 8 Name"; Text[50]) { Caption = 'Shortcut Dimension 8 Name'; CaptionClass = GetDimensionName(8); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(8), Code = field("Shortcut Dimension 8 Code"))); }
        field(14135500; "Import ID"; Guid) { Caption = 'Import ID'; DataClassification = CustomerContent; }
        field(14135501; Voided; Boolean) { Caption = 'Voided'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(LoanNo; "Loan No.") { }
    }

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
        DimensionNames: array[8] of Text;
        DimensionNamesRetrieved: Boolean;

    local procedure GetDimensionName(DimensionNo: Integer): Text
    var
        Dimension: Record Dimension;
        Idx: Integer;
    begin
        if not DimensionNamesRetrieved then begin
            for Idx := 1 to 8 do
                if Dimension.Get(GetGlobalDimensionNo(Idx)) then
                    DimensionNames[Idx] := Dimension.Name
                else
                    DimensionNames[Idx] := '';
            DimensionNamesRetrieved := true;
        end;
        exit(DimensionNames[DimensionNo]);
    end;

    local procedure GetGlobalDimensionNo(DimensionNo: Integer): Code[20]
    begin
        GetGLSetup();
        case DimensionNo of
            1:
                exit(GLSetup."Shortcut Dimension 1 Code");
            2:
                exit(GLSetup."Shortcut Dimension 2 Code");
            3:
                exit(GLSetup."Shortcut Dimension 3 Code");
            4:
                exit(GLSetup."Shortcut Dimension 4 Code");
            5:
                exit(GLSetup."Shortcut Dimension 5 Code");
            6:
                exit(GLSetup."Shortcut Dimension 6 Code");
            7:
                exit(GLSetup."Shortcut Dimension 7 Code");
            8:
                exit(GLSetup."Shortcut Dimension 8 Code");
        end;
        exit('');
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then begin
            GLSetup.Get();
            GLSetupRead := true;
        end;
    end;
}