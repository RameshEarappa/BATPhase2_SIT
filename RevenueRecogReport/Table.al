table 50102 "Table Storage"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "File Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "File Extension"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Attached Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Content; Blob)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        Validate("Attached Date", CurrentDateTime);
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}