
/* since column annualsalary in the csv file [creditcardprofiledata] has dataype text hence to convert it into integer we need to replace "," with nospace */
 update creditcardprofiledata
set annualsalary=replace(annualsalary,",","")

                                                   /*QUESTION AND ANSWER ON BASIC AND COMPLEX JOINS*/


/* 1. Find the list of the applicants who are eligible for loan.
[Eligibility criteria: Must have credit history and income should be greater than 10,000] */
select lo.loan_id,cust.custID,cust.gender
from loan_data lo
inner join
customers cust
on lo.loan_id=cust.loan_id
where cust.Credit_History>="0" and cust.ApplicantIncome>'10000'


/* 2. Categorize the customers into “High Value Customer” and “Low Value Customer”.
[High value customer: Have credit history and income greater than 8000, else low value customer] */
select custid,gender,education,credit_history,applicantincome,if(credit_history>"0" and applicantincome>='8000',"high value customer","low value customer") as STATUS
from customers
order by custid asc


/* 3. Find the customers who neither have any credit history nor applied for a loan. */
SELECT LOAN_ID FROM  CUSTOMERS
WHERE LOAN_ID NOT IN (SELECT LOAN_ID FROM LOAN_DATA)



/* 4. List the customers who have dependents 0 credit history and rejected loans. */
SELECT CU.CUSTID,CU.GENDER,CU.DEPENDENTS,CU.CREDIT_HISTORY,LO.LOAN_STATUS
FROM CUSTOMERS CU
INNER JOIN
LOAN_DATA LO
ON CU.LOAN_ID=LO.LOAN_ID
WHERE CU.DEPENDENTS='1' AND CU.CREDIT_HISTORY='0' AND LO.LOAN_STATUS="N"


/*5 . Customers complete details along with the details of the loans they have applied for. */ 
SELECT CU.*,LO.*
FROM CUSTOMERS CU
INNER JOIN
LOAN_DATA LO
ON LO.LOAN_ID=CU.LOAN_ID


/* 6. Find the top 5 female and male customers in terms of the income. Also, show their ranks as a separate column. */
SET @RANK:=0

SELECT* FROM (
SELECT CUSTID,GENDER,APPLICANTINCOME,@RANK:=@RANK+1 AS RNK FROM CUSTOMERS
ORDER BY APPLICANTINCOME DESC ) AS TEMPTABLE
WHERE RNK<="5"


/* B) Create a new database import the following tables from CreditCard Profiling Dataset cc_profile, customer_region, region.
Once you have imported the tables, please answer the following business questions:

1. Customers names and the city they live in. */

SELECT CRE.NAME,REG.CITY
FROM CREDITCARDPROFILEDATA CRE
INNER JOIN
CUSTOMERS_REGION REG
ON CRE.CUSTID=REG.CUSTID

/* 2. Find the list of married customers from midwest and south regions. */
SELECT CRED.NAME,CRED.AGE,CRED.GENDER,REG.REGION
FROM CREDITCARDPROFILEDATA CRED
INNER JOIN
CUSTOMERS_REGION REG
ON CRED.CUSTID=REG.CUSTID 
WHERE REG.REGION IN("MIDWEST","SOUTH")
GROUP BY CRED.NAME


/*3. Find the region-wise list of customers, their age, and the fraud level. */
SELECT CRED.CUSTID,CRED.NAME,CRED.AGE,CUST.REGION,REG.FRAUD_LEVEL
FROM CREDITCARDPROFILEDATA CRED
INNER JOIN
CUSTOMERS_REGION CUST
ON CRED.CUSTID=CUST.CUSTID
JOIN REGION_DATA REG
ON CUST.REGION=REG.REGION


/*4 How many cities the customers live in? */
select count(city) from (
select city,count(city) from customers_region
group by city) as temptable


/*5. Show all the customers from MidWest if there are any female customers in MidWest with salary more than 700,000. */
select cred.name,cred.age,cred.gender,cred.annualsalary,cust.region 
from creditcardprofiledata cred
inner join
customers_region cust
on cred.custid=cust.custid 
where cred.gender="f" and cust.region="midwest" and cred.annualsalary>'700000'
order by cred.age asc


/* 6. List total number of customers in each city. */
select city,count(custid) as total_no_of_customers from customers_region
group by city


/*7. Show only those cities with at least 400 customers.*/
select * from (
select city,count(custid) as no_of_customers from customers_region
group by city) as temptable
where no_of_customers >= '400'


/* 8. List the top 5 cities with highest income customers. */
select cust.city,max(cred.annualsalary)
from creditcardprofiledata cred
inner join
customers_region cust
on cred.custid=cust.custid
group by city
order by max(cred.annualsalary) desc
limit 5 ;


/*9. List the average salary of female customers in different regions. Hint: Use Avg() function after grouping */
select cust.region,avg(cred.annualsalary) as AVERAGE_FEMALE_SALARY
from creditcardprofiledata cred
inner join
customers_region cust
on cred.custid=cust.custid
where cred.gender='f'
group by region
order by avg(cred.annualsalary) asc

/* 10. List the number of customers from each region and city. */
select region,city,count(custid) as no_of_customers from customers_region
group by region,city