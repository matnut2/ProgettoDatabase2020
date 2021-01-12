--
---				AUTO E MODO D'EPOCA
---			Soldà				Veronese
---				  a.a. 2020/2021
---				Progetto Basi di Dati
--
-- DROPS DELLE TABELLE
DROP TABLE IF EXISTS Biglietto CASCADE;
DROP TABLE IF EXISTS Cliente CASCADE;
DROP TABLE IF EXISTS Luogo CASCADE;
DROP TABLE IF EXISTS Indirizzo;
DROP TABLE IF EXISTS Veicolo CASCADE;
DROP TABLE IF EXISTS Autoveicolo;
DROP TABLE IF EXISTS Motoveicolo;
DROP TABLE IF EXISTS Espositore CASCADE;
DROP TABLE IF EXISTS Persona;
DROP TABLE IF EXISTS Societa;
DROP TABLE IF EXISTS Staff CASCADE;
DROP TABLE IF EXISTS Evento CASCADE;
DROP TABLE IF EXISTS Venditore;
DROP TABLE IF EXISTS Svolge;
DROP TABLE IF EXISTS Turno;

-- CREAZIONE ENTITA'
CREATE TABLE Biglietto(
	Numero SMALLINT PRIMARY KEY,
	Prezzo DECIMAL(5,2) NOT NULL,
	Tipo VARCHAR(20) NOT NULL,
	InizioValidita DATE NOT NULL,
	FineValidita DATE
);

CREATE TABLE Cliente(
	CF CHAR(16) PRIMARY KEY,
	Nome VARCHAR(20) NOT NULL,
	Cognome VARCHAR(20) NOT NULL,
	DataNascita DATE,
	Sesso CHAR(1),
	Mail VARCHAR(64) NOT NULL,
	Biglietto SMALLINT NOT NULL,

	FOREIGN KEY (Biglietto) REFERENCES Biglietto(Numero) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE Espositore(
	CF CHAR(16) PRIMARY KEY,
	Citta VARCHAR(16),
	Via VARCHAR(64),
	Civico VARCHAR(5)
);

CREATE TABLE Luogo(
	ID VARCHAR(2) PRIMARY KEY,
	Dimensione DECIMAL(6, 2) NOT NULL,
	Posti SMALLINT NOT NULL,
	PuntoRistoro BOOLEAN NOT NULL,
	ServiziIgenici BOOLEAN NOT NULL
);

CREATE TABLE Indirizzo(
	CFCliente CHAR(16) PRIMARY KEY,
	Citta VARCHAR(16),
	Via VARCHAR(64),
	Civico VARCHAR(5),
	
	FOREIGN KEY (CFCliente) REFERENCES Cliente(CF) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Veicolo(
	Targa CHAR(7) PRIMARY KEY,
	Espositore CHAR(16) NOT NULL,
	Posizione VARCHAR(2) NOT NULL,
	Cilindrata INTEGER NOT NULL,
	AnnoProduzione DATE NOT NULL,
	Marca VARCHAR(16) NOT NULL,
	Modello VARCHAR(32) NOT NULL,
	Acquirente CHAR(16) DEFAULT NULL,
	Prezzo DECIMAL(8,2) DEFAULT NULL,

	FOREIGN KEY (Espositore) REFERENCES Espositore(CF),
	FOREIGN KEY (Posizione) REFERENCES Luogo(ID),
	FOREIGN KEY (Acquirente) REFERENCES Cliente(CF)
);

CREATE TABLE Motoveicolo(
	TargaVeicolo CHAR(7) PRIMARY KEY,
	Sidecar BOOLEAN DEFAULT FALSE,
	
	FOREIGN KEY (TargaVeicolo) REFERENCES Veicolo(Targa) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Autoveicolo(
	TargaVeicolo CHAR(7) PRIMARY KEY,
	Alimentazione VARCHAR(16) NOT NULL,
	TipoCambio VARCHAR(16) NOT NULL,
	Passeggeri SMALLINT DEFAULT 4,
	
	FOREIGN KEY (TargaVeicolo) REFERENCES Veicolo(Targa) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Persona(
	CFEspositore CHAR(16) PRIMARY KEY,
	Nome VARCHAR(20) NOT NULL,
	Cognome VARCHAR(20) NOT NULL,
	DataNascita DATE,
	
	FOREIGN KEY (CFEspositore) REFERENCES Espositore(CF) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Societa(
	CFEspositore CHAR(16) PRIMARY KEY,
	RagioneSociale VARCHAR(64) NOT NULL,
	NomeRappresentante VARCHAR(20),
	CognomeRappresentante VARCHAR(20) NOT NULL,
	CapitaleSociale DECIMAL(10, 2),
	
	FOREIGN KEY (CFEspositore) REFERENCES Espositore(CF) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Venditore(
	NOME VARCHAR(64) PRIMARY KEY,
	IDLuogo VARCHAR(2) NOT NULL,
	Categoria VARCHAR(32),
	Dimensione DECIMAL(4,2) NOT NULL,
	PostiOccupati SMALLINT DEFAULT 1,

	FOREIGN KEY (IDLuogo) REFERENCES Luogo(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Staff(
	Matricola CHAR(9) PRIMARY KEY,
	Nome VARCHAR(20),
	Cognome VARCHAR(20),
	TipoServizio VARCHAR(16),
	DataNascita DATE,
	Sesso CHAR(1),
	CF CHAR(16) NOT NULL
);

CREATE TABLE Evento(
	Nome VARCHAR(64) PRIMARY KEY,
	Tipologia VARCHAR(64),
	Durata SMALLINT NOT NULL
);

-- CREAZIONE RELAZIONI
CREATE TABLE Svolge(
	NomeEvento VARCHAR(64),
	IDLuogo VARCHAR(2),
	Data DATE,
	OraInizio TIME,
	OraFine TIME,

	FOREIGN KEY (NomeEvento) REFERENCES Evento(Nome) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (IDLuogo) REFERENCES Luogo(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (NomeEvento, IDLuogo)
);

CREATE TABLE Turno(
	IDLuogo VARCHAR(2),
	MatricolaDip VARCHAR(16),
	Giorno DATE,
	Inizio TIME,
	Fine TIME,

	FOREIGN KEY (IDLuogo) REFERENCES Luogo(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (MatricolaDip) REFERENCES Staff(Matricola) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (IDLuogo, MatricolaDip, Giorno)
);

-- POPOLAZIONE DEL DATABASE
INSERT INTO Biglietto (Numero, Prezzo, Tipo, InizioValidita, FineValidita) VALUES
(0001,25.50,'Giornaliero','2020-10-01', '2020-10-25'),
(0002,51.00,'2 Giorni','2020-10-25', '2020-10-27'),
(0003,25.50,'Giornaliero','2020-10-26','2020-10-26'),
(0004,125.00,'Settimanale','2020-10-17', '2020-10-24'),
(0005,25.50,'Giornaliero','2020-10-29','2020-10-29'),
(0006,125.00,'Settimanale','2020-10-1','2020-10-8'),
(0007,25.50,'Giornaliero','2020-10-02','2020-10-02'),
(0008,51.00,'2 Giorni','2020-10-02','2020-10-04'),
(0009,25.50,'Giornaliero','2020-10-25', '2020-10-25'),
(0010,125.00,'Settimanale','2020-10-20', '2020-10-27'),
(0011, 25.5, 'Giornaliero', '2020-10-2', '2020-10-2'),
(0012, 125.0, 'Settimanale', '2020-10-3', '2020-10-9'),
(0013, 125.0, 'Settimanale', '2020-10-1', '2020-10-7'),
(0014, 125.0, 'Settimanale', '2020-10-8', '2020-10-14'),
(0015, 51.0, '2 Giorni', '2020-10-12', '2020-10-13'),
(0016, 25.5, 'Giornaliero', '2020-10-5', '2020-10-5'),
(0017, 25.5, 'Giornaliero', '2020-10-7', '2020-10-7'),
(0018, 125.0, 'Settimanale', '2020-10-9', '2020-10-15'),
(0019, 25.5, 'Giornaliero', '2020-10-8', '2020-10-8'),
(0020, 25.5, 'Giornaliero', '2020-10-13', '2020-10-13'),
(0021, 51.0, '2 Giorni', '2020-10-18', '2020-10-19'),
(0022, 51.0, '2 Giorni', '2020-10-14', '2020-10-15'),
(0023, 125.0, 'Settimanale', '2020-10-16', '2020-10-22'),
(0024, 51.0, '2 Giorni', '2020-10-13', '2020-10-14'),
(0025, 51.0, '2 Giorni', '2020-10-18', '2020-10-19'),
(0026, 51.0, '2 Giorni', '2020-10-8', '2020-10-9'),
(0027, 51.0, '2 Giorni', '2020-10-13', '2020-10-14'),
(0028, 51.0, '2 Giorni', '2020-10-15', '2020-10-16'),
(0029, 51.0, '2 Giorni', '2020-10-1', '2020-10-2'),
(0030, 51.0, '2 Giorni', '2020-10-14', '2020-10-15'),
(0031, 25.5, 'Giornaliero', '2020-10-14', '2020-10-14'),
(0032, 25.5, 'Giornaliero', '2020-10-11', '2020-10-11'),
(0033, 25.5, 'Giornaliero', '2020-10-12', '2020-10-12'),
(0034, 51.0, '2 Giorni', '2020-10-16', '2020-10-17'),
(0035, 51.0, '2 Giorni', '2020-10-20', '2020-10-21'),
(0036, 25.5, 'Giornaliero', '2020-10-15', '2020-10-15'),
(0037, 125.0, 'Settimanale', '2020-10-1', '2020-10-7'),
(0038, 125.0, 'Settimanale', '2020-10-13', '2020-10-19'),
(0039, 125.0, 'Settimanale', '2020-10-16', '2020-10-22'),
(0040, 125.0, 'Settimanale', '2020-10-4', '2020-10-10'),
(0041, 125.0, 'Settimanale', '2020-10-4', '2020-10-10'),
(0042, 125.0, 'Settimanale', '2020-10-19', '2020-10-25'),
(0043, 25.5, 'Giornaliero', '2020-10-10', '2020-10-10'),
(0044, 125.0, 'Settimanale', '2020-10-1', '2020-10-7'),
(0045, 25.5, 'Giornaliero', '2020-10-17', '2020-10-17'),
(0046, 125.0, 'Settimanale', '2020-10-18', '2020-10-24'),
(0047, 125.0, 'Settimanale', '2020-10-8', '2020-10-14'),
(0048, 125.0, 'Settimanale', '2020-10-12', '2020-10-18'),
(0049, 51.0, '2 Giorni', '2020-10-12', '2020-10-13'),
(0050, 125.0, 'Settimanale', '2020-10-14', '2020-10-20'),
(0051, 25.5, 'Giornaliero', '2020-10-3', '2020-10-3'),
(0052, 51.0, '2 Giorni', '2020-10-15', '2020-10-16'),
(0053, 25.5, 'Giornaliero', '2020-10-21', '2020-10-21'),
(0054, 25.5, 'Giornaliero', '2020-10-8', '2020-10-8'),
(0055, 51.0, '2 Giorni', '2020-10-16', '2020-10-17'),
(0056, 125.00, 'Settimanale', '2020-10-20', '2020-10-27');

INSERT INTO Cliente(CF, Nome, Cognome, DataNascita, Sesso, Mail, Biglietto) VALUES
('VRNNDR00H24G224U','Andrea', 'Veronesi', '2000-06-24','M','giovannidavergara@gmail.com', 0001),
('SLDMTT85F21M224U','Matteo', 'Solda', '1985-05-21','M','matt1985@yahoo.com', 0002),
('CMLSRA77F15G221F','Sara', 'Camilleri', '1977-01-15','F','camisara@gmail.com', 0003),
('STVGVN00H06F226U','Giovanni', 'Stevanato', '2000-02-06','M','stavanatogiova@gmail.com', 0004),
('MDUCRS95G03M224U','Christian', 'Midu', '1995-03-03','M','miducris@protonmail.com', 0005),
('FVRLSN68E02A665F','Alessandra', 'Favero', '1986-08-02','F','faveroa@outlook.com', 0006),
('REAMAU59E22S456F','Mauro', 'Reani', '1959-09-22','M','mauro.reani59@gmail.com', 0007),
('STVSFI97H30G224U','Sofia', 'Sofia', '1997-06-30','F','stv.sofi@gmail.com', 0008),
('CHVGVN49G24O224U','Giovanni', 'Chiavinato', '1949-10-24','M','chiavinato.giova1949@yahoo.com', 0009),
('SLDGLG76H06G229F','Gianluigi', 'Solida', '1976-06-06','M','solida.g@gmail.com', 0010);

INSERT INTO Cliente(CF, Nome, Cognome, DataNascita, Mail, Sesso, Biglietto) VALUES
('RSSALE94E12A883V', 'Alessandro', 'Rossi', '1994-08-21', 'alessandro.rossi@gmail.com', 'M', 0011),
('NRIGNL98E12AA83V', 'Angela', 'Neri', '1999-10-12', 'angela.neri@gmail.com', 'F', 0012),
('BRYBMB60E12A703P', 'Bryan', 'Bemba', '1960-04-27', 'bryan.bemba@gmail.com', 'F', 0013),
('BRTBRT97E12A963V', 'Berto', 'Barto', '1997-01-01', 'berto.barto@gmail.com', 'M', 0014),
('BNDFBB99E12A983V', 'Benedetta', 'Fabbri', '1999-03-27', 'benedetta.fabbri@outlook.com', 'F', 0015),
('CRLMNN65E12A553V', 'Carlo', 'Maino', '1965-02-12', 'carlo.maino@gmail.com', 'M', 0016),
('CSMVRT80E12A993V', 'Cesare', 'Verto', '1980-12-16', 'cesare.veerto@locorocol.com', 'M', 0017),
('CRSABT00E12A783S', 'Cristina', 'Battista', '2000-04-16', 'cristicristi00@gmail.com', 'F', 0018),
('DGGDDD99E12A703V', 'Diego', 'Deidda', '1999-03-03', 'diegoddeids@gmail.com', 'M', 0019),
('DNLANT96E12A993V', 'Daniele', 'Antonini', '1996-06-19', 'danielito96.abba@gmail.com', 'M', 0020),
('EDDCST99E12A403P', 'Edoardo', 'Costa', '1997-05-22', 'edo.costa97@gmail.com', 'M', 0021),
('MNLGRP94E12A833M', 'Manuela', 'Grappa', '1994-10-10', 'manuanum94@gmail.com', 'F', 0022),
('RKKZAN98E1299A3V', 'Erik', 'Zanotto', '1998-04-17', 'erik.zannabianca@gmail.com','M', 0023),
('FDRGTT99E16A309S', 'Federico', 'Gatto', '1999-11-01', 'fede99.herba@gmail.com', 'M', 0024),
('FBBCMP97G12A333M', 'Fabio', 'Campagnolo', '1997-01-14', 'campodigrano.97@gmail.com','M', 0025),
('GKHNCR60C17L411G', 'Giuseppe', 'Giordani', '1993-02-09', 'giuseppe.gioo@hotmail.com', 'M', 0026),
('QHTTLF68S04E527F', 'Giuliano', 'Belva', '1989-02-18', 'belvarossa89@spam.com', 'M', 0027),
('BTBWBO31H13E566W', 'Henry', 'Calza', '2001-03-24', 'henry.calza@gmail.com', 'M', 0028),
('GKIWLJ34T52C797D', 'Ivana', 'Balzan', '1995-03-24', 'ivana.balzan@gmail.com', 'F', 0029),
('HZNHFN91M61G232E', 'James', 'Ford', '1997-04-12', 'iamjames@gmail.com', 'M', 0030),
('KSMFZH45C60E409D', 'Laura', 'Lesta', '1991-02-06', 'll.laura@gmail.com', 'F', 0031),
('CNWRNA57M42A835D', 'Luca', 'Giaretta', '1992-07-23', 'giaretz.luca@gmail.com', 'M', 0032),
('CZGRBL69L57F464W', 'Mirko', 'Gettone', '1995-11-29', 'emmegemme@locoroco.com', 'M', 0033),
('SHBTHT34M31C969A', 'Manuel', 'Cusinato', '1996-11-20', 'cusimanuel@alice.it', 'M', 0034),
('MHJPBI84E05L547D', 'Nikita', 'Saugo', '2000-02-06', 'nikitaniki00@gmail.com', 'F', 0035),
('DYSFGK37H61D455K', 'Nicola', 'Mercante', '1999-01-16', 'nicola1223@gmail.com', 'M', 0036),
('FKBHVM60B23H825N', 'Nicola', 'Olivieri', '1999-09-16', 'nic0livieri@gmail.com', 'M', 0037),
('VRZXLT45S62E546N', 'Otello', 'Grendene', '1992-02-16', 'altootello@virgilio.it', 'M', 0038),
('VGDGVY56T62B355D', 'Paola', 'Maggi', '1998-02-16', 'paora98@libero.it', 'F', 0039),
('RWGMTD70M55I310O', 'Patrizio', 'Pozzato', '1985-03-15', 'pozzapatri@gmail.com', 'M', 0040),
('ZKZCTR71T21L667Q', 'Ruben', 'Miazzo', '1999-02-20', 'rubazze.alle12@gmail.com', 'M', 0041),
('LMFCGT40D30F833P', 'Raffaella', 'Fedele', '1995-07-20', 'fedelissima95@gmail.com', 'F', 0042),
('MMOBMR89S61G131C', 'Giuseppe', 'Nardi', '1994-02-02', 'giunardi@gmail.com', 'M', 0043),
('PSJSXZ65B65L633D', 'Mattia', 'Esposito', '1999-07-12', 'mesposito99@gmail.com', 'M', 0044),
('GZNTZZ82B08F598F', 'Edoardo', 'Perobelli', '1997-09-17', 'edo.pero97@gmail.com', 'M', 0045),
('STNPWT41B09H165I', 'Chiara', 'Cappozzo', '1997-05-21', 'chiaraross@gmail.com', 'F', 0046),
('CDHTBZ40H27D017G', 'Matteo', 'Munari', '1998-07-20', 'munamatte98@gmail.com', 'M', 0047),
('DXSZZU53R03Z310T', 'Marco', 'Bressan', '1994-01-10', 'tokyodrift@gmail.com', 'M', 0048),
('PWCDPP61C09H291K', 'Fabio', 'Dari', '1991-10-20', 'fardello.pes@gmail.com', 'M', 0049),
('HFMPDZ27R71A109F', 'Stefano', 'Lepri', '1994-03-25', 'st3pny94@gmail.com', 'M', 0050),
('BDRWGI71P55C514Q', 'Renato', 'Clapis', '2000-03-18', 'clapisclepo00@gmail.com', 'M', 0051),
('RBVSVF41R19A435N', 'Gianluca', 'Orlandi', '1998-12-25', 'gianluca.orli@gmail.com', 'M', 0052),
('YTNGSL78E69E851Z', 'Roberto', 'Mannu', '1994-01-14', 'robertone94@gmail.com', 'M', 0053),
('DDANLK88F12J0X1F', 'Marco', 'Paluman', '1992-12-20', 'marco487@gmail.com', 'M', 0054),
('LAPEND78E94L093Z', 'Lucia', 'Nade', '1996-09-02', 'luciathebest@gmail.com', 'F', 0055),
('PAOASN92E69E523R', 'Jim', 'Morrison', '1980-05-11', 'morrison5823gmail.com', 'M', 0056);

INSERT INTO Indirizzo(CFCliente, Citta, Via, Civico) VALUES
('VRNNDR00H24G224U', 'Milano','Via Cristofori', '29'),
('SLDMTT85F21M224U','Salerno', 'Viale Montereale', '133/B'),
('CMLSRA77F15G221F', 'Padova', 'Via Crescini', '56'),
('STVGVN00H06F226U', 'Arezzo', 'Corso Stati Uniti','34'),
('MDUCRS95G03M224U', 'Domodossola', 'Via Monte Cervino', '14'),
('FVRLSN68E02A665F', 'Arezzo', 'Via Siracusa', '144'),
('REAMAU59E22S456F', 'Salerno', 'Via Giorgione', '89'),
('STVSFI97H30G224U', 'Marostica', 'Via Colombo','13'),
('CHVGVN49G24O224U', 'Genova', 'Via Ghibellini', '17'),
('SLDGLG76H06G229F', 'Napoli', 'Varco di Via Brombeis', '98');

INSERT INTO Espositore(CF, Citta, Via, Civico) VALUES
('00004568943','Padova', 'Viale Della Navigazione Interna' , '144'),
('02457190384', 'Parma', 'Via Caduti della Repubblica', '16'),
('82837674780',' Como', 'Via Verga', '64'),
('ZLLGNN64H28M224U', 'Andria', 'Via Leopardi', '44/B'),
('09283756590','Genova', 'Viale Interno', '155'),
('PLQNQV75A24F939O', 'Padova', 'Via Nazareth', '112/B'),
('PMUWVN88E42I715E', 'Padova', 'Via Due Palazzi' , '221'),
('KDLDWH77L14D546K', 'Padova', 'Via Caduti della Repubblica', '16'),
('GNEYRH70L55G453M', 'Avellino', 'Via Cesare Ladrone', '25'),
('TWZPTR75A11Z509G', 'Genova', 'Vicolo Stretto', '46'),
('09128912821', 'Palermo', 'Corso Stati Uniti', '56/G'),
('23487348934', 'Como', 'Via Europa', '56/4'),
('02138290382', 'Roma', 'Via Capitale', '89'),
('09128312903', 'Roma', 'Raccordo Anulare', '1524'),
('84753456712', 'Padova', 'Via Hummels', '69');

INSERT INTO Persona(CFEspositore, Nome, Cognome, DataNascita) VALUES
('ZLLGNN64H28M224U', 'Gianni', 'Zannellato', '1964-05-28'),
('PMUWVN88E42I715E', 'Uwuvewnu', 'Pamua' , '1991-06-12'),
('KDLDWH77L14D546K', 'Dwohem', 'Kadel', '1958-04-26'),
('GNEYRH70L55G453M', 'Gwenyt', 'Yorkshire', '1989-05-30'),
('TWZPTR75A11Z509G', 'Pointer', 'Tewunuwa', '1978-06-09');

INSERT INTO Societa(CFEspositore, RagioneSociale, NomeRappresentante, CognomeRappresentante, CapitaleSociale) VALUES
('00004568943', 'Ceccato Motors s.r.l', 'Giovanni', 'Marescon', 1250000),
('02457190384', 'Padova Star s.p.a', 'Marco', 'Aurelio', 2000000),
('82837674780', ' Motorsport s.p.a', 'Andrea', 'Rossi', 1500000),
('09283756590', 'F.lli Vicari s.p.a', 'Katia', 'Longhin', 600000),
('09128912821', 'Autosport Extreme', 'Paolo', 'Plinio', 250000),
('23487348934', 'Luxury Runs', 'Lucio', 'Dalla', 26550),
('02138290382', 'Hurricane', 'Rodrigo', 'Don', 2500000),
('09128312903', 'Manikanos', 'Gianpaolo', 'Eusebio', 152400),
('84753456712', 'Glacyos', 'Umberto', 'Glacyos', 25000000);

INSERT INTO Luogo(ID, Dimensione, Posti, PuntoRistoro, ServiziIgenici) VALUES
('1', 2500.00, 200, TRUE, TRUE),
('2', 2700.00, 22, TRUE, FALSE),
('3', 800.00, 8, TRUE, TRUE),
('4', 1600.00, 30, FALSE, FALSE),
('5', 1325.00, 16, FALSE, TRUE),
('6', 1400.00, 19, FALSE, FALSE),
('8', 600.00, 9, FALSE, TRUE),
('13', 1500.00, 25, TRUE, TRUE),
('14', 2000.00, 41, TRUE, FALSE),
('A', 800.00, 20, FALSE, FALSE),
('B', 1000.00, 25, FALSE, FALSE);

INSERT INTO Veicolo(Targa, Espositore, Posizione, Cilindrata, AnnoProduzione, Marca, Modello, Acquirente, Prezzo) VALUES
('AS967AZ', '00004568943','13', 2500, '1979-01-01', 'Fiat', '124 Spyder', NULL, NULL),
('BH816EY', '02457190384', '5', 3700, '1965-01-01', 'Mercedes', 'SLS AMG', 'MDUCRS95G03M224U', 250000), 
('DN494ZT', '82837674780', '6', 2000,'1983-01-01','BMW', 'Isetta', 'STVGVN00H06F226U', 79000),
('AB674CZ', 'ZLLGNN64H28M224U', '3', 5700, '1971-01-01', 'Ford', 'Mustang GT','SLDGLG76H06G229F', 65000),
('AN944SZ', '09283756590','6', 1697, '1980-01-01', 'Volkswagen', 'Scirocco','BNDFBB99E12A983V', 25000),
('BF564TR', '09283756590','6', 2000, '1981-01-01', 'Volkswagen', 'Golf GTI','REAMAU59E22S456F',25000),
('EZ840BV', '02457190384', '5', 1980, '1963-01-01', 'Mercedes', 'Classe S', NULL, NULL), 
('CA569AZ', '02457190384', '3', 800, '1979-01-01', 'Moto Guzzi', 'Le Mans', NULL, NULL),
('AC85165', 'ZLLGNN64H28M224U', '3', 745, '1941-01-01', 'BMW', 'R75', 'BNDFBB99E12A983V', 50000),
('ER74471', '09128912821', '2', 1200, '2019-01-01', 'Kawasaki', 'Z1000', 'FBBCMP97G12A333M', 7100),

('EG458PI', 'PMUWVN88E42I715E', '5', 2000, '2020-01-01', 'Mercedes', 'GLA 200', NULL, NULL),
('EG460PI', 'PMUWVN88E42I715E', '5', 2500, '2020-01-01', 'Mercedes', 'GLA 250', NULL, NULL),
('EG264ZC', 'PMUWVN88E42I715E', '5', 6200, '2020-01-01', 'Mercedes', 'SLS AMG', NULL, NULL),
('FV244JL', 'PMUWVN88E42I715E', '5', 1200, '2020-01-01', 'Mercedes', 'CLA 120', NULL, NULL),
('DC684NL', 'PMUWVN88E42I715E', '5', 2000, '2020-01-01', 'Mercedes', 'CLA 200', NULL, NULL),
('FT218YU', 'PMUWVN88E42I715E', '5', 2000, '2020-01-01', 'Mercedes', 'GLA 200', NULL, NULL),
('DG321HS', 'PMUWVN88E42I715E', '5', 2000, '2020-01-01', 'Mercedes', 'GLA 200', NULL, NULL),
('AD953BZ', '02138290382', '8',2000,'1989-01-01', 'Mercedes', 'Classe B', NULL, NULL),
('BL890RT', '02138290382', '8',1300,'1967-01-01', 'Mercedes', 'Classe E', NULL, NULL),
('CZ836OP', '02138290382', '8',1900,'2000-01-01', 'Mercedes', '190', 'BRTBRT97E12A963V', 75000),
('PU156YT', '02138290382', '8',2500,'1996-01-01','Mercedes', 'Classe C 180', NULL, NULL),
('LA967TY', '02138290382', '8',2000, '1975-01-01', 'Mercedes', 'D 240', NULL, NULL);


INSERT INTO Motoveicolo(TargaVeicolo, Sidecar) VALUES
('AC85165', FALSE),
('ER74471', TRUE);

INSERT INTO Autoveicolo(TargaVeicolo, Alimentazione, TipoCambio, Passeggeri) VALUES
('AS967AZ', 'Benzina','Manuale', 5),
('BH816EY', 'Diesel','Automatico', 2), 
('DN494ZT', 'Diesel', 'Manuale', 4),
('AB674CZ', 'Benzina', 'Manuale', 3),
('AN944SZ', 'Benzina','Automatico',3),
('BF564TR', 'Benzina','Manuale', 4),
('EZ840BV', 'Benzina', 'Automatico', 2),
('EG458PI', 'Diesel', 'Automatico', 5),
('EG460PI', 'Diesel', 'Automatico', 5),
('EG264ZC', 'Diesel', 'Automatico', 5),
('FV244JL', 'Diesel', 'Automatico', 5),
('DC684NL', 'Diesel', 'Automatico', 5),
('FT218YU', 'Diesel', 'Automatico', 5),
('DG321HS', 'Diesel', 'Automatico', 5),
('AD953BZ', 'Benzina', 'Manuale', 5),
('BL890RT','Diesel','Manuale',5),
('CZ836OP','Diesel','Automatico',5),
('PU156YT','Benzina','Manuale',5),
('LA967TY','Benzina','Automatico',5);

INSERT INTO Venditore(NOME, IdLuogo, Categoria, Dimensione, PostiOccupati) VALUES
('Motorsport Addiction', '1',  'Parti di Ricambio Custom', 45.00 , 5),
('AutoSpareParts','2', 'Ricambi Multimarca', 32, 3),
('JapaneseParts','2', 'Filtri Olio OEM', 52.50, 6),
('Mann', '2', 'Filtri olio OEM e Potenziati', 79, 8),
('TuningWorld','1', 'Parti Ricambio Custom', 50 ,5),
('RicambiRetro','1', 'Ricambi Auto Epocali', 74, 7),
('OEMSparePartsFinder','2', 'Ricambi Multimarca', 85, 9);

INSERT INTO Evento(Nome, Tipologia, Durata) VALUES
('Drifting School', 'Show Automobilistico', 120),
('Old Timer Race', 'Gara Auto Retro', 30),
('TwoWeels Showoff', 'Esposizione e Test Live', 180),
('Retro Showoff', 'Esposizione Esterna', 200),
('Monster Truck Live', 'Show Automobilistico', 60),
('Cosa Trovo Dentro una Ambulanza', 'Documentario Live', 120),
('Cosa Trovo Dentro la Volante della Polizia', 'Documentario Live', 200),
('Cosa Trovo Dentro il Furgone dei Pompieri', 'Documentario Live', 200),
('Cosa Trovo Dentro la Automedica', 'Documentario Live', 60),
('Cosa Trovo Dentro un Carro Armato delle Forze Armate', 'Documentario Live', 180),
('Cosa Trovo Dentro il Furgone della Pfizer', 'Documentario Live', 60),
('Cosa Trovo Dentro un Canadair', 'Documentario Live', 180),
('Guida Sicura', 'Show Automobilistico', 120),
('Auto e Moto della Seconda Guerra Mondiale', 'Esposizione Esterna', 120),
('Il Meccanico Live', 'Manutenzione in tempo reale', 180),
('Esposizione Interni di Pregio', 'Esposizione esterna', 60),
('Pronto Intervento con Polizia', 'Show Automobilistico', 120),
('Moose Test', 'Show Automobilistico', 60);

INSERT INTO Svolge(NomeEvento, IDLuogo, Data, OraInizio, OraFine) VALUES
('Drifting School', 'A', '2020-10-25', '10:30:00', '12:30:00'),
('Old Timer Race', 'B', '2020-10-25', '14:30:00', '15:00:00'),
('TwoWeels Showoff', 'A', '2020-10-30', '12:00:00', '15:00:00'),
('Retro Showoff', 'A', '2020-10-02', '10:00:00', '13:20:00'),
('Monster Truck Live', 'A', '2020-10-02', '10:00:00', '13:20:00'),
('Cosa Trovo Dentro una Ambulanza', 'A', '2020-10-03', '08:00:00', '10:00:00'),
('Cosa Trovo Dentro la Volante della Polizia', 'A', '2020-10-03', '10:00:00', '13:20:00'),
('Cosa Trovo Dentro il Furgone dei Pompieri', 'A', '2020-10-03', '13:20:00', '16:40:00'),
('Cosa Trovo Dentro la Automedica', 'A', '2020-10-03', '17:00:00', '18:00:00'),
('Cosa Trovo Dentro un Carro Armato delle Forze Armate', 'B', '2020-10-03', '8:00:00', '11:00:00'),
('Cosa Trovo Dentro il Furgone della Pfizer', 'B', '2020-10-03', '11:00:00', '12:00:00'),
('Cosa Trovo Dentro un Canadair', 'B', '2020-10-03', '12:00:00', '15:00:00'),
('Guida Sicura', 'B', '2020-10-05', '8:00:00', '10:00:00'),
('Auto e Moto della Seconda Guerra Mondiale', 'A', '2020-10-23', '!2:00:00', '14:00:00'),
('Il Meccanico Live', 'B', '2020-10-23', '10:00:00', '13:00:00'),
('Esposizione Interni di Pregio', 'A', '2020-10-26', '08:00:00', '09:00:00'),
('Pronto Intervento con Polizia', 'B', '2020-10-27' ,'10:00:00', '12:00:00'),
('Moose Test', 'A', '2020-10-30', '16:00:00', '17:00:00');

INSERT INTO Staff(Matricola, Nome, Cognome, TipoServizio, DataNascita, Sesso, CF) VALUES
	('M13562411', 'Alfonso', 'Meridio', 'Medico', '1985-01-15', 'M', 'MRDALF25J48P564O'),
	('V25A34225', 'Paolo', 'Alabarda', 'Vigilanza', '1991-10-23', 'M', 'LBRPLA31H26S324B'),
	('P25114854', 'Laura', 'Arelana', 'Pulizie', '1968-07-3', 'F', 'RLNLRA25J48P564O'),
	('P23487524', 'Gianluca', 'Beronetta', 'Pulizie', '1964-12-20', 'M', 'BRNGNL25J48P564O'),
	('M21324546', 'Zitto', 'Fabruk', 'Medico', '1974-06-14', 'M', 'FBKZTT36M41H450B'),
	('V12548799', 'Xanvier', 'Ranarro', 'Vigilanza', '1985-01-15', 'M', 'RNRXNV82T08D182H'),
	('P31854654', 'Vehiqa', 'Pawohan', 'Pulizie', '1991-03-12', 'F', 'PWHVHQ58E65M204P'),
	('V65489418', 'Tabatha', 'Rewiaz', 'Vigilanza', '2000-07-10', 'F', 'RWZTBT47R55L909E'),
	('P64615796', 'Waeti', 'Serra', 'Pulizie', '1998-05-20', 'M', 'SRRWTE60S65D817H'),
	('V16574641', 'Yopnik', 'Bapavlov', 'Vigilanza', '1986-02-07', 'M', 'BPVYPN64L02H276X'),
	('M29062000', 'Matteo', 'Soldà', 'Medico', '2000-06-29', 'M', 'SLDMTT00H29G224I'),
	('V13562411', 'Andrea', 'Veronese', 'Vigilanza', '2000-06-30', 'M', 'VRNNDR25H64I256K'),
	('V32321312', 'Matteo', 'Bando', 'Vigilanza' , '2000-05-15', 'M', 'BNDMTT25H56G485Y');
	
INSERT INTO Turno(IDLuogo, MatricolaDip, Giorno, Inizio, Fine) VALUES
('A', 'P31854654', '2020-10-27', '14:00:00', '20:00:00'),
('6', 'P64615796', '2020-10-19', '8:00:00', '14:00:00'),
('B', 'M21324546', '2020-10-6', '8:00:00', '14:00:00'),
('5', 'V25A34225', '2020-10-5', '8:00:00', '14:00:00'),
('2', 'M21324546', '2020-10-17', '14:00:00', '20:00:00'),
('13', 'V65489418', '2020-10-9', '8:00:00', '14:00:00'),
('B', 'M29062000', '2020-10-17', '8:00:00', '14:00:00'),
('3', 'V13562411', '2020-10-23', '8:00:00', '14:00:00'),
('6', 'P64615796', '2020-10-27', '8:00:00', '14:00:00'),
('2', 'V25A34225', '2020-10-18', '14:00:00', '20:00:00'),
('A', 'P64615796', '2020-10-22', '14:00:00', '20:00:00'),
('A', 'P64615796', '2020-10-15', '14:00:00', '20:00:00'),
('14', 'V12548799', '2020-10-4', '14:00:00', '20:00:00'),
('14', 'V65489418', '2020-10-27', '14:00:00', '20:00:00'),
('1', 'V65489418', '2020-10-18', '14:00:00', '20:00:00'),
('13', 'M13562411', '2020-10-21', '14:00:00', '20:00:00'),
('14', 'M13562411', '2020-10-15', '8:00:00', '14:00:00'),
('6', 'V13562411', '2020-10-27', '20:00:00', '8:00:00'),
('14', 'V16574641', '2020-10-10', '8:00:00', '14:00:00'),
('5', 'V65489418', '2020-10-14', '8:00:00', '14:00:00'),
('2', 'M29062000', '2020-10-5', '14:00:00', '20:00:00'),
('3', 'P31854654', '2020-10-26', '20:00:00', '8:00:00'),
('5', 'M29062000', '2020-10-22', '8:00:00', '14:00:00'),
('4', 'V25A34225', '2020-10-27', '20:00:00', '8:00:00'),
('1', 'M29062000', '2020-10-30', '14:00:00', '20:00:00'),
('4', 'M29062000', '2020-10-2', '8:00:00', '14:00:00'),
('A', 'V12548799', '2020-10-1', '8:00:00', '14:00:00'),
('2', 'P31854654', '2020-10-3', '8:00:00', '14:00:00'),
('3', 'V16574641', '2020-10-16', '8:00:00', '14:00:00'),
('13', 'V12548799', '2020-10-5', '8:00:00', '14:00:00'),
('6', 'V13562411', '2020-10-25', '20:00:00', '8:00:00'),
('4', 'M29062000', '2020-10-9', '14:00:00', '20:00:00'),
('3', 'V65489418', '2020-10-1', '14:00:00', '20:00:00'),
('8', 'P64615796', '2020-10-17', '14:00:00', '20:00:00'),
('8', 'M21324546', '2020-10-27', '8:00:00', '20:00:00'),
('3', 'P64615796', '2020-10-9', '20:00:00', '24:00:00'),
('4', 'V13562411', '2020-10-21', '14:00:00', '20:00:00'),
('3', 'P64615796', '2020-10-14', '14:00:00', '20:00:00'),
('14', 'V13562411', '2020-10-12', '20:00:00', '8:00:00'),
('B', 'P31854654', '2020-10-10', '20:00:00', '24:00:00'),
('2', 'V16574641', '2020-10-5', '20:00:00', '8:00:00'),
('5', 'P23487524', '2020-10-5', '14:00:00', '20:00:00'),
('6', 'V12548799', '2020-10-8', '14:00:00', '20:00:00'),
('2', 'V13562411', '2020-10-20', '20:00:00', '8:00:00'),
('3', 'V65489418', '2020-10-20', '8:00:00', '14:00:00'),
('13', 'P23487524', '2020-10-6', '8:00:00', '14:00:00'),
('14', 'P25114854', '2020-10-21', '20:00:00', '24:00:00'),
('A', 'P64615796', '2020-10-8', '20:00:00', '24:00:00'),
('8', 'P25114854', '2020-10-26', '8:00:00', '14:00:00'),
('5', 'P64615796', '2020-10-20', '8:00:00', '14:00:00'),
('A', 'V32321312', '2020-10-28', '20:00:00', '08:00:00');
;


-- Query 1
SELECT MatricolaDip
FROM Turno 
WHERE MatricolaDip LIKE 'V%' AND MatricolaDip NOT IN (
	SELECT MatricolaDip
	FROM Turno T JOIN Staff S ON T.MatricolaDip = S.Matricola
	WHERE (Inizio = '08:00:00' OR Inizio = '14:00:00')
);


-- Query 2
SELECT Espositore, Count(Targa) as VeicoliMercedes
FROM Veicolo V JOIN Espositore E ON V.Espositore = E.CF
WHERE CF NOT IN 
(
	SELECT CF
	FROM Espositore E JOIN Veicolo V on E.CF = V.Espositore
	WHERE V.Marca = 'Mercedes' AND Prezzo > 0
)
GROUP BY Espositore
HAVING Count(Targa) >= 5;

-- Query 3
SELECT CF,COUNT(CF) AS VeicoliComprati, SUM(Prezzo) AS ImportoTotale 
FROM Cliente C JOIN Veicolo V on C.CF = V.Acquirente
WHERE Mail like '%@outlook.com' AND Sesso = 'F'
GROUP BY C.CF
HAVING COUNT(CF) >= 2 AND SUM(Prezzo) <= 100000;

-- Query 4
SELECT Marca, COUNT(Targa) AS NumeroVeicoliVenduti, SUM(Prezzo) as ImportoTotale
FROM Veicolo
WHERE Prezzo > 0
GROUP BY Marca
HAVING COUNT(Targa)>= 2 AND SUM(Prezzo) >= 75000;

-- Query 5
CREATE VIEW IncassoBigliettoAcquirenti AS
SELECT B.Tipo AS TipoBiglietto, SUM(Prezzo) AS IncassoTipoBiglietto
FROM Biglietto B 
JOIN Cliente C ON C.Biglietto = B.Numero
WHERE CF IN
(
	SELECT C.CF
	FROM Cliente C 
	JOIN Veicolo V on C.CF = V.Acquirente
	WHERE Prezzo > 0
	GROUP BY C.CF
	HAVING COUNT(Targa) > 0
)
GROUP BY B.Tipo
ORDER BY IncassoTipoBiglietto DESC;

SELECT * FROM IncassoBigliettoAcquirenti;

-- Query 6
SELECT DISTINCT S1.Data, S1.OraInizio, Evento1.Nome AS PrimoEvento
FROM Evento AS Evento1
JOIN Svolge AS S1 ON Evento1.Nome = S1.NomeEvento
JOIN Evento AS Evento2 ON
	Evento1.Nome <> Evento2.Nome
JOIN Svolge AS S2 ON Evento2.Nome = S2.NomeEvento
WHERE S1.Data = S2.Data 
AND S1.OraInizio = S2.OraInizio
AND S1.IDLuogo <> S2.IDLuogo;

-- Indici
CREATE INDEX idx_cfclienti
ON Cliente(CF);

CREATE INDEX idx_clienti
ON Cliente(Nome, Cognome);
