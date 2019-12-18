create database school charset=utf8;
use school;
create table student(id int primary key auto_increment,
name varchar(30) not null,birthday date,sex enum('m','w'));

create table teacher(id int primary key auto_increment,
name varchar(30) not null);

create table subject(id int primary key auto_increment,
name varchar(30) not null,
teacher_id int not null,constraint teacher_fk
foreign key(teacher_id) references teacher(id));

create table score(student_id int not null,subject_id int not null,
score varchar(30) not null,
primary key(student_id,subject_id),
constraint stu_fk foreign key(student_id) references student(id),
constraint sub_fk foreign key(subject_id) references subject(id));


insert into student (id, name, birthday, sex)
values  ('01' , '赵雷' , '1990-01-01' , 'm'),
        ('02' , '钱电' , '1990-12-21' , 'm'),
        ('03' , '孙风' , '1990-05-20' , 'm'),
        ('04' , '李云' , '1990-08-06' , 'w'),
        ('05' , '周梅' , '1991-12-01' , 'w'),
        ('06' , '吴兰' , '1992-03-01' , 'w'),
        ('07' , '郑竹' , '1989-07-01' , 'm'),
        ('08' , '王菊' , '1990-01-20' , 'w');

insert into teacher (id, name)
values  ('01' , '张三'),
        ('02' , '李四'),
        ('03' , '王五');

insert into subject (id, name, teacher_id)
values  ('01' , '语文' , '02'),
        ('02' , '数学' , '01'),
        ('03' , '英语' , '03');

 insert into score (student_id, subject_id, score)
values  ('01' , '01' , 80),
        ('01' , '02' , 90),
        ('01' , '03' , 99),
        ('02' , '01' , 70),
        ('02' , '02' , 60),
        ('02' , '03' , 80),
        ('03' , '01' , 80),
        ('03' , '02' , 80),
        ('03' , '03' , 80),
        ('04' , '01' , 50),
        ('04' , '02' , 30),
        ('04' , '03' , 20),
        ('05' , '01' , 76),
        ('05' , '02' , 87),
        ('06' , '01' , 31),
        ('06' , '03' , 34),
        ('07' , '02' , 89),
        ('07' , '03' , 98);

create table total(
select a.student.id as s_id,a.student.name as s_name,a.student.age as s_age,a.student.sex as s_sex,
b.subject.id as c_id,b.score as score,c.teacher_id as t_id,d.t_name as t_name
from student a
left join
score  b on a.s_id=b.s_id
left join
course c on b.c_id=c.c_id
left join
teacher d on c.t_id=d.t_id
);
select * from total;

create table total(
select a.student.id as s_id,a.student.name as s_name,a.student.age as s_age,a.student.sex as s_sex,
b.subject.id as c_id,b.score as score,c.teacher.id as t_id,d.teacher.name as t_name
from student a
left join
score  b on a.student.id=b.student.id
left join
subject c on b.subject.id=c.subject.id
left join
teacher d on c.teacher.id=d.teacher.id
);

-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数

select student.*,c_name,score1,score2 from

((select score form score where c_id='01') as score1 inner join
(select score form score where c_id='02') as score2 where score1>score2) on

-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩

select a.s_id as s_id,a.s_name as s_name,b.avg(score)_as avg_score from student right join


-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select student.* from student,
where s_id in (select s_id from score where c_id='01') and
s_id in (select s_id from score where c_id='02') ;


--10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
select student.* from student,
where s_id in (select s_id from score where c_id='01') and
s_id not in (select s_id from score where c_id='02') ;

--11、查询没有学全所有课程的同学的信息

select * from student,
(select s_id,count(c_id) as a from score group by s_id having a<3) as b
where student.s_id=b.s_id;


--12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息

select  distinct student.* from student,(select s_id,c_id from score) as a,
(select c_id from score where s_id='01') as b
where student.s_id=a.s_id and student.s_id !='01' and a.c_id=b.c_id;

--13查询和"01"号的同学学习的课程完全相同的其他同学的信息

select  student.*,a.c_id,count(a.c_id) as c from student,(select s_id,c_id from score) as a,
(select c_id,count (c_id) as d from score where s_id='01') as b
where student.s_id=a.s_id and student.s_id !='01' and a.c_id=b.c_id and c=d;

-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名
select s_name from student where s_id not in 
(select s_id from score,(select c_id from course,teacher
where course.t_id=teacher.t_id and t_name='张三') as a
 where score.c_id=a.c_id);

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select s.s_id,s_name,b from student as s,
(select s_id,avg(score) as b from score where score<60 group by s_id) as a
where s.s_id=a.s_id ;

--16、检索"01"课程分数小于60，按分数降序排列的学生信息
select s.* from student as s inner join
(select s_id,score from score where score<60 and c_id='01'
order by score desc) as a on s.s_id=a.s_id;
--21、查询不同老师所教不同课程平均分从高到低显示

























