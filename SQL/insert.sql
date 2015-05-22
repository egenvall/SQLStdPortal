INSERT INTO Departments (name,id) VALUES ('Chemistry and Bio Engineering','CMB');
INSERT INTO Departments (name,id) VALUES ('Computer Science and Engineering','CSE');
INSERT INTO Departments (name,id) VALUES ('Architecture','ARC');
INSERT INTO Departments(name,id)  VALUES ('Physics and Mathematic Engineering','CPM');
INSERT INTO Programs (name,id) VALUES ('Bio Engineering','TKBIO');
INSERT INTO Programs (name,id) VALUES ('Chemical Engineering','TKCHM');
INSERT INTO Programs(name,id)  VALUES ('Mechanical enginering','TKMAS');
INSERT INTO Programs(name,id)  VALUES ('Technical Design','TKDES');
INSERT INTO Programs (name,id) VALUES ('Software Engineering','TKITE');
INSERT INTO Programs (name,id) VALUES ('Computer Science and Engineering','TKDAT');
INSERT INTO Programs(name,id)  VALUES ('Architecture Engineering','TKARC');
INSERT INTO Programs (name,id) VALUES ('Electric Engineering','TKELE');
INSERT INTO Programs (name,id) VALUES ('Mathematical Engineering','TKMAT');
INSERT INTO DepHosts (department, program) VALUES ('CSE', 'Software Engineering');
INSERT INTO DepHosts (department, program) VALUES ('ARC', 'Architecture Engineering');
INSERT INTO DepHosts (department, program) VALUES ('CMB', 'Bio Engineering');
INSERT INTO DepHosts(department, program) VALUES ('CPM', 'Mathematical Engineering');
INSERT INTO Branches(name, program) VALUES ('Biological structure','Bio Engineering');
INSERT INTO Branches (name, program)VALUES ('Large Scale Design','Architecture Engineering');
INSERT INTO Branches(name,program) VALUES ('Communication Engineering','Software Engineering');
INSERT INTO Courses (code,name,credits,department) VALUES ('TDA615','Introduction to computer systems',5,'CSE');
INSERT INTO Courses (code,name,credits,department) VALUES ('DAT215','Design of graphical interfaces',5,'CSE');
INSERT INTO Courses (code,name,credits,department)VALUES ('TMV200','Discrete math',5,'CPM');
INSERT INTO Courses (code,name,credits,department)VALUES ('EDA433','Computer systems',5,'CSE');
INSERT INTO Courses (code,name,credits,department)VALUES ('CCCP81','Math for the motherland',25,'CPM');
INSERT INTO Courses(code,name,credits,department) VALUES ('LSP310','Human interraction for engineers',5,'CSE');
INSERT INTO Courses(code,name,credits,department) VALUES ('MVE045','Calculus',5,'CPM');
INSERT INTO Courses(code,name,credits,department) VALUES ('EMP001','How to run a one man army',5,'CPM');
INSERT INTO Courses(code,name,credits,department) VALUES ('TMA235','Introduction to mathematics',5,'CPM');
INSERT INTO Courses (code,name,credits,department)VALUES ('TDA545','Object oriented programming',5,'CSE');
INSERT INTO Courses(code,name,credits,department) VALUES ('TDA550','Advanced Object Oriented Programming',5,'CSE');
INSERT INTO Courses (code,name,credits,department)VALUES ('DAT255','Software engineering project',5,'CSE');
INSERT INTO LimitedCourses (code,students) VALUES('DAT255', 23);
INSERT INTO LimitedCourses (code,students) VALUES('TMV200', 5);
INSERT INTO LimitedCourses (code,students) VALUES('EMP001', 1);
INSERT INTO Classifications (type) VALUES('mathematical');
INSERT INTO Classifications (type) VALUES('seminar');
INSERT INTO Classifications (type) VALUES('science');
INSERT INTO HasClassification (course,classification)VALUES('CCCP81', 'mathematical');
INSERT INTO HasClassification (course,classification)VALUES('TMV200', 'mathematical');
INSERT INTO HasClassification (course,classification) VALUES('MVE045', 'mathematical');
INSERT INTO HasClassification(course,classification) VALUES('TMA235', 'mathematical');
INSERT INTO HasClassification (course,classification)VALUES('TDA615', 'science');
INSERT INTO HasClassification (course,classification)VALUES('EDA433', 'science');
INSERT INTO HasClassification (course,classification)VALUES('TDA545', 'science');
INSERT INTO HasClassification (course,classification)VALUES('TDA550', 'science');
INSERT INTO HasClassification (course,classification)VALUES('DAT255', 'science');
INSERT INTO HasClassification (course,classification)VALUES('DAT215', 'science');
INSERT INTO HasClassification (course,classification)VALUES('LSP310', 'seminar');
INSERT INTO Requires (course,requiredCourse) VALUES('TMV200', 'TMA235');
INSERT INTO Requires (course,requiredCourse) VALUES('MVE045', 'TMV200');
INSERT INTO Requires (course,requiredCourse) VALUES('TDA550', 'TDA545');
INSERT INTO MandatoryForProgram (program,course) VALUES('Software Engineering', 'MVE045');
INSERT INTO MandatoryForProgram (program,course)VALUES('Software Engineering', 'TMV200');
INSERT INTO MandatoryForProgram (program,course)VALUES('Software Engineering', 'TDA545');
INSERT INTO MandatoryForProgram(program,course) VALUES('Software Engineering', 'TDA550');
INSERT INTO MandatoryForBranch (program,branch,course)VALUES('Software Engineering','Communication Engineering', 'DAT215');
INSERT INTO MandatoryForBranch (program,branch,course)VALUES('Software Engineering','Communication Engineering', 'DAT255');
INSERT INTO Recommended (program,branch,course) VALUES ('Software Engineering','Communication Engineering','LSP310');
INSERT INTO Recommended (program,branch,course)VALUES ('Software Engineering','Communication Engineering','EDA433');
INSERT INTO Recommended (program,branch,course)VALUES ('Software Engineering','Communication Engineering','CCCP81');
INSERT INTO Students(id,name,program) VALUES ('apope','Alexander Pope','Software Engineering');
INSERT INTO Students(id,name,program) VALUES ('darwin','Charles Darwin','Software Engineering');
INSERT INTO Students(id,name,program)VALUES ('dummy','Dummy Char','Mechanical enginering');
INSERT INTO Students(id,name,program)VALUES ('clumpsy','Dumsy Strat','Mechanical enginering');
INSERT INTO HasRead (student,course,grade) VALUES('apope', 'TMV200','5');
INSERT INTO HasRead(student,course,grade)VALUES('apope', 'TMA235', '4');
INSERT INTO HasRead(student,course,grade)VALUES('apope', 'CCCP81', '5');
INSERT INTO HasRead(student,course,grade)VALUES('apope', 'MVE045', '5');
INSERT INTO HasRead(student,course,grade)VALUES('apope', 'LSP310', '4');
INSERT INTO HasRead(student,course,grade) VALUES('apope', 'TDA545', '4');
INSERT INTO HasRead(student,course,grade) VALUES('apope', 'TDA550', '4');
INSERT INTO HasRead(student,course,grade) VALUES('apope', 'EDA433', '4');
INSERT INTO HasRead (student,course,grade)VALUES('apope', 'DAT255', '3');
INSERT INTO HasRead (student,course,grade)VALUES('apope', 'DAT215', '4');
INSERT INTO HasRead (student,course,grade)VALUES('darwin', 'TMA235', '4');
INSERT INTO HasRead(student,course,grade) VALUES('darwin', 'TDA545', 'U');
INSERT INTO HasRead(student,course,grade) VALUES('darwin', 'TDA550', '4');
INSERT INTO HasRead (student,course,grade)VALUES('darwin', 'DAT255', 'U');
INSERT INTO HasRead(student,course,grade) VALUES('darwin', 'DAT215', '4');
INSERT INTO Takes (student,course) VALUES('darwin', 'TDA615');
INSERT INTO Takes (student,course) VALUES('clumpsy', 'TDA615');
INSERT INTO Takes (student,course) VALUES('clumpsy', 'EDA433');
INSERT INTO Takes (student,course) VALUES('clumpsy', 'EMP001');
INSERT INTO Major(student,program,branch) VALUES('apope','Software Engineering','Communication Engineering');
INSERT INTO Major (student,program,branch) VALUES('darwin','Software Engineering','Communication Engineering');
INSERT INTO Register(student,course,queuePlace) VALUES('darwin','DAT255',QueuePlace.nextval);
INSERT INTO Register (student,course,queuePlace)VALUES('darwin','TMV200',QueuePlace.nextval);
INSERT INTO Register (student,course,queuePlace)VALUES('clumpsy','TMV200',QueuePlace.nextval);
INSERT INTO Register (student,course,queuePlace)VALUES('clumpsy','DAT255',QueuePlace.nextval);















