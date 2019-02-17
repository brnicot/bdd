DROP TABLE Personnes CASCADE CONSTRAINTS;

CREATE TABLE Personnes
(codePersonne VARCHAR(5), nomPersonne VARCHAR(20), prenomPersonne VARCHAR(20), agePersonne NUMBER,
CONSTRAINT pk_Personnes PRIMARY KEY (codePersonne)) ;

INSERT INTO Personnes (codePersonne, nomPersonne, prenomPersonne, agePersonne) VALUES ('1', 'Zétofrais', 'Mélanie',28);
INSERT INTO Personnes (codePersonne, nomPersonne, prenomPersonne, agePersonne) VALUES ('2', 'Bricot', 'Juda',46);
INSERT INTO Personnes (codePersonne, nomPersonne, prenomPersonne, agePersonne) VALUES ('3', 'Némard', 'Jean',33);
INSERT INTO Personnes (codePersonne, nomPersonne, prenomPersonne, agePersonne) VALUES ('4', 'Zeblouze', 'Agathe',NULL);
INSERT INTO Personnes (codePersonne, nomPersonne, prenomPersonne, agePersonne) VALUES ('5', 'Ouzy', 'Jacques',12);
INSERT INTO Personnes (codePersonne, nomPersonne, prenomPersonne, agePersonne) VALUES ('6', 'Deuf', 'John',NULL);
INSERT INTO Personnes (codePersonne, nomPersonne, prenomPersonne, agePersonne) VALUES ('7', 'Titouplin', NULL,0);

COMMIT;