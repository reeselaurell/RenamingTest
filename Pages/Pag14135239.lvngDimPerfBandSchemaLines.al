page 14135239 lvngDimPerfBandSchemaLines
{
    PageType = List;
    SourceTable = lvngDimPerfBandSchemaLine;
    Caption = 'Dimension Performance Band Schema Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Band No."; "Band No.") { ApplicationArea = All; }
                field("Dimension Filter"; "Dimension Filter")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                    begin
                        DimensionValue.Reset();
                        DimensionValue.SetRange("Dimension Code", DimensionCode);
                        if Page.RunModal(Page::"Dimension Values", DimensionValue) = Action::LookupOK then begin
                            Text := DimensionValue.Code;
                            "Header Description" := DimensionValue.Name;
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Header Description"; "Header Description") { ApplicationArea = All; }
                field("Band Type"; "Band Type") { ApplicationArea = All; }
                field("Row Formula Code"; "Row Formula Code") { ApplicationArea = All; }
            }
        }
    }

    var
        DimensionCode: Code[20];

    procedure SetParams(DimCode: Code[20])
    begin
        DimensionCode := DimCode;
    end;
}