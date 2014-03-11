-- --------------------------------------------------------------------------------------------------------------------
-- Kurze Beschreibung den Funktionen und Prozeduren
-- computeDiff: berechnet die Differenz zwischen Aktuelle Geschwindigkeit und die Geschwindigkeitgrenze auf irgendeine Strasse
-- getAllowedSpeed: Abfragen von der Geschwindigkeitgrenze auf irgendeine Strasse
-- getPersonenInfo: Abfragen von der personen id mit definierte Autokennzeichen
-- getPersonenName: Abfrage von der personen name mit definierte personen id
-- getStrafeBetrag: Abfragen von der Strafebetragshoehe
-- getStrafeID: Abfragen von strafe id
-- getStrafeMonat: Abfragen von Fuehrerscheinenzugsdauer
-- getStrafePunkte: Abfragen von Punkte in Flensburg werte
-- getStrasseOrt: Abfragen von dem Ort der Strasse zB.: ausserhhalb oder innerhalb geschlossener ort
-- addAkte: speichert die Strafe- und Personeninformationen in akte Tabelle
-- summeAkte: Abfragen die gesamte Strafe Informationen fuer ein Person
-- summeAkte2: Abfragen die gesamte Strafe Informationen fuer alle Person von eine temporaere Tabelle
-- --------------------------------------------------------------------------------------------------------------------


-- Tabelle fuer Personen erstellen, Werte eingeben, und Funtion erstellen um Personen zu suchen
-- von Autokennzeichen als Eingabe

CREATE TABLE personen (
	person_id INT PRIMARY KEY AUTO_INCREMENT,
	pname VARCHAR(10),
	padresse VARCHAR(50)
);

INSERT INTO personen (pname, padresse) 
VALUES ("Hans", 'Nollendorfplatz 3'), 
("Lisa", 'Kurfurstendamm 234'), ("Kevin", 'Amrumerstr.23'), 
("Hidayat", 'Leipzigerstr.5'), ("Aykut", 'Grunewaldstr.6'),
("Peter", 'Oberfeldstr.111');

DROP TABLE personen;
SELECT * FROM personen;

CREATE FUNCTION getPersonenInfo(zkennz VARCHAR(100)) RETURNS INT
RETURN IF (zkennz = 'B-AH-2020', (SELECT pID FROM zulassung WHERE zID=1),
(IF (zkennz = 'H-FX-1220', (SELECT pID FROM zulassung WHERE zID=2),
(IF (zkennz = 'S-TV-0020', (SELECT pID FROM zulassung WHERE zID=3),
(IF (zkennz = 'N-SV-5620', (SELECT pID FROM zulassung WHERE zID=4),
(IF (zkennz = 'K-XG-2780', (SELECT pID FROM zulassung WHERE zID=5),
(IF (zkennz = 'M-BV-3450', (SELECT pID FROM zulassung WHERE zID=6),
(SELECT pID FROM zulassung WHERE zID=NULL))))))))))));

CREATE FUNCTION getPersonenName(per_id INT) RETURNS VARCHAR(20)
RETURN IF (per_id = 1, (SELECT pname FROM personen WHERE person_id=1),
(IF (per_id = 2, (SELECT pname FROM personen WHERE person_id=2),
(IF (per_id = 3, (SELECT pname FROM personen WHERE person_id=3),
(IF (per_id = 4, (SELECT pname FROM personen WHERE person_id=4),
(IF (per_id = 5, (SELECT pname FROM personen WHERE person_id=5),
(IF (per_id = 6, (SELECT pname FROM personen WHERE person_id=6),
(SELECT pname FROM personen WHERE person_id=NULL))))))))))));

DROP FUNCTION getPersonenName;
DROP FUNCTION getPersonenInfo;
SELECT * FROM personen WHERE person_id=getPersonenInfo();
-- --------------------------------------------------------------------------------------------------------------------

-- Tabelle fuer Auto Information erstellen, Werte eingeben

CREATE TABLE zulassung (
	zID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	zkennz VARCHAR(25),
	pID INT,
	zHerstel VARCHAR(10),
	zModell VARCHAR(10),
	FOREIGN KEY (pID) REFERENCES personen(person_id)
);

DROP TABLE zulassung;
SELECT * FROM zulassung;

INSERT INTO zulassung (zkennz, pID, zHerstel, zModell) VALUES
('B-AH-2020', 3, 'BMW', '3er'),
('H-FX-1220', 1, 'MERCEDES', 'E-Klasse'),
('S-TV-0020', 6, 'PORSCHE', 'Panamera'),
('N-SV-5620', 2, 'AUDI', 'A6'),
('K-XG-2780', 5, 'VOLKSWAGEN', 'POLO'),
('M-BV-3450', 4, 'FERRARI', 'ENZO');

SELECT * FROM zulassung WHERE zkennz= getZID();

-- --------------------------------------------------------------------------------------------------------------------

-- Tabelle fuer Strasse Information erstellen, Werte eingeben, Funktionen um die aktuelle Geschwindigkeit 
-- zu erkennen erstellen und auch um die Geschwindigkeitgreze zu erkennen erstellen 
-- sowie die Geschwindigkeitdifferenz zu berechnen

CREATE TABLE strasse (
    sid INT PRIMARY KEY AUTO_INCREMENT,
	sname VARCHAR(15),
	speedl_frueh INT,
	speedl_spaet INT,
	ort VARCHAR(15)
);

DROP TABLE strasse;
SELECT * FROM strasse;

INSERT INTO strasse (sname, speedl_frueh, speedl_spaet, ort) VALUES 
("Strasse1", 50, 30, "IO"),
("Strasse2", 50, 50, "IO"),
("Strasse3", 30, 30, "IO"),
("Strasse4", 30, 50, "IO"),
("Strasse5", 120, 120, "AO"),
("Strasse6", 80, 80, "AO"),
("Strasse7", 180, 180, "AO");

CREATE FUNCTION computeDiff(currentSpeed INT, currentTime INT, street INT) RETURNS INT
RETURN currentSpeed - getAllowedSpeed(currentTime, street);

CREATE FUNCTION getAllowedSpeed(currentTime INT, street INT) RETURNS INT
RETURN IF (currentTime < 18, (SELECT speedl_frueh FROM strasse WHERE sid = street), 
(SELECT speedl_spaet FROM strasse WHERE sid = street));

CREATE FUNCTION getStrasseOrt(strasseID INT) RETURNS VARCHAR(15)
RETURN IF (strasseID = 1, (SELECT ort FROM strasse WHERE sid = 1),
(IF(strasseID = 2, (SELECT ort FROM strasse WHERE sid = 2),
(IF(strasseID = 3, (SELECT ort FROM strasse WHERE sid = 3),
(IF(strasseID = 4, (SELECT ort FROM strasse WHERE sid = 4),
(IF(strasseID = 5, (SELECT ort FROM strasse WHERE sid = 5),
(IF(strasseID = 6, (SELECT ort FROM strasse WHERE sid = 6),
(IF(strasseID = 7, (SELECT ort FROM strasse WHERE sid = 7),
(0))))))))))))));

SELECT sid, getAllowedSpeed(10, sid), computeDiff(120, 10, sid) FROM strasse;
SELECT * FROM strasse;

SELECT sid, getAllowedSpeed(10, sid) FROM strasse;

SELECT euro, getStrafeID(computeDiff(80,12,1)) FROM strafe WHERE strafe_id=getStrafeID(computeDiff(80,12,1));

-- --------------------------------------------------------------------------------------------------------------------

-- Tabelle fuer Strafekataloge erstellen, Werte eingeben und Funktionen erstellen um die Strafeklasse
-- jeweils ihre Zeitraum zu erkennen

CREATE TABLE strafe (
	strafe_id INT PRIMARY KEY NOT NULL,
	betrag INT,
	punktef INT,
	fschein_enzug INT
);

INSERT INTO strafe (strafe_id, betrag, punktef, fschein_enzug) VALUES
(1, 15, 0, 0), (11, 25, 0, 0), (16, 35, 0, 0),
(21, 80, 1, 0), (26, 100, 3, 0), (31, 160, 3, 1),
(41, 200, 4, 1), (51, 280, 4, 2), (61, 480, 4, 3),
(71, 680, 4, 3), (101, 10, 0, 0), (111, 20, 0, 0),
(116, 30, 0, 0),(121, 70, 1, 0), (126, 80, 3, 0),
(131, 120, 3, 0), (141, 160, 3, 1), (151, 240, 4, 1),
(161, 440, 4, 2), (171, 600, 4, 3);

DROP TABLE strafe;
SELECT * FROM strafe;

CREATE FUNCTION getStrafeID(speed INT) RETURNS INT
RETURN IF (speed >= 1 AND speed <=10, (SELECT strafe_id FROM strafe WHERE strafe_id = 1),
(IF(speed >= 11 AND speed <= 15, (SELECT strafe_id FROM strafe WHERE strafe_id = 11),
(IF(speed >= 16 AND speed <= 20, (SELECT strafe_id FROM strafe WHERE strafe_id = 16),
(IF(speed >= 21 AND speed <= 25, (SELECT strafe_id FROM strafe WHERE strafe_id = 21),
(IF(speed >= 26 AND speed <= 30, (SELECT strafe_id FROM strafe WHERE strafe_id = 26),
(IF(speed >= 31 AND speed <= 40, (SELECT strafe_id FROM strafe WHERE strafe_id = 31),
(IF(speed >= 41 AND speed <= 50, (SELECT strafe_id FROM strafe WHERE strafe_id = 41),
(IF(speed >= 51 AND speed <= 60, (SELECT strafe_id FROM strafe WHERE strafe_id = 51),
(IF(speed >= 61 AND speed <= 70, (SELECT strafe_id FROM strafe WHERE strafe_id = 61),
(SELECT strafe_id FROM strafe WHERE strafe_id = 71))))))))))))))))));

CREATE FUNCTION getStrafeBetrag(speed INT, strasse_id INT) RETURNS INT
RETURN IF (speed <=0 , 0,
(IF(speed >= 1 AND speed <=10 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 1),
(IF(speed >= 1 AND speed <=10 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 101),
(IF(speed >= 11 AND speed <= 15 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 11),
(IF(speed >= 11 AND speed <= 15 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 111),
(IF(speed >= 16 AND speed <= 20 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 16),
(IF(speed >= 16 AND speed <= 20 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 116),
(IF(speed >= 21 AND speed <= 25 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 21),
(IF(speed >= 21 AND speed <= 25 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 121),
(IF(speed >= 26 AND speed <= 30 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 26),
(IF(speed >= 26 AND speed <= 30 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 126),
(IF(speed >= 31 AND speed <= 40 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 31),
(IF(speed >= 31 AND speed <= 40 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 131),
(IF(speed >= 41 AND speed <= 50 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 41),
(IF(speed >= 41 AND speed <= 50 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 141),
(IF(speed >= 51 AND speed <= 60 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 51),
(IF(speed >= 51 AND speed <= 60 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 151),
(IF(speed >= 61 AND speed <= 70 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 61),
(IF(speed >= 61 AND speed <= 70 AND getStrasseOrt(strasse_id)='AO', (SELECT betrag FROM strafe WHERE strafe_id = 161),
(IF(speed >= 71 AND getStrasseOrt(strasse_id)='IO', (SELECT betrag FROM strafe WHERE strafe_id = 71),
(SELECT betrag FROM strafe WHERE strafe_id = 171))))))))))))))))))))))))))))))))))))))));

CREATE FUNCTION getStrafePunkte(speed INT) RETURNS INT
RETURN IF (speed <=0 , 0,
(IF(speed >= 1 AND speed <=10, (SELECT punktef FROM strafe WHERE strafe_id = 1),
(IF(speed >= 11 AND speed <= 15, (SELECT punktef FROM strafe WHERE strafe_id = 11),
(IF(speed >= 16 AND speed <= 20, (SELECT punktef FROM strafe WHERE strafe_id = 16),
(IF(speed >= 21 AND speed <= 25, (SELECT punktef FROM strafe WHERE strafe_id = 21),
(IF(speed >= 26 AND speed <= 30, (SELECT punktef FROM strafe WHERE strafe_id = 26),
(IF(speed >= 31 AND speed <= 40, (SELECT punktef FROM strafe WHERE strafe_id = 31),
(IF(speed >= 41 AND speed <= 50, (SELECT punktef FROM strafe WHERE strafe_id = 41),
(IF(speed >= 51 AND speed <= 60, (SELECT punktef FROM strafe WHERE strafe_id = 51),
(IF(speed >= 61 AND speed <= 70, (SELECT punktef FROM strafe WHERE strafe_id = 61),
(SELECT punktef FROM strafe WHERE strafe_id = 71))))))))))))))))))));

CREATE FUNCTION getStrafeMonat(speed INT) RETURNS INT
RETURN IF (speed <=0 , 0,
(IF(speed >= 1 AND speed <=10, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 1),
(IF(speed >= 11 AND speed <= 15, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 11),
(IF(speed >= 16 AND speed <= 20, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 16),
(IF(speed >= 21 AND speed <= 25, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 21),
(IF(speed >= 26 AND speed <= 30, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 26),
(IF(speed >= 31 AND speed <= 40, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 31),
(IF(speed >= 41 AND speed <= 50, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 41),
(IF(speed >= 51 AND speed <= 60, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 51),
(IF(speed >= 61 AND speed <= 70, (SELECT fschein_enzug FROM strafe WHERE strafe_id = 61),
(SELECT fschein_enzug FROM strafe WHERE strafe_id = 71))))))))))))))))))));

DROP FUNCTION getStrafeID;
DROP FUNCTION getStrafeBetrag;
DROP FUNCTION getStrafeMonat;

SELECT * FROM strafe WHERE strafe_id=getStrafeID(computeDiff());

-- --------------------------------------------------------------------------------------------------------------------

-- Tabelle fuer Akterekord erstellen, Werte eingeben

CREATE TABLE akte (
	akte_id INT PRIMARY KEY AUTO_INCREMENT,
	p_id INT,
	betrag INT,
	punkte_f INT,
	f_enzug INT,
	f_zeit INT,
	f_ort VARCHAR(15)
);

DROP TABLE akte;
SELECT * FROM akte;

-- --------------------------------------------------------------------------------------------------------------------

-- Prozedur um alle Funktionen auszufuehren mit definierter Eingabe und die Ergebnis in der Akte Tabelle speichern

SELECT * FROM akte;

DELIMITER |
CREATE PROCEDURE addAkte(IN autoKennzeichen VARCHAR(25), IN fahrZeit INT, IN fahrGeschwindigkeit INT, IN fahrStrasse INT)
	BEGIN
	INSERT INTO akte(p_id, betrag, punkte_f, f_enzug, f_zeit, f_ort) SELECT
	getPersonenInfo(autoKennzeichen),
	getStrafeBetrag(computeDiff(fahrGeschwindigkeit, fahrZeit, fahrStrasse), fahrStrasse),
	getStrafePunkte(computeDiff(fahrGeschwindigkeit, fahrZeit, fahrStrasse)),
	getStrafeMonat(computeDiff(fahrGeschwindigkeit, fahrZeit, fahrStrasse)),
	fahrZeit, getStrasseOrt(fahrStrasse);
	CALL summeAkte;
	SELECT person_id AS Personen_ID,
		   pname AS Personen_Name,
		   padresse AS Adresse,
		   zkennz AS Autokennzeichen,
		   zHerstel AS Hersteller,
		   zModell AS Modell,
		   betrag AS Strafe_Betrag_in_Euro,
		   punkte_f AS Punkte_in_Flensbburg,
		   f_enzug AS Fuehrerscheinenzug_in_Monat,
		   sname AS Strassenamen,
		   f_ort AS Inner_Ausser_Ort,
		   f_zeit AS Fahrzeit_in_Uhr
		   FROM personen, akte, zulassung, strasse
		   WHERE personen.person_id=akte.p_id AND
				 personen.person_id=zulassung.pID AND 
				 strasse.sid=fahrStrasse AND
				 akte.f_ort=getStrasseOrt(fahrStrasse);
	END;
| DELIMITER ;

-- CALL addAkte('Autokennzeichen' VARCHAR, Fahrzeit INT, Fahrgeschwindigkeit INT, StrassenID INT)

CALL addAkte('S-TV-0020', 9, 50, 3);

SELECT * FROM personen;

DROP PROCEDURE addAkte;
-- --------------------------------------------------------------------------------------------------------------------

-- Aufruf um die komplette Summe der Betraege fuer alle Personen in eine temporaere Tabelle
-- zu speichern und die Ergebnisse auszugeben.

DELIMITER |
CREATE PROCEDURE summeAkte()
	BEGIN
	INSERT INTO summe_temp(summebetrag, person_name, summe_punkte, summe_monat) SELECT SUM(betrag), getPersonenName(1), SUM(punkte_f), SUM(f_enzug) FROM akte WHERE p_id=1;
	INSERT INTO summe_temp(summebetrag, person_name, summe_punkte, summe_monat) SELECT SUM(betrag), getPersonenName(2), SUM(punkte_f), SUM(f_enzug) FROM akte WHERE p_id=2;
	INSERT INTO summe_temp(summebetrag, person_name, summe_punkte, summe_monat) SELECT SUM(betrag), getPersonenName(3), SUM(punkte_f), SUM(f_enzug) FROM akte WHERE p_id=3;
	INSERT INTO summe_temp(summebetrag, person_name, summe_punkte, summe_monat) SELECT SUM(betrag), getPersonenName(4), SUM(punkte_f), SUM(f_enzug) FROM akte WHERE p_id=4;
	INSERT INTO summe_temp(summebetrag, person_name, summe_punkte, summe_monat) SELECT SUM(betrag), getPersonenName(5), SUM(punkte_f), SUM(f_enzug) FROM akte WHERE p_id=5;
	INSERT INTO summe_temp(summebetrag, person_name, summe_punkte, summe_monat) SELECT SUM(betrag), getPersonenName(6), SUM(punkte_f), SUM(f_enzug) FROM akte WHERE p_id=6;
	SELECT person_name AS Person, summebetrag AS Betragssumme, summe_punkte AS Summe_Punkte_in_Flensburg, summe_monat AS Fuhrerscheinentzugsdauer FROM summe_temp;
	DROP TABLE summe_temp;
	CREATE TABLE summe_temp (
	summebetrag INT,
	person_name VARCHAR(20),
	summe_punkte INT,
	summe_monat INT);
	END;
| DELIMITER ;

DROP PROCEDURE summeAkte;

CALL summeAkte;
