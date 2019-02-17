CREATE INDEX idx_Etudiants_nomEtudiant ON Etudiants (nomEtudiant);
CREATE INDEX idx_Profs_nomProf ON Profs (nomProf);
CREATE INDEX idx_UV_nomUV ON UV (nomUV);

CREATE BITMAP INDEX idx_Profs_typeProf ON Profs (typeProf);
CREATE BITMAP INDEX idx_Profs_sexeProf ON Profs (sexeProf);
