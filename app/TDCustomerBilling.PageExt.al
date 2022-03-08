pageextension 69100 "TD Customer Billing" extends "Customer Card"
{
    layout
    {
        addlast(Invoicing)
        {
            field(TDBIllingPeriodDateCalc; Rec."TD BIlling Period Date Calc.")
            {
                ApplicationArea = All;
                ToolTip = 'Date formula applied to the document date to calculate the billing date';
            }
            field(TDBillingGroupCode; Rec."TD Billing Group Code")
            {
                ApplicationArea = All;
                ToolTip = 'Code of the billing group that defines default billing parameters for the customer';
            }
        }
    }
}