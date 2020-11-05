tableextension 14135101 "lvnGenJnlLine" extends "Gen. Journal Line"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;
        }
        field(14135101; lvnSourceName; Text[50])
        {
            Caption = 'Source Name';
            DataClassification = CustomerContent;
        }
        field(14135108; lvnServicingType; enum lvnServicingType)
        {
            Caption = 'Servicing Type';
            DataClassification = CustomerContent;
        }
        field(14135500; lvnImportID; Guid)
        {
            Caption = 'Import ID';
            DataClassification = CustomerContent;
        }
        field(14135999; lvnDocumentGuid; Guid)
        {
            DataClassification = CustomerContent;
        }
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
                            Rec.lvnSourceName := CopyStr(BankAccount.Name, 1, MaxStrLen(Rec.lvnSourceName));
                        end;
                    Rec."Account Type"::Customer:
                        begin
                            Customer.Get(Rec."Account No.");
                            Rec.lvnSourceName := CopyStr(Customer.Name, 1, MaxStrLen(Rec.lvnSourceName));
                        end;
                    Rec."Account Type"::Vendor:
                        begin
                            Vendor.Get(Rec."Account No.");
                            Rec.lvnSourceName := CopyStr(Vendor.Name, 1, MaxStrLen(Rec.lvnSourceName));
                        end;
                    Rec."Account Type"::"G/L Account":
                        begin
                            GLAccount.Get(Rec."Account No.");
                            Rec.lvnSourceName := CopyStr(GLAccount.Name, 1, MaxStrLen(Rec.lvnSourceName));
                        end;
                    Rec."Account Type"::"Fixed Asset":
                        begin
                            FixedAsset.Get(Rec."Account No.");
                            Rec.lvnSourceName := CopyStr(FixedAsset.Description, 1, MaxStrLen(Rec.lvnSourceName));
                        end;
                end;
            end;
        }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvnDocumentGuid = EmptyGuid then
            lvnDocumentGuid := CreateGuid();
    end;
}