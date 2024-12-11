-- 
-- Subquery
--

--
-- 1) Select 절
--
select (Select 1+1 from dual) from dual;
-- insert into t1 values (null, (select max(no) + 1 from t1));

--
-- 2) From 절의 서브쿼리
--
select now() as n, sysdate() as s, 3 + 1 as r from dual;

select *
from (select now() as n, sysdate() as s, 3 + 1 as r from dual) a;

--
-- 3) Where 절의 서브쿼리
--

-- 예) 현재 Fai Bale이 근무하는 부서에서 근무하는 직원의 사번, 전체 이름을 출력해보세요.

SELECT 
    dept_no
FROM
    employees ep
        JOIN
    dept_emp de ON ep.emp_no = de.emp_no
WHERE
    de.to_date = '9999-01-01'
        AND ep.first_name LIKE 'Fai'
        AND ep.last_name LIKE 'Bale';

-- d004 ---
SELECT 
    ep.emp_no, ep.first_name
FROM
    employees ep
        JOIN
    dept_emp de ON ep.emp_no = de.emp_no
WHERE
    de.to_date = '9999-01-01'
        AND de.dept_no = (SELECT 
								dept_no
							FROM
								employees ep
									JOIN
								dept_emp de ON ep.emp_no = de.emp_no
							WHERE
								de.to_date = '9999-01-01'
									AND ep.first_name LIKE 'Fai'
									AND ep.last_name LIKE 'Bale'
							);
                            
                            
-- 3-1. 단일행 연산자: =, >, <, >=, <= , <>, !=
-- 실습1
-- 현재, 전체 사원의 평균 연봉보다 적은 급여를 받는 사원의 이름과 급여를 출력하세요.

SELECT 
    concat(first_name,' ', last_name) as Name, sa.salary
FROM
    employees ep JOIN
    (SELECT 
        emp_no, salary
    FROM
        salaries
    WHERE
        salary < (SELECT AVG(salary)
					FROM salaries
					WHERE to_date = '9999-01-01')
	AND to_date = '9999-01-01') sa ON ep.emp_no = sa.emp_no
ORDER BY sa.salary desc;

-- 실습문제2:
-- 현재, 직책별 평균 급여 중 가장 적은 평균 급여의 직책 이름과 그 평균 급여를 출력하세요
SELECT a.title, MIN(avg_salary)
FROM (SELECT tt.title, AVG(salary) as avg_salary
		FROM
			(SELECT 
				emp_no, salary
			FROM
				salaries
			WHERE
				to_date = '9999-01-01') sa
				JOIN
			(SELECT 
				emp_no, title
			FROM
				titles
			WHERE
				to_date = '9999-01-01') tt ON sa.emp_no = tt.emp_no
		GROUP BY tt.title
		) as a;

-- 3) sol1: where절 subquery
SELECT tt.title, AVG(salary) as avg_salary
FROM
	(SELECT 
		emp_no, salary
	FROM
		salaries
	WHERE
		to_date = '9999-01-01') sa
		JOIN
	(SELECT 
		emp_no, title
	FROM
		titles
	WHERE
		to_date = '9999-01-01') tt ON sa.emp_no = tt.emp_no
GROUP BY tt.title
Having avg(salary) = (SELECT MIN(avg_salary)
						FROM (SELECT tt.title, AVG(salary) as avg_salary
								FROM
									(SELECT 
										emp_no, salary
									FROM
										salaries
									WHERE
										to_date = '9999-01-01') sa
										JOIN
									(SELECT 
										emp_no, title
									FROM
										titles
									WHERE
										to_date = '9999-01-01') tt ON sa.emp_no = tt.emp_no
								GROUP BY tt.title
								) as a);

-- 4) sol2 :top-k
SELECT tt.title, AVG(salary) as avg_salary
FROM
	(SELECT emp_no, salary
	FROM salaries
	WHERE to_date = '9999-01-01') sa
	JOIN
	(SELECT emp_no, title
	FROM titles
	WHERE to_date = '9999-01-01') tt ON sa.emp_no = tt.emp_no
GROUP BY tt.title
ORDER BY AVG(sa.salary) asc
limit 1;

-- 3-1. 복수행 연산자: in, not in, 비교 연산자 any, 비교 연산자 All
-- any 사용법
-- 1. =any: in
-- 2. >any, >= any : 최소값
-- 3. <any, <= any : 최대값
-- 4. <>any, !=any : not in

-- all 사용법
-- 1. =all: (x)
-- 2. >all, >=all: 최댓값
-- 3. <all, <=all: 최소값
-- 4. <>all, !=all : 


-- 실습문제 3
-- 현재 급여가 50000 이상인 직원의 이름과 급여를 출력하세요
-- 둘리 60000

-- sol1
select concat(e.first_name, ' ', e.last_name) , s.salary
from employees e, salaries s
where e.emp_no = s.emp_no 
and s.salary >= 50000 and s.to_date='9999-01-01';

-- sol2 : join말고 where절 사용
select concat(e.first_name, ' ', e.last_name) , s.salary
from employees e, salaries s
where e.emp_no = s.emp_no 
and (e.emp_no, s.salary) in (select emp_no, salary from salaries where to_date = '9999-01-01' and salary > 50000) 
and s.to_date='9999-01-01';

-- 실습문제 4:
-- 현재, 각 부서별 최고 급여를 받고 있는 직원의 이름, 부서이름, 급여 출력

select * from salaries;
select * from dept_emp;
select * from employees;
select * from departments;

-- Sol01
select dp.dept_name, concat(ep.first_name, ' ' , ep.last_name) AS NAME, sl.salary
from dept_emp de ,salaries sl, employees ep, departments dp
where de.dept_no=dp.dept_no
and de.emp_no=sl.emp_no
and de.emp_no=ep.emp_no
and de.to_date='9999-01-01'
and sl.to_date='9999-01-01'
and (de.dept_no, salary) in (	select dept_no, max(salary) as max_salary
								from dept_emp de ,salaries sl
								where de.emp_no=sl.emp_no
								and de.to_date='9999-01-01'
								and sl.to_date='9999-01-01'
								group by dept_no
								);

-- Sol02. FROM절 SubQuery & Join
select dp.dept_name, concat(ep.first_name, ' ' , ep.last_name) AS NAME, sl.salary
from dept_emp de ,salaries sl, employees ep, departments dp, (	select dept_no, max(salary) as max_salary
								from dept_emp de ,salaries sl
								where de.emp_no=sl.emp_no
								and de.to_date='9999-01-01'
								and sl.to_date='9999-01-01'
								group by dept_no
								) e
where de.dept_no=dp.dept_no
and de.emp_no=sl.emp_no
and de.emp_no=ep.emp_no
and de.dept_no = e.dept_no
and sl.salary = e.max_salary
and de.to_date='9999-01-01'
and sl.to_date='9999-01-01';
