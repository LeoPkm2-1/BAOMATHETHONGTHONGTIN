CREATE TRIGGER AutoFillCCCD
    BEFORE INSERT ON congdan
    FOR EACH ROW
    WHEN (new.cccd IS NULL)
DECLARE
    max_cccd NUMBER := 1;
BEGIN
    SELECT MAX(cccd) FROM congdan INTO max_cccd;
    :new.cccd := max_cccd + 1;
END;