tableextension 14135101 lvngGenJnlLine extends "Gen. Journal Line"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; lvngSourceName; Text[50]) { Caption = 'Source Name'; DataClassification = CustomerContent; }
        field(14135108; lvngServicingType; enum lvngServicingType) { Caption = 'Servicing Type'; DataClassification = CustomerContent; }
        field(14135500; lvngImportID; Guid) { Caption = 'Import ID'; DataClassification = CustomerContent; }
        field(14135999; lvngDocumentGuid; Guid) { DataClassification = CustomerContent; }

        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                BankAccount: Record "Bank Account";
                Customer: Record Customer;
                Vendor: Record Vendor;
                GLAccount: Record "G/L Account";
                FixedAsset: Record "Fixed Asset";
            begin
                if Rec."Account No." = '' then
                    exit;
                case Rec."Account Type" of
                    Rec."Account Type"::"Bank Account":
                        begin
                            BankAccount.Get(Rec."Account No.");
                            Rec.lvngSourceName := CopyStr(BankAccount.Name, 1, MaxStrLen(Rec.lvngSourceName));
                        end;
                    Rec."Account Type"::Customer:
                        begin
                            Customer.Get(Rec."Account No.");
                            Rec.lvngSourceName := CopyStr(Customer.Name, 1, MaxStrLen(Rec.lvngSourceName));
                        end;
                    Rec."Account Type"::Vendor:
                        begin
                            Vendor.Get(Rec."Account No.");
                            Rec.lvngSourceName := CopyStr(Vendor.Name, 1, MaxStrLen(Rec.lvngSourceName));
                        end;
                    Rec."Account Type"::"G/L Account":
                        begin
                            GLAccount.Get(Rec."Account No.");
                            Rec.lvngSourceName := CopyStr(GLAccount.Name, 1, MaxStrLen(Rec.lvngSourceName));
                        end;
                    Rec."Account Type"::"Fixed Asset":
                        begin
                            FixedAsset.Get(Rec."Account No.");
                            Rec.lvngSourceName := CopyStr(FixedAsset.Description, 1, MaxStrLen(Rec.lvngSourceName));
                        end;
                end;
            end;
        }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvngDocumentGuid = EmptyGuid then
            lvngDocumentGuid := CreateGuid();
    end;
}