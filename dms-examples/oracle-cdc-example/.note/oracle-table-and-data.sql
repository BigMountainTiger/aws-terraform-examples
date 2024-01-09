-- Create Table and add data
DROP TABLE ORACLE.example;

-- If the table is not found, DMS will report an errr.
CREATE TABLE ORACLE.example 
(	
	"ID" NUMBER(*,0) GENERATED ALWAYS AS IDENTITY NOT NULL, 
	"NAME" VARCHAR2(100), 
	 CONSTRAINT "example_PK" PRIMARY KEY ("ID")
);

GRANT SELECT ON ORACLE.example to CDCUSER;
alter table ORACLE.example add supplemental log data (PRIMARY KEY) columns;

INSERT INTO ORACLE.example (name) VALUES('Song Li');
INSERT INTO ORACLE.example (name) VALUES('Joe Bidden');
INSERT INTO ORACLE.example (name) VALUES('Donald Trump');

UPDATE ORACLE.EXAMPLE SET NAME = NAME || ' updated' WHERE ID = 1;
DELETE FROM ORACLE.EXAMPLE WHERE ID = 2;


SELECT * FROM ORACLE.example;