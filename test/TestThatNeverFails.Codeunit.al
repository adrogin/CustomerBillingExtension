codeunit 69150 "Test That Never Fails"
{
    Description = 'This codeunit demonstrates incorrect tests that do not verify any application functionality';
    Subtype = Test;

    [Test]
    procedure AssignBillingPeriodCalcFormula()
    var
        Customer: Record Customer;
        PeriodDateFormula: DateFormula;
        DateFormulaTxt: Label '<%1D>', Comment = '%1 = No. of days', Locked = true;
    begin
        Evaluate(PeriodDateFormula, StrSubstNo(DateFormulaTxt, LibraryRandom.RandInt(10)));
        LibrarySales.CreateCustomer(Customer);

        Customer.Validate("TD Billing Period Date Calc.", PeriodDateFormula);

        Assert.AreEqual(
            PeriodDateFormula, Customer."TD Billing Period Date Calc.",
            StrSubstNo(UnexpectedFieldValueErr, Customer.FieldCaption("TD Billing Group Code"), Customer.TableCaption()));
    end;

    [Test]
    procedure AssignBillingPeriodCalcFormulaOnPage()
    var
        Customer: Record Customer;
        PeriodDateFormula: DateFormula;
        CustomerCard: TestPage "Customer Card";
        DateFormulaTxt: Label '<%1D>', Comment = '%1 = No. of days', Locked = true;
    begin
        Evaluate(PeriodDateFormula, StrSubstNo(DateFormulaTxt, LibraryRandom.RandInt(10)));

        LibrarySales.CreateCustomer(Customer);
        CustomerCard.OpenEdit();
        CustomerCard.GoToRecord(Customer);

        CustomerCard.TDBIllingPeriodDateCalc.SetValue(PeriodDateFormula);
        CustomerCard.Close();

        Customer.Find();
        Assert.AreEqual(
            PeriodDateFormula, Customer."TD Billing Period Date Calc.",
            StrSubstNo(UnexpectedFieldValueErr, Customer.FieldCaption("TD Billing Group Code"), Customer.TableCaption()));
    end;

    var
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";
        Assert: Codeunit Assert;
        UnexpectedFieldValueErr: Label 'Unexpected value of the field %1 in table %2',
            Comment = '%1 = Field caption; %2 = field caption';
}