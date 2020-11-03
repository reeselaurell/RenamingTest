xmlport 14135108 "lvnPurchInvImport"
{
    Caption = 'Purchase Invoice Import';
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
                AutoUpdate = false;
                AutoSave = false;

                textelement(DocNo) { }
                textelement(PostingDate) { }
                textelement(VendorNo) { }
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
                    Loan: Record lvnLoan;
                    DimensionHierarchy: Record lvnDimensionHierarchy;
                    DimensionMgmt: Codeunit lvnDimensionsManagement;
                    DateHolder: Date;
                    MainDimensionNo: Integer;
                    DimensionUsage: array[5] of Boolean;
                    DimensionCode: Code[20];
                begin
                    if not PurchInvHdrBuffer.Get(DocNo) then begin
                        PurchInvHdrBuffer."No." := DocNo;
                        Evaluate(DateHolder, PostingDate);
                        PurchInvHdrBuffer."Posting Date" := DateHolder;
                        PurchInvHdrBuffer."Buy From Vendor No." := VendorNo;
                        Evaluate(DateHolder, DocumentDate);
                        PurchInvHdrBuffer."Document Date" := DateHolder;
                        PurchInvHdrBuffer."Payment Method Code" := PaymentMethodCode;
                        Evaluate(DateHolder, DueDate);
                        PurchInvHdrBuffer.Validate("Due Date", DateHolder);
                        PurchInvHdrBuffer."Posting Description" := PostingDescription;
                        PurchInvHdrBuffer.Insert();
                    end else begin
                        PurchInvHdrBuffer.Reset();
                        PurchInLineBuffer2.Reset();
                        PurchInLineBuffer2.SetRange("Document No.", DocNo);
                        if PurchInLineBuffer2.FindSet() then;
                        PurchInvLineBuffer."Line No." := PurchInLineBuffer2.Count * 10000 + 10000;
                        PurchInvLineBuffer."Document No." := DocNo;
                        PurchInvLineBuffer."Loan No." := LoanNo;
                        PurchInvLineBuffer."No." := GLAccountNo;
                        PurchInvLineBuffer.Validate(Description, CopyStr(LineDescription, 1, MaxStrLen(PurchInvLineBuffer.Description)));
                        PurchInvLineBuffer.Validate("Description 2", CopyStr(LineDescription, 51, MaxStrLen(PurchInvLineBuffer.Description)));
                        PurchInvLineBuffer."Loan No. Validation" := LoanNoValidation;
                        Evaluate(PurchInvLineBuffer."Direct Unit Cost", Amount);
                        PurchInvLineBuffer.Type := PurchInvLineBuffer.Type::"G/L Account";
                        case DimensionValidation of
                            DimensionValidation::"Dimensions from File":
                                begin
                                    PurchInvLineBuffer."Shortcut Dimension 1 Code" := Dimension1Code;
                                    PurchInvLineBuffer."Shortcut Dimension 2 Code" := Dimension2Code;
                                    PurchInvLineBuffer."Shortcut Dimension 3 Code" := Dimension3Code;
                                    PurchInvLineBuffer."Shortcut Dimension 4 Code" := Dimension4Code;
                                    PurchInvLineBuffer."Shortcut Dimension 5 Code" := Dimension5Code;
                                    PurchInvLineBuffer."Shortcut Dimension 6 Code" := Dimension6Code;
                                    PurchInvLineBuffer."Shortcut Dimension 7 Code" := Dimension7Code;
                                    PurchInvLineBuffer."Shortcut Dimension 8 Code" := Dimension8Code;
                                end;
                            DimensionValidation::"Dimensions from Loan":
                                begin
                                    if Loan.Get(LoanNo) then begin
                                        PurchInvLineBuffer."Shortcut Dimension 1 Code" := Loan."Global Dimension 1 Code";
                                        PurchInvLineBuffer."Shortcut Dimension 2 Code" := Loan."Global Dimension 2 Code";
                                        PurchInvLineBuffer."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
                                        PurchInvLineBuffer."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
                                        PurchInvLineBuffer."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
                                        PurchInvLineBuffer."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
                                        PurchInvLineBuffer."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
                                        PurchInvLineBuffer."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
                                    end else begin
                                        PurchInvLineBuffer."Shortcut Dimension 1 Code" := '';
                                        PurchInvLineBuffer."Shortcut Dimension 2 Code" := '';
                                        PurchInvLineBuffer."Shortcut Dimension 3 Code" := '';
                                        PurchInvLineBuffer."Shortcut Dimension 4 Code" := '';
                                        PurchInvLineBuffer."Shortcut Dimension 5 Code" := '';
                                        PurchInvLineBuffer."Shortcut Dimension 6 Code" := '';
                                        PurchInvLineBuffer."Shortcut Dimension 7 Code" := '';
                                        PurchInvLineBuffer."Shortcut Dimension 8 Code" := '';
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
                                    DimensionHierarchy.SetFilter(Date, '..%1', PurchInvHdrBuffer."Posting Date");
                                    DimensionHierarchy.SetRange(Code, DimensionCode);
                                    if DimensionHierarchy.FindFirst() then begin
                                        if DimensionUsage[1] then
                                            PurchInvLineBuffer."Shortcut Dimension 1 Code" := DimensionHierarchy."Global Dimension 1 Code";
                                        if DimensionUsage[2] then
                                            PurchInvLineBuffer."Shortcut Dimension 2 Code" := DimensionHierarchy."Global Dimension 2 Code";
                                        if DimensionUsage[3] then
                                            PurchInvLineBuffer."Shortcut Dimension 3 Code" := DimensionHierarchy."Shortcut Dimension 3 Code";
                                        if DimensionUsage[4] then
                                            PurchInvLineBuffer."Shortcut Dimension 4 Code" := DimensionHierarchy."Shortcut Dimension 4 Code";
                                        if DimensionUsage[5] then
                                            PurchInvLineBuffer."Business Unit Code" := DimensionHierarchy."Business Unit Code";
                                    end;
                                end;
                        end;
                        PurchInLineBuffer2 := PurchInvLineBuffer;
                        PurchInLineBuffer2.Insert();
                        PurchInvLineBuffer.Insert();
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
        PurchInvHdrBuffer: Record lvnPurchInvHdrBuffer;
        PurchInvLineBuffer: Record lvnPurchInvLineBuffer;
        PurchInLineBuffer2: Record lvnPurchInvLineBuffer;
        DimensionValidation: Option "Dimensions from File","Dimensions from Loan","From Dimension Hierarchy";
        LoanNoValidation: Enum lvnLoanNoValidationRule;

    trigger OnPreXmlPort()
    begin
        PurchInvHdrBuffer.Reset();
        PurchInvLineBuffer.Reset();
        PurchInvHdrBuffer.DeleteAll();
        PurchInvLineBuffer.DeleteAll();
    end;

    trigger OnPostXmlPort()
    var
        InvoiceErrorDetail: Record lvnInvoiceErrorDetail;
        PurchInvImportMgmt: Codeunit lvnPurchInvoiceImportMgmt;
        PurchInvoiceImportJnl: Page lvnPurchInvoiceImportJnl;
    begin
        PurchInvImportMgmt.GroupLines(PurchInvHdrBuffer, PurchInvLineBuffer);
        PurchInvImportMgmt.ValidateHeaderEntries(InvoiceErrorDetail, PurchInvHdrBuffer);
        PurchInvImportMgmt.ValidateLineEntries(InvoiceErrorDetail, PurchInvLineBuffer);
        PurchInvoiceImportJnl.SetHeaderBuffer(PurchInvHdrBuffer);
        PurchInvoiceImportJnl.SetLineBuffer(PurchInvLineBuffer);
        PurchInvoiceImportJnl.SetErrors(InvoiceErrorDetail);
        PurchInvoiceImportJnl.Run();
    end;
}