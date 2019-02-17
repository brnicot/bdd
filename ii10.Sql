CREATE SEQUENCE seqPersonnes
START WITH 1 INCREMENT BY 1;

CREATE TABLE Personnes(
	numPersonne NUMBER,
	nomPersonne VARCHAR(16),
	prenomPersonne VARCHAR(16),
	villePersonne VARCHAR(32),

	CONSTRAINT pk_Personnes PRIMARY KEY(numPersonne)
);

CREATE OR REPLACE TRIGGER t_insert_Personnes
BEFORE INSERT ON Personnes
FOR EACH ROW
BEGIN
	:NEW.numPersonne := seqPersonnes.nextVal;
END;


INSERT INTO Personnes(nomPersonne, prenomPersonne, villePersonne) VALUES('NICOT', 'Bryan', 'Montpellier');
INSERT INTO Personnes(nomPersonne, prenomPersonne, villePersonne) VALUES('FASSETTA', 'Stéphane', 'Aimargues');
INSERT INTO Personnes(nomPersonne, prenomPersonne, villePersonne) VALUES('SUREAU', 'Benjamin', 'Nîmes');

GRANT SELECT ON Personnes TO PUBLIC;

SELECT * FROM sureaub.Personnes;

INSERT INTO Personnes(nomPersonne, prenomPersonne, villePersonne) VALUES('MORAL', 'Anthony', 'Béziers');

INSERT INTO sureaub.Personnes(nomPersonne, prenomPersonne, villePersonne) VALUES('NICOT', 'Bryan', 'Montpellier');

CREATE OR REPLACE PROCEDURE nouvellePersonne(p_nomPersonne IN Personnes.nomPersonne%TYPE, p_prenomPersonne IN Personnes.prenomPersonne%TYPE, p_villePersonne IN Personnes.villePersonne%TYPE)
IS
BEGIN
	INSERT INTO Personnes(nomPersonne, prenomPersonne, villePersonne)
	VALUES(p_nomPersonne, p_prenomPersonne, p_villePersonne);
END;

CALL nouvellePersonne('VP', 'Morgane', 'Aix');

SELECT * FROM Personnes;

GRANT EXECUTE ON nouvellePersonne TO sureaub;

CALL sureaub.nouvellePersonne('Mathieu', 'Serviere', 'Mende');

REVOKE SELECT
ON Personnes
FROM PUBLIC;

CREATE OR REPLACE VIEW PersonnesMtp AS (
	SELECT * FROM Personnes
	WHERE villePersonne = 'Montpellier'
);

GRANT SELECT ON PersonnesMtp TO sureaub;

SELECT * FROM sureaub.PersonnesDeMtp;

CREATE OR REPLACE VIEW Judas AS (
	SELECT * FROM Personnes
	WHERE prenomPersonne = 'Judas'
);
GRANT ALL ON Judas TO sureaub;
GRANT SELECT ON seqPersonnes TO sureaub;

INSERT INTO sureaub.Judas(nomPersonne, prenomPersonne, villePersonne) VALUES('Bricot', 'Judas', 'Jérusalem');
INSERT INTO sureaub.Judas(nomPersonne, prenomPersonne, villePersonne) VALUES('un faux', 'juif', 'Neuilly sur Seine');
COMMIT;
SELECT * FROM sureaub.Judas;

CREATE OR REPLACE VIEW Judas AS (
	SELECT * FROM Personnes
	WHERE prenomPersonne = 'Judas'
) WITH CHECK OPTION;

INSERT INTO sureaub.Judas(nomPersonne, prenomPersonne, villePersonne) VALUES('Nicolas', 'Sarkozy', 'Neuilly sur Seine');
-- pas possible à cause du check option 

GRANT UPDATE ON Personnes TO sureaub;
INSERT INTO Personnes(nomPersonne, prenomPersonne, villePersonne) VALUES('Vocat', 'Judas', 'Paris');
COMMIT;
UPDATE sureaub.Personnes SET villePersonne = 'Strasbourg' WHERE nomPersonne = 'Vocat' AND prenomPersonne = 'Judas';
UPDATE Personnes SET villePersonne = 'Perpignan' WHERE nomPersonne = 'Vocat' AND prenomPersonne = 'Judas';

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;