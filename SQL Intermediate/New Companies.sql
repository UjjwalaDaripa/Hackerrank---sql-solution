Select  c.company_code, c.founder ,count(distinct l.lead_manager_code ), count(distinct s.senior_manager_code), count(distinct m.manager_code),  count(distinct e.employee_code)
from company c
inner join Lead_Manager l on  c.company_code=l.company_code
inner join Senior_Manager s on c.company_code=s.company_code
inner join Manager m on m.company_code = c.company_code
inner join employee e on c.company_code=e.company_code
group by c.company_code,c.founder
order by c.company_code,c.founder
