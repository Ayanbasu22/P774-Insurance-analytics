use Airlines;
show tables;
select * from maindata;
select count(*) as Total_Records from maindata;
CREATE TABLE calender (
    Datefield DATE,
    Year INT,
    Day INT,
    Month INT,
    Week INT,
    MonthName VARCHAR(50),
    Weekday INT,
    YearMonth VARCHAR(50),
    DayName VARCHAR(50),
    Quarters VARCHAR(50),
    Financial_Month VARCHAR(50),
    Financial_Quarter VARCHAR(50)
);
desc calender;

INSERT INTO calender (Datefield, Year, Day, Month, Week, MonthName, Weekday, YearMonth, DayName, Quarters, Financial_Month, Financial_Quarter)
SELECT 
    Date_column AS Datefield,
    YEAR(Date_column) AS Year,
    DAY(Date_column) AS Day,
    MONTH(Date_column) AS Month,
    WEEK(Date_column) AS Week,
    MONTHNAME(Date_column) AS MonthName,
    WEEKDAY(Date_column) AS Weekday, -- In MySQL, WEEKDAY() returns 0 (Monday) to 6 (Sunday)
    CONCAT(YEAR(Date_column), '-', MONTHNAME(Date_column)) AS YearMonth,
    DAYNAME(Date_column) AS DayName,

    
    CASE 
        WHEN MONTH(Date_column) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(Date_column) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(Date_column) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4' 
    END AS Quarters,

    CASE 
        WHEN MONTH(Date_column) = 1 THEN 'FM10'
        WHEN MONTH(Date_column) = 2 THEN 'FM11'
        WHEN MONTH(Date_column) = 3 THEN 'FM12'
        WHEN MONTH(Date_column) = 4 THEN 'FM1'
        WHEN MONTH(Date_column) = 5 THEN 'FM2'
        WHEN MONTH(Date_column) = 6 THEN 'FM3'
        WHEN MONTH(Date_column) = 7 THEN 'FM4'
        WHEN MONTH(Date_column) = 8 THEN 'FM5'
        WHEN MONTH(Date_column) = 9 THEN 'FM6'
        WHEN MONTH(Date_column) = 10 THEN 'FM7'
        WHEN MONTH(Date_column) = 11 THEN 'FM8'
        ELSE 'FM9' 
    END AS Financial_Month,

    CASE 
        WHEN MONTH(Date_column) BETWEEN 1 AND 3 THEN 'FQ4'
        WHEN MONTH(Date_column) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(Date_column) BETWEEN 7 AND 9 THEN 'FQ2'
        ELSE 'FQ3' 
    END AS Financial_Quarter

FROM maindata;
desc calender;
select * from calender limit 100;

select date_column from maindata;

SELECT 
    year(Date_column) as year,concat('Q',Quarter(Date_column)) as quarter,month(Date_column) as month,
    
    concat(round(Avg(Transported_passengers) / SUM(Available_seats) * 100,2) ,'%')AS Load_Factor_Percentage
FROM maindata
GROUP BY Date_column
ORDER BY Load_Factor_Percentage desc ;


SELECT 
    carrier_name,
    
    ifnull(concat(round(Avg(Transported_passengers) / SUM(Available_seats) * 100,2) ,'%'),0)AS Load_Factor_Percentage
FROM maindata
GROUP BY carrier_name
ORDER BY Load_Factor_Percentage desc;

## Identify Top 10 Carrier Names based passengers preference 

select carrier_name,count(Transported_passengers) as Total_passengers
from maindata group by carrier_name order by Total_passengers desc limit 10;



### Display top Routes ( from-to City) based on Number of Flights 

select From_To_City ,sum(Departures_performed) as flights_count
from maindata 
group by From_To_City 
order by flights_count desc;

select
case 
when weekday(Date_column) in(1,7) 
then 'weekend' else 'weekend'
end as day_category,
concat(round(Avg(Transported_passengers) / SUM(Available_seats) * 100,2) ,'%')AS Load_Factor_Percentage
from maindata
group by day_category;

## Identify number of flights based on Distance group


select Distance_Interval,count(Airline_ID) as Total_Flights
from maindata join distance_groups on maindata.Distance_Group_ID = distance_groups.Distance_Group_ID
group by Distance_Interval
order by Total_Flights desc;


SELECT 
    dg.Distance_Interval, 
    COUNT(m.Airline_ID) AS Total_Flights
FROM maindata m
JOIN distance_groups dg ON m.Distance_Group_ID = dg.Distance_Group_ID
GROUP BY dg.Distance_Interval
ORDER BY Total_Flights DESC;


