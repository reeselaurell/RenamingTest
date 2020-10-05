xmlport 14135109 lvngSalesInvImport
{
    Caption = 'Sales Invoice Import';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = '<TAB>';

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                SourceTableView = sorting(Number);
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;

                textelement(DocNo) { }
                textelement(PostingDate) { }
                textelement(CustomerNo) { }
                textelement(DocumentDate) { }
                textelement(PaymentMethodCode) { MinOccurs = Zero; }
                textelement(DueDate) { }
                textelement(PostingDescription) { MinOccurs = Zero; }
                textelement(LoanNo) { }
                textelement(GLAccountNo) { }
                textelement(LineDescription) { MinOccurs = Zero; }
                textelement(Amount) { }
                textelement(Dimension1Code) { MinOccurs = Zero; }
                textelement(Dimension2Code) { MinOccurs = Zero; }
                textelement(Dimension3Code) { MinOccurs = Zero; }
                textelement(Dimension4Code) { MinOccurs = Zero; }
                textelement(Dimension5Code) { MinOccurs = Zero; }
                textelement(Dimension6Code) { MinOccurs = Zero; }
                textelement(Dimension7Code) { MinOccurs = Zero; }
                textelement(Dimension8Code) { MinOccurs = Zero; }

                trigger OnBeforeInsertRecord()
                var
                    SalesInvLineBuffer2: Record lvngSalesInvLineBuffer;
                    Loan: Record lvngLoan;
                    DimensionHierarchy: Record lvngDimensionHierarchy;
                    GenLedgSetup: Record "General Ledger Setup";
                    DimensionMgmt: Codeunit lvngDimensionsManagement;
                    DateHolder: Date;
                    MainDimensionNo: Integer;
                    DimensionUsage: array[5] of Boolean;
                    DimensionCode: Code[20];
                begin
                    if not SalesInvHdrBuffer.Get(DocNo) then begin
                        SalesInvHdrBuffer."No." := DocNo;
                        Evaluate(DateHolder, PostingDate);
                        SalesInvHdrBuffer."Posting Date" := DateHolder;
                        SalesInvHdrBuffer."Sell-to Customer No." := CustomerNo;
                        Evaluate(DateHolder, DocumentDate);
                        SalesInvHdrBuffer."Document Date" := DateHolder;
                        SalesInvHdrBuffer."Payment Method Code" := PaymentMethodCode;
                        Evaluate(DateHolder, DueDate);
                        SalesInvHdrBuffer.Validate("Due Date", DateHolder);
                        SalesInvHdrBuffer."Posting Description" := PostingDescription;
                        SalesInvHdrBuffer.Insert();
                    end else begin
                        SalesInvHdrBuffer.Reset();
                        SalesInvLineBuffer2.Reset();
                        SalesInvLineBuffer2.SetRange("Document No.", DocNo);
                        if SalesInvLineBuffer2.FindSet() then;
                        SalesInvLineBuffer."Line No." := SalesInvLineBuffer2.Count * 10000 + 10000;
                        SalesInvLineBuffer."Document No." := DocNo;
                        SalesInvLineBuffer."Loan No." := LoanNo;
                        SalesInvLineBuffer."No." := GLAccountNo;
                        SalesInvLineBuffer.Validate(Description, CopyStr(LineDescription, 1, MaxStrLen(SalesInvLineBuffer.Description)));
                        SalesInvLineBuffer.Validate("Description 2", CopyStr(LineDescription, 51, MaxStrLen(SalesInvLineBuffer.Description)));
                        SalesInvLineBuffer."Loan No. Validation" := LoanNoValidation;
                        Evaluate(SalesInvLineBuffer."Unit Price", Amount);
                        SalesInvLineBuffer.Type := SalesInvLineBuffer.Type::"G/L Account";
                        case DimensionValidation of
                            DimensionValidation::"Dimensions from File":
                                begin
                                    SalesInvLineBuffer."Shortcut Dimension 1 Code" := Dimension1Code;
                                    SalesInvLineBuffer."Shortcut Dimension 2 Code" := Dimension2Code;
                                    SalesInvLineBuffer."Shortcut Dimension 3 Code" := Dimension3Code;
                                    SalesInvLineBuffer."Shortcut Dimension 4 Code" := Dimension4Code;
                                    SalesInvLineBuffer."Shortcut Dimension 5 Code" := Dimension5Code;
                                    SalesInvLineBuffer."Shortcut Dimension 6 Code" := Dimension6Code;
                                    SalesInvLineBuffer."Shortcut Dimension 7 Code" := Dimension7Code;
                                    SalesInvLineBuffer."Shortcut Dimension 8 Code" := Dimension8Code;
                                end;
                            DimensionValidation::"Dimensions from Loan":
                                begin
                                    if Loan.Get(LoanNo) then begin
                                        SalesInvLineBuffer."Shortcut Dimension 1 Code" := Loan."Global Dimension 1 Code";
                                        SalesInvLineBuffer."Shortcut Dimension 2 Code" := Loan."Global Dimension 2 Code";
                                        SalesInvLineBuffer."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
                                        SalesInvLineBuffer."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
                                        SalesInvLineBuffer."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
                                        SalesInvLineBuffer."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
                                        SalesInvLineBuffer."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
                                        SalesInvLineBuffer."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
                                    end else begin
                                        SalesInvLineBuffer."Shortcut Dimension 1 Code" := '';
                                        SalesInvLineBuffer."Shortcut Dimension 2 Code" := '';
                                        SalesInvLineBuffer."Shortcut Dimension 3 Code" := '';
                                        SalesInvLineBuffer."Shortcut Dimension 4 Code" := '';
                                        SalesInvLineBuffer."Shortcut Dimension 5 Code" := '';
                                        SalesInvLineBuffer."Shortcut Dimension 6 Code" := '';
                                        SalesInvLineBuffer."Shortcut Dimension 7 Code" := '';
                                        SalesInvLineBuffer."Shortcut Dimension 8 Code" := '';
                                    end;
                                end;
                            DimensionValidation::"From Dimension Hierarchy":
                                begin
                                    MainDimensionNo := DimensionMgmt.GetMainHierarchyDimensionNo();
                                    DimensionMgmt.GetHierarchyDimensionsUsage(DimensionUsage);
                                    case MainDimensionNo of
                                        1:
                                            DimensionCode := Dimension1Code;
                                        2:
                                            DimensionCode := Dimension2Code;
                                        3:
                                            DimensionCode := Dimension3Code;
                                        4:
                                            DimensionCode := Dimension4Code;
                                    end;
                                    DimensionHierarchy.Reset();
                                    DimensionHierarchy.Ascending(false);
                                    DimensionHierarchy.SetFilter(Date, '..%1', SalesInvHdrBuffer."Posting Date");
                                    DimensionHierarchy.SetRange(Code, DimensionCode);
                                    if DimensionHierarchy.FindFirst() then begin
                                        if DimensionUsage[1] then
                                            SalesInvLineBuffer."Shortcut Dimension 1 Code" := DimensionHierarchy."Global Dimension 1 Code";
                                        if DimensionUsage[2] then
                                            SalesInvLineBuffer."Shortcut Dimension 2 Code" := DimensionHierarchy."Global Dimension 2 Code";
                                        if DimensionUsage[3] then
                                            SalesInvLineBuffer."Shortcut Dimension 3 Code" := DimensionHierarchy."Shortcut Dimension 3 Code";
                                        if DimensionUsage[4] then
                                            SalesInvLineBuffer."Shortcut Dimension 4 Code" := DimensionHierarchy."Shortcut Dimension 4 Code";
                                        if DimensionUsage[5] then
                                            SalesInvLineBuffer."Business Unit Code" := DimensionHierarchy."Business Unit Code";
                                    end;
                                end;
                        end;
                        SalesInvLineBuffer.Insert();
                    end;
                    Dimension1Code := '';
                    Dimension2Code := '';
                    Dimension3Code := '';
                    Dimension4Code := '';
                    Dimension5Code := '';
                    Dimension6Code := '';
                    Dimension7Code := '';
                    Dimension8Code := '';
                    LineDescription := '';
                    PaymentMethodCode := '';
                    PostingDescription := '';
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(DimensionValidation; DimensionValidation) { Caption = 'Dimension Valitation'; ApplicationArea = All; }
                    field(LoanNoValidation; LoanNoValidation) { Caption = 'Loan No. Validation'; ApplicationArea = All; }
                }
            }
        }
    }

    var
        SalesInvHdrBuffer: Record lvngSalesInvHdrBuffer;
        SalesInvLineBuffer: Record lvngSalesInvLineBuffer;
        DimensionValidation: Option "Dimensions from File","Dimensions from Loan","From Dimension Hierarchy";
        LoanNoValidation: Enum lvngLoanNoValidationRule;

    trigger OnPreXmlPort()
    begin
        SalesInvHdrBuffer.Reset();
        SalesInvLineBuffer.Reset();
        SalesInvHdrBuffer.DeleteAll();
        SalesInvLineBuffer.DeleteAll();
    end;

    trigger OnPostXmlPort()
    var
        InvoiceErrorDetail: Record lvngInvoiceErrorDetail;
        SalesInvImportMgmt: Codeunit lvngSalesInvoiceImportMgmt;
    begin
        SalesInvImportMgmt.GroupLines();
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.DeleteAll();
        SalesInvImportMgmt.ValidateHeaderEntries();
        SalesInvImportMgmt.ValidateLineEntries();
    end;
}