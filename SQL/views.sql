	
CREATE OR REPLACE VIEW StudentsFollowing AS
SELECT Students.id, Students.name,Students.program,Programs.name AS programname,branch
	FROM Students JOIN Programs ON Students.program = Programs.name
	LEFT JOIN Major ON Major.student = Students.id;
		
	
CREATE OR REPLACE VIEW FinishedCourses AS
SELECT course, Courses.name AS courseName,
	student, Students.name AS studentName, grade, credits
	FROM HasRead
	JOIN Students ON student = id
	JOIN Courses ON course = Courses.code;

CREATE OR REPLACE VIEW Registrations AS
	WITH
		CompletedRegistrations AS 
			(SELECT student,Students.name AS studentname,course,Courses.name AS coursename,'registered' AS status
				FROM Takes
				JOIN Courses ON course = code
				JOIN Students ON student = id),
				WaitingRegistrations AS
				(SELECT student,Students.name AS studentname,course,Courses.name AS coursename,'waiting' AS status
				FROM Register
				JOIN Courses ON course =  code
				JOIN Students on student = id)
				SELECT * FROM CompletedRegistrations
				UNION
				SELECT * FROM WaitingRegistrations;
	

	CREATE OR REPLACE VIEW PassedCourses AS
	SELECT course AS code, courseName AS name, student, grade, credits
	FROM FinishedCourses
	WHERE grade != 'U';
	
	
	CREATE OR REPLACE VIEW UnreadMandatory AS 
       WITH
	   AllMandatoryCourses AS
			(SELECT student,course FROM Major
			JOIN MandatoryForBranch ON Major.branch = MandatoryForBranch.branch
			AND Major.program = MandatoryForBranch.program
			UNION
			SELECT id AS student,course FROM Students
			JOIN MandatoryForProgram ON Students.program = MandatoryForProgram.program),
		Unread AS
			(SELECT * FROM AllMandatoryCourses WHERE 
				NOT EXISTS
			(SELECT * FROM PassedCourses WHERE
			AllMandatoryCourses.student = PassedCourses.student
			AND AllMandatoryCourses.course = PassedCourses.code))
		SELECT Unread.student,Unread.course,Courses.name AS coursename 
		FROM Unread
		JOIN Courses ON Unread.course = Courses.code;
	
	
	CREATE OR REPLACE VIEW PathToGraduation AS
		WITH GraduationHelp AS
			(SELECT id,COALESCE(SUM(credits),0) AS totalCredits,
			(SELECT COALESCE(SUM(credits),0) FROM PassedCourses
			JOIN Recommended ON PassedCourses.code = Recommended.course
			WHERE id = student AND branch = (SELECT branch FROM Major WHERE Major.student = id)) AS branchCredits,
			(SELECT COALESCE(SUM(credits),0) FROM PassedCourses
			JOIN HasClassification ON PassedCourses.code = HasClassification.course
			WHERE id = student AND classification = 'mathematical') AS mathCredits,
			(SELECT COALESCE(SUM(credits),0) FROM PassedCourses
			JOIN HasClassification ON PassedCourses.code = HasClassification.course
			WHERE id = student AND classification = 'science') AS scienceCredits,
			(SELECT COUNT(credits) FROM PassedCourses
			JOIN HasClassification ON PassedCourses.code = HasClassification.course
			WHERE id = student AND classification = 'seminar') AS nbrofSeminar,
			(SELECT COUNT(*) FROM UnreadMandatory WHERE id = student)
			AS nbrOfMandatoryLeft
			FROM Students
			OUTER JOIN PassedCourses ON id = student
			GROUP BY id)
			SELECT id,totalCredits,mathCredits,scienceCredits,branchCredits,nbrofSeminar,nbrOfMandatoryLeft,
			CASE 
				WHEN
					nbrOfMandatoryLeft < 1
					AND mathCredits >= 20
					AND scienceCredits >=10
					AND branchCredits >= 10
					AND nbrofSeminar >=1
					THEN 'Yes'
					ELSE 'No'
					END AS canGraduate
				FROM Graduationhelp;
			
			
	