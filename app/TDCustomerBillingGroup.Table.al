table 69100 "TD Customer Billing Group"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(3; "Billing Period"; DateFormula)
        {
            Caption = 'Billing Period';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}