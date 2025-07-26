DROP table if exists Zepto;

CREATE TABLE ZEPTO(
sku_id serial PRIMARY KEY,
Category VARCHAR(120),
name varchar(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

select * from zepto
LIMIT 10;

-- null values

select * from zepto
where name is NULL
OR
CATEGORY IS NULL
OR
mrp IS NULL
OR
DISCOUNTPERCENT IS NULL
OR
AVAILABLEQUANTITY IS NULL
OR
DISCOUNTEDSELLINGPRICE IS NULL
OR
WEIGHTINGMS IS NULL
OR
OUTOFSTOCK IS NULL
OR
QUANTITY IS NULL;

--DIFFERENT PRODUCT CATEGORY
SELECT DISTINCT CATEGORY
FROM ZEPTO
ORDER BY CATEGORY;

--PRODUCTS IN STOCK VS OUT OF STOCK
SELECT outofstock, count(sku_id)
from zepto
group by outofstock;

--product names present multiple times
select name, count(sku_id) as "number of SKUs"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) DESC;

--DATA CLEANING

--products with price = 0
select * from zepto
where mrp=0 or discountedSellingPrice=0;

DELETE FROM ZEPTO
WHERE MRP=0;

--CONVERT PAISE TO RUPEE
UPDATE ZEPTO SET MRP = MRP/100.0,
DISCOUNTEDSELLINGPRICE = DISCOUNTEDSELLINGPRICE/100.0;

SELECT MRP,DISCOUNTEDSELLINGPRICE FROM ZEPTO;

--Q1. Find the top 10 best-value products based on the discount percentage.
select distinct(name), mrp,discountpercent
from zepto
order by discountpercent desc
limit 10;

--Q2. what are the products with high mrp but out of stock

select distinct(name), mrp from zepto
where outofstock = True and mrp>300
order by mrp desc;

--Q3. calculate estimated revenue for each category
select category, sum(discountedsellingprice * availablequantity) as total_revenue
from zepto
group by category
order by total_revenue;

--Q4. find all products where mrp is greater than 500 and discount is less than 10%
select distinct name, mrp, discountPercent
from zepto
where mrp>500 and discountpercent<10
order by mrp desc, discountpercent DESC;

--Q5. identify the top 5 categories offering the highest average discount percentage.
select category, round(avg(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--Q6. find the price per gram for products above 100 gm and sort by best value.
select distinct name, weightingms, discountedsellingprice, 
round(discountsellingprice/weightingms,2) as price_per_gram
from zepto
where weightingms >= 100
order by price_pe_gram;

--Q7. group the products into categories like low, medium, bulk.
select distinct name, weightingms,
case when weightingms < 1000 then 'low'
when weightingms < 5000 then 'medium'
else 'bulk'
end as weight_categories
from zepto;

--Q8. what is the total inventory weight per category.
select category,
sum(weightingms * availablequantity) as total_weight
from zepto
group by category
order by total_weight;

--Q9.  Identify the top 10 products with the largest absolute discount in Rupees.
select name,mrp, discountedsellingprice,
       (mrp - discountedsellingprice) as absolute_discount
from zepto
order by absolute_discount DESC
limit 10;

--Q10. What is the average product weight per category?
select category, round(avg(weightingms),2) as avg_product_weight
from zepto
group by category
order by avg_product_weight desc;

