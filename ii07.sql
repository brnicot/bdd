----------------------------------------------------------------------------------------------------------------------------------
-- Création de la BD

CREATE TABLE Client(
  numeroClient NUMBER,
  nomClient VARCHAR(16) CONSTRAINT nn_Client_nomClient NOT NULL,
  prenomClient VARCHAR(16) CONSTRAINT nn_Client_prenomClient NOT NULL,
  categorieClient VARCHAR(16),
  villeClient VARCHAR(16),

  CONSTRAINT pk_Client PRIMARY KEY(numeroClient)
);

CREATE TABLE Vendeurs(
  numeroVendeur NUMBER,
  nomVendeur VARCHAR(16),
  prenomVendeur VARCHAR(16),

  CONSTRAINT pk_Vendeurs PRIMARY KEY(numeroVendeur)
);

CREATE TABLE EtreSuivi(
  numeroClient NUMBER,
  numeroVendeur NUMBER,

  CONSTRAINT pk_EtreSuivi PRIMARY KEY (numeroClient, numeroVendeur),
  CONSTRAINT fk_EtreSuivi_numeroClient FOREIGN KEY (numeroClient) REFERENCES Client (numeroClient),
  CONSTRAINT fk_EtreSuivi_numeroVendeur FOREIGN KEY (numeroVendeur) REFERENCES Vendeurs (numeroVendeur)
);

CREATE TABLE Achats(
  referenceAchat VARCHAR(16),
  montantAchat NUMBER,
  numeroClient NUMBER,
  numeroVendeur NUMBER,

  CONSTRAINT pk_Achats_referenceAchat PRIMARY KEY (referenceAchat),
  CONSTRAINT fk_Achats_Suivi FOREIGN KEY (numeroClient, numeroVendeur) REFERENCES EtreSuivi (numeroClient, numeroVendeur)
);



CREATE OR REPLACE TRIGGER trig_EtreSuivi_Max
BEFORE INSERT ON EtreSuivi
FOR EACH ROW
DECLARE
  v_nbSuivi NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_nbSuivi
  FROM EtreSuivi
  WHERE numeroClient = :NEW.numeroClient;

  IF(v_nbSuivi >= 2) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Le client est déjà suivi par trop de vendeurs (max 2) !');
  END IF;
END;



CREATE SEQUENCE seqClient
START WITH 1 INCREMENT BY 1;



CREATE OR REPLACE PROCEDURE nouveauClient(
        p_nom IN Client.nomClient%TYPE,
        p_prenom IN Client.prenomClient%TYPE,
        p_ville IN Client.villeClient%TYPE
) IS 
BEGIN
    INSERT INTO Client(numeroClient, nomClient, prenomClient, categorieClient, villeClient)
    VALUES (seqClient.nextVal, p_nom, p_prenom, 'PROSPECTS', p_ville);
END;



CREATE OR REPLACE TRIGGER trig_Achats_catClient
AFTER INSERT ON Achats
FOR EACH ROW
BEGIN
    UPDATE Client SET categorieClient = 'CLIENTS'
    WHERE numeroClient = :NEW.numeroClient
    AND categorieClient = 'PROSPECTS';
END;



CALL nouveauClient('Bono', 'Jean', 'Montpellier');
CALL nouveauClient('Bon', 'Jean', 'Nîmes');
--> ok pour catégorie prospect et auto increment avec la séquence

INSERT INTO Vendeurs VALUES(1, 'Stické', 'Sophie');
INSERT INTO Vendeurs VALUES(2, 'Palleja', 'Xavier');

INSERT INTO EtreSuivi VALUES (1,1);
INSERT INTO Achats(referenceAchat, montantAchat, numeroClient, numeroVendeur) VALUES ('ACH1', 240, 1, 2);
--> impossible car pas client 1 pas suivi par vendeur 2

INSERT INTO Achats(referenceAchat, montantAchat, numeroClient, numeroVendeur) VALUES ('ACH1', 240, 1, 1);
--> ok car client 1 est bien suivi par le vendeur 1

SELECT * FROM Client
--> le client 1 est bien en catégorie 'CLIENTS' et plus 'PROSPECTS'

INSERT INTO EtreSuivi VALUES (1,2);
--> ok

INSERT INTO Vendeurs VALUES(3, 'Agathe', 'Zeblouse');
INSERT INTO EtreSuivi VALUES(1, 3);
--> pas possible car le client 1 est déjà suivi par 2 vendeurs !



-- SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE caTotalClient(
    p_Client IN Client.numeroClient%TYPE
) IS
    v_caTotalClient Achats.montantAchat%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;

    SELECT SUM(montantAchat) INTO v_caTotalClient
    FROM Achats
    WHERE numeroClient = p_Client;

    DBMS_OUTPUT.PUT_LINE(v_caTotalClient);
END;



CREATE OR REPLACE TRIGGER trig_Achats_minutage
BEFORE INSERT ON Achats
DECLARE
    v_Minute NUMBER;
BEGIN
    SELECT EXTRACT(MINUTE FROM SYSTIMESTAMP) INTO v_Minute
    FROM DUAL;

    IF(MOD(v_Minute, 2) = 0) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Pas possible d''acheter pendant une minute paire !');
    END IF;
END;

-- avec une minute impaire
INSERT INTO Achats(referenceAchat, montantAchat, numeroClient, numeroVendeur) VALUES ('ACH3', 6432, 1, 1);
-- ok ça marche

-- avec une minute impaire
INSERT INTO Achats(referenceAchat, montantAchat, numeroClient, numeroVendeur) VALUES ('ACH4', 666, 1, 1);
-- ok ça refuse bien
/*
  ERREUR à la ligne 1 :
  ORA-20002: Pas possible d'acheter pendant une minute paire !
  ORA-06512: à "NICOTB.TRIG_ACHATS_MINUTAGE", ligne 8
  ORA-04088: erreur lors d'exécution du déclencheur 'NICOTB.TRIG_ACHATS_MINUTAGE' 
*/