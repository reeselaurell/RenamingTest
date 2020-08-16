tableextension 14135100 lvngGLEntry extends "G/L Entry"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; lvngShortcutDimension3Code; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(14135102; lvngShortcutDimension4Code; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(14135103; lvngShortcutDimension5Code; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(14135104; lvngShortcutDimension6Code; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(14135105; lvngShortcutDimension7Code; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(14135106; lvngShortcutDimension8Code; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(14135107; lvngEntryDate; Date) { Caption = 'Entry Date'; DataClassification = CustomerContent; }
        field(14135108; lvngServicingType; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135109; lvngSourceName; Text[50]) { Caption = 'Source Name'; DataClassification = CustomerContent; }
        field(14135110; lvngComment; Text[250]) { Caption = 'Comment'; DataClassification = CustomerContent; }
        field(14135150; lvngWarehouseLineCode; Code[50]) { Caption = 'Warehouse Line Code'; Editable = false; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Warehouse Line Code" where("No." = field(lvngLoanNo))); }
        field(14135151; lvngBorrowerSearchName; Code[100]) { Caption = 'Borrower Search Name'; Editable = false; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Search Name" where("No." = field(lvngLoanNo))); }
        field(14135220; lvngGlobalDimension1Name; Text[50]) { Caption = 'Global Dimension 1 Name'; CaptionClass = GetDimensionName(1); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(1), Code = field("Global Dimension 1 Code"))); }
        field(14135221; lvngGlobalDimension2Name; Text[50]) { Caption = 'Global Dimension 2 Name'; CaptionClass = GetDimensionName(2); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(2), Code = field("Global Dimension 2 Code"))); }
        field(14135222; lvngShortcutDimension3Name; Text[50]) { Caption = 'Shortcut Dimension 3 Name'; CaptionClass = GetDimensionName(3); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(3), Code = field(lvngShortcutDimension3Code))); }
        field(14135223; lvngShortcutDimension4Name; Text[50]) { Caption = 'Shortcut Dimension 4 Name'; CaptionClass = GetDimensionName(4); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(4), Code = field(lvngShortcutDimension4Code))); }
        field(14135224; lvngShortcutDimension5Name; Text[50]) { Caption = 'Shortcut Dimension 5 Name'; CaptionClass = GetDimensionName(5); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(5), Code = field(lvngShortcutDimension5Code))); }
        field(14135225; lvngShortcutDimension6Name; Text[50]) { Caption = 'Shortcut Dimension 6 Name'; CaptionClass = GetDimensionName(6); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(6), Code = field(lvngShortcutDimension6Code))); }
        field(14135226; lvngShortcutDimension7Name; Text[50]) { Caption = 'Shortcut Dimension 7 Name'; CaptionClass = GetDimensionName(7); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(7), Code = field(lvngShortcutDimension7Code))); }
        field(14135227; lvngShortcutDimension8Name; Text[50]) { Caption = 'Shortcut Dimension 8 Name'; CaptionClass = GetDimensionName(8); Editable = false; FieldClass = FlowField; CalcFormula = lookup ("Dimension Value".Name where("Global Dimension No." = const(8), Code = field(lvngShortcutDimension8Code))); }
        field(14135500; lvngImportID; Guid) { Caption = 'Import ID'; DataClassification = CustomerContent; }
        field(14135501; lvngVoided; Boolean) { Caption = 'Voided'; DataClassification = CustomerContent; }
        field(14135999; lvngDocumentGuid; Guid) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(LoanNo; lvngLoanNo) { }
        key(EntryDate; lvngEntryDate) { }
    }

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
        DimensionNames: array[8] of Text;
        DimensionNamesRetrieved: Boolean;

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvngDocumentGuid = EmptyGuid then
            lvngDocumentGuid := CreateGuid();
    end;

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