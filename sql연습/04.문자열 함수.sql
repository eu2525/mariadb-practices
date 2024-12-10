--
-- 문자열 함수
-- 

-- upper
select upper('seoul'), ucase('SeOuL') from dual;
select upper(first_name) from employees;

-- lower
select lower('SEOUL'), lcase('Seoul') from dual;
select lower(first_name) from employees;

-- substring(문자열, index, length)
select substring('hello world', 3, 2) from dual;


-- 예제 : employees 테이블에서 직원의 이름, 성별, 입사일 출력
select first_name, hire_date
from employees
where substring(hire_date, 1, 4) = '1989';

-- lpad, rpad
select lpad('1234', 10, '-'), rpad('1234', 10, '-') from dual;

-- trim, ltrim, rtrim
select concat('---', ltrim('   hello    '), '---'),
		concat('---', trim(leading '' from '  hello    '), '---'),
        concat('---', trim(leading 'x' from 'xxxxxxxxxxhelloxxxxxxxxxxxxxxxxxxx'), '---'),
        concat('---', trim(trailing 'x' from 'xxxxxxxxxxhelloxxxxxxxxxxxxxxxxxxx'), '---'),
        concat('---', trim(both 'x' from 'xxxxxxxxxxhelloxxxxxxxxxxxxxxxxxxx'), '---'),
		concat('---', rtrim('   hello    '), '---') 
from dual;

-- length
select length('Hello World') from dual;