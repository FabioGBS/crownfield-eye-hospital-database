-- =====================================================================
-- MODULE: CPU4:103 Introduction to Database
-- PROJECT: Crownfield Eye Hospital Information System
-- DELIVERABLE: Master Submission SQL Script (DDL, DML, DQL, DCL)
-- AUTHOR: Fabio Andrade
-- =====================================================================

DROP DATABASE IF EXISTS CrownfieldEyeHospital;
CREATE DATABASE CrownfieldEyeHospital;
USE CrownfieldEyeHospital;

-- =====================================================================
-- SECTION 1: PHYSICAL SCHEMA DEFINITION (DDL)
-- =====================================================================

-- Table 1: Patient_Table
CREATE TABLE Patient_Table (
    PatientID VARCHAR(10) NOT NULL,
    PFirstName VARCHAR(50) NOT NULL,
    PLastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PostCode VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Patient PRIMARY KEY (PatientID)
);

-- Table 2: Clinician_Table
CREATE TABLE Clinician_Table (
    ClinicianID VARCHAR(10) NOT NULL,
    CFirstName VARCHAR(50) NOT NULL,
    CLastName VARCHAR(50) NOT NULL,
    Speciality VARCHAR(50) NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    CONSTRAINT PK_Clinician PRIMARY KEY (ClinicianID)
);

-- Table 3: Appointment_Table
CREATE TABLE Appointment_Table (
    AppointmentID VARCHAR(10) NOT NULL,
    PatientID VARCHAR(10) NOT NULL,
    ClinicianID VARCHAR(10) NOT NULL,
    AppointmentLocation VARCHAR(100) NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentStatus ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    CONSTRAINT PK_Appointment PRIMARY KEY (AppointmentID),
    CONSTRAINT FK_App_Patient FOREIGN KEY (PatientID) 
        REFERENCES Patient_Table(PatientID) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_App_Clinician FOREIGN KEY (ClinicianID) 
        REFERENCES Clinician_Table(ClinicianID) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table 4: Diagnosis_Table
CREATE TABLE Diagnosis_Table (
    DiagnosisID VARCHAR(10) NOT NULL,
    AppointmentID VARCHAR(10) NOT NULL,
    DiagnosisRef VARCHAR(20) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Severity ENUM('Routine', 'Mild', 'Moderate', 'Severe', 'High', 'Urgent') DEFAULT 'Routine',
    CONSTRAINT PK_Diagnosis PRIMARY KEY (DiagnosisID),
    CONSTRAINT FK_Diag_Appointment FOREIGN KEY (AppointmentID) 
        REFERENCES Appointment_Table(AppointmentID) 
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table 5: Prescription_Table
CREATE TABLE Prescription_Table (
    PrescriptionID VARCHAR(10) NOT NULL,
    AppointmentID VARCHAR(10) NOT NULL,
    DiagnosisID VARCHAR(10) NULL,
    IssuedDate DATE NOT NULL,
    Medicine VARCHAR(150) NOT NULL,
    CONSTRAINT PK_Prescription PRIMARY KEY (PrescriptionID),
    CONSTRAINT FK_Presc_Appointment FOREIGN KEY (AppointmentID) 
        REFERENCES Appointment_Table(AppointmentID) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_Presc_Diagnosis FOREIGN KEY (DiagnosisID) 
        REFERENCES Diagnosis_Table(DiagnosisID) 
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Table 6: Follow_Up_Plan
CREATE TABLE Follow_Up_Plan (
    Follow_UpID VARCHAR(10) NOT NULL,
    AppointmentID VARCHAR(10) NOT NULL,
    PrescriptionID VARCHAR(10) NULL,
    DueDate DATE NOT NULL,
    Priority ENUM('Routine', 'High', 'Urgent') DEFAULT 'Routine',
    Follow_UpStatus ENUM('Pending', 'Completed', 'Cancelled', 'Overdue') DEFAULT 'Pending',
    Notes VARCHAR(255) NULL,
    CONSTRAINT PK_FollowUp PRIMARY KEY (Follow_UpID),
    CONSTRAINT FK_FUP_Appointment FOREIGN KEY (AppointmentID) 
        REFERENCES Appointment_Table(AppointmentID) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_FUP_Prescription FOREIGN KEY (PrescriptionID) 
        REFERENCES Prescription_Table(PrescriptionID) 
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- =====================================================================
-- SECTION 2: DATA POPULATION (DML)
-- =====================================================================

-- Insert Patients (Appendix 1 Legacy + Synthetic Rows)
INSERT INTO Patient_Table (PatientID, PFirstName, PLastName, DateOfBirth, Gender, Phone, Email, PostCode) VALUES
('OP001', 'Amina', 'Yusuf', '1988-04-12', 'Female', '07700900101', 'amina.yusuf@example.com', 'NE1 4AB'),
('OP002', 'Daniel', 'Reed', '1975-09-23', 'Male', '07700900102', 'daniel.reed@example.com', 'N16 7QP'),
('OP003', 'Sofia', 'Bennett', '1992-02-17', 'Female', '07700900103', 'sofia.bennett@example.com', 'E8 2LD'),
('OP004', 'Michael', 'Okoro', '1980-11-05', 'Male', '07700900104', 'michael.okoro@example.com', 'SE6 3RT'),
('OP005', 'Liam', 'Henderson', '1995-03-10', 'Male', '07700900105', 'liam.henderson@example.com', 'B1 1AA'),
('OP006', 'Emma', 'Watson', '1989-07-22', 'Female', '07700900106', 'emma.watson@example.com', 'B2 4QA'),
('OP007', 'Noah', 'Taylor', '2001-12-04', 'Male', '07700900107', 'noah.taylor@example.com', 'CV9 1AP'),
('OP008', 'Olivia', 'Davies', '1968-05-19', 'Female', '07700900108', 'olivia.davies@example.com', 'CV9 2BE'),
('OP009', 'Ethan', 'Evans', '1984-08-30', 'Male', '07700900109', 'ethan.evans@example.com', 'B77 1AB'),
('OP010', 'Ava', 'Thomas', '1999-10-14', 'Female', '07700900110', 'ava.thomas@example.com', 'B78 3DF'),
('OP011', 'Lucas', 'Roberts', '1972-01-28', 'Male', '07700900111', 'lucas.roberts@example.com', 'E1 6AN'),
('OP012', 'Mia', 'Johnson', '2003-06-11', 'Female', '07700900112', 'mia.johnson@example.com', 'EC1A 1BB'),
('OP013', 'James', 'Wilson', '1961-03-15', 'Male', '07700900113', 'james.wilson@example.com', 'SW1A 1AA'),
('OP014', 'Chloe', 'Brown', '1994-09-09', 'Female', '07700900114', 'chloe.brown@example.com', 'W1D 3QU');

-- Insert Clinicians (Appendix 1 Legacy + Synthetic Rows)
INSERT INTO Clinician_Table (ClinicianID, CFirstName, CLastName, Speciality, Phone, Email) VALUES
('DOC001', 'Maya', 'Shah', 'Glaucoma', '07800900001', 'maya.shah@crownfield.nhs.uk'),
('DOC002', 'Leo', 'Grant', 'Retina', '07800900002', 'leo.grant@crownfield.nhs.uk'),
('DOC003', 'Priya', 'Nair', 'Cornea', '07800900003', 'priya.nair@crownfield.nhs.uk'),
('DOC004', 'Arthur', 'Pendleton', 'Cataract', '07800900004', 'arthur.pendleton@crownfield.nhs.uk'),
('DOC005', 'Elena', 'Rostova', 'Pediatric Ophthalmology', '07800900005', 'elena.rostova@crownfield.nhs.uk'),
('DOC006', 'Tariq', 'Mansoor', 'Neuro-Ophthalmology', '07800900006', 'tariq.mansoor@crownfield.nhs.uk'),
('DOC007', 'Hannah', 'Abbott', 'Glaucoma', '07800900007', 'hannah.abbott@crownfield.nhs.uk'),
('DOC008', 'Marcus', 'Vance', 'Retina', '07800900008', 'marcus.vance@crownfield.nhs.uk'),
('DOC009', 'Siddharth', 'Patel', 'Oculoplastics', '07800900009', 'siddharth.patel@crownfield.nhs.uk'),
('DOC010', 'Grace', 'Kim', 'Uveitis', '07800900010', 'grace.kim@crownfield.nhs.uk'),
('DOC011', 'Oliver', 'Twist', 'Cornea', '07800900011', 'oliver.twist@crownfield.nhs.uk'),
('DOC012', 'Sarah', 'Connor', 'Refractive Surgery', '07800900012', 'sarah.connor@crownfield.nhs.uk'),
('DOC013', 'David', 'Beckett', 'Medical Retina', '07800900013', 'david.beckett@crownfield.nhs.uk');

-- Insert Appointments (Appendix 1 Legacy + Synthetic Rows)
INSERT INTO Appointment_Table (AppointmentID, PatientID, ClinicianID, AppointmentLocation, AppointmentDate, AppointmentStatus) VALUES
('APP001', 'OP001', 'DOC001', 'City Road', '2026-10-05', 'Completed'),
('APP002', 'OP002', 'DOC002', 'City Road', '2026-10-05', 'Completed'),
('APP003', 'OP001', 'DOC001', 'Bedford', '2026-11-16', 'Scheduled'),
('APP004', 'OP003', 'DOC001', 'City Road', '2026-10-06', 'Completed'),
('APP005', 'OP004', 'DOC003', 'Croydon', '2026-10-07', 'Completed'),
('APP006', 'OP005', 'DOC004', 'City Road', '2026-10-08', 'Completed'),
('APP007', 'OP006', 'DOC005', 'Bedford', '2026-10-09', 'Completed'),
('APP008', 'OP007', 'DOC006', 'City Road', '2026-10-10', 'Completed'),
('APP009', 'OP008', 'DOC007', 'Croydon', '2026-10-11', 'Scheduled'),
('APP010', 'OP009', 'DOC008', 'City Road', '2026-10-12', 'Cancelled'),
('APP011', 'OP010', 'DOC009', 'Bedford', '2026-10-13', 'Completed'),
('APP012', 'OP011', 'DOC010', 'City Road', '2026-10-14', 'Scheduled'),
('APP013', 'OP012', 'DOC011', 'Croydon', '2026-10-15', 'Completed'),
('APP014', 'OP013', 'DOC012', 'City Road', '2026-10-16', 'Completed'),
('APP015', 'OP014', 'DOC013', 'City Road', '2026-10-17', 'Scheduled');

-- Insert Diagnoses (Appendix 1 Legacy + Synthetic Rows)
INSERT INTO Diagnosis_Table (DiagnosisID, AppointmentID, DiagnosisRef, Description, Severity) VALUES
('D001', 'APP001', 'H40.0', 'Ocular hypertension', 'High'),
('D002', 'APP002', 'H35.81', 'Diabetic macular oedema', 'Urgent'),
('D003', 'APP003', 'H40.0', 'Ocular hypertension', 'Routine'),
('D004', 'APP004', 'H40.00', 'Glaucoma suspect', 'Routine'),
('D005', 'APP005', 'H18.6', 'Keratoconus', 'Routine'),
('D006', 'APP006', 'H25.9', 'Age-related cataract', 'Moderate'),
('D007', 'APP007', 'H50.0', 'Strabismus (childhood)', 'Routine'),
('D008', 'APP008', 'H46.9', 'Optic neuritis', 'Urgent'),
('D009', 'APP009', 'H40.1', 'Primary open-angle glaucoma', 'High'),
('D010', 'APP010', 'H33.2', 'Serous retinal detachment', 'Urgent'),
('D011', 'APP011', 'H02.0', 'Entropion and trichiasis', 'Routine'),
('D012', 'APP012', 'H20.9', 'Anterior uveitis', 'High'),
('D013', 'APP013', 'H16.0', 'Corneal ulceration', 'Urgent'),
('D014', 'APP014', 'H52.1', 'Myopia and astigmatism', 'Mild'),
('D015', 'APP015', 'H35.3', 'Age-related macular degeneration', 'Moderate');

-- Insert Prescriptions (Appendix 1 Legacy atomised + Synthetic Rows)
INSERT INTO Prescription_Table (PrescriptionID, AppointmentID, DiagnosisID, IssuedDate, Medicine) VALUES
('PR001', 'APP001', 'D001', '2026-10-05', 'Latanoprost 0.005% eye drops'),
('PR002', 'APP001', 'D001', '2026-10-05', 'Timolol 0.5% eye drops'),
('PR003', 'APP002', 'D002', '2026-10-05', 'Aflibercept 40mg/ml injection'),
('PR004', 'APP003', 'D003', '2026-11-16', 'Latanoprost 0.005% eye drops'),
('PR005', 'APP005', 'D005', '2026-10-07', 'Sodium chloride 5% drops'),
('PR006', 'APP006', 'D006', '2026-10-08', 'Ketorolac 0.5% ophthalmic'),
('PR007', 'APP007', 'D007', '2026-10-09', 'Atropine 1% eye drops'),
('PR008', 'APP008', 'D008', '2026-10-10', 'Methylprednisolone 500mg IV'),
('PR009', 'APP009', 'D009', '2026-10-11', 'Bimatoprost 0.03% eye drops'),
('PR010', 'APP010', 'D010', '2026-10-12', 'Prednisolone acetate 1%'),
('PR011', 'APP011', 'D011', '2026-10-13', 'Chloramphenicol 0.5% drops'),
('PR012', 'APP012', 'D012', '2026-10-14', 'Dexamethasone 0.1% eye drops'),
('PR013', 'APP013', 'D013', '2026-10-15', 'Moxifloxacin 0.5% eye drops'),
('PR014', 'APP014', 'D014', '2026-10-16', 'Artificial tears carboxymethylcellulose'),
('PR015', 'APP015', 'D015', '2026-10-17', 'Ranibizumab 10mg/ml injection');

-- Insert Follow_Up_Plan (Appendix 1 Legacy + Synthetic Rows)
INSERT INTO Follow_Up_Plan (Follow_UpID, AppointmentID, PrescriptionID, DueDate, Priority, Follow_UpStatus, Notes) VALUES
('FU001', 'APP001', 'PR001', '2026-11-16', 'High', 'Pending', 'Review IOP'),
('FU002', 'APP002', 'PR003', '2026-11-02', 'Urgent', 'Completed', 'OCT before review'),
('FU003', 'APP003', 'PR004', '2027-02-08', 'Routine', 'Pending', 'Visual field test'),
('FU004', 'APP004', NULL,     '2027-04-06', 'Routine', 'Pending', 'Monitor'),
('FU005', 'APP005', 'PR005', '2026-12-02', 'Routine', 'Pending', 'Corneal topography'),
('FU006', 'APP006', 'PR006', '2026-11-10', 'Routine', 'Pending', 'Post-op cataract check'),
('FU007', 'APP007', 'PR007', '2026-12-15', 'Routine', 'Pending', 'Orthoptic assessment'),
('FU008', 'APP008', 'PR008', '2026-10-24', 'Urgent', 'Completed', 'Visual evoked potential test'),
('FU009', 'APP009', 'PR009', '2026-11-20', 'High', 'Pending', 'Pachymetry review'),
('FU010', 'APP010', 'PR010', '2026-10-25', 'Urgent', 'Cancelled', 'Surgical vitrectomy consultation'),
('FU011', 'APP011', 'PR011', '2026-11-30', 'Routine', 'Pending', 'Lid margin assessment'),
('FU012', 'APP012', 'PR012', '2026-10-28', 'High', 'Pending', 'Slit-lamp inflammation check'),
('FU013', 'APP013', 'PR013', '2026-10-22', 'Urgent', 'Pending', 'Corneal re-epithelialisation check'),
('FU014', 'APP014', 'PR014', '2027-04-20', 'Routine', 'Pending', 'Annual refractive refraction check'),
('FU015', 'APP015', 'PR015', '2026-11-14', 'Routine', 'Pending', 'Macular thickness scan');

-- Controlled Modification Integrity Tests
UPDATE Appointment_Table SET AppointmentStatus = 'Completed' WHERE AppointmentID = 'APP009';
DELETE FROM Follow_Up_Plan WHERE Follow_UpID = 'FU010';

-- =====================================================================
-- SECTION 3: ANALYTICAL QUERIES & REPORTING (DQL)
-- =====================================================================

-- Query 1: Comprehensive Patient Care Pathway (Multi-Table Relational JOIN)
SELECT 
    a.AppointmentID,
    CONCAT(p.PFirstName, ' ', p.PLastName) AS PatientName,
    CONCAT(c.CFirstName, ' ', c.CLastName) AS Clinician,
    c.Speciality,
    d.Description AS Diagnosis,
    COALESCE(pr.Medicine, 'None Prescribed') AS PrescribedMedicine,
    a.AppointmentDate
FROM Appointment_Table a
JOIN Patient_Table p ON a.PatientID = p.PatientID
JOIN Clinician_Table c ON a.ClinicianID = c.ClinicianID
LEFT JOIN Diagnosis_Table d ON a.AppointmentID = d.AppointmentID
LEFT JOIN Prescription_Table pr ON a.AppointmentID = pr.AppointmentID
ORDER BY a.AppointmentDate ASC;

-- Query 2: Clinician Workload & Urgent Case Tracking (Aggregation & Grouping)
SELECT 
    CONCAT(c.CFirstName, ' ', c.CLastName) AS Clinician,
    c.Speciality,
    COUNT(DISTINCT a.AppointmentID) AS TotalAppointments,
    COUNT(DISTINCT f.Follow_UpID) AS HighPriorityCases
FROM Clinician_Table c
JOIN Appointment_Table a ON c.ClinicianID = a.ClinicianID
LEFT JOIN Follow_Up_Plan f ON a.AppointmentID = f.AppointmentID AND f.Priority IN ('High', 'Urgent')
GROUP BY c.ClinicianID, Clinician, c.Speciality
ORDER BY TotalAppointments DESC;

-- =====================================================================
-- SECTION 4: VIEWS & STORED PROCEDURES (PROGRAMMABILITY)
-- =====================================================================

-- 1. Operational View: Pending Urgent Follow-Ups
DROP VIEW IF EXISTS v_UrgentFollowUps;
CREATE VIEW v_UrgentFollowUps AS
SELECT 
    f.Follow_UpID,
    p.PatientID,
    CONCAT(p.PFirstName, ' ', p.PLastName) AS PatientName,
    p.Phone AS ContactNumber,
    c.Speciality,
    f.DueDate,
    f.Priority,
    f.Notes
FROM Follow_Up_Plan f
JOIN Appointment_Table a ON f.AppointmentID = a.AppointmentID
JOIN Patient_Table p ON a.PatientID = p.PatientID
JOIN Clinician_Table c ON a.ClinicianID = c.ClinicianID
WHERE f.Priority IN ('High', 'Urgent') 
  AND f.Follow_UpStatus = 'Pending';

-- 2. Stored Procedure: Patient Clinical History Lookup
DROP PROCEDURE IF EXISTS sp_GetPatientSummary;
DELIMITER //
CREATE PROCEDURE sp_GetPatientSummary(IN p_PatientID VARCHAR(10))
BEGIN
    SELECT 
        a.AppointmentID,
        a.AppointmentDate,
        CONCAT(c.CFirstName, ' ', c.CLastName) AS Clinician,
        d.Description AS Diagnosis,
        COALESCE(pr.Medicine, 'None') AS PrescribedMedication,
        f.DueDate AS NextFollowUp
    FROM Appointment_Table a
    JOIN Clinician_Table c ON a.ClinicianID = c.ClinicianID
    LEFT JOIN Diagnosis_Table d ON a.AppointmentID = d.AppointmentID
    LEFT JOIN Prescription_Table pr ON a.AppointmentID = pr.AppointmentID
    LEFT JOIN Follow_Up_Plan f ON a.AppointmentID = f.AppointmentID
    WHERE a.PatientID = p_PatientID
    ORDER BY a.AppointmentDate DESC;
END //
DELIMITER ;

-- Verification of Programmability
SELECT * FROM v_UrgentFollowUps;
CALL sp_GetPatientSummary('OP001');

-- =====================================================================
-- SECTION 5: ACCESS CONTROL & ROLES (DCL - SECURITY & RBAC)
-- =====================================================================

-- 1. Role Definitions
DROP ROLE IF EXISTS 'receptionist_role', 'clinician_role', 'admin_role';
CREATE ROLE 'receptionist_role', 'clinician_role', 'admin_role';

-- 2. Granular Role Grants (Principle of Least Privilege / Caldicott & GDPR)
GRANT SELECT, INSERT, UPDATE ON CrownfieldEyeHospital.Patient_Table TO 'receptionist_role';
GRANT SELECT, INSERT, UPDATE ON CrownfieldEyeHospital.Appointment_Table TO 'receptionist_role';

GRANT SELECT ON CrownfieldEyeHospital.Patient_Table TO 'clinician_role';
GRANT SELECT, UPDATE ON CrownfieldEyeHospital.Appointment_Table TO 'clinician_role';
GRANT SELECT, INSERT, UPDATE ON CrownfieldEyeHospital.Diagnosis_Table TO 'clinician_role';
GRANT SELECT, INSERT, UPDATE ON CrownfieldEyeHospital.Prescription_Table TO 'clinician_role';
GRANT SELECT, INSERT, UPDATE ON CrownfieldEyeHospital.Follow_Up_Plan TO 'clinician_role';

-- 3. User Creation and Role Assignment
DROP USER IF EXISTS 'reception_staff'@'localhost', 'dr_shah'@'localhost';
CREATE USER 'reception_staff'@'localhost' IDENTIFIED BY 'ReceptionPass2026!';
CREATE USER 'dr_shah'@'localhost' IDENTIFIED BY 'ClinicianPass2026!';

GRANT 'receptionist_role' TO 'reception_staff'@'localhost';
GRANT 'clinician_role' TO 'dr_shah'@'localhost';

SET DEFAULT ROLE 'receptionist_role' TO 'reception_staff'@'localhost';
SET DEFAULT ROLE 'clinician_role' TO 'dr_shah'@'localhost';

-- 4. Audit Verification
SHOW GRANTS FOR 'receptionist_role';
SHOW GRANTS FOR 'clinician_role';