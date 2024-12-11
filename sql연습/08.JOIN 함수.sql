--
-- inner join
--

-- 예제 1. 현재 근무하는 직원의 이름과 직책을 모두 출력 하세요.
select ep.first_name, ep.last_name, tt.title
from employees ep, titles tt
where ep.emp_no = tt.emp_no 
	and tt.to_date='9999-01-01';
    
-- 예제 2. 현재 근무하는 직원의 이름과 직책을 모두 출력하되, 여성 엔지니어(Engineer)만 출력하세요.
select ep.first_name, ep.last_name, ep.gender, tt.title
from employees ep, titles tt
where ep.emp_no = tt.emp_no				-- join 조건(n - 1)
	and tt.to_date='9999-01-01'			-- row 선택 조건1
    and ep.gender = 'F'					-- row 선택 조건2
    and tt.title LIKE '%Engineer%';		-- row 선택 조건3

--
-- ANSI / ISO SQL1999 JOIN 표준문법
--


-- 1) natural join
select ep.first_name, ep.last_name, tt.title
from employees ep natural join titles tt
where tt.to_date='9999-01-01';

-- 2) join ~ using 
-- natural join의 문제점 : 공동의 컬럼이 많은 경우 조인하고 싶은 컬럼 이름을 명시 못함
select ep.first_name, ep.last_name, tt.title
from employees ep join titles tt using (emp_no)
where tt.to_date='9999-01-01';

select *
from salaries a join titles b using (emp_no)
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01';


-- 3) join ~ on
select *
from salaries a join titles b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01';

-- 실습문제1
-- 현재 직책별 평균 연봉을 큰 순서대로 출력하세요
select b.title, avg(salary)
from salaries a join titles b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01'
group by b.title 
order by avg(salary) desc;

-- 실습문제2
-- 현재, 직책별 평균 연봉과 직원 수를 구하되, 직원 수가 100명 이상인 직책만 출력
select title, avg(salary), count(*) as "직원수"
from salaries a join titles b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01'
group by b.title 
having count(*) >= 100;

-- 실습문제3
-- 현재, 부서별로 직책이 Engineer인 직원들에 대한 평균연봉을 구하세요.
-- projection: 부서 이름 | 평균 연봉

-- 1. 직책이 엔지니어인 직원들 구하기
-- 2. 
-- 3. 부서별로 group by

select dp.dept_name, avg_dept.avg_salary
from	(Select dept_no, avg(salary) as avg_salary
			from (
					select de.emp_no, de.dept_no
					from dept_emp de join employees ep on de.emp_no = ep.emp_no
					where de.to_date = '9999-01-01') dep 
				  join 
				  (
					select a.emp_no, b.title, a.salary
					from salaries a join titles b on a.emp_no = b.emp_no
					where a.to_date = '9999-01-01'
						and b.to_date = '9999-01-01'
				  ) sl on dep.emp_no = sl.emp_no
			where title Like 'Engineer'
			group by dept_no) avg_dept join departments dp on avg_dept.dept_no = dp.dept_no
Order by avg_salary;


	