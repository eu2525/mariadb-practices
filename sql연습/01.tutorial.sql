select version(), current_date, current_date(), now()
from dual;

-- 수학함수, 사칙연산도 가능
select sin(pi()/4), 1+2*3 - 4 / 5 from dual; 

-- 대소문자 구분이 없다
select version(), current_DATe, NOW()
from dual;

-- Table 생성
CREATE TABLE pet(
	name varchar(100),
	owner varchar(20),
    species varchar(10),
    gender char(1),
    birth date,
    death date
);

-- schema 확인
describe pet;
desc pet;

-- Table 삭제
drop table pet;

-- insert (C)
insert 
	into pet 
	values('빵이', '한상진', 'cat', 'm', '2020-05-25', null);
    
-- select (R)
select * from pet;

-- update (U)
update pet set name='한빵이' where name='빵이';
update pet set death=null where death='0000-00-00';

-- delete (D)
delete from pet where name = '한빵이';

-- load data : mysql(CLI) Local 전용
-- load data local infile '/home/eu2525/pet.txt' into table pet;

-- select 연습
select name, species
from pet
where name='Bowser';

select name, species, birth
from pet
where birth>='1998-01-01';

select name, species, gender
from pet
where species ='dog' and gender='F';

SELECT name, species
from pet
where species='snake' or species='bird';

select name, birth, death
from pet
where death is not null;

Select name 
from pet
where name like 'B%';

Select name 
from pet
where name like '%w%';

Select name 
from pet
where name like '____';

Select name 
from pet
where name like 'b____';

select count(*), max(birth)
from pet;