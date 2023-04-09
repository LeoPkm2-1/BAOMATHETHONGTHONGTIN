CREATE TRIGGER AutoFillVoteHistory
    AFTER INSERT ON phieubau
    FOR EACH ROW
DECLARE
    
BEGIN
    INSERT INTO lichsubau (cccd_cutri, ma_ungcuvien, thoi_gian)
        VALUES (:new.cccd_cutri, :new.ma_ungcuvien, :new.thoi_gian);
END;