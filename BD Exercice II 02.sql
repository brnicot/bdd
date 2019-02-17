SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

DECLARE
	ERREUR_STRUCTURE EXCEPTION;
	TABLE_NOT_EXISTS EXCEPTION;
	PRAGMA EXCEPTION_INIT(TABLE_NOT_EXISTS,-00942);
	NB_ERREURS NUMBER ;

BEGIN
	COMMIT;
	NB_ERREURS := 0;
	DBMS_OUTPUT.PUT_LINE('Lancement du programme de test') ;
	
	BEGIN
		EXECUTE IMMEDIATE 'SELECT * FROM Profs';
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p1'', ''Palaysi'', ''Jérôme'', ''M'', ''Titulaire'', ''18/11/1964'')';
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p2'', ''Michel'', ''Fabien'', ''M'', ''Titulaire'', ''13/03/1981'')';
	EXCEPTION
		WHEN TABLE_NOT_EXISTS THEN
			DBMS_OUTPUT.PUT_LINE('La table Profs n''existe pas') ;
			RAISE ERREUR_STRUCTURE ;
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erreur sur la structure de la table Profs ou erreur sur les valeurs possibles de typeProf ou sexeProf') ;
			RAISE ERREUR_STRUCTURE ;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'SELECT * FROM Classes';
		EXECUTE IMMEDIATE 'INSERT INTO Classes (nomClasse, codeProfPrincipal) VALUES (:v1, :v2)' USING 's1', 'p1';
	EXCEPTION
		WHEN TABLE_NOT_EXISTS THEN
			DBMS_OUTPUT.PUT_LINE('La table Classes n''existe pas') ;
			RAISE ERREUR_STRUCTURE ;
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erreur sur la structure de la table Classes') ;
			RAISE ERREUR_STRUCTURE ;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'SELECT * FROM Etudiants';
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant) VALUES (:v1, :v2, :v3, :v4)' USING 'e1', 'Tanrien', 'Jean', 's1';
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES (:v1, :v2, :v3, :v4, :v5)' USING 'e2', 'Deuf', 'John', 's1', 'e1';
	EXCEPTION
		WHEN TABLE_NOT_EXISTS THEN
			DBMS_OUTPUT.PUT_LINE('La table Etudiants n''existe pas') ;
			RAISE ERREUR_STRUCTURE ;

		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erreur sur la structure de la table Etudiants') ;
			RAISE ERREUR_STRUCTURE ;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'SELECT * FROM UV';
		EXECUTE IMMEDIATE 'INSERT INTO UV (codeUV, nomUV, nomComposante, codeProfResponsable) VALUES (:v1, :v2, :v3, :v4)' USING 'u1', 'Macramé', 'Art Moderne', 'p1';
		EXECUTE IMMEDIATE 'INSERT INTO UV (codeUV, nomUV, nomComposante, codeProfResponsable) VALUES (:v1, :v2, :v3, :v4)' USING 'u2', 'Dentellerie', 'Art Moderne', 'p1';
	EXCEPTION
		WHEN TABLE_NOT_EXISTS THEN
			DBMS_OUTPUT.PUT_LINE('La table UV n''existe pas') ;
			RAISE ERREUR_STRUCTURE ;
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erreur sur la structure de la table UV ou sur la taille de nomUV') ;
			RAISE ERREUR_STRUCTURE ;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'SELECT * FROM Passer';
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (:v1, :v2, :v3)' USING 'e1', 'u1', 10;
	EXCEPTION
		WHEN TABLE_NOT_EXISTS THEN
			DBMS_OUTPUT.PUT_LINE('La table Passer n''existe pas') ;
			RAISE ERREUR_STRUCTURE ;
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erreur sur la structure de la table Passer') ;
			RAISE ERREUR_STRUCTURE ;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p1'', ''Palaysi'', ''Jérôme'', ''M'', ''Titulaire'', ''18/11/1964'')';
		DBMS_OUTPUT.PUT_LINE('Erreur de doublons sur clé primaire table Profs') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (NULL, ''Palaysi'', ''Jérôme'', ''M'', ''Titulaire'', ''18/11/1964'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec clé primaire nulle table Profs') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Classes (nomClasse, codeProfPrincipal) VALUES (''s1'', ''p1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur de doublons sur clé primaire table Classes') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Classes (nomClasse, codeProfPrincipal) VALUES (NULL, ''p1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec clé primaire nulle table Classes') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES (''e1'', ''Tanrien'', ''Jean'', ''s1'', NULL)';
		DBMS_OUTPUT.PUT_LINE('Erreur de doublons sur clé primaire table Etudiants') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES (NULL, ''Tanrien'', ''Jean'', ''s1'', NULL)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec clé primaire nulle table Etudiants') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO UV (codeUV, nomUV, nomComposante, codeProfResponsable) VALUES (''u1'', ''Macramé'', ''Art Moderne'', ''p1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur de doublons sur clé primaire table UV') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO UV (codeUV, nomUV, nomComposante, codeProfResponsable) VALUES (''u1'', ''Macramé'', ''Art Moderne'', ''p1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec clé primaire nulle table UV') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (''e1'', ''u1'', 10)';
		DBMS_OUTPUT.PUT_LINE('Erreur de doublons sur clé primaire table Passer') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (NULL, ''u1'', 10)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec clé primaire nulle table Passer') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (''e1'', NULL, 10)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec clé primaire nulle table Passer') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Classes (nomClasse, codeProfPrincipal) VALUES (''s2'', ''p9'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec Contrainte d''Intégrité Référentielle de codeProfPrincipal de la table Classes') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES (''e3'', ''Croque'', ''Odile'', ''s9'', ''e1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec Contrainte d''Intégrité Référentielle de classeEtudiant de la table Etudiant') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES (''e4'', ''Stické'', ''Sophie'', ''s1'', ''e9'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec Contrainte d''Intégrité Référentielle de numEtudiantParrain de la table Etudiant') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO UV (codeUV, nomUV, nomComposante, codeProfResponsable) VALUES (''u3'', ''Feston'', ''Art Ancien'', ''p9'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec Contrainte d''Intégrité Référentielle de codeProfPrincipal de la table UV') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (''e9'', ''01'', 10)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec Contrainte d''Intégrité Référentielle de numEtudiant de la table Passer') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (''e1'', ''u9'', 10)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec Contrainte d''Intégrité Référentielle de codeUV de la table Passer') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p30'', ''Marie-Jeanne'', ''Alain'', ''M'', ''Titulaire'', ''14/07/1989'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec format de codeProf de la table Profs') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Classes (nomClasse, codeProfPrincipal) VALUES (''s30'', ''p2'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec format de nomClasse de la table Classes') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES (''e50'', ''Touille'', ''Sacha'', ''s1'', ''e1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec format de numEtudiant de la table Etudiants') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO UV (codeUV, nomUV, nomComposante, codeProfResponsable) VALUES (''u40'', ''Broderie'', ''Art Ancien'', ''p1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec format de codeUV de la table UV') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p4'', ''Mahé'', ''Serge-André'', ''M'', ''Retraité'', ''17/01/1972'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec valeurs possibles de typeProf de la table Profs') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p5'', ''Betaille'', ''Henri'', ''M'', NULL, ''17/04/1981'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec profs qui peuvent ne pas avoir de typeProf dans la table Profs') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;

	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p6'', ''Roulle'', ''Yves'', ''H'', ''Titulaire'', ''14/07/1962'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec profs qui peuvent avoir un autre sexe que M/F dans la table Profs') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;
	
	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p7'', ''Boyat'', ''Jeannine'', NULL, ''Titulaire'', ''25/12/1958'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec profs qui peuvent ne pas avoir de sexeProf dans la table Profs') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;

	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Classes (nomClasse, codeProfPrincipal) VALUES (''s4'', ''p1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec des profs qui peuvent être prof principal de plusieurs classes dans la table Classes') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Profs (codeProf, nomProf, prenomProf, sexeProf, typeProf, dateProf) VALUES (''p6'', NULL, ''Alphonse'', ''M'', ''Titulaire'', ''01/01/1924'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec profs qui peuvent ne pas avoir de nomProf dans la table Profs') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES (''e6'', NULL, ''Marcel'', ''s1'', ''e1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec étudiants qui peuvent ne pas avoir de nomEtudiant dans la table Etudiants') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Etudiants (numEtudiant, nomEtudiant, prenomEtudiant, classeEtudiant, numEtudiantParrain) VALUES (''e7'', ''Menvussa'', ''Gérard'', NULL, ''e1'')';
		DBMS_OUTPUT.PUT_LINE('Erreur avec étudiants qui peuvent ne pas avoir de classeEtudiant dans la table Etudiants') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;

	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Classes (nomClasse, codeProfPrincipal) VALUES (''s5'', NULL)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec classes qui peuvent ne pas avoir de codeProfPrincipal dans la table Classes') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO UV (codeUV, nomUV, nomComposante, codeProfResponsable) VALUES (''u5'', ''Couture'', ''Art Ancien'', NULL)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec UV qui peuvent ne pas avoir de codeProfResponsable dans la table UV') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	DECLARE
		v_laNote NUMBER;
	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (''e2'', ''u1'', 12.3)';
		EXECUTE IMMEDIATE 'SELECT note FROM Passer WHERE numEtudiant = ''e2'' AND codeUV = ''u1''' INTO v_laNote ;
		IF v_laNote <> 12 THEN
			DBMS_OUTPUT.PUT_LINE('Erreur avec notes qui peuvent ne pas être entières dans la table Passer') ;
			NB_ERREURS := NB_ERREURS + 1 ;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;


	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (''e2'', ''u2'', -1)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec notes qui peuvent être négatives dans la table Passer') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;

	BEGIN
		EXECUTE IMMEDIATE 'INSERT INTO Passer (numEtudiant, codeUV, note) VALUES (''e1'', ''u2'', 21)';
		DBMS_OUTPUT.PUT_LINE('Erreur avec notes qui peuvent être supérieures à 20 dans la table Passer') ;
		NB_ERREURS := NB_ERREURS + 1 ;
	EXCEPTION
		WHEN OTHERS THEN NULL;
	END ;

	IF NB_ERREURS = 0
	THEN
		DBMS_OUTPUT.PUT_LINE('Pas d''erreur ; tout va bien. Vous pouvez passer à la question suivante') ;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Il y a ' || NB_ERREURS || ' erreur(s). Corrigez les avant de passer à la suite') ;
	END IF ;
	ROLLBACK ;



EXCEPTION
	WHEN ERREUR_STRUCTURE THEN
		DBMS_OUTPUT.PUT_LINE('Il y a une erreur sur la structure d''une table. Vérification du respect des contraintes impossible') ;
		ROLLBACK ;
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Echec du programme de Test') ;
		ROLLBACK ;

END ;
