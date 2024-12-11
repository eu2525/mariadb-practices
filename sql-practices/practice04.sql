-- 서브쿼리(SUBQUERY) SQL 문제입니다.
-- 단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다. 

-- 문제1.
-- 현재 전체 사원의 평균 급여보다 많은 급여를 받는 사원은 몇 명이나 있습니까?
select count(*)
from salaries sl
where sl.salary >= (select avg(salary) from salaries where to_date='9999-01-01')
and to_date='9999-01-01';


-- 문제2. 
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서, 급여을 조회하세요. 단 조회결과는 급여의 내림차순으로 정렬합니다.
select ep.emp_no, ep.first_name, dept.dept_name, sl.salary
from salaries sl, employees ep, (select dp.dept_name, de.emp_no, de.dept_no
								from departments dp, dept_emp de
								where dp.dept_no = de.dept_no
								and de.to_date='9999-01-01') dept
where sl.emp_no = dept.emp_no
and sl.to_date='9999-01-01'
and ep.emp_no =sl.emp_no
and (dept.dept_name, sl.salary) in (SELECT dept_name, max(salary)
									FROM salaries sl, (select dp.dept_name, de.emp_no, de.dept_no
														from departments dp, dept_emp de
														where dp.dept_no = de.dept_no
														and de.to_date='9999-01-01') dept
									where sl.emp_no = dept.emp_no
									and sl.to_date='9999-01-01'
									group by dept.dept_name)
order by salary desc;


-- 문제3.
-- 현재, 사원 자신들의 부서의 평균급여보다 급여가 많은 사원들의 사번, 이름 그리고 급여를 조회하세요 
select ep.emp_no, ep.first_name, sl.salary
from salaries sl ,
	employees ep,
	(select dp.dept_name, de.emp_no, de.dept_no
		from departments dp, dept_emp de
		where dp.dept_no = de.dept_no
		and de.to_date='9999-01-01') dept , 
	(SELECT dept_name, avg(salary) as avg_salary
	FROM salaries sl, (select dp.dept_name, de.emp_no, de.dept_no
						from departments dp, dept_emp de
						where dp.dept_no = de.dept_no
						and de.to_date='9999-01-01') dept
	where sl.emp_no = dept.emp_no
	and sl.to_date='9999-01-01'
	group by dept.dept_name) avg_dept
where sl.emp_no = dept.emp_no
and dept.dept_name = avg_dept.dept_name
and sl.emp_no = ep.emp_no
and sl.to_date='9999-01-01'
and sl.salary >= avg_dept.avg_salary ;



-- 부서별 평균 급여
SELECT dept_name, avg(salary)
FROM salaries sl, (select dp.dept_name, de.emp_no, de.dept_no
					from departments dp, dept_emp de
					where dp.dept_no = de.dept_no
					and de.to_date='9999-01-01') dept
where sl.emp_no = dept.emp_no
and sl.to_date='9999-01-01'
group by dept.dept_name;

        
-- 문제4.
-- 현재, 사원들의 사번, 이름, 그리고 매니저 이름과 부서 이름을 출력해 보세요.
SELECT ep.emp_no, ep.first_name, dm.manager_name, dm.dept_name
FROM employees ep, dept_emp de, (select dp.dept_name, dp.dept_no, dm.emp_no, ep.first_name as manager_name
									from dept_manager dm, departments dp , employees ep
									where dm.dept_no = dp.dept_no
                                    and dm.emp_no = ep.emp_no
									and dm.to_date='9999-01-01') dm
WHERE ep.emp_no = de.emp_no
and de.to_date='9999-01-01'
and de.dept_no = dm.dept_no;


-- 문제5.
-- 현재, 평균급여가 가장 높은 부서의 사원들의 사번, 이름, 직책 그리고 급여를 조회하고 급여 순으로 출력하세요.

-- 1) 평균 급여가 가장 높은 부서
-- 2) 사번, 이름, 직책, 급여
-- 3) 급여 순서대로 출력
select ep.emp_no, ep.first_name, tt.title, sl.salary
from employees ep, titles tt, salaries sl, dept_emp de
where ep.emp_no = tt.emp_no
and ep.emp_no = sl.emp_no
and ep.emp_no = de.emp_no
and tt.to_date='9999-01-01'
and sl.to_date='9999-01-01'
and de.to_date='9999-01-01'
and de.dept_no = (SELECT dept.dept_no
					 FROM salaries sl, (select de.emp_no, de.dept_no
										from departments dp, dept_emp de
										where dp.dept_no = de.dept_no
										and de.to_date='9999-01-01') dept
					where sl.emp_no = dept.emp_no
					and sl.to_date='9999-01-01'
					group by dept.dept_no
					order by avg(salary) desc
                    LIMIT 1)
order by salary desc;


-- 문제6.
-- 현재, 평균 급여가 가장 높은 부서의 이름 그리고 평균급여를 출력하세요.
SELECT dept.dept_name, avg(salary)
 FROM salaries sl, (select de.emp_no, de.dept_no, dp.dept_name
					from departments dp, dept_emp de
					where dp.dept_no = de.dept_no
					and de.to_date='9999-01-01') dept
where sl.emp_no = dept.emp_no
and sl.to_date='9999-01-01'
group by dept.dept_name
order by avg(salary) desc
LIMIT 1;


-- 문제7.
-- 현재, 평균 급여가 가장 높은 직책의 타이틀 그리고 평균급여를 출력하세요.
select tt.title, avg(sl.salary) avg_salary
from titles tt, salaries sl
where tt.emp_no = sl.emp_no
and tt.to_date='9999-01-01'
and sl.to_date='9999-01-01'
group by tt.title
order by avg(sl.salary) desc
LIMIT 1;