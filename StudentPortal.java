import java.sql.*; // JDBC stuff.
import java.io.*;  // Reading user input.
/**
* Kim Egenvall, Carl Fredriksson Group 39.
*
*/
public class StudentPortal
{
	/* This is the driving engine of the program. It parses the
	 * command-line arguments and calls the appropriate methods in
	 * the other classes.
	 *
	 * You should edit this file in two ways:
	 * 	1) 	Insert your database username and password (no @medic1!)
	 *		in the proper places.
	 *	2)	Implement the three functions getInformation, registerStudent
	 *		and unregisterStudent.
	 */
	public static void main(String[] args)
	{
		if (args.length == 1) {
			try {
				DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
				String url = "jdbc:oracle:thin:@tycho.ita.chalmers.se:1521/kingu.ita.chalmers.se";
				String userName = "vtda357_039"; // Your username goes here!
				String password = "vtda357_039"; // Your password goes here!
				Connection conn = DriverManager.getConnection(url,userName,password);

				String student = args[0]; // This is the identifier for the student.
				BufferedReader input = new BufferedReader(new InputStreamReader(System.in));
				System.out.println("Welcome!");
				while(true) {
					System.out.println("Please choose a mode of operation:");
					System.out.print("? > ");
					String mode = input.readLine();
					if ((new String("information")).startsWith(mode.toLowerCase())) {
						/* Information mode */
						getInformation(conn, student);
					} else if ((new String("register")).startsWith(mode.toLowerCase())) {
						/* Register student mode */
						System.out.print("Register for what course? > ");
						String course = input.readLine();
						registerStudent(conn, student, course);
					} else if ((new String("unregister")).startsWith(mode.toLowerCase())) {
						/* Unregister student mode */
						System.out.print("Unregister from what course? > ");
						String course = input.readLine();
						unregisterStudent(conn, student, course);
					} else if ((new String("quit")).startsWith(mode.toLowerCase())) {
						System.out.println("Goodbye!");
						break;
					} else {
						System.out.println("Unknown argument, please choose either information, register, unregister or quit!");
						continue;
					}
				}
				conn.close();
			} catch (SQLException e) {
				System.err.println(e);
				System.exit(2);
			} catch (IOException e) {
				System.err.println(e);
				System.exit(2);
			}
		} else {
			System.err.println("Wrong number of arguments");
			System.exit(3);
		}
	}

	static void getInformation(Connection conn, String student)
	{

		/* Info 
		Get: 
		StudentName,Program,Branch*/ 
		Statement stmt = null;
		try{

			stmt = conn.createStatement();
			String sql;
			sql = "SELECT name,program,branch FROM StudentsFollowing WHERE StudentsFollowing.id = '"+student+"'";
			ResultSet rs = stmt.executeQuery(sql);


			while(rs.next()){
				//Retrieve by column name
				String studname  = rs.getString("name");
				String prog = rs.getString("program");
				String branch = rs.getString("branch");


				//Display values
				System.out.println("Name: " + studname);
				System.out.println("Program: " + prog);
				System.out.println("Branch: " + branch);

			}


			/* Read courses */ 
			sql = "SELECT course,coursename,credits,grade FROM FinishedCourses WHERE FinishedCourses.student = '"+student+"'";
			rs = stmt.executeQuery(sql);

			while(rs.next()){

				String coursename = rs.getString("coursename");
				String code = rs.getString("course");
				int credits = rs.getInt("credits");
				String grade = rs.getString("grade");


				//Display values
				System.out.println(coursename + "("+ code + ")" + ", " + credits + "p: " + grade);
			}



			/* Registered courses (name (code), credits: status*/ 
			sql = "SELECT course,coursename,status,credits FROM Registrations INNER "
					+ "JOIN Courses	ON Registrations.course = Courses.code "
					+ "AND Registrations.student = '"+student+"'";

			rs = stmt.executeQuery(sql);
			System.out.println("REGISTERED COURSES BELOW");
			while(rs.next()){

				String coursename = rs.getString("coursename");
				String code = rs.getString("course");
				int credits = rs.getInt("credits");
				String status = rs.getString("status");

					// FIX THIS
				if(status.equals("waiting")){
					ResultSet rs2;
					Statement stmt2 = conn.createStatement();
					sql = "SELECT queueposition FROM CourseQueuePositions WHERE"
							+" student = '"+student+"' AND course = '"+code+"'";
					rs2 = stmt2.executeQuery(sql);
					while(rs2.next()){
						int queueplace = rs2.getInt("queueposition");
						System.out.println(coursename + "("+ code + ")" + ", " + credits + "p: " + status + "as number: " + queueplace);
					}
					rs2.close();
				}
				else{
					System.out.println(coursename + "("+ code + ")" + ", " + credits + "p: " + status);

				}

			}

			/*PathtoGrad  seminar taken,mathcred,sceincred,total cred, fulfill?*/
			sql = "SELECT nbrofseminar,mathcredits,sciencecredits,totalcredits,cangraduate FROM PathToGraduation"
					+ " WHERE id = '"+student+"'";


			rs = stmt.executeQuery(sql);

			while(rs.next()){

				int nbrofseminar = rs.getInt("nbrofseminar");
				int mathcredits = rs.getInt("mathcredits");
				int sciencecredits = rs.getInt("sciencecredits");
				int totalcredits = rs.getInt("totalcredits");
				String canGraduate = rs.getString("cangraduate");


				System.out.println("Seminar courses taken: " + nbrofseminar);
				System.out.println("Math credits taken: " + mathcredits);
				System.out.println("Science credits taken: " + sciencecredits);
				System.out.println("Total credits taken: " + totalcredits);
				System.out.println("Fulfills the requirements for graduation: " + canGraduate);

			}

		}
		catch(SQLException se){
			System.out.println(se.getMessage());
		}

	}


	static void registerStudent(Connection conn, String student, String course)
	{
		String registeredWaiting = null,registered = null;
		Statement stmt = null;
		String sql;
		ResultSet rs;
		try{
			
			stmt = conn.createStatement();

			sql = "INSERT INTO Registrations (course, student) VALUES "
					+ "('"+course +"', '"+student+"')";
			stmt.executeQuery(sql);

		}
		catch(SQLException se){
			System.out.println(se.getMessage());
			return;
		}

		/*If we get here it means student is either registered or waiting..*/
		/*Check which status..*/
		String status;
		String coursename;
		String coursecode;
		int queuepos;
		sql = "SELECT course,coursename,status FROM Registrations R WHERE R.student = '"+student+"'"
				+ "AND R.course = '"+course+"'";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while(rs.next()){
				status = rs.getString("status");
				coursename = rs.getString("coursename");
				coursecode = rs.getString("course");


				if(status.equals("waiting")){
					sql = "SELECT queueposition FROM CourseQueuePositions WHERE "
							+ "student = '"+student+"' AND course = '"+course+"'";
					rs = stmt.executeQuery(sql);
					while(rs.next()){
						queuepos = rs.getInt("queueposition");
						//Display waiting message
						registeredWaiting = "Course: " + coursecode+ " " + coursename + " is full,"
								+ "you are put in waiting list as number " + queuepos;
					}	
				}
				else{
					registered = "You have been registered on " + course;
				}


				
			}

		} catch (SQLException e1) {
			System.out.println(e1.getMessage());


		}

		
			
		if(registeredWaiting != null)
			System.out.println(registeredWaiting);

		if(registered != null)
			System.out.println(registered);

		
	}

	static void unregisterStudent(Connection conn, String student, String course)
	{
		Statement stmt = null;
		String sql;
		ResultSet rs;
		try{
			
			stmt = conn.createStatement();
			sql = "DELETE FROM Registrations WHERE student = '"+student+"' AND course = '"+course+"'";
			rs = stmt.executeQuery(sql);
			

		}
		catch(SQLException se){
			System.out.println(se.getMessage());
			return;
		}
		System.out.println("Sucessfully unregistered");
	}
}