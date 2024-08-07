select N, 
case
when P is null then 'Root'
when N  in (select P from bst) then 'Inner'
Else 'Leaf'
END
from bst
order by N
