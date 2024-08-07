with cte as(
Select submission_date,count(submission_id) count,hacker_id
from Submissions
group by submission_date,hacker_id
),
cte2 as(
Select submission_date,hacker_id,rank()over(partition by submission_date order by count desc) rank
from cte
),
cte3 as(
Select submission_date,min(hacker_id)hacker_id
from cte2
where rank=1
group by submission_date
),
cte4 as(
select cte3.submission_date,cte3.hacker_id,name
from cte3
inner join Hackers on Hackers.hacker_id=cte3.hacker_id
),
cte5 as (
Select hacker_id, min(submission_date) min, max(submission_date) max
from Submissions
group by hacker_id
having min(submission_date) = '2016-03-01'
),
cte6 as(
Select distinct s1.hacker_id, s1.submission_date start_date, s2.submission_date end_date
from Submissions s1
inner join Submissions s2 on s1.hacker_id=s2.hacker_id and datediff(day,s1.submission_date,s2.submission_date)=1 
    where s1.hacker_id in (select hacker_id from cte5)
),
cte7 as(
Select a.hacker_id,Start_Date,End_Date from
(SELECT c1.hacker_id,Start_Date,rank()over(partition by hacker_id order by Start_Date ) rank FROM cte6 c1 WHERE Start_Date NOT IN (SELECT End_Date FROM cte6 where hacker_id=c1.hacker_id  ) )a
inner join
(SELECT c1.hacker_id,End_Date,rank()over(partition by hacker_id order by End_Date ) rank FROM cte6 c1 WHERE End_Date NOT IN (SELECT Start_Date FROM cte6 where hacker_id=c1.hacker_id))b
on a.hacker_id=b.hacker_id and a.rank=1 and b.rank=1 and start_date='2016-03-01'
),
cte8 as(
Select c1.hacker_id,start_date, end_date
from cte6 c1
where  start_date>=(Select Start_Date from cte7 where hacker_id=c1.hacker_id )
and end_date<=(Select End_Date from cte7 where hacker_id=c1.hacker_id )
    ),
cte9 as 
(Select end_date, count(distinct hacker_id) count
from cte8
group by end_date
union
Select submission_date end_date, count(distinct hacker_id) count
from Submissions
where submission_date = '2016-03-01'
group by submission_date)
select cte4.submission_date,count,cte4.hacker_id,name
from cte4
inner join cte9 on cte4.submission_date=cte9.end_date
order by cte4.submission_date
