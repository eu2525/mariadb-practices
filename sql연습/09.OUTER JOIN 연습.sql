select * from department;

-- insert into department values(1, '개발');
-- insert into department values(2, '영업');
-- insert into department values(3, '기획');
-- insert into department values(4, '총무');

-- insert into employee values(1, 1, '둘리');
-- insert into employee values(2, 2, '마이콜');
-- insert into employee values(3, 3, '또치');
-- insert into employee values(4, null, '길동');

-- inner join
select a.name as '이름', b.name as '부서'
from employee a join department b on a.department_id = b.id;

-- left (outer) join 
select a.name as '이름', ifnull(b.name, '없음') as '부서'
from employee a left join department b on a.department_id = b.id;

-- right (outer) join
select ifnull(a.name, '없음') as '이름', b.name as '부서'
from employee a right join department b on a.department_id = b.id;

-- full (outer) join
-- mariadb는 지원 안함
