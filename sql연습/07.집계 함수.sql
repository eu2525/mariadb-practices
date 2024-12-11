--
-- 1) 집계쿼리: select 절에 집계함수(count, max, min, avg, variance, strdev, sum)
select avg(salary), sum(salary) from salaries;

-- 2) select 절에 집계함수(그룹함수)가 잇는 경우, 어떤 컬럼도 select 절에 올 수 없다!!!
-- 오류가 나야하는데, mariadb는 오류를 안냄. -> 오류 나는게 맞음
select emp_no, avg(salary) 
from salaries;

-- 3) query 순서
-- 1. from : 접근 테이블 확인
-- 2. where : 조건에 맞는 row를 확인 선택
-- 3. 집계(결과 테이블)
select avg(salary)
from salaries
where emp_no = 10060;

-- 4) Group by에 적혀있는 컬럼은 Projection이 가능하다 : select 절에 올 수 있다!
-- 예제: 사원별 평균 연봉?
select emp_no, avg(salary)
from salaries
group by emp_no;

-- 5) Having
-- 집계결과(결과테이블)에서 row를 선택해야 하는 경우 이용.
-- 이미 where 절은 실행이 완료되었기 때문에 Having 절에서 조건을 줌. 
-- 에제 : 평균 월급이 60000 이상인 사원의 사번과 평균 연봉을 출력하라
select avg(salary) as avg_salary
from salaries
group by emp_no
having avg(salary) > 60000;

-- 6) order by
-- order by는 항상 맨 마지막(출력 전)에 실행된다
select avg(salary) as avg_salary
from salaries
group by emp_no
having avg(salary) > 60000
order by avg_salary asc;

-- 주의) 사번이 10060인 사원의 사번, 평균급여, 급여총합을 출력하세요
select emp_no, avg(salary) as avg_salary, sum(salary) as "급여총합"
from salaries
where emp_no ='10060'
group by emp_no;
