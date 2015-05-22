/* 
Kim Egenvall, Carl Fredriksson


*/


CREATE OR REPLACE VIEW CourseQueuePositions AS 
	SELECT student,course,(SELECT COUNT(*) FROM Register R
		WHERE R.course = Register.course AND R.queuePlace <= Register.queuePlace) AS queuePosition
		FROM Register;
		
	CREATE OR REPLACE VIEW CourseSlots AS
		WITH Reg AS
			(SELECT course AS code, COUNT(*) AS registered 
			FROM Takes GROUP BY course),
		LimitAndRegd AS
			(SELECT LimitedCourses.code, LimitedCourses.students AS limit, registered 
			FROM LimitedCourses  JOIN Reg ON LimitedCourses.code = Reg.code),
		CoursesWithSlots AS
			(SELECT C.code, (limit-registered) AS slots 
			FROM LimitAndRegd  RIGHT JOIN 
		Courses C ON LimitAndRegd.code = C.code)
		SELECT code, CASE WHEN
			CoursesWithSlots.slots <= 0
		THEN 0
		ELSE 1
	END AS hasSlots FROM CoursesWithSlots;
	
	
	
CREATE OR REPLACE TRIGGER Register
	INSTEAD OF INSERT ON Registrations
	REFERENCING NEW AS newRegistration
	FOR EACH ROW
		DECLARE
			slots CourseSlots.hasSlots%TYPE;
			hasread NUMBER;
			preRequisite NUMBER;
			registered NUMBER;
			waiting NUMBER;
		BEGIN
			SELECT COUNT(*) INTO preRequisite FROM Requires R WHERE 
			R.course = :newRegistration.course AND NOT EXISTS 
				(SELECT * FROM PassedCourses P WHERE P.student = :newRegistration.student 
				AND P.code = R.requiredcourse);
			SELECT COUNT(*) INTO hasread FROM PassedCourses P WHERE
			P.student = :newRegistration.student AND P.code = :newRegistration.course;
			IF hasread != 0 THEN
				RAISE_APPLICATION_ERROR(-20001, 'Course has already been passed');
			ELSIF preRequisite != 0 THEN
				RAISE_APPLICATION_ERROR(-20002, 'Prerequisites for course not met');
			ELSE
				SELECT hasSlots INTO slots FROM CourseSlots 
				WHERE :newRegistration.course = CourseSlots.code;
				SELECT COUNT(*) INTO registered From Takes WHERE 
					:newRegistration.student = Takes.student AND :newRegistration.course = Takes.course;
				IF registered != 0 THEN
					RAISE_APPLICATION_ERROR(-20003, 'Student is already registered on this course');
				ELSE
					IF slots = 1 THEN
						INSERT INTO Takes VALUES (:newRegistration.student, :newRegistration.course);
					ELSE
						SELECT COUNT(*) INTO waiting FROM Register WHERE 
						:newRegistration.student = Register.student AND :newRegistration.course = Register.course;
						IF waiting != 0 THEN
							RAISE_APPLICATION_ERROR(-20014, 'Student is already in queue');
						ELSE
							INSERT INTO Register VALUES (:newRegistration.student, :newRegistration.course, QueuePlace.nextval);
						END IF;
					END IF;
				END IF;
			END IF;
		END;


CREATE OR REPLACE TRIGGER UnRegister
	INSTEAD OF DELETE ON Registrations
	REFERENCING OLD AS oldRegistration
	FOR EACH ROW
		DECLARE
			waitingStudents NUMBER;
			firstInQueue VARCHAR(8);
			studentsTaking NUMBER;
			studLimit NUMBER;
			countVar NUMBER;
		BEGIN
			IF :oldRegistration.status = 'registered' THEN
				SELECT COUNT(*) INTO waitingStudents FROM Registrations
				WHERE Registrations.course = :oldRegistration.course AND Registrations.status = 'waiting';
				
				SELECT COUNT(*) INTO countVar FROM LimitedCourses
					WHERE :oldRegistration.course = LimitedCourses.code;
				IF countVar = 1  THEN
					SELECT students INTO studLimit FROM LimitedCourses WHERE :oldRegistration.course = LimitedCourses.code;
				ELSE
					countVar := 0;
				END IF;
			
				SELECT COUNT(*) INTO studentsTaking FROM Takes 
				WHERE Takes.course = :oldRegistration.course;
				IF waitingStudents > 0 AND (studentsTaking-studLimit) = 0  THEN
					SELECT CQP.student INTO firstInQueue
					FROM CourseQueuePositions CQP
					WHERE CQP.course = :oldRegistration.course AND CQP.queuePosition = 1;
					DELETE FROM Register
					WHERE Register.student = firstInQueue AND Register.course = :oldRegistration.course;
					UPDATE Takes 
					SET Takes.student = firstInQueue
					WHERE Takes.student = :oldRegistration.student AND Takes.course = :oldRegistration.course;
				ELSE
					DELETE FROM Takes 
					WHERE Takes.student = :oldRegistration.student AND Takes.course = :oldRegistration.course;
				END IF;
			ELSE
				DELETE FROM Register
				WHERE Register.student = :oldRegistration.student AND Register.course = :oldRegistration.course;
			END IF;
		END;
