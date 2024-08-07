with cte (city,len,rank) as(
Select  city, len(city) , rank() over (partition by len(city) order by city) as rank
from station
where len(city)=(select min(len(city)) from station)
or len(city)=(select max(len(city)) from station))

select city,len from cte
where rank =1
