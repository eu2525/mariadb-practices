--
-- DDL/DML 연습
--

CREATE TABLE member(
	id int not null auto_increment, 
    email varchar(200) not null,
    password varchar(64) not null,
    name varchar(50) not null,
    department varchar(100),    
    -- constraint
    primary key(id)
);

desc member;

-- drop table member;

ALTER Table member add column juminbunho char(13) not null default '';
desc member;

ALTER Table member drop juminbunho;
desc member;

ALTER Table member add column juminbunho char(13) not null after email;
desc member;

alter table member change column department dept varchar(100);
desc member;

alter table member add column profile text;
desc member;

alter table member drop juminbunho;
desc member;

-- insert
insert into member values (null, 'kickscar@gmailcom',  password('1234'), '안대혁', '개발팀', null);

select * from member;

insert into member(id, email, name, password, dept)
values (null, 'kickscar@gmailcom','안대혁2',  password('1234'), '개발팀');

-- update
update member
	set email='kickscar3@gmail.com', password=password('1234')
where id = 2;

select * from member;

-- delete
delete 
	from member
where id = 2;
select * from member;

-- transaction

select id, email from member;

select @@autocommit; -- 1
insert into member 
values(null, 'kickscar2@gmail.com', '안대혁2', password=password('12345'), '개발팀2', null);


-- TX:begin
set autocommit = 0;
select @@autocommit; -- 0
insert into member values (null, 'kickscar2@gmail.com', '안대혁3', password=password('123'), '개발팀2');

-- TX:end
commit;
-- rollback;
select id, email from member;


