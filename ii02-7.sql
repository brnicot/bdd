-------------------------------------------------------------------------------
-- R01 Nom et prénom des étudiants qui sont nés en 1992, classés par ordre alphabétique de leur Nom

SELECT E.prenomEtudiant, E.nomEtudiant FROM Etudiants E
WHERE E.dateEtudiant >= '01/01/1992' AND E.dateEtudiant <= '31/12/1992'
ORDER BY E.nomEtudiant;

-------------------------------------------------------------------------------
-- R02 Nom et prénom du prof principal de l'étudiant Jacques Ouzy

SELECT P.nomProf, P.prenomProf FROM Profs P
JOIN Classes Cl ON Cl.codeProfPrincipal = P.codeProf
JOIN Etudiants E ON E.classeEtudiant = Cl.nomClasse
WHERE E.nomEtudiant = 'Ouzy' AND E.prenomEtudiant = 'Jacques';

-------------------------------------------------------------------------------
-- R03 Nom et prénom du parrain de l'étudiant Jacques Ouzy

SELECT parrains.nomEtudiant, parrains.prenomEtudiant
FROM Etudiants parrains
JOIN Etudiants filleuls ON parrains.numEtudiant = filleuls.numEtudiantParrain
WHERE filleuls.prenomEtudiant = 'Jacques' AND filleuls.nomEtudiant = 'Ouzy';

-------------------------------------------------------------------------------
-- R04 Nb d'étudiants dans la classe S1

SELECT COUNT(*)
FROM Etudiants E
WHERE E.classeEtudiant = 'S1';

-------------------------------------------------------------------------------
-- R05 Nom et prénom des étudiants qui n'ont pas passé d'UV

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
WHERE E.numEtudiant NOT IN (SELECT numEtudiant FROM Passer);

-------------------------------------------------------------------------------
-- R06 Nom des UV passées à la fois par l'étudiante Agathe Zeblouse et par l'étudiant Jean Némard

SELECT U.nomUV
FROM UV U
JOIN Passer P ON U.codeUV = P.codeUV
JOIN Etudiants E ON E.numEtudiant = P.numEtudiant
WHERE E.nomEtudiant = 'Zeblouse' AND E.prenomEtudiant = 'Agathe'

INTERSECT

SELECT U.nomUV
FROM UV U
JOIN Passer P ON U.codeUV = P.codeUV
JOIN Etudiants E ON E.numEtudiant = P.numEtudiant
WHERE E.nomEtudiant = 'Némard' AND E.prenomEtudiant = 'Jean';

-------------------------------------------------------------------------------
-- R07 Le nombre d'étudiants dans chacune des Classes

SELECT classeEtudiant, COUNT(*) FROM Etudiants
GROUP BY classeEtudiant;

-------------------------------------------------------------------------------
-- R08 La liste des étudiants (nom et prénom) classés par rapport à leur moyenne générale

SELECT E.nomEtudiant, E.prenomEtudiant, AVG(P.note) AS mg
FROM Etudiants E
JOIN Passer P ON P.numEtudiant = E.numEtudiant
GROUP BY E.nomEtudiant, E.prenomEtudiant
ORDER BY mg;

-------------------------------------------------------------------------------
-- R09 Numéro, nom et prénom des étudiants qui n'ont pas passé plus de deux UV

SELECT E.numEtudiant, E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
JOIN Passer P ON P.numEtudiant = E.numEtudiant
GROUP BY E.numEtudiant, E.nomEtudiant, E.prenomEtudiant
HAVING COUNT(*) < 2;

-------------------------------------------------------------------------------
-- R09 BIS on rajoute les étudiants n'ayant pas passé d'UV !

SELECT E.numEtudiant, E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
LEFT JOIN Passer P ON P.numEtudiant = E.numEtudiant
GROUP BY E.numEtudiant, E.nomEtudiant, E.prenomEtudiant
HAVING COUNT(*) < 2;

-------------------------------------------------------------------------------
-- R10 Nom et prénom des étudiants qui ont moins de 13 de moyenne générale et qui ont passé plus d'une UV

SELECT E.nomEtudiant, E.prenomEtudiant, AVG(P.note)
FROM Etudiants E
JOIN Passer P ON P.numEtudiant = E.numEtudiant
GROUP BY E.nomEtudiant, E.prenomEtudiant
HAVING AVG(P.note) < 13 AND COUNT(*) > 1

-------------------------------------------------------------------------------
-- R11 Nom et prénom des profs qui sont en préretraite (= ne sont ni prof principal ni responsable d'UV)

SELECT P.nomProf, P.prenomProf
FROM Profs P
WHERE NOT EXISTS (
  SELECT codeProfPrincipal FROM Classes
  WHERE codeProfPrincipal = P.codeProf

  UNION

  SELECT codeProfResponsable FROM UV
  WHERE codeProfResponsable = P.codeProf
)

-------------------------------------------------------------------------------
-- R12 Nom et prénom des profs qui sont plus jeunes qu'un des étudiants (au moins) de l'IUT

SELECT P.nomProf, P.prenomProf
FROM Profs P
WHERE P.dateProf > (SELECT MIN(dateEtudiant) FROM Etudiants);

-------------------------------------------------------------------------------
-- R13 Nom et prénom des étudiants qui ont eu la moyenne (10 ou plus) à toutes les UV qu'ils ont passées

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
NATURAL JOIN Passer P
GROUP BY E.nomEtudiant, E.prenomEtudiant
HAVING MIN(P.note) >= 10

-------------------------------------------------------------------------------
-- R14 Nom et prénom de l'étudiant qui a eu la plus mauvaise note en 'BD'
-- logique : la note de l'étudiant en BD doit être égale à la pire note en BD

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
NATURAL JOIN Passer P
JOIN UV U ON U.codeUV = P.codeUV
WHERE U.nomUV = 'BD'
AND P.note = (SELECT MIN(note)
              FROM Passer
              JOIN UV ON UV.codeUV = Passer.codeUV
              WHERE UV.nomUV = 'BD');

-------------------------------------------------------------------------------
-- R15 Nom et prénom de l'étudiant qui a la meilleure moyenne générale

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
NATURAL JOIN Passer P
GROUP BY E.numEtudiant, E.nomEtudiant, E.prenomEtudiant
HAVING AVG(P.note) =
            (SELECT MAX(AVG(note))
            FROM Passer
            GROUP BY numEtudiant
            )

-------------------------------------------------------------------------------
-- R16 Nom des UV passées soit par l'étudiante Jacques Ouzy soit par l'étudiant Jean Némard mais pas par les deux

SELECT U.nomUV
FROM UV U
NATURAL JOIN Passer
NATURAL JOIN Etudiants
WHERE (nomEtudiant = 'Ouzy' AND prenomEtudiant = 'Jacques') OR (nomEtudiant = 'Némard' AND prenomEtudiant = 'Jean')

MINUS

((SELECT U.nomUV
FROM UV U
NATURAL JOIN Passer
NATURAL JOIN Etudiants
WHERE nomEtudiant = 'Ouzy' AND prenomEtudiant = 'Jacques')
INTERSECT
(SELECT U.nomUV
FROM UV U
NATURAL JOIN Passer
NATURAL JOIN Etudiants
WHERE nomEtudiant = 'Némard' AND prenomEtudiant = 'Jean'));

-------------------------------------------------------------------------------
-- R17 Nom et prénom des étudiants qui ont obtenu la meilleure note de la promotion à au moins un partiel
-- ! ne pas faire de group by

SELECT DISTINCT (E.nomEtudiant, E.prenomEtudiant)
FROM Etudiants E
NATURAL JOIN Passer P
WHERE (P.note) IN (
  SELECT MAX(note)
  FROM Passer
  WHERE codeUV = P.codeUV
)

-------------------------------------------------------------------------------
-- R18 Pour chacune des composantes, l'UV pour laquelle la moyenne de la promotion est la plus faible

SELECT nomComposante, nomUV
FROM Passer
NATURAL JOIN UV u
GROUP BY nomComposante, nomUV
HAVING AVG(note) IN (
                      SELECT MIN(AVG(note))
                      FROM Passer
                      NATURAL JOIN UV
                      WHERE UV.nomComposante = u.nomComposante
                      GROUP BY nomUV
                    )

-------------------------------------------------------------------------------
-- R20 Le nom et le prénom des étudiants qui ont eu la moyenne (au moins 10) en IHM et en BD

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
NATURAL JOIN Passer
NATURAL JOIN UV
WHERE nomUV = 'BD' AND note >= 10

INTERSECT

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
NATURAL JOIN Passer
NATURAL JOIN UV
WHERE nomUV = 'IHM' AND note >= 10;

-------------------------------------------------------------------------------
-- R21 Le nom et le prénom des profs qui sont responsables d'une (ou plusieurs) UV sans être prof principal d'une classe

SELECT P.nomProf, P.prenomProf
FROM Profs P
WHERE EXISTS (SELECT * FROM UV WHERE codeProfResponsable = P.codeProf)
AND NOT EXISTS (SELECT * FROM Classes WHERE codeProfPrincipal = P.codeProf);

-------------------------------------------------------------------------------
-- R22 Le nom et le prénom des profs qui ont corrigé au moins autant de copies que Francis Garcia
-- ! Attention aux group by, et opérateurs ensemblistes : on doit les utiliser sur des CLEFS PRIMAIRES

SELECT Pr.nomProf, Pr.prenomProf
FROM Profs Pr
JOIN UV U ON U.codeProfResponsable = Pr.codeProf
JOIN Passer P ON P.codeUV = U.codeUV
WHERE NOT (prenomProf = 'Francis' AND nomProf = 'Garcia')
GROUP BY Pr.codeProf, Pr.nomProf, Pr.prenomProf
HAVING COUNT(P.note) >= (
  SELECT COUNT(note)
  FROM Passer
  JOIN UV ON UV.codeUV = Passer.codeUV
  JOIN Profs ON Profs.codeProf = UV.codeProfResponsable
  WHERE Profs.nomProf = 'Garcia' AND Profs.prenomProf = 'Francis'
)

-------------------------------------------------------------------------------
-- R23 La classe qui possède le plus d'étudiants

SELECT classeEtudiant
FROM Etudiants
GROUP BY classeEtudiant
HAVING COUNT(numEtudiant) = (
  SELECT MAX(COUNT(numEtudiant))
  FROM Etudiants
  GROUP BY classeEtudiant
)

-------------------------------------------------------------------------------
-- R24 Pour chaque enseignant, le nom, le prénom ainsi que le nb d'UV dont il est responsable

SELECT P.nomProf, P.prenomProf, COUNT(codeUV) AS nbUvResp
FROM Profs P
LEFT JOIN UV U ON U.codeProfResponsable = P.codeProf
GROUP BY P.nomProf, P.prenomProf;

-------------------------------------------------------------------------------
-- R25 Le nom et le prénom de l'étudiant qui possède le plus de filleuls

SELECT MAX(COUNT(numEtudiant))
FROM Etudiants
GROUP BY numEtudiantParrain;
