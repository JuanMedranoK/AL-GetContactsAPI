table 50120 "JK API Contacts"
{
    Caption = 'Contacts';
    DataClassification = ToBeClassified;

    fields
    {
        field(50120; "Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(50121; "LastName"; Text[100])
        {
            Caption = 'LastName';
        }
        field(50122; "Phone"; Integer)
        {
            Caption = 'Phone';
        }
        field(50124; "Phone Text"; Text[50])
        {
            Caption = 'Phone';
        }
        field(50123; "ID"; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}
