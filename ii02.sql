CREATE TABLE Profs(
	codeProf CHAR(2),
	nomProf VARCHAR(16) CONSTRAINT nn_Profs_nomProf NOT NULL,
	prenomProf VARCHAR(16),
	sexeProf CHAR(1) CONSTRAINT nn_Profs_sexeProf NOT NULL,
	typeProf CHAR(9) CONSTRAINT nn_Profs_typeProf NOT NULL,
	dateProf DATE,

	CONSTRAINT pk_Profs PRIMARY KEY(codeProf),
	CONSTRAINT ck_Profs_sexeProf CHECK (sexeProf = 'M' OR sexeProf = 'F'),
	CONSTRAINT ck_Profs_typeProf CHECK (typeProf = 'Titulaire' OR typeProf = 'Vacataire')
);

CREATE TABLE Classes(
	nomClasse CHAR(2),
	codeProfPrincipal CHAR(2) CONSTRAINT nn_Classes_principal NOT NULL,

	CONSTRAINT pk_Classes_nomClasse PRIMARY KEY(nomClasse),
	CONSTRAINT fk_Classes_codeProfPrincipal FOREIGN KEY (codeProfPrincipal) REFERENCES Profs (codeProf),
	CONSTRAINT un_Classes_codeProfPrincipal UNIQUE (codeProfPrincipal)
);

CREATE TABLE UV(
	codeUV CHAR(2),
	nomUV VARCHAR(16),
	nomComposante VARCHAR(16),
	codeProfResponsable CHAR(2) CONSTRAINT nn_UV_Responsable NOT NULL,

	CONSTRAINT pk_UV_codeUV PRIMARY KEY(codeUV),
	CONSTRAINT fk_UV_codeProfResponsable FOREIGN KEY (codeProfResponsable) REFERENCES Profs (codeProf)
);

CREATE TABLE Etudiants(
	numEtudiant CHAR(2),
	nomEtudiant VARCHAR(16) CONSTRAINT nn_Etudiants_nom NOT NULL,
	prenomEtudiant VARCHAR(16),
	classeEtudiant CHAR(2) CONSTRAINT nn_Etudiants_classeEtudiant NOT NULL,
	numEtudiantParrain CHAR(2),

	CONSTRAINT pk_Etudiants PRIMARY KEY(numEtudiant),
	CONSTRAINT fk_Etudiants_classeEtudiant FOREIGN KEY (classeEtudiant) REFERENCES Classes (nomClasse),
	CONSTRAINT fk_Etudiants_parrain FOREIGN KEY (numEtudiantParrain) REFERENCES Etudiants (numEtudiant)
);

CREATE TABLE Passer(
	numEtudiant CHAR(2),
	codeUV CHAR(2),
	note INTEGER,

	CONSTRAINT pk_Passer PRIMARY KEY(numEtudiant, codeUV),
	CONSTRAINT fk_Passer_numEtudiant FOREIGN KEY (numEtudiant) REFERENCES Etudiants (numEtudiant),
	CONSTRAINT fk_Passer_codeUV FOREIGN KEY (codeUV) REFERENCES UV (codeUV),
	CONSTRAINT ck_Passer_note CHECK (note BETWEEN 0 AND 20)
);















INSERT INTO Profs(codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES('P1', 'Palleja', 'Xavier', 'M', 'Titulaire', '11/04/1966');
INSERT INTO Profs(codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES('P2', 'Palleja', 'Nathalie', 'F', 'Vacataire', '17/11/1982');
INSERT INTO Profs(codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES('P3', 'Mugnier', 'Marie-Laure', 'F', 'Titulaire', '02/09/1970');
INSERT INTO Profs(codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES('P4', 'Garcia', 'Francis', 'M', 'Titulaire', '26/06/1969');
INSERT INTO Profs(codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES('P5', 'Bellahsene', 'Zohra', 'F', 'Titulaire', '01/01/1967');

INSERT INTO Classes(nomClasse, codeProfPrincipal) VALUES('S1', 'P3');
INSERT INTO Classes(nomClasse, codeProfPrincipal) VALUES('S2', 'P5');

INSERT INTO UV(codeUV, nomUV, nomComposante, codeProfResponsable) VALUES('01', 'PROG', 'Informatique', 'P1');
INSERT INTO UV(codeUV, nomUV, nomComposante, codeProfResponsable) VALUES('02', 'IHM', 'Communication', 'P3');
INSERT INTO UV(codeUV, nomUV, nomComposante, codeProfResponsable) VALUES('03', 'BD', 'Informatique', 'P4');

INSERT INTO Etudiants(numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant) VALUES('E1', 'Zétofrais', 'Mélanie', 'S1');
INSERT INTO Etudiants(numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES('E2', 'Bricot', 'Judas', 'S2', 'E1');
INSERT INTO Etudiants(numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES('E3', 'Némard', 'Jean', 'S1', 'E2');
INSERT INTO Etudiants(numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES('E4', 'Zeblouse', 'Agathe', 'S1', 'E1');
INSERT INTO Etudiants(numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES('E5', 'Ouzy', 'Jacques', 'S2', 'E3');

INSERT INTO Passer(numEtudiant, codeUV, note) VALUES('E1', '01', 13);
INSERT INTO Passer(numEtudiant, codeUV, note) VALUES('E1', '02', 20);
INSERT INTO Passer(numEtudiant, codeUV, note) VALUES('E1', '03', 9);
INSERT INTO Passer(numEtudiant, codeUV, note) VALUES('E3', '02', 10);
INSERT INTO Passer(numEtudiant, codeUV, note) VALUES('E3', '03', 15);
INSERT INTO Passer(numEtudiant, codeUV) VALUES('E4', '01');
INSERT INTO Passer(numEtudiant, codeUV, note) VALUES('E4', '03', 18);
INSERT INTO Passer(numEtudiant, codeUV, note) VALUES('E5', '02', 9);















ALTER TABLE Etudiants ADD dateEtudiant DATE;











UPDATE Etudiants SET dateEtudiant = '17/11/1992' WHERE numEtudiant = 'E1';
UPDATE Etudiants SET dateEtudiant = '18/10/1993' WHERE numEtudiant = 'E2';
UPDATE Etudiants SET dateEtudiant = '02/09/1992' WHERE numEtudiant = 'E3';
UPDATE Etudiants SET dateEtudiant = '25/12/1992' WHERE numEtudiant = 'E4';
UPDATE Etudiants SET dateEtudiant = '25/12/1989' WHERE numEtudiant = 'E5';




UPDATE Passer SET note = 8 WHERE numEtudiant = 'E4' AND codeUV = '01';