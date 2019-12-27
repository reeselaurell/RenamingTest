table 14135230 lvngNumberFormat
{
    DataClassification = CustomerContent;
    LookupPageId = lvngNumberFormatList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { }
        field(11; "Value Type"; Enum lvngPerformanceValueType) { DataClassification = CustomerContent; }
        field(12; Rounding; Enum lvngRounding) { DataClassification = CustomerContent; }
        field(13; "Blank Zero"; Enum lvngBlankZero) { DataClassification = SystemMetadata; }
        field(14; "Negative Formatting"; Enum lvngNegativeFormatting) { DataClassification = CustomerContent; }
        field(15; "Suppress Thousand Separator"; Boolean) { DataClassification = CustomerContent; }
        field(16; "Invert Sign"; Boolean) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    procedure FormatValue(NumericValue: Decimal) TextValue: Text
    begin
        if NumericValue = 0 then
            case "Blank Zero" of
                "Blank Zero"::Zero:
                    exit('0');
                "Blank Zero"::Dash:
                    exit('-');
                "Blank Zero"::Blank:
                    exit('&nbsp;');
            end;
        if "Invert Sign" then
            NumericValue := -NumericValue;
        if (NumericValue < 0) and ("Negative Formatting" = "Negative Formatting"::"Suppress Sign") then
            NumericValue := Abs(NumericValue);
        case Rounding of
            Rounding::Two:
                NumericValue := Round(NumericValue, 0.01);
            Rounding::One:
                NumericValue := Round(NumericValue, 0.1);
            Rounding::Round:
                NumericValue := Round(NumericValue, 1);
            Rounding::Thousands:
                NumericValue := Round(NumericValue, 1000);
        end;
        if "Suppress Thousand Separator" then
            TextValue := Format(NumericValue, 0, 9)
        else
            TextValue := Format(NumericValue);
        case "Value Type" of
            "Value Type"::Currency:
                TextValue := '$' + TextValue;
            "Value Type"::Percentage:
                TextValue := TextValue + '%';
        end;
        if "Negative Formatting" = "Negative Formatting"::Parenthesis then
            if NumericValue < 0 then
                TextValue := '(' + TextValue + ')'
            else
                TextValue := '&nbsp;' + TextValue + '&nbsp;';
    end;
}