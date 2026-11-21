DROP TABLE IF EXISTS AuditChiens;
CREATE TABLE  AuditChiens (
    IdChien serial PRIMARY KEY,
    NomChien varchar(45) NOT NULL,
    IdRace int DEFAULT NULL,
    SexeChien boolean DEFAULT NULL,
    NumTatouageChien varchar(45) DEFAULT NULL,
    DateNaissanceChien date DEFAULT NULL,
    CouleurPelageChien varchar(45) DEFAULT NULL,
    IdClient int DEFAULT NULL,
    PrixVente decimal(10,0) DEFAULT NULL,
    DateVente date DEFAULT NULL,
    DateModification timestamp
);

CREATE OR REPLACE FUNCTION audit_chien_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO AuditChiens (
        IdChien,
        NomChien,
        IdRace,
        SexeChien,
        NumTatouageChien,
        DateNaissanceChien,
        CouleurPelageChien,
        IdClient,
        PrixVente,
        DateVente,
        DateModification
    ) VALUES (
        OLD.IdChien,
        OLD.NomChien,
        OLD.IdRace,
        OLD.SexeChien,
        OLD.NumTatouageChien,
        OLD.DateNaissanceChien,
        OLD.CouleurPelageChien,
        OLD.IdClient,
        OLD.PrixVente,
        OLD.DateVente,
        NOW()
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_update_chiens
BEFORE UPDATE ON Chiens
FOR EACH ROW
EXECUTE FUNCTION audit_chien_update();



