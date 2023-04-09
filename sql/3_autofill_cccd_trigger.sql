CREATE OR REPLACE TRIGGER AutoFillCCCD
    BEFORE INSERT ON congdan
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
    WHEN (new.cccd IS NULL)
DECLARE
    max_cccd NUMBER := 1;
BEGIN
    SELECT MAX(cccd) INTO max_cccd FROM congdan;
    :new.cccd := COALESCE(max_cccd + 1,1);
END;
/
