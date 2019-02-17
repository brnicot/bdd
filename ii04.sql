-------------------------------------------------------------------------------
-- R50 Le nom et le prénom des étudiants qui sont plus jeunes que tous les profs

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
WHERE dateEtudiant > ALL (SELECT dateProf FROM Profs)

-------------------------------------------------------------------------------
-- R51 Le nom de l'UV (ou des UV) pour laquelle la meilleure note a été attribuée

SELECT U.nomUV
FROM UV U
NATURAL JOIN Passer p
WHERE note >= ALL (SELECT note FROM Passer)

-------------------------------------------------------------------------------
-- R52 Le pourcentage d'enseignants qui sont responsables d'une UV

WITH A AS (
	SELECT COUNT(DISTINCT codeProfResponsable) AS nbResp
	FROM UV
),
B AS (
	SELECT COUNT(*) AS nbProfs FROM Profs
)

SELECT A.nbResp / B.nbProfs * 100 AS pourcentageProfsResponsables
FROM A, B;

-------------------------------------------------------------------------------
-- R53 Nom et prénom des étudiants qui ont passé toutes les UVs

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
WHERE NOT EXISTS (
	SELECT codeUV FROM UV
	MINUS
	SELECT codeUV FROM Passer
	WHERE numEtudiant = E.numEtudiant
)

-------------------------------------------------------------------------------
-- R54 Nom et prénom des étudiants qui ont passé toutes les UVs d'Informatique

SELECT nomEtudiant, prenomEtudiant
FROM Etudiants E1
WHERE NOT EXISTS  (
	SELECT * 
	FROM UV U2
	WHERE nomComposante = 'Informatique'
	AND NOT EXISTS (
		SELECT *
		FROM Passer P3
		WHERE P3.numEtudiant = E1.numEtudiant
		AND P3.codeUV = U2.codeUV
	)
)

-------------------------------------------------------------------------------
-- R55 (R03 bis) Nom et prénom des parrains ainsi que des parrains des parrains
-- ainsi que des parrains des parrains des parrains (etc...) de l'étudiant Jacques Ouzy
-- Puis modifier vos requêtes affin d'afficher le niveau de parrainage de la hiérarchie
-- (1 pour Jacques Ouzy, 2 pour ses parrains directs, 3 pour les parrains de ses parrains, etc.)

WITH A (numEtudiant, nomEtudiant, prenomEtudiant, numEtudiantParrain)
AS (SELECT numEtudiant, nomEtudiant, prenomEtudiant, numEtudiantParrain
	FROM Etudiants
	WHERE prenomEtudiant = 'Jacques' AND nomEtudiant = 'Ouzy'
	
	UNION ALL
	
	SELECT par.numEtudiant, par.nomEtudiant, par.prenomEtudiant, par.numEtudiantParrain
	FROM A filleul
	JOIN Etudiants par ON filleul.numEtudiantParrain = par.numEtudiant)
SELECT e.nomEtudiant, e.prenomEtudiant
FROM A a
JOIN Etudiants e ON a.numEtudiant = e.numEtudiant;


WITH A (numEtudiant, nomEtudiant, prenomEtudiant, numEtudiantParrain, niveau)
AS (SELECT numEtudiant, nomEtudiant, prenomEtudiant, numEtudiantParrain, 1
	FROM Etudiants
	WHERE prenomEtudiant = 'Jacques' AND nomEtudiant = 'Ouzy'
	
	UNION ALL
	
	SELECT par.numEtudiant, par.nomEtudiant, par.prenomEtudiant, par.numEtudiantParrain, niveau + 1
	FROM A filleul
	JOIN Etudiants par ON filleul.numEtudiantParrain = par.numEtudiant)
SELECT e.nomEtudiant, e.prenomEtudiant, niveau
FROM A a
JOIN Etudiants e ON a.numEtudiant = e.numEtudiant;

-------------------------------------------------------------------------------
-- R56 (R12 bis) Nom et prénom des profs qui sont plus jeunes qu'un des étudiants (au moins)
-- de l'IUT (cette fois-ci, réaliser cette requête de façon très simple grâce à une inéquijointure relationnelle)

SELECT nomProf, prenomProf
FROM Profs
WHERE codeProf IN (
	SELECT codeProf
	FROM Profs
	JOIN Etudiants ON dateProf > dateEtudiant
);

-------------------------------------------------------------------------------
-- R57 Nombre d'UVs passées par chaque étudiant (on veut grâce à une jointure externe faire apparaître les étudiants qui n'ont pas passé d'UV)

SELECT E.prenomEtudiant, E.nomEtudiant, COUNT(P.codeUV) AS nbUvPassees
FROM Passer P
NATURAL RIGHT JOIN Etudiants E
GROUP BY numEtudiant, E.prenomEtudiant, E.nomEtudiant;

-------------------------------------------------------------------------------
-- R58 (R08 bis) La liste des étudiants classés par rapport à leur moyenne générale
-- On veut faire apparaître les étudiants qui n'ont pas passé d'UV (ils n'auront bien sûr pas de moyenne)

SELECT prenomEtudiant, nomEtudiant, AVG(note) as moyG
FROM Etudiants E
NATURAL LEFT JOIN Passer
GROUP BY numEtudiant, prenomEtudiant, nomEtudiant
ORDER BY moyG DESC NULLS LAST;

-------------------------------------------------------------------------------
-- R59 Le nombre de copies corrigées par chaque prof (doivent apparaître les profs qui n'ont pas corrigé de copies)

SELECT Pr.prenomProf, Pr.nomProf, COUNT(E.numEtudiant) AS nbCopiesCorrigees
FROM Etudiants E
JOIN Passer P ON E.numEtudiant = P.numEtudiant
JOIN UV U ON U.codeUV = P.codeUV
RIGHT JOIN Profs Pr ON Pr.codeProf = U.codeProfResponsable
GROUP BY Pr.codeProf, Pr.prenomProf, Pr.nomProf
ORDER BY nbCopiesCorrigees DESC;

-------------------------------------------------------------------------------
-- R60 (R05 bis) Nom et prénom des étudiants qui n'ont pas passé d'UV. Réaliser cette fois-ci la requête à l'aide
-- d'une jointure externe et du prédicat IS NULLS

SELECT E.nomEtudiant, E.prenomEtudiant
FROM Etudiants E
LEFT JOIN Passer P ON P.numEtudiant = E.numEtudiant
WHERE P.numEtudiant IS NULL;

-------------------------------------------------------------------------------
-- R61 Nom et prénom des étudiants qui ont passé toutes les UV passées par Jean Némard

SELECT E1.nomEtudiant, E1.prenomEtudiant
FROM Etudiants E1
WHERE NOT EXISTS (
	SELECT U.*
	FROM UV U2
	JOIN Passer P2 ON U2.codeUV = P2.codeUV
	JOIN Etudiants E2 ON E2.numEtudiant = P2.numEtudiant
	WHERE E2.nomEtudiant = 'Némard'
	AND E2.prenomEtudiant = 'Jean'
	AND NOT EXISTS (
			SELECT *
			FROM Passer P3
			WHERE P3.numEtudiant = E1.numEtudiant
			--AND P3.numEtudiant != E2.numEtudiant
			AND P3.codeUV = U2.codeUV
		)
)

-------------------------------------------------------------------------------
-- R62 (R18 bis) En utilisant une expression de table WITH, afficher pour chacune des composantes,
-- l'UV pour laquelle la moyenne de la promotion est la plus faible
