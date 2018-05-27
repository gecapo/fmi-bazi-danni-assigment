-- Create Initial Tables
create table Doctors
(
    [EGN] [varchar](10) NOT NULL,
    [FulllName] [varchar](50) NOT NULL,
    [Address] [varchar](250) NULL,
    [PhoneNumber] [varchar](50) NULL,
    [Specilization] [varchar](50) NULL,
    CONSTRAINT [PK_Doctors] PRIMARY KEY CLUSTERED
   (
      [EGN] asc
   )
)

create table Beds
(
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Floor] [numeric](2,0) NULL,
    [Room] [numeric](3,0) NULL,
    [IsTaken] [bit] NULL
        CONSTRAINT [PK_Beds] PRIMARY KEY CLUSTERED
   (
      [Id] asc
   )
)

create table Patients
(
    [EGN] [varchar](10) NOT NULL,
    [FulllName] [varchar](50) NOT NULL,
    [Address] [varchar](50) NULL,
    [Sex] [varchar](6) NULL,
    [Diagnose] [varchar](MAX) NULL,
    [Birthdate] [Date] NULL,
    Doctor [varchar](10) references Doctors(EGN),
    [Bed] [int] REFERENCES Beds(Id),
    CONSTRAINT [PK_Patients] PRIMARY KEY CLUSTERED
   (
      [EGN] asc
   )
)


create table Drugs
(
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [FulllName] [varchar](50) NOT NULL,
    [Quantity] [varchar](50) NOT NULL,
    CONSTRAINT [PK_Drugs] PRIMARY KEY CLUSTERED
   (
      [Id] asc
   )

)

Create table Patients_Drugs
(
    Ref_PatEGN [varchar] (10) not null,
    Ref_DrugID [int] not null,
    Quantity [nvarchar] (50) not null,
    Foreign key (Ref_PatEGN) references Patients(EGN),
    Foreign key (Ref_DrugID) references Drugs(ID),
    UNIQUE (Ref_PatEGN,Ref_DrugID)
);

--Doctors
INSERT INTO Doctors (EGN, FulllName, [Address], PhoneNumber, Specilization)
VALUES ('9001204587', 'Sasho Georigev', 'Pirotska N1 ,Nqkude si, Bulgaria', '+359883559900', 'Hirurg');

INSERT INTO Doctors (EGN, FulllName, [Address], PhoneNumber, Specilization)
VALUES ('9021204587', 'Petur Petkov', 'Pirotska N1 ,Nqkude si, Bulgaria', '+354864559910', 'Hirurg');

INSERT INTO Doctors (EGN, FulllName, [Address], PhoneNumber, Specilization)
VALUES ('9001204397', 'Vasko Kalinov', 'Pirotska N1 ,Nqkude si, Bulgaria', '+359883558899', 'Hirurg');

INSERT INTO Doctors (EGN, FulllName, [Address], PhoneNumber, Specilization)
VALUES ('8043704587', 'Georgi Kalinkov', 'Pirotska N1 ,Nqkude si, Bulgaria', '+359883486100', 'GP');

INSERT INTO Doctors (EGN, FulllName, [Address], PhoneNumber, Specilization)
VALUES ('5701204587', 'Ivan Petrov', 'Pirotska N1 ,Nqkude si, Bulgaria', '+359883457916', 'Hirurg');

INSERT INTO Doctors (EGN, FulllName, [Address], PhoneNumber, Specilization)
VALUES ('8701204689', 'Sasho Georigev', 'Pirotska N1 ,Nqkude si, Bulgaria', '+359883559457', 'Hirurg');

INSERT INTO Doctors (EGN, FulllName, [Address], PhoneNumber, Specilization)
VALUES ('7705064587', 'Kiril Morkov', 'Pirotska N1 ,Nqkude si, Bulgaria', '+359883634865', 'GP');

INSERT INTO Doctors (EGN, FulllName, [Address], PhoneNumber, Specilization)
VALUES ('9043702587', 'Dimitar Paskalov', 'Pirotska N1 ,Nqkude si, Bulgaria', '+359883634865', 'Anesteziolog');

--Beds
INSERT INTO Beds ([Floor], Room, IsTaken)
VALUES (1, 1, 0);
INSERT INTO Beds ([Floor], Room, IsTaken )
VALUES (1, 2, 0);
INSERT INTO Beds ([Floor], Room, IsTaken )
VALUES (1, 3, 0)
INSERT INTO Beds ([Floor], Room, IsTaken )
VALUES (1, 3, 0)
INSERT INTO Beds ([Floor], Room, IsTaken )
VALUES (2, 2, 0)
INSERT INTO Beds ([Floor], Room, IsTaken )
VALUES (3, 1, 0);
INSERT INTO Beds ([Floor], Room, IsTaken )
VALUES (3, 1, 0);
INSERT INTO Beds ([Floor], Room, IsTaken )
VALUES (3, 10, 0);


--Patients
INSERT INTO Patients (EGN, FulllName, [Address], Sex, Diagnose, Birthdate, Doctor, Bed)
VALUES ('8701264587', 'Kiril Morkov', 'Pirotska N1 ,Nqkude si, Bulgaria', 'Male', 'Hepatit', '1987-01-26', '5701204587', 1);


INSERT INTO Patients (EGN, FulllName, [Address], Sex, Diagnose, Birthdate, Doctor, Bed)
VALUES ('9011094587', 'Dimitar Paskalov', 'Pirotska N1 ,Nqkude si, Bulgaria', 'Female', 'Herniq', '1990-11-09' , '5701204587', (select id from Beds  where ([Floor] = 3 and Room = 10)));
UPDATE Beds
SET IsTaken = 1
WHERE ([Floor] = 3 and Room = 10);

-- INSERT A HOLE LOT OF BEDS
DECLARE @i int = 0
DECLARE @x int = 1
DECLARE @y int = 1
WHILE @i < 191
BEGIN
    SET @i = @i + 1
    INSERT INTO Beds ([Floor], Room, IsTaken )
	VALUES (@x, @y, 0);
	IF (@i % 30) = 0
	SET @x = @x + 1
	IF (@i % 2) = 0
	SET @y = @y + 1
END

-- END OF BEDS MANIA

--specific bed 
INSERT INTO Beds ([id],[Floor], Room, IsTaken )
VALUES (3, 307, 1);

--end spec bed

INSERT INTO Patients (EGN, FulllName, [Address], Sex, Diagnose, Birthdate, Doctor, Bed)
VALUES ('5511201234,', 'Georgi Petrov', 'ul. Latinka 5', 'Male', 'Herniq', '1955-11-20' , '9001204587', 200);


---VIEWs
select EGN, FulllName, [Address], (SELECT DATEDIFF(hour,Birthdate,GETDATE())/8766) as Age 
from Patients 
where Diagnose = 'Hepatit' and Doctor = ( select EGN from Doctors where FulllName = 'Ivan Petrov' )


select Diagnose, Bed
from Patients 
where Doctor = ( select EGN from Doctors where FulllName = 'Ivan Petrov' )
		and
	bed = ((select Id from Beds where [Floor] = 3 and Room = 10 and IsTaken = 1))


--TODO
select (SELECT [Floor], [Room]
FROM Beds where IsTaken = 0) as freebeds
