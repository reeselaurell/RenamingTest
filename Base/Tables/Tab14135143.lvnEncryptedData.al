table 14135143 "lvnEncryptedData"
{
    Caption = 'Encrypted Data';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Key"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Key';
        }
        field(2; Value; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
        }
    }

    keys
    {
        key(PK; "Key") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        "Key" := CreateGuid();
    end;

    procedure EncryptValue(SensitiveData: Text)
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        OStream: OutStream;
    begin
        if EncryptionManagement.IsEncryptionPossible() then
            SensitiveData := EncryptionManagement.Encrypt(SensitiveData);
        Value.CreateOutStream(OStream);
        OStream.Write(SensitiveData)
    end;

    procedure DecryptValue() SensitiveData: Text
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        IStream: InStream;
    begin
        CalcFields(Value);
        Value.CreateInStream(IStream);
        IStream.Read(SensitiveData);
        if EncryptionManagement.IsEncryptionPossible() then
            SensitiveData := EncryptionManagement.Decrypt(SensitiveData);
    end;
}