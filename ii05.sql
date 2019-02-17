----------------------------------------------------------------------------------------------------------------------------------
-- R1 : pour chacun des diplômes de la table Diplômes, le nombre de salariés titulaires du diplôme
SELECT D.nomDiplome, COUNT(P.numSalarie)
FROM Diplomes D
JOIN Posseder P on P.referenceDiplome = D.referenceDiplome
GROUP BY D.referenceDiplome

----------------------------------------------------------------------------------------------------------------------------------
-- R2 : le nom du projet qui utilise le plus de salariés
SELECT P.nomProjet
FROM Projets P
JOIN EtreAffecte E ON E.codeProjet = P.codeProjet
GROUP BY P.nomProjet
HAVING COUNT(E.numSalarie) = (SELECT MAX(COUNT(*)) FROM EtreAffecte GROUP BY codeProjet)

----------------------------------------------------------------------------------------------------------------------------------
-- R3 : le nom des projets dont tous les salariés possèdent un salaire supérieur à 2500 €

SELECT DISTINCT P.nomProjet
FROM Projets P
JOIN EtreAffecte E ON E.codeProjet = P.codeProjet
WHERE NOT EXISTS (
    SELECT S.*
    FROM Salaries S
    WHERE S.numSalarie = E.numSalarie
    AND S.salaireSalarie <= 2500
)

----------------------------------------------------------------------------------------------------------------------------------
-- R4 : nom et prénom des salariés qui possèdent un diplôme 'Licence Pro' et qui ne sont affectés à aucun projets

SELECT S.nomSalarie, S.prenomSalarie
FROM Salaries S
JOIN Posseder P ON P.numSalarie = S.numSalarie
JOIN Diplomes D ON D.referenceDiplome = P.referenceDiplome
WHERE D.nomDiplome = 'Licence Pro'
AND S.numSalarie NOT IN (SELECT numSalarie FROM EtreAffecte)

----------------------------------------------------------------------------------------------------------------------------------
-- R5 : le nom et prénom des supérieurs hiérarchiques (direct et indirects) de la salarié 'Sophie Stické'

WITH A (numSalarie, nomSalarie, prenomSalarie, numSalarieChef)
AS (SELECT numSalarie, nomSalarie, prenomSalarie, numSalarieChef
	FROM Salaries
	WHERE nomSalarie = 'Stické' AND prenomSalarie = 'Sophie'

	UNION ALL

	SELECT sup.numSalarie, sup.nomSalarie, sup.prenomSalarie, sup.numSalarieChef
	FROM A sophiesticke
	JOIN Salaries sup ON sophiesticke.numSalarieChef = sup.numSalarie)
SELECT S.numSalarie, S.nomSalarie, S.prenomSalarie
FROM A a
JOIN Salaries S ON a.numSalarie = S.numSalarie;

----------------------------------------------------------------------------------------------------------------------------------
-- R6 : nom et prénom des salariés qui ont été affectés sur tous les projets des clients de la catégorie 'Gros client'

SELECT S.nomSalarie, S.prenomSalarie
FROM Salaries S
WHERE NOT EXISTS (
    SELECT *
    FROM Projets P
    JOIN Clients C ON C.numClient = P.numClient
    WHERE C.categorieClient = 'Gros Client'
    AND NOT EXISTS (
        SELECT *
        FROM EtreAffecte E
        WHERE E.numSalarie = S.numSalarie
        AND E.codeProjet = P.codeProjet
    )
)

----------------------------------------------------------------------------------------------------------------------------------
-- R7 : le nom et le prénom des salariés qui possèdent tous les diplômes qu'a obtenu le salarié 'Jean Bono'

SELECT S.nomSalarie, S.prenomSalarie
FROM Salaries S
WHERE NOT EXISTS(

  SELECT P.referenceDiplome
  FROM Posseder P
  WHERE P.numSalarie = S.numSalarie

  MINUS

  SELECT P.referenceDiplome
  FROM Posseder P
  JOIN Salaries S2 ON P.numSalarie = S2.numSalarie
  WHERE S2.nomSalarie = 'Bono' AND S2.prenomSalarie = 'Jean'

)

----------------------------------------------------------------------------------------------------------------------------------
-- R8 : pour chaque catégorie de clients, le nom du client qui possède le plus de projets

SELECT C.categorieClient, P.numClient, COUNT(*)
FROM Projets P
JOIN Clients C ON C.numClient = P.numClient
GROUP BY C.categorieClient, P.numClient
HAVING COUNT(P.codeProjet) IN (
    SELECT MAX(COUNT(codeProjet))
    FROM Projets
    NATURAL JOIN Clients
    GROUP BY categorieClient
)

----------------------------------------------------------------------------------------------------------------------------------
-- R9 : pour chacun des clients de la table Clients, le nb de projets de plus de 50 000€ qui ont été contractés

SELECT C.nomClient, COUNT(P.codeProjet)
FROM Projets P
JOIN Clients C ON C.numClient = P.numClient
WHERE P.budgetProjet > 50000
GROUP BY C.numClient, C.nomClient;

----------------------------------------------------------------------------------------------------------------------------------
-- R10 : le nom des projets pour lesquels aucun salarié affecté ne possède plusieurs diplômes

SELECT DISTINCT P.nomProjet
FROM Projets P
JOIN EtreAffecte E ON E.codeProjet = P.codeProjet
WHERE NOT EXISTS (
      SELECT numSalarie, COUNT(*)
      FROM Posseder
      WHERE numSalarie = E.numSalarie
      GROUP BY numSalarie

      MINUS

      SELECT numSalarie, COUNT(*)
      FROM Posseder
      WHERE numSalarie = E.numSalarie
      GROUP BY numSalarie
      HAVING COUNT(*) < 2
)

----------------------------------------------------------------------------------------------------------------------------------
-- R11 : le trajet qu'il faut emprunter en train pour aller du siège social de LOGISOFT (Mtp) chez le client 'Peugeot' afin d'avoir le moins de correspondance possible

?

----------------------------------------------------------------------------------------------------------------------------------
-- R12 : le trajet qu'il faut emprunter en train pour aller du siège social de LOGISOFT (Mtp) chez le client 'Peugeot' afin d'avoir le trajet le plus court (en temps)

?

----------------------------------------------------------------------------------------------------------------------------------
-- R13 : le nom et le prénom des salariés qui possèdent tous les diplômes qu'a obtenu le salarié 'Jean Bono', et uniquement ceux là

SELECT S.nomSalarie, S.prenomSalarie
FROM Salaries S
WHERE NOT EXISTS (
  SELECT P.referenceDiplome
  FROM Posseder P
  WHERE P.numSalarie = S.numSalarie

  MINUS

  SELECT P2.referenceDiplome
  FROM Posseder P2
  JOIN Salaries S2 ON S2.numSalarie = P2.numSalarie
  WHERE S2.prenomSalarie = 'Jean' AND S2.nomSalarie = 'Bono'
)
AND NOT EXISTS (
  SELECT P2.referenceDiplome
  FROM Posseder P2
  JOIN Salaries S2 ON S2.numSalarie = P2.numSalarie
  WHERE S2.prenomSalarie = 'Jean' AND S2.nomSalarie = 'Bono'

  MINUS

  SELECT P.referenceDiplome
  FROM Posseder P
  WHERE P.numSalarie = S.numSalarie
)
