
CREATE TABLE Patient (
  AadharID VARCHAR2(12) PRIMARY KEY,
  Name VARCHAR2(100),
  Address VARCHAR2(255),
  Age NUMBER,
  PrimaryPhysicianID VARCHAR2(12)
);


CREATE TABLE Doctor (
	AadharID VARCHAR2(12) PRIMARY KEY,
	Name VARCHAR2(100),
	Specialty VARCHAR2(100),
	YearsExperience NUMBER
);

ALTER TABLE Patient
ADD CONSTRAINT fk_primary_physician
FOREIGN KEY (PrimaryPhysicianID) REFERENCES Doctor(AadharID);

CREATE TABLE PharmaceuticalCompany (
Name VARCHAR2(100) PRIMARY KEY,
PhoneNumber VARCHAR2(15)
);


CREATE TABLE Drug (
TradeName VARCHAR2(100),
Formula VARCHAR2(100),
CompanyName VARCHAR2(100),
PRIMARY KEY (TradeName, CompanyName),
FOREIGN KEY (CompanyName) REFERENCES PharmaceuticalCompany(Name) ON DELETE CASCADE
);

CREATE TABLE Pharmacy (
PharmacyID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Name VARCHAR2(100),
Address VARCHAR2(255),
PhoneNumber VARCHAR2(15)
);

CREATE TABLE PharmacyDrug (
PharmacyID NUMBER,
TradeName VARCHAR2(100),
CompanyName VARCHAR2(100),
Quantity number(10),
Price NUMBER(10, 2),
PRIMARY KEY (PharmacyID, TradeName, CompanyName),
FOREIGN KEY (PharmacyID) REFERENCES Pharmacy(PharmacyID),
FOREIGN KEY (TradeName, CompanyName) REFERENCES Drug(TradeName, CompanyName)
);


CREATE TABLE Prescription (
PrescriptionID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
DoctorID VARCHAR2(12),
PatientID VARCHAR2(12),
PrescriptionDate DATE,
UNIQUE(DoctorID, PatientID, PrescriptionDate),
FOREIGN KEY (DoctorID) REFERENCES Doctor(AadharID),
FOREIGN KEY (PatientID) REFERENCES Patient(AadharID)
);


CREATE TABLE PrescriptionDrug (
PrescriptionID NUMBER,
TradeName VARCHAR2(100),
CompanyName VARCHAR2(100),
Quantity NUMBER,
PRIMARY KEY (PrescriptionID, TradeName, CompanyName),
FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID) ON DELETE CASCADE,
FOREIGN KEY (TradeName, CompanyName) REFERENCES Drug(TradeName, CompanyName)
);

CREATE TABLE Contract (
ContractID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
CompanyName VARCHAR2(100),
PharmacyID NUMBER,
StartDate DATE,
EndDate DATE,
Content VARCHAR2(500),
SupervisorID VARCHAR2(12),
FOREIGN KEY (CompanyName) REFERENCES PharmaceuticalCompany(Name),
FOREIGN KEY (PharmacyID) REFERENCES Pharmacy(PharmacyID),
FOREIGN KEY (SupervisorID) REFERENCES Doctor(AadharID)
);

INSERT INTO Doctor (AadharID, Name, Specialty, YearsExperience) VALUES
('111122223333', 'Dr. Asha Mehta', 'Cardiology', 15),
('222233334444', 'Dr. Ravi Kumar', 'Neurology', 10),
('333344445555', 'Dr. Nidhi Sharma', 'General Medicine', 8);

-- Insert into Patient
INSERT INTO Patient (AadharID, Name, Address, Age, PrimaryPhysicianID) VALUES
('123456789012', 'Vedant Rao', 'Bangalore, KA', 28, '111122223333'),
('987654321098', 'Anjali Menon', 'Chennai, TN', 34, '222233334444'),
('567890123456', 'Aman Verma', 'Delhi, DL', 41, '333344445555');

-- Insert into PharmaceuticalCompany
INSERT INTO PharmaceuticalCompany (Name, PhoneNumber) VALUES
('Pfizer', '1800123456'),
('Cipla', '1800234567'),
('Sun Pharma', '1800345678'),
('Dr. Reddy''s', '1800456789');

-- Insert into Drug
INSERT INTO Drug (TradeName, Formula, CompanyName) VALUES
('Paracetamol', 'C8H9NO2', 'Pfizer'),
('Aspirin', 'C9H8O4', 'Cipla'),
('Ibuprofen', 'C13H18O2', 'Sun Pharma'),
('Azithromycin', 'C38H72N2O12', 'Dr. Reddy''s');

-- Insert into Pharmacy
INSERT INTO Pharmacy (Name, Address, PhoneNumber) VALUES
('Apollo MedStore', 'MG Road, Bangalore', '08012345678'),
('HealthKart Pharmacy', 'Sector 22, Noida', '0120123456');

-- Insert into PharmacyDrug (assuming PharmacyID 1 and 2)
INSERT INTO PharmacyDrug (PharmacyID, TradeName, CompanyName, Quantity, Price) VALUES
(1, 'Paracetamol', 'Pfizer', 100, 29.99),
(1, 'Aspirin', 'Cipla', 75, 19.50),
(2, 'Ibuprofen', 'Sun Pharma', 60, 34.99),
(2, 'Azithromycin', 'Dr. Reddy''s', 40, 59.00);

-- Insert into Prescription
INSERT INTO Prescription (DoctorID, PatientID, PrescriptionDate) VALUES
('111122223333', '123456789012', TO_DATE('2024-04-19', 'YYYY-MM-DD')),
('222233334444', '987654321098', TO_DATE('2024-04-20', 'YYYY-MM-DD')),
('333344445555', '567890123456', TO_DATE('2024-04-21', 'YYYY-MM-DD'));

-- Insert into PrescriptionDrug (assuming PrescriptionIDs 1, 2, 3)
INSERT INTO PrescriptionDrug (PrescriptionID, TradeName, CompanyName, Quantity) VALUES
(1, 'Paracetamol', 'Pfizer', 10),
(2, 'Aspirin', 'Cipla', 5),
(3, 'Ibuprofen', 'Sun Pharma', 15);

-- Insert into Contract (assuming PharmacyID 1, 2)
INSERT INTO Contract (CompanyName, PharmacyID, StartDate, EndDate, Content, SupervisorID) VALUES
('Pfizer', 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Annual supply contract', '111122223333'),
('Cipla', 1, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2025-02-01', 'YYYY-MM-DD'), 'Bulk purchase agreement', '222233334444'),
('Sun Pharma', 2, '23-APR-24', '24-APR-26', 'Bi-annual supply contract', '111122223333'),
('Dr. Reddy''s', 2, '23-APR-25', '24-APR-27', 'Bi-annual supply contract', '111122223333');

CREATE OR REPLACE PROCEDURE add_patient (
p_aadhar IN VARCHAR2,
p_name IN VARCHAR2,
p_address IN VARCHAR2,
p_age IN NUMBER,
p_doctor IN VARCHAR2
)
IS
BEGIN
INSERT INTO Patient (AadharID, Name, Address, Age, PrimaryPhysicianID)
VALUES (p_aadhar, p_name, p_address, p_age, p_doctor);
DBMS_OUTPUT.PUT_LINE('Patient added successfully.');
END;
/

EXEC add_patient(111223312121, 'Vedant', '105 VK BITS Pilani', 20, 111122223333);
EXEC add_patient(111223312122, 'Manas', '376 VK BITS Pilani', 20, 111122223333);
EXEC add_patient(111223312134, 'Ayaan', '325 VK BITS Pilani', 19, 111122223333);


CREATE OR REPLACE PROCEDURE delete_patient (
    p_aadhar IN VARCHAR2
)
IS
BEGIN
    DELETE FROM Patient WHERE AadharID = p_aadhar;
    DBMS_OUTPUT.PUT_LINE('Patient deleted successfully.');
END;
/

exec delete_patient(111223312121);
exec delete_patient(111223312121);

CREATE OR REPLACE PROCEDURE update_patient (
    p_aadhar IN VARCHAR2,
    p_name IN VARCHAR2,
    p_address IN VARCHAR2,
    p_age IN NUMBER,
    p_doctor IN VARCHAR2
)
IS
BEGIN
    UPDATE Patient
    SET Name = p_name,
        Address = p_address,
        Age = p_age,
        PrimaryPhysicianID = p_doctor
    WHERE AadharID = p_aadhar;
    DBMS_OUTPUT.PUT_LINE('Patient updated successfully.');
END;
/

exec update_patient(111223312121, 'VVB', '204 xyz bphc', 22, 111122223333);

CREATE OR REPLACE PROCEDURE add_doctor (
    p_aadhar_id IN VARCHAR2,
    p_name IN VARCHAR2,
    p_speciality IN VARCHAR2,
    p_years_of_experience IN NUMBER
)
IS
BEGIN
    INSERT INTO Doctor (AadharID, Name, Specialty, YearsExperience)
    VALUES (p_aadhar_id, p_name, p_speciality, p_years_of_experience);
    DBMS_OUTPUT.PUT_LINE('Doctor added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding doctor: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE delete_doctor (
    p_aadhar IN VARCHAR2
)
IS
BEGIN
    DELETE FROM Doctor WHERE AadharID = p_aadhar;
    DBMS_OUTPUT.PUT_LINE('Doctor deleted successfully.');
END;
/

CREATE OR REPLACE PROCEDURE update_doctor (
    p_aadhar IN varchar2,
    p_name IN VARCHAR2,
    p_speciality IN VARCHAR2,
    p_years_of_experience IN NUMBER
)
IS
BEGIN
    UPDATE Doctor
    SET Name = p_name,
        Specialty = p_speciality,
        YearsExperience = p_years_of_experience
    WHERE AadharID = p_aadhar;
    DBMS_OUTPUT.PUT_LINE('Doctor updated successfully.');
END;
/

CREATE OR REPLACE PROCEDURE add_drug (
    p_trade_name IN VARCHAR2,
    p_company_name IN VARCHAR2,
    p_formula IN VARCHAR2
)
IS
BEGIN
    INSERT INTO Drug (TradeName, CompanyName, Formula)
    VALUES (p_trade_name, p_company_name, p_formula);
    DBMS_OUTPUT.PUT_LINE('Drug added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding drug: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE delete_drug (
    p_trade_name IN VARCHAR2,
    p_company_name IN VARCHAR2
)
IS
BEGIN
    DELETE FROM Drug
    WHERE TradeName = p_trade_name AND CompanyName = p_company_name;
    DBMS_OUTPUT.PUT_LINE('Drug deleted successfully.');
END;
/

CREATE OR REPLACE PROCEDURE update_drug (
    p_trade_name IN VARCHAR2,
    p_company_name IN VARCHAR2,
    p_formula IN VARCHAR2
)
IS
BEGIN
    UPDATE Drug
    SET Formula = p_formula
    WHERE TradeName = p_trade_name AND CompanyName = p_company_name;
    DBMS_OUTPUT.PUT_LINE('Drug updated successfully.');
END;
/

CREATE OR REPLACE PROCEDURE add_prescription (
    p_prescription_id IN VARCHAR2,
    p_patient_id IN VARCHAR2,
    p_doctor_id IN VARCHAR2,
    p_prescription_date IN DATE
)
IS
BEGIN
    INSERT INTO Prescription (PrescriptionID, PatientID, DoctorID, PrescriptionDate)
    VALUES (p_prescription_id, p_patient_id, p_doctor_id, p_prescription_date);
    DBMS_OUTPUT.PUT_LINE('Prescription added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding prescription: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE delete_prescription (
    p_prescription_id IN VARCHAR2
)
IS
BEGIN
    DELETE FROM Prescription WHERE PrescriptionID = p_prescription_id;
    DBMS_OUTPUT.PUT_LINE('Prescription deleted successfully.');
END;
/

CREATE OR REPLACE PROCEDURE update_prescription (
    p_prescription_id IN VARCHAR2,
    p_patient_id IN VARCHAR2,
    p_doctor_id IN VARCHAR2,
    p_date IN DATE
)
IS
BEGIN
    UPDATE Prescription
    SET PatientID = p_patient_id,
        DoctorID = p_doctor_id,
        PrescriptionDate = p_date
    WHERE PrescriptionID = p_prescription_id;
    DBMS_OUTPUT.PUT_LINE('Prescription updated successfully.');
END;
/

CREATE OR REPLACE PROCEDURE add_pharmacy (
    p_pharmacy_id IN VARCHAR2,
    p_name IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phone IN VARCHAR2
)
IS
BEGIN
    INSERT INTO Pharmacy (PharmacyID, Name, Address, PhoneNumber)
    VALUES (p_pharmacy_id, p_name, p_address, p_phone);
    DBMS_OUTPUT.PUT_LINE('Pharmacy added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding pharmacy: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE delete_pharmacy (
    p_pharmacy_id IN VARCHAR2
)
IS
BEGIN
    DELETE FROM Pharmacy WHERE PharmacyID = p_pharmacy_id;
    DBMS_OUTPUT.PUT_LINE('Pharmacy deleted successfully.');
END;
/

CREATE OR REPLACE PROCEDURE update_pharmacy (
    p_pharmacy_id IN number,
    p_name IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phone IN VARCHAR2
)
IS
BEGIN
    UPDATE Pharmacy
    SET Name = p_name,
        Address = p_address,
        PhoneNumber = p_phone
    WHERE PharmacyID = p_pharmacy_id;
    DBMS_OUTPUT.PUT_LINE('Pharmacy updated successfully.');
END;
/

CREATE OR REPLACE PROCEDURE add_pharmaceutical_company (
    p_company_name IN VARCHAR2,
    p_phone IN VARCHAR2
)
IS
BEGIN
    INSERT INTO PharmaceuticalCompany (Name, PhoneNumber)
    VALUES (p_company_name, p_phone);
    DBMS_OUTPUT.PUT_LINE('Pharmaceutical company added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding pharmaceutical company: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE delete_pharma_company (
    p_company_name IN VARCHAR2
)
IS
BEGIN
    DELETE FROM PharmaceuticalCompany WHERE Name = p_company_name;
    DBMS_OUTPUT.PUT_LINE('Pharmaceutical company deleted successfully.');
END;
/

CREATE OR REPLACE PROCEDURE update_pharma_company (
    p_company_name IN VARCHAR2,
    p_phone IN VARCHAR2
)
IS
BEGIN
    UPDATE PharmaceuticalCompany
    SET PhoneNumber = p_phone
    WHERE Name = p_company_name;
    DBMS_OUTPUT.PUT_LINE('Pharmaceutical company updated successfully.');
END;
/

CREATE OR REPLACE PROCEDURE add_contract (
    p_contract_id IN VARCHAR2,
    p_pharmacy_id IN VARCHAR2,
    p_company_name IN VARCHAR2,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_contract_content IN VARCHAR2,
    p_supervisor_id IN VARCHAR2
)
IS
BEGIN
    INSERT INTO Contract (ContractID, PharmacyID, CompanyName, StartDate, EndDate, Content, SupervisorID)
    VALUES (p_contract_id, p_pharmacy_id, p_company_name, p_start_date, p_end_date, p_contract_content, p_supervisor_id);
    DBMS_OUTPUT.PUT_LINE('Contract added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding contract: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE delete_contract (
    p_contract_id IN VARCHAR2
)
IS
BEGIN
    DELETE FROM Contract WHERE ContractID = p_contract_id;
    DBMS_OUTPUT.PUT_LINE('Contract deleted successfully.');
END;
/

CREATE OR REPLACE PROCEDURE update_contract (
    p_contract_id IN VARCHAR2,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_content IN VARCHAR2,
    p_supervisor_id IN VARCHAR2
)
IS
BEGIN
    UPDATE Contract
    SET StartDate = p_start_date,
        EndDate = p_end_date,
        Content = p_content,
        SupervisorID = p_supervisor_id
    WHERE ContractID = p_contract_id;
    DBMS_OUTPUT.PUT_LINE('Contract updated successfully.');
END;
/

CREATE OR REPLACE PROCEDURE get_prescriptions_between_dates (
p_patient_id IN VARCHAR2,
p_start_date IN DATE,
p_end_date IN DATE
)
IS
BEGIN
FOR rec IN (
SELECT p.PrescriptionID, p.PrescriptionDate, d.Name AS DoctorName
FROM Prescription p
JOIN Doctor d ON p.DoctorID = d.AadharID
WHERE p.PatientID = p_patient_id AND p.PrescriptionDate BETWEEN p_start_date AND p_end_date
)
LOOP
DBMS_OUTPUT.PUT_LINE('Prescription ID: ' || rec.PrescriptionID || ', Date: ' || rec.PrescriptionDate || ', Doctor: ' || rec.DoctorName);
END LOOP;
END;
/

EXEC get_prescriptions_between_dates(123456789012, '19-APR-25', '21-APR-25');

CREATE OR REPLACE PROCEDURE get_prescription_by_date (
p_patient_id IN VARCHAR2,
p_date IN DATE
)
IS
BEGIN
FOR rec IN (
SELECT pd.TradeName, pd.CompanyName, pd.Quantity
FROM Prescription p
JOIN PrescriptionDrug pd ON p.PrescriptionID = pd.PrescriptionID
WHERE p.PatientID = p_patient_id AND p.PrescriptionDate = p_date
)
LOOP
DBMS_OUTPUT.PUT_LINE('Drug: ' || rec.TradeName || ' | Company: ' || rec.CompanyName || ' | Qty: ' || rec.Quantity);
END LOOP;
END;
/

exec get_prescription_by_date(123456789012, '20-APR-25');

CREATE OR REPLACE PROCEDURE get_drugs_by_company (
p_company_name IN VARCHAR2
)
IS
BEGIN
FOR rec IN (
SELECT TradeName, formula
FROM Drug
WHERE CompanyName = p_company_name
) LOOP
DBMS_OUTPUT.PUT_LINE('Trade Name: ' || rec.TradeName || ', Formula: ' || rec.formula);
END LOOP;
END;
/

exec get_drugs_by_company('Pfizer');

CREATE OR REPLACE PROCEDURE get_stock_position (
p_pharmacy_id IN VARCHAR2
)
IS
BEGIN
FOR rec IN (
SELECT d.TradeName, s.quantity, s.price
FROM PharmacyDrug s
JOIN Drug d ON s.TradeName = d.TradeName AND s.CompanyName = d.CompanyName
WHERE s.PharmacyID = p_pharmacy_id
) LOOP
DBMS_OUTPUT.PUT_LINE('Drug: ' || rec.TradeName || ', Quantity: ' || rec.quantity || ', Price: ' || rec.price);
END LOOP;
END;
/

exec get_stock_position(1);


CREATE OR REPLACE PROCEDURE get_contact_details (
p_pharmacy_id IN number,
p_company_name IN VARCHAR2
)
IS
v_phone_pharmacy VARCHAR2(20);
v_phone_company VARCHAR2(20);
BEGIN
SELECT PhoneNumber INTO v_phone_pharmacy FROM Pharmacy WHERE PharmacyID = p_pharmacy_id;
SELECT PhoneNumber INTO v_phone_company FROM PharmaceuticalCompany WHERE name = p_company_name;

DBMS_OUTPUT.PUT_LINE('Pharmacy Phone: ' || v_phone_pharmacy);
DBMS_OUTPUT.PUT_LINE('Company Phone: ' || v_phone_company);
END;
/

exec get_contact_details(1, 'Pfizer');


CREATE OR REPLACE PROCEDURE get_patients_by_doctor (
p_doctor_id IN VARCHAR2
)
IS
BEGIN
FOR rec IN (
SELECT p.aadharID, p.name, p.age
FROM Patient p
WHERE p.PrimaryPhysicianID = p_doctor_id
) LOOP
DBMS_OUTPUT.PUT_LINE('Patient ID: ' || rec.aadharID || ', Name: ' || rec.name || ', Age: ' || rec.age);
END LOOP;
END;
/

exec get_patients_by_doctor (111122223333);

CREATE OR REPLACE PROCEDURE get_contract_details (
    p_pharmacy_id IN number,
    p_company_name IN VARCHAR2
)
IS
BEGIN
    FOR rec IN (
        SELECT c.ContractID, c.StartDate, c.EndDate, c.Content, c.supervisorID
        FROM Contract c
        WHERE c.pharmacyID = p_pharmacy_id
        AND c.CompanyName = p_company_name
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Contract ID: ' || rec.ContractID);
        DBMS_OUTPUT.PUT_LINE('Start Date: ' || rec.StartDate);
        DBMS_OUTPUT.PUT_LINE('End Date: ' || rec.EndDate);
        DBMS_OUTPUT.PUT_LINE('Contract Content: ' || rec.Content);
        DBMS_OUTPUT.PUT_LINE('Supervisor ID: ' || rec.supervisorID);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
END;
/

exec get_contract_details(1, 'Pfizer');
exec get_contract_details(2, 'Cipla');