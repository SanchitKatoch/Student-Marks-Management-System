

-- Create Database
CREATE DATABASE StudentMarksDB;
USE StudentMarksDB;

-- TABLE 1: Departments
-- Stores information about different academic departments.
CREATE TABLE Departments (
  DeptID INT PRIMARY KEY AUTO_INCREMENT,
  DeptName VARCHAR(100) UNIQUE NOT NULL,
  HODName VARCHAR(100)
);


-- TABLE 2: Courses
-- Stores details about all available courses in departments.

CREATE TABLE Courses (
  CourseID INT PRIMARY KEY AUTO_INCREMENT,
  DeptID INT,
  CourseCode VARCHAR(20) UNIQUE NOT NULL,
  CourseName VARCHAR(100),
  Credits INT CHECK (Credits BETWEEN 1 AND 6),
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);


-- TABLE 3: Students
-- Stores basic information about students.
CREATE TABLE Students (
  StudentID INT PRIMARY KEY AUTO_INCREMENT,
  RollNo VARCHAR(20) UNIQUE NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Gender VARCHAR(10),
  DOB DATE,
  DeptID INT,
  Email VARCHAR(100) UNIQUE,
  Phone VARCHAR(15),
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

-- TABLE 4: Subjects
-- Each course may have multiple subjects.
CREATE TABLE Subjects (
  SubjectID INT PRIMARY KEY AUTO_INCREMENT,
  CourseID INT,
  SubjectCode VARCHAR(20) UNIQUE NOT NULL,
  SubjectName VARCHAR(100),
  MaxMarks INT DEFAULT 100,
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


-- TABLE 5: Exams
-- Stores exam information (Mid-term, End-term, etc.)
CREATE TABLE Exams (
  ExamID INT PRIMARY KEY AUTO_INCREMENT,
  ExamName VARCHAR(50),
  ExamDate DATE
);

-- TABLE 6: Marks
-- Stores marks obtained by each student in each subject in a given exam.
CREATE TABLE Marks (
  MarkID INT PRIMARY KEY AUTO_INCREMENT,
  StudentID INT,
  SubjectID INT,
  ExamID INT,
  MarksObtained INT CHECK (MarksObtained BETWEEN 0 AND 100),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
  FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
  FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);

-- TABLE 7: Attendance
-- Stores attendance record for each student in each subject.
CREATE TABLE Attendance (
  AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
  StudentID INT,
  SubjectID INT,
  TotalClasses INT,
  ClassesAttended INT,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);


-- TABLE 8: Teachers
-- Information about teachers handling courses/subjects.
CREATE TABLE Teachers (
  TeacherID INT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(15),
  DeptID INT,
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);


-- TABLE 9: Feedback
-- Students can give feedback on teachers or subjects.
CREATE TABLE Feedback (
  FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
  StudentID INT,
  TeacherID INT,
  SubjectID INT,
  Rating INT CHECK (Rating BETWEEN 1 AND 5),
  Comments TEXT,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID),
  FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);


-- INSERT SAMPLE DATA
-- Insert Departments
INSERT INTO Departments (DeptName, HODName) VALUES
('Computer Science', 'Dr. Ramesh Sharma'),
('Mathematics', 'Dr. Kavita Mehta'),
('Physics', 'Dr. Suresh Kumar');

-- Insert Courses
INSERT INTO Courses (DeptID, CourseCode, CourseName, Credits) VALUES
(1, 'CS101', 'BCA', 4),
(1, 'CS201', 'MCA', 5),
(2, 'MA101', 'B.Sc Mathematics', 4),
(3, 'PH101', 'B.Sc Physics', 4);

-- Insert Students
INSERT INTO Students (RollNo, Name, Gender, DOB, DeptID, Email, Phone) VALUES
('CS001', 'Roshan Kumar Singh', 'Male', '2003-02-15', 1, 'roshan.cs@uni.edu', '9876543210'),
('CS002', 'Anurag Kumar', 'Male', '2002-12-10', 1, 'anurag.mca@uni.edu', '9876500012'),
('MA001', 'Ritika Sharma', 'Female', '2003-08-20', 2, 'ritika.math@uni.edu', '9823456712');

-- Insert Subjects
INSERT INTO Subjects (CourseID, SubjectCode, SubjectName, MaxMarks) VALUES
(1, 'CSF101', 'Programming Fundamentals', 100),
(1, 'CSD201', 'Database Management', 100),
(2, 'CSA501', 'Advanced Java', 100),
(3, 'MAP301', 'Algebra', 100);

-- Insert Exams
INSERT INTO Exams (ExamName, ExamDate) VALUES
('Mid-Term', '2025-03-10'),
('End-Term', '2025-05-25');

-- Insert Marks
INSERT INTO Marks (StudentID, SubjectID, ExamID, MarksObtained) VALUES
(1, 1, 1, 78),
(1, 2, 1, 85),
(2, 3, 2, 90),
(3, 4, 2, 88);

-- Insert Attendance
INSERT INTO Attendance (StudentID, SubjectID, TotalClasses, ClassesAttended) VALUES
(1, 1, 40, 38),
(1, 2, 42, 39),
(2, 3, 45, 44),
(3, 4, 40, 36);

-- Insert Teachers
INSERT INTO Teachers (Name, Email, Phone, DeptID) VALUES
('Komal Mishra', 'komal.mishra@uni.edu', '9988776655', 1),
('Amit Verma', 'amit.verma@uni.edu', '9988123456', 2);

-- Insert Feedback
INSERT INTO Feedback (StudentID, TeacherID, SubjectID, Rating, Comments) VALUES
(1, 1, 2, 5, 'Excellent explanation and practical examples.'),
(2, 1, 3, 4, 'Good teaching style, could improve pace.');

-- BASIC SELECT QUERIES (VIEW ALL TABLES)


SELECT * FROM Departments;
SELECT * FROM Courses;
SELECT * FROM Students;
SELECT * FROM Subjects;
SELECT * FROM Exams;
SELECT * FROM Marks;
SELECT * FROM Attendance;
SELECT * FROM Teachers;
SELECT * FROM Feedback;

-- ANALYTICAL AND REPORT QUERIES
-- Show all students with their department
SELECT s.Name, s.RollNo, d.DeptName
FROM Students s
JOIN Departments d ON s.DeptID = d.DeptID;

-- Show marks of all students with subjects and exams
SELECT s.Name, sub.SubjectName, m.MarksObtained, e.ExamName
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
JOIN Exams e ON m.ExamID = e.ExamID;

-- Show students with their attendance percentage
SELECT s.Name, sub.SubjectName,
       (a.ClassesAttended / a.TotalClasses) * 100 AS Attendance_Percentage
FROM Attendance a
JOIN Students s ON a.StudentID = s.StudentID
JOIN Subjects sub ON a.SubjectID = sub.SubjectID;

-- Average marks per subject
SELECT sub.SubjectName, AVG(m.MarksObtained) AS Average_Marks
FROM Marks m
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
GROUP BY sub.SubjectName;

-- Students scoring above 85
SELECT s.Name, sub.SubjectName, m.MarksObtained
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
WHERE m.MarksObtained > 85;

-- Teacher feedback report
SELECT t.Name AS Teacher, sub.SubjectName, AVG(f.Rating) AS Avg_Rating
FROM Feedback f
JOIN Teachers t ON f.TeacherID = t.TeacherID
JOIN Subjects sub ON f.SubjectID = sub.SubjectID
GROUP BY t.Name, sub.SubjectName;

-- ADDITIONAL QUERIES
-- Students in Computer Science
SELECT Name, RollNo FROM Students
WHERE DeptID = (SELECT DeptID FROM Departments WHERE DeptName = 'Computer Science');

-- Subjects offered under MCA
SELECT SubjectName FROM Subjects
WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'MCA');

-- Top 5 marks
SELECT s.Name, sub.SubjectName, m.MarksObtained
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
ORDER BY m.MarksObtained DESC LIMIT 5;

-- Attendance below 75%
SELECT s.Name, sub.SubjectName,
       (a.ClassesAttended / a.TotalClasses) * 100 AS Attendance_Percentage
FROM Attendance a
JOIN Students s ON a.StudentID = s.StudentID
JOIN Subjects sub ON a.SubjectID = sub.SubjectID
WHERE (a.ClassesAttended / a.TotalClasses) * 100 < 75;

-- Department-wise student count
SELECT d.DeptName, COUNT(s.StudentID) AS Total_Students
FROM Departments d
LEFT JOIN Students s ON d.DeptID = s.DeptID
GROUP BY d.DeptName;

-- Highest and lowest marks
SELECT sub.SubjectName, MAX(m.MarksObtained) AS Highest, MIN(m.MarksObtained) AS Lowest
FROM Marks m
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
GROUP BY sub.SubjectName;

-- Average marks per exam
SELECT e.ExamName, AVG(m.MarksObtained) AS Average_Marks
FROM Marks m
JOIN Exams e ON m.ExamID = e.ExamID
GROUP BY e.ExamName;

-- Update phone number
UPDATE Students SET Phone = '9998877665' WHERE RollNo = 'CS001';

-- Update marks after revaluation
UPDATE Marks SET MarksObtained = MarksObtained + 5
WHERE StudentID = 1 AND SubjectID = 2 AND ExamID = 1;

-- Change HOD
UPDATE Departments SET HODName = 'Dr. Neha Patel' WHERE DeptName = 'Mathematics';

-- Delete student
DELETE FROM Students WHERE StudentID = 3;

-- Delete feedback of a teacher
DELETE FROM Feedback WHERE TeacherID = 2;

-- Delete subjects of Physics course
DELETE FROM Subjects WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'B.Sc Physics');

-- Students above average in DBMS
SELECT s.Name, m.MarksObtained
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
WHERE SubjectID = (SELECT SubjectID FROM Subjects WHERE SubjectName = 'Database Management')
AND MarksObtained > (SELECT AVG(MarksObtained) FROM Marks WHERE SubjectID = 2);

-- Feedback below rating 3
SELECT s.Name, f.Rating, f.Comments
FROM Feedback f
JOIN Students s ON f.StudentID = s.StudentID
WHERE f.Rating < 3;

-- Student, Subject, Marks, Teacher
SELECT s.Name AS Student, sub.SubjectName, m.MarksObtained, t.Name AS Teacher
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
JOIN Teachers t ON t.DeptID = s.DeptID;

-- Department, Course, Subject hierarchy
SELECT d.DeptName, c.CourseName, sub.SubjectName
FROM Departments d
JOIN Courses c ON d.DeptID = c.DeptID
JOIN Subjects sub ON c.CourseID = sub.CourseID;

-- Create performance view
CREATE VIEW StudentPerformance AS
SELECT s.Name, sub.SubjectName, e.ExamName, m.MarksObtained
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
JOIN Exams e ON m.ExamID = e.ExamID;

-- Display view
SELECT * FROM StudentPerformance;

-- Add result status column
ALTER TABLE Marks ADD COLUMN ResultStatus VARCHAR(10);

-- Update result status
UPDATE Marks
SET ResultStatus = CASE
    WHEN MarksObtained >= 40 THEN 'PASS'
    ELSE 'FAIL'
END;