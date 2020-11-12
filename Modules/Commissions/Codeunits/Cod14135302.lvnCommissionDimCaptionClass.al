codeunit 14135302 lvnCommissionDimCaptionClass
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Caption Class", 'OnResolveCaptionClass', '', true, false)]
    local procedure OnResolveDimensionCaptionClass(
        CaptionArea: Text;
        CaptionExpr: Text;
        Language: Integer;
        var Caption: Text;
        var Resolved: Boolean)
    var
        AreaFieldType: Integer;
        CommaPosition: Integer;
        DimensionNo: Integer;
    begin
        case CaptionArea of
            '14135307':
                begin
                    CommaPosition := StrPos(CaptionExpr, ',');
                    Evaluate(AreaFieldType, CopyStr(CaptionExpr, 1, CommaPosition - 1));
                    Evaluate(DimensionNo, CopyStr(CaptionExpr, CommaPosition + 1));
                    case AreaFieldType of
                        1:
                            begin
                                Caption := GetAccrualOptionDimensionCaption(DimensionNo);
                                Resolved := true;
                            end;
                        2:
                            begin
                                Caption := GetDefaultDimensionCaption(DimensionNo);
                                Resolved := true;
                            end;
                    end;
                end;
        end;
    end;

    local procedure GetAccrualOptionDimensionCaption(DimensionNo: Integer): Text
    var
        DimensionsManagement: Codeunit lvnDimensionsManagement;
        DimensionNames: array[8] of Text;
        AccrualOptionLbl: Label '%1 Accrual Option';
    begin
        DimensionsManagement.GetDimensionNames(DimensionNames);
        exit(StrSubstNo(AccrualOptionLbl, DimensionNames[DimensionNo]));
    end;

    local procedure GetDefaultDimensionCaption(DimensionNo: Integer): Text
    var
        DimensionsManagement: Codeunit lvnDimensionsManagement;
        DimensionNames: array[8] of Text;
        DefaultDimensionLbl: Label 'Default %1';
    begin
        DimensionsManagement.GetDimensionNames(DimensionNames);
        exit(StrSubstNo(DefaultDimensionLbl, DimensionNames[DimensionNo]));
    end;
}