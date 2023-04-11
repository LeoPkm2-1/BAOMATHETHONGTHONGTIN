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


-- nguoi giam sat giam sat khu vuc minh o
create  OR REPLACE TRIGGER rangbuocvenggiamsat
    before INSERT 
    on elec.nguoigiamsat
    for EACH ROW
DECLARE
    -- tao exception
    e_vi_pham_khuvuc EXCEPTION;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20012 );
    -- tao bien local de luu lai khu vuc
    l_khuvuc NUMBER := 0;
BEGIN
    
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO l_khuvuc
    from elec.congdan
    where cccd = :new.cccd;

    if l_khuvuc =  :new.ma_khu_vuc then
        raise_application_error(-20012,'nguoi giam sat khong duoc quan ly khu vuc minh song');
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
    PRAGMA exception_init( e_vi_pham_khuvuc, -20013 );
    -- tao bien local de luu lai khu vuc
    l_khuvuc NUMBER := 0;
BEGIN
    
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO l_khuvuc
    from elec.congdan
    where cccd = :new.cccd;

    if l_khuvuc !=  :new.ma_khu_vuc then
        raise_application_error(-20013,'nguoi lap cu tri chi duoc lap cu tri cho khu vuc dang song');
    end if;

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;



-- khi update nguoi lap cu tri khu vuc lap cu tri phai la noi dang sinh song cua nguoi lap cu tri
create or replace trigger rangbuocupdatenguoilapcutri
    before UPDATE
    on elec.nguoilapcutri
    for each ROW
DECLARE
    -- tao exception
    e_vi_pham_khuvuc EXCEPTION;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20013 );
    -- tao bien local de luu lai khu vuc
    l_khuvuc NUMBER := 0;
BEGIN
    -- truy xuat khu vuc nguoi lap cu tri dang song
    select ma_khu_vuc
    into l_khuvuc
    from elec.congdan  
    where cccd = :new.cccd;

    if l_khuvuc != :new.ma_khu_vuc THEN
        raise_application_error(-20021, 'nguoi lap cu tri chi duoc lap cu tri cho khu vuc dang song');
    end if;

    EXCEPTION  
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND; 
END;




-- update nguoi giam sat bat buoc giam sat khu vuc khac khu vuc minh dang song  
create or replace trigger rangbuocupdatenguoigiamsat
    before UPDATE
    on elec.nguoigiamsat
    for each ROW
DECLARE
    -- tao exception
    e_vi_pham_khuvuc EXCEPTION;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20022 );
    -- tao bien local de luu lai khu vuc
    l_khuvuc NUMBER := 0;
BEGIN
    -- truy xuat khu vuc nguoi lap cu tri dang song
    select ma_khu_vuc
    into l_khuvuc
    from elec.congdan  
    where cccd = :new.cccd;

    if l_khuvuc = :new.ma_khu_vuc THEN
        raise_application_error(-20022, 'nguoi giam sat bat buoc giam sat khu vuc khac khu vuc minh dang song');
    end if;

    EXCEPTION  
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND; 
END;




-- update nguoi theo doi bat thuoc theo doi khu vuc khac khu vuc minh dang song     
create or replace trigger rangbuocupdatenguoitheodoi
    before UPDATE
    on elec.nguoitheodoi
    for each ROW
DECLARE
    -- tao exception
    e_vi_pham_khuvuc EXCEPTION;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20023);
    -- tao bien local de luu lai khu vuc
    l_khuvuc NUMBER := 0;
BEGIN
    -- truy xuat khu vuc nguoi lap cu tri dang song
    select ma_khu_vuc
    into l_khuvuc
    from elec.congdan  
    where cccd = :new.cccd;

    if l_khuvuc = :new.ma_khu_vuc THEN
        raise_application_error(-20023, 'nguoi theo doi bat buoc giam sat khu vuc khac khu vuc minh dang song');
    end if;

    EXCEPTION  
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND; 
END;




