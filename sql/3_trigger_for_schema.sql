-- kết nối với hệ quản trị cơ sở dữ liệu
conn elec/elec;

create  OR REPLACE TRIGGER rangbuocvengtheodoi
    before INSERT 
    on elec.nguoitheodoi
    for EACH ROW
DECLARE
    -- tao exception
    e_vi_pham_khuvuc EXCEPTION;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20011 );
    -- tao bien local de luu lai khu vuc
    l_khuvuc NUMBER := 0;
BEGIN
    
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO l_khuvuc
    from elec.congdan
    where cccd = :new.cccd;

    if l_khuvuc =  :new.ma_khu_vuc then
        raise_application_error(-20011,'nguoi theo doi khong duoc quan ly khu vuc dang song');
    end if;

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;


-- CREATE TRIGGER AutoFillVoteHistory
--     AFTER INSERT ON phieubau
--     FOR EACH ROW
-- DECLARE
    
-- BEGIN
--     INSERT INTO lichsubau (cccd_cutri, ma_ungcuvien, thoi_gian)
--         VALUES (:new.cccd_cutri, :new.ma_ungcuvien, :new.thoi_gian);
-- END;
-- nguoi giam sat giam sat khu vuc minh o
create  OR REPLACE TRIGGER rangbuocvenggiamsat
    before INSERT 
    on elec.nguoigiamsat
    for EACH ROW
DECLARE
    -- tao exception
    e_vi_pham_khuvuc EXCEPTION;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20011 );
    -- tao bien local de luu lai khu vuc
    l_khuvuc NUMBER := 0;
BEGIN
    
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO l_khuvuc
    from elec.congdan
    where cccd = :new.cccd;

    if l_khuvuc !=  :new.ma_khu_vuc then
        raise_application_error(-20011,'nguoi giam sat chi duoc quan ly khu vuc dang song');
    end if;

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;
-- nguoi lap cu tri lap cu tri cho khu vuc minh o
create  OR REPLACE TRIGGER rangbuocvenguoilapcutri
    before INSERT 
    on elec.nguoilapcutri
    for EACH ROW
DECLARE
    -- tao exception
    e_vi_pham_khuvuc EXCEPTION;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20011 );
    -- tao bien local de luu lai khu vuc
    l_khuvuc NUMBER := 0;
BEGIN
    
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO l_khuvuc
    from elec.congdan
    where cccd = :new.cccd;

    if l_khuvuc !=  :new.ma_khu_vuc then
        raise_application_error(-20011,'nguoi lap cu tri chi duoc lap cu tri cho khu vuc dang song');
    end if;

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;



