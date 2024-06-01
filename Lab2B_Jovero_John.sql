use DMIT1508_1222_Lab2B
go

--Requirement 1: Queries 
/*
a. (1 mark) What is the ward name (name_2) and councillor for each Ward in
Edmonton? You can use the EdmontonWard table to answer this question
*/
select 
	name_2 as 'Ward Name',
	councillor as 'Ward Councillor'
from EdmontonWard

/*
b. (1 mark) What is the number, name, and description of each neighbourhood
that contains the word beautiful in its description? Sort the results by the
neighbourhood name. You can use the EdmontonNeighbourhood table to
answer this question. 
*/
select
	neighbourhood_number,
	[name],
	[description]

from EdmontonNeighbourhood
where [description] like ('%beautiful%')
order by name asc 

/*
c. (1 mark) What is the averaged assessed value for a residential property in
Edmonton in the tax year of 2022? You can use the
EdmontonPropertyAssessment table to answer this question.
*/
select 
	AVG(assessed_value) as 'Averaged Assessed Value'
from EdmontonPropertyAssessment
where tax_year = 2022

/*
d. (1 mark) What is the total tax rate (Municipal + Education + Education
Requestion Allowance) in the tax year of 2022? You can use the
EdmontonPropertyTaxRate table to answer this question
*/
select
	'2022 Total Tax Rate' = sum(tax_rate) 
from EdmontonPropertyTaxRate
where tax_year = 2022


/*
e. (1 mark) How many payments were made on June 30, 2022? You can use the
EdmontonPropertyTaxPayment table to answer this question
*/
select
	COUNT(*) as 'Payment Count on June 30, 2022'

from EdmontonPropertyTaxPayment
where payment_date = '2022-06-30'

/*
f. (1 mark) What is the highest, lowest, and average payment amount in December
2022? You can use the EdmontonPropertyTaxPayment table to answer this
question
*/
select 
	MAX(payment_amount) as 'Highest Payment',
	MIN(payment_amount) as 'Lowest Payment',
	AVG(payment_amount) as 'Average Payment'

from EdmontonPropertyTaxPayment
where MONTH(payment_date) = 12 AND tax_year =2022

/*
g. (1 mark) For each tax year, what is the average assessed value for a residental
property? Sort the results descending by the year. You can use the
EdmontonPropertyAssessment table to answer this question.
*/
select
	tax_year,
	AVG(assessed_value) as 'Average Value'
from EdmontonPropertyAssessment
group by tax_year
order by tax_year desc

/*
h. (1 mark) How many properties are there in each neighbourhood that have more
than 5000 residental properties? Display the neighbourhood number and the count.
Sort the results descending by the count. You can use the EdmontonProperty table
to answer this question.
*/

select
	neighbourhood_number,
	COUNT(*) as 'Property Count'
from EdmontonProperty
group by neighbourhood_number
having COUNT(*) > 5000
order by neighbourhood_number desc


/*
i. (2 marks) What is the property address (house number and street name),
neighbourhood name, and assessed value for all houses in the neighbourood
of Windermere on the street name �171 STREET SW� and is between
$425000 and $450000. Sort the resultsing be the assessed value. You can
use the EdmontonProperty, EdmontonPropertyAssessment, and
EdmontonNeighbourhood tables to answer this question.
*/
select
	'Address' = ep.house_number + ' ' + ep.street_name,
	en.descriptive_name,
	epa.assessed_value
from EdmontonProperty as ep
	inner join EdmontonPropertyAssessment as epa on ep.account_number = epa.account_number
	inner join EdmontonNeighbourhood as en on ep.neighbourhood_number = en.neighbourhood_number
where epa.assessed_value in (
	select
		assessed_value 
	from EdmontonPropertyAssessment
	where assessed_value between 425000 and 450000
	) 
	AND ep.street_name like '%171 STREET SW%'
	AND en.descriptive_name like '%Windermere%'
order by epa.assessed_value,ep.house_number asc


/*
j. (2 marks) What is the account owners, account email, propery address (house
number and street name), legal description, neighbourhood name, and ward name
for account number 10002852 in the tax year of 2022? You can use the
EdmontonProperty, EdmontonPropertyAssessment,
EdmontonNeighbourhood, EdmontonWard and EdmontonPropertyOwner
tables to answer this question.
*/
select
	epo.account_owners,
	epo.email,
	ep.house_number + ' ' + ep.street_name as 'Property Address',
	ep.legal_description,
	en.descriptive_name,
	ew.name_2,
	epa.assessed_value

from EdmontonProperty as ep
	inner join EdmontonPropertyOwner as epo on ep.account_number = epo.account_number
	inner join EdmontonPropertyAssessment as epa on ep.account_number = epa.account_number
	inner join EdmontonNeighbourhood as en on ep.neighbourhood_number = en.neighbourhood_number
	inner join EdmontonWard as ew on en.ward_id = ew.ward_id

where ep.account_number = 10002852 AND epa.tax_year = 2022

/*
k. (2 marks) What is the lowest, average, and highest assessed value for each
neighhourhood? Show the neighbourhood descriptive name for each. Sort the
results by the neighbourhood descriptive name. You can use the
EdmontonProperty, EdmontonPropertyAssessment, and
EdmontonNeighbourhood tables to answer this question.
*/
select
	en.descriptive_name,
	MIN(epa.assessed_value) as 'Lowest Assessed Value',
	AVG(epa.assessed_value) as 'Average Assessed Value',
	MAX(epa.assessed_value) as 'Highest Assessed Value'

from EdmontonNeighbourhood as en
	inner join EdmontonProperty as ep on en.neighbourhood_number = ep.neighbourhood_number
	inner join EdmontonPropertyAssessment as epa on ep.account_number =epa.account_number
where epa.tax_year = 2022

group by en.descriptive_name
order by en.descriptive_name

/*
l. (2 marks) In the tax year of 2022, what is the property address (house
number and street name) and assessed value of the residental property with
the highest assessed value? You can use the EdmontonProperty and
EdmontonPropertyAssessment tables to answer this quest
*/
select
	epa.tax_year,
	ep.house_number + ' ' + ep.street_name as 'Property Address',
	epa.assessed_value

from EdmontonProperty as ep
	inner join EdmontonPropertyAssessment as epa on ep.account_number = epa.account_number

where ep.account_number = (
		Select 
			account_number
		from EdmontonPropertyAssessment 
		where assessed_value = (
			select
				MAX(assessed_value)
			from EdmontonPropertyAssessment
			where tax_year = 2022
		)
	) 
	AND epa.tax_year = 2022

/*
m. (2 marks) What is the neighbourhood number, descriptive neighbourhood
name, and property count for all neighhourhoods including neighbourhoods
that does not have any residential property? You can use the
EdmontonProperty and EdmontonNeighbourhood tables to answer this
question. 
*/
select
	en.neighbourhood_number,
	en.descriptive_name,
	count(ep.neighbourhood_number) as 'Neighborhood Count'
from EdmontonNeighbourhood as en
	left join EdmontonProperty as ep on en.neighbourhood_number = ep.neighbourhood_number
group by en.neighbourhood_number,en.descriptive_name
order by en.descriptive_name asc

/*
n. (5 marks) What is the property address (house number and street name),
assessed value, Municipal tax, Eduction tax, and Education Requisition
Allowance tax, and Total Tax for account number 10006194 in the tax year of
2022? You can use the EdmontonPropertyTaxRate, EdmontonProperty,
and EdmontonPropertyAssessment tables to answer this question. (Hint:
you may need use both joins and subqueries in the select list components to
answer this question.)
*/
select
	ep.house_number + ' ' +  ep.street_name as 'Property Address',
	epa.assessed_value,

	[MunicipalTax] = epa.assessed_value *
		(select tax_rate from EdmontonPropertyTaxRate 
			where tax_year = 2022 AND tax_rate_type = 'Municipal'),

	[Education] = epa.assessed_value *
		(select tax_rate from EdmontonPropertyTaxRate 
			where tax_year = 2022 AND tax_rate_type = 'Education'),

	[Education Requisition Allowance] = epa.assessed_value * 
		(select tax_rate from EdmontonPropertyTaxRate 
			where tax_year = 2022 AND tax_rate_type = 'Education Requisition Allowance'),

	[Total Tax] = epa.assessed_value *
		(select sum(tax_rate) from EdmontonPropertyTaxRate 
			where tax_year = 2022)

from EdmontonProperty as ep
	inner join EdmontonPropertyAssessment as epa on ep.account_number = epa.account_number
where ep.account_number = 10006194 and epa.tax_year = 2022


/*
o. (4 marks) What is the tax amount for each tax rate type including the total tax
for account number 10006194 in tax year 2022? You can use the
EdmontonPropertyTaxRate and EdmontonPropertyAssessment tables to
answer this question. (Hint: you may need to use a union operator and
subqueries in the select list components to answer this question.)
*/

select
	tax_rate_type,
	[Tax Amount] = tax_rate * 
		(Select assessed_value
		from EdmontonPropertyAssessment
		where account_number = 10006194 AND tax_year = 2022)
from EdmontonPropertyTaxRate
where tax_year = 2022

union

select
	'Total Tax',
	SUM(tax_rate) * (Select assessed_value
		from EdmontonPropertyAssessment
		where account_number = 10006194 AND tax_year = 2022)
from EdmontonPropertyTaxRate
where tax_year = 2022


--Requirement 2: Views
/*
a. (1 mark) Create a view called PropertyAssessmentHistory that will select
the account number, property address (as one column with house number
and street name), tax year, and assessed value. (2 marks)
*/
use DMIT1508_1222_Lab2B
go
create view  PropertyAssessmentHistory 
as
	select
		ep.account_number,
		[Address] = ep.house_number + ' ' + ep.street_name,
		epa.tax_year,
		epa.assessed_value
	from EdmontonProperty as ep
		inner join EdmontonPropertyAssessment as epa  on ep.account_number = epa.account_number


/*
b. (1 mark) Use the PropertyAssessmentHistory view to select the address,
tax year, and assessed value for account numbers 10007189, 10009253, and
10013055.
*/
select
	[Address],
	tax_year,
	assessed_value
from PropertyAssessmentHistory
where account_number in (10007189,10009253,10013055)


--Requirement 3: DML
/*
a. (2 marks) Insert the following record in the EdmontonPropertyAssessment
table given the following data.
*/

insert into EdmontonPropertyAssessment (account_number, tax_year, assessed_value)
values (9990687,
	2023, 
	1.10 * (select assessed_value
			from EdmontonPropertyAssessment
			where account_number = 9990687 and tax_year = 2022)
		)
--already tested

/*
b. (1 mark) Insert the following record in the EdmontonPropertyTaxPayment
table given the following data.
*/
--exec sp_help EdmontonPropertyTaxPayment 
insert into EdmontonPropertyTaxPayment (account_number, payment_amount, payment_date, tax_year)
values	
	(10015271, 199.88, '2023-03-01', 2022)
--already tested


/*
c. (2 marks) Update the payment balance in the EdmontonPropertyTaxNotice
table to subtract the payment amount of $199.98 that was made to account number
10015271 on 2023-03-01.
*/
update EdmontonPropertyTaxNotice 
set payment_balance = payment_due - (select payment_amount from EdmontonPropertyTaxPayment where account_number = 10015271 and payment_date = '2023-03-01')
where account_number = 10015271
--already tested

/*
(2 marks) Delete all neighbourhoods from the EdmontonNeighbourhood
table that does not have residential properties.
*/
delete from EdmontonNeighbourhood
where neighbourhood_number in (
	select 
		en.neighbourhood_number
	from EdmontonNeighbourhood as en
		left join EdmontonProperty as ep on en.neighbourhood_number = ep.neighbourhood_number
	group by en.neighbourhood_number
	having count(ep.neighbourhood_number) = 0
)
--already tested

