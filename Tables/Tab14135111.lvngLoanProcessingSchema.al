table 14135111 lvngLoanProcessingSchema
{
    Caption = 'Loan Processing Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvngLoanProcessingSchema;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(11; "No. Series"; Code[20]) { Caption = 'Document No. Series'; DataClassification = CustomerContent; TableRelation = "No. Series"; }
        field(12; "Global Schema"; Boolean) { DataClassification = CustomerContent; }
        field(13; "Use Global Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngLoanProcessingSchema.Code where("Global Schema" = const(true)); }
        field(14; "Document Type Option"; Enum lvngDocumentTypeOption) { DataClassification = CustomerContent; }
        field(80; "Global Dimension 1 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(81; "Global Dimension 2 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(88; "Business Unit Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(1000; "Dimension 1 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(1); DataClassification = CustomerContent; }
        field(1001; "Dimension 2 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(2); DataClassification = CustomerContent; }
        field(1002; "Dimension 3 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(3); DataClassification = CustomerContent; }
        field(1003; "Dimension 4 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(4); DataClassification = CustomerContent; }
        field(1004; "Dimension 5 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(5); DataClassification = CustomerContent; }
        field(1005; "Dimension 6 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(6); DataClassification = CustomerContent; }
        field(1006; "Dimension 7 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(7); DataClassification = CustomerContent; }
        field(1007; "Dimension 8 Rule"; enum lvngProcessingDimensionRule) { CaptionClass = GetRuleCaptionString(8); DataClassification = CustomerContent; }
        field(1008; "Business Unit Rule"; enum lvngProcessingDimensionRule) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    local procedure GetRuleCaptionString(Index: Integer): Text
    var
        DimensionsManagement: Codeunit lvngDimensionsManagement;
        DimensionNamesRetrieved: Boolean;
        DimensionNames: array[8] of Text;
    begin
        if (Index in [1 .. 8]) then begin
            if not DimensionNamesRetrieved then begin
                DimensionsManagement.GetDimensionNames(DimensionNames);
                DimensionNamesRetrieved := true;
            end;
            exit(StrSubstNo(RuleCaptionLbl, DimensionNames[Index]));
        end;
        exit('')
    end;

    var
        RuleCaptionLbl: Label '%1 Rule';
}