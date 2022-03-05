page 69100 "Customer Billing Groups List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TD Customer Billing Group";

    layout
    {
        area(Content)
        {
            repeater(BillingGroup)
            {
                field(GroupCode; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Code of the billing group';
                }
                field(Piority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Default payment priority for the customers in this group';
                }
                field(BillingPeriod; Rec."Billing Period")
                {
                    ApplicationArea = ALl;
                    ToolTip = 'Default billing period calculation formula for the customers in this group';
                }
            }
        }
    }
}