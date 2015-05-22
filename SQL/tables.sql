Kim Egenvall, Carl Fredriksson Group 39.
Update: Fixed constraint for name, updated insert, updated join in views.
Last version got mixed up files when transferring from pc to mac.
PathToGraduation has not been changed since If i understood we did not have to change it
if it works?


begin
for c in (select table_name from user_tables) loop
execute immediate ('drop table '||c.table_name||' cascade constraints');
end loop;
end;
/
begin
for c in (select * from user_objects) loop
execute immediate ('drop '||c.object_type||' '||c.object_name);
end loop;
end;
/

CREATE TABLE Departments(
  name VARCHAR(64) NOT NULL,
  id VARCHAR(8),
  CONSTRAINT DepID PRIMARY KEY (id),
  CONSTRAINT DepUniqueName UNIQUE (name)
);

CREATE TABLE Programs(
  name VARCHAR(64),
  id CHAR(6) NOT NULL,
  CONSTRAINT ProgName PRIMARY KEY (name)
 
);

CREATE TABLE Students(
  id VARCHAR(8),
  name VARCHAR(64) NOT NULL,
  program VARCHAR(64),
  CONSTRAINT StudID PRIMARY KEY(id),
  CONSTRAINT StudProgRef FOREIGN KEY (program) REFERENCES Programs(name),
  CONSTRAINT StudIDProgUnique UNIQUE (id, program)
);

CREATE TABLE Branches(
  name VARCHAR(64) NOT NULL,
  program VARCHAR(64),
  CONSTRAINT BranchIDProg PRIMARY KEY (name, program),
  CONSTRAINT BranchProgRef FOREIGN KEY (program) REFERENCES Programs(name)
);

CREATE TABLE Courses(
  code CHAR(6),
  name VARCHAR(64) NOT NULL,
  credits INTEGER NOT NULL,
  department VARCHAR(8),
  CONSTRAINT CourseCode PRIMARY KEY (code),
  CONSTRAINT CourseDepRef FOREIGN KEY (department) REFERENCES Departments(id),
  CONSTRAINT CourseInvalidCredits CHECK (credits >= 0)
);

CREATE TABLE LimitedCourses(
  code CHAR(6),
  students INTEGER NOT NULL,
  CONSTRAINT LimitedCourseCode PRIMARY KEY (code),
  CONSTRAINT LCCCodeRef FOREIGN KEY (code) REFERENCES Courses(code),
  CONSTRAINT LCCoInvNbrOfStud CHECK (students > 0)
);

CREATE TABLE Classifications(
  type VARCHAR(64) PRIMARY KEY
);

CREATE TABLE HasClassification(
  course CHAR(6),
  classification VARCHAR(64),
  CONSTRAINT HasClassifctnCourseClass PRIMARY KEY (course, classification),
  CONSTRAINT HasClassifctnCourseRef FOREIGN KEY (course) REFERENCES Courses(code),
  CONSTRAINT HasClassifctnClassRef FOREIGN KEY (classification) REFERENCES Classifications(type)
);

CREATE TABLE Requires(
  course CHAR(6),
  requiredCourse CHAR(6),
  CONSTRAINT RqireCourseReqCourse PRIMARY KEY (course, requiredCourse),
  CONSTRAINT RqireCourseRef FOREIGN KEY (course) REFERENCES Courses(code),
  CONSTRAINT RqireReqCourseRef FOREIGN KEY (requiredCourse) REFERENCES Courses(code),
  CONSTRAINT RqireRequireItself CHECK (course != requiredCourse)
);

CREATE TABLE DepHosts(
  department VARCHAR(8),
  program VARCHAR(64),
  CONSTRAINT DepHostDepProg PRIMARY KEY (department, program),
  CONSTRAINT DepHostDepRef FOREIGN KEY (department) REFERENCES Departments(id),
  CONSTRAINT DepHostProRef FOREIGN KEY (program) REFERENCES Programs(name)
);




CREATE TABLE MandatoryForProgram(
  program VARCHAR(64),
  course CHAR(6),
  CONSTRAINT MandatFPProgCourse PRIMARY KEY (program, course),
  CONSTRAINT MandatFPProgRef FOREIGN KEY (program) REFERENCES Programs(name),
  CONSTRAINT MandatFPCourseRef FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE MandatoryForBranch(
  program VARCHAR(64),
  branch VARCHAR(64),
  course CHAR(6),
  CONSTRAINT MandatFBProgBraCourse PRIMARY KEY (program, branch, course),
  CONSTRAINT MandatFBProgBraRef FOREIGN KEY (program, branch) REFERENCES Branches(program, name),
  CONSTRAINT MandatFBCourseRef FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE Recommended(
  program VARCHAR(64),
  branch VARCHAR(64),
  course CHAR(6),
  CONSTRAINT RecProgBraCourse PRIMARY KEY (program, branch, course),
  CONSTRAINT RecProgBraRef FOREIGN KEY (program, branch) REFERENCES Branches(program, name),
  CONSTRAINT RecCourseRef FOREIGN KEY (course) REFERENCES Courses(code)
);



CREATE TABLE Takes(
  student VARCHAR(8),
  course CHAR(6),
  CONSTRAINT TakesStudCourse PRIMARY KEY (student, course),
  CONSTRAINT TakesStudRef FOREIGN KEY (student) REFERENCES Students(id),
  CONSTRAINT TakesCourseRef FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE HasRead(
  student VARCHAR(8),
  course CHAR(6),
  grade CHAR(1) NOT NULL,
  PRIMARY KEY (student, course),
  FOREIGN KEY (student) REFERENCES Students(id),
  FOREIGN KEY (course) REFERENCES Courses(code),
  CONSTRAINT ValidGrade CHECK (grade IN ('U', '3', '4', '5'))
);

CREATE TABLE Register(
  student VARCHAR(8),
  course CHAR(6),
  queuePlace INTEGER NOT NULL,
  CONSTRAINT RegStudCourse PRIMARY KEY (student, course),
  CONSTRAINT RegStudRef FOREIGN KEY (student) REFERENCES Students(id),
  CONSTRAINT RegCourseRef FOREIGN KEY (course) REFERENCES LimitedCourses(code),
  CONSTRAINT RegCourseQueueUnique UNIQUE (course, queuePlace)
);

CREATE TABLE Major(
  student VARCHAR(8),
  program VARCHAR(64),
  branch VARCHAR(64),
  CONSTRAINT MajorStud PRIMARY KEY (student),
  CONSTRAINT MajorStudProgRef FOREIGN KEY (student, program) REFERENCES Students(id, program),
  CONSTRAINT MajorProgBraRef FOREIGN KEY (program, branch) REFERENCES Branches(program, name)
);

CREATE SEQUENCE QueuePlace
START WITH 1
INCREMENT BY 1;