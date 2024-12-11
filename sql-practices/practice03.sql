-- 테이블 조인(JOIN) SQL 문제입니다.

-- 문제 1. 
-- 현재 급여가 많은 직원부터 직원의 사번, 이름, 그리고 연봉을 출력 하시오.
SELECT sl.emp_no, ep.first_name, sl.salary
FROM salaries sl join employees ep on sl.emp_no = ep.emp_no 
WHERE sl.to_date='9999-01-01'
ORDER BY salary desc;


-- 문제2.
-- 전체 사원의 사번, 이름, 현재 직책을 이름 순서로 출력하세요.
SELECT ep.emp_no, ep.first_name, tt.title
FROM employees ep, titles tt
WHERE ep.emp_no = tt.emp_no
and tt.to_date='9999-01-01'
order by first_name;

-- 문제3.
-- 전체 사원의 사번, 이름, 현재 부서를 이름 순서로 출력하세요.
SELECT ep.emp_no, ep.first_name, dp.dept_name
FROM employees ep, dept_emp de, departments dp
WHERE de.dept_no = dp.dept_no
and ep.emp_no = de.emp_no
and de.to_date='9999-01-01'
order by first_name;


-- 문제4.
-- 현재 근무중인 전체 사원의 사번, 이름, 연봉, 직책, 부서를 모두 이름 순서로 출력합니다.
select ep.emp_no, ep.first_name, sl.salary, tt.title, dp.dept_name
from employees ep, salaries sl, departments dp, dept_emp de, titles tt
where ep.emp_no = sl.emp_no
and ep.emp_no = tt.emp_no
and ep.emp_no = de.emp_no
and dp.dept_no = de.dept_no
and ep.emp_no = tt.emp_no
and sl.to_date='9999-01-01'
and de.to_date='9999-01-01'
and tt.to_date='9999-01-01'
order by first_name;


-- 문제5.
-- 'Technique Leader'의 직책으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 출력하세요.
-- (현재 'Technique Leader'의 직책으로 근무하는 사원은 고려하지 않습니다.)
select tt.emp_no, ep.first_name
from employees ep, ( select distinct(emp_no)
					from titles
					where title='Technique Leader'
					and to_date != '9999-01-01') tt
where ep.emp_no = tt.emp_no;


-- 문제6.
-- 직원 이름(last_name) 중에서 S로 시작하는 직원들의 이름, 부서명, 직책을 조회하세요.
SELECT concat(ep.first_name, ' ' , ep.last_name) as NAME, dept.dept_name, tt.title
FROM titles tt, 
		(select emp_no, first_name, last_name
		from employees ep
		where ep.last_name LIKE 'S%') ep,
		(select dp.dept_name, de.emp_no, de.dept_no
		from departments dp, dept_emp de
		where dp.dept_no = de.dept_no
		and de.to_date='9999-01-01') dept
WHERE ep.emp_no=tt.emp_no
and ep.emp_no = dept.emp_no
and tt.to_date='9999-01-01';


-- 문제7.
-- 현재, 직책이 Engineer인 사원 중에서 현재 급여가 40,000 이상인 사원들의 사번, 이름, 급여 그리고 타이틀을 급여가 큰 순서대로 출력하세요.

select ep.emp_no, ep.first_name, sltt.salary, sltt.title
from employees ep,
	(select sl.emp_no, salary, tt.title
	from salaries sl, 
			(SELECT emp_no, title
			FROM titles 
			WHERE title = 'Engineer'
			and to_date='9999-01-01') tt
	where sl.emp_no = tt.emp_no
	and sl.to_date='9999-01-01'
	and sl.salary >= 40000) sltt
where ep.emp_no = sltt.emp_no
order by sltt.salary desc;

-- 문제8.
-- 현재, 평균급여가 50,000이 넘는 직책을 직책과 평균급여을 평균급여가 큰 순서대로 출력하세요.
select tt.title, avg(sl.salary)
from salaries sl, 
	(SELECT emp_no, title
	FROM titles 
	WHERE to_date='9999-01-01') tt
where sl.emp_no = tt.emp_no
and sl.to_date='9999-01-01'
group by tt.title
having avg(sl.salary) >= 50000
order by avg(sl.salary) desc;

-- 문제9.
-- 현재, 부서별 평균급여을 평균급여가 큰 순서대로 부서명과 평균연봉을 출력 하세요.
select dept.dept_name, avg(sl.salary)
from salaries sl, 
		(select dp.dept_name, de.emp_no, de.dept_no
		from departments dp, dept_emp de
		where dp.dept_no = de.dept_no
		and de.to_date='9999-01-01') dept
where sl.emp_no = dept.emp_no
and sl.to_date='9999-01-01'
group by dept.dept_name
order by avg(sl.salary) desc;

-- 문제10.
-- 현재, 직책별 평균급여를 평균급여가 큰 직책 순서대로 직책명과 그 평균연봉을 출력 하세요.
select tt.title, avg(sl.salary)
from salaries sl, 
	(SELECT emp_no, title
	FROM titles 
	WHERE to_date='9999-01-01') tt
where sl.emp_no = tt.emp_no
and sl.to_date='9999-01-01'
group by tt.title
order by avg(sl.salary) desc;


