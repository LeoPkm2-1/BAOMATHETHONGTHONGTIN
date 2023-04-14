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
    l_tontai NUMBER := 0;
BEGIN
    
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO l_khuvuc
    from elec.congdan
    where cccd = :new.cccd;

    if l_khuvuc =  :new.ma_khu_vuc then
        raise_application_error(-20011,'nguoi theo doi khong duoc quan ly khu vuc dang song');
    end if;

    -- truy xuất xem người theo doi mới có tồn tại trong các bảng lap cu tri hay khong
    select count(*)
    into l_tontai
    from nguoilapcutri
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20011,'nguoi theo doi khong duoc  la nguoi lap cu tri');
    end if;

    -- truy xuất xem người theo doi mới có tồn tại trong các bảng giam sat hay khong
    select count(*)
    into l_tontai
    from nguoigiamsat
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20011,'nguoi theo doi khong duoc  la nguoi giam sat');
    end if;    


    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;
/


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
    l_tontai NUMBER := 0;
BEGIN
    
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO l_khuvuc
    from elec.congdan
    where cccd = :new.cccd;

    if l_khuvuc =  :new.ma_khu_vuc then
        raise_application_error(-20012,'nguoi giam sat khong duoc quan ly khu vuc minh song');
    end if;

    -- truy xuất xem người giam sat mới có tồn tại trong các bảng lap cu tri hay khong
    select count(*)
    into l_tontai
    from nguoilapcutri
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20012,'nguoi giam sat khong duoc la nguoi lap cu tri');
    end if;

    -- truy xuất xem người giám sát mới có tồn tại trong bảng người theo dõi không
    select count(*)
    into l_tontai
    from nguoitheodoi
    where :new.cccd = cccd;

    if l_tontai != 0 then 
        raise_application_error(-20012, 'nguoi giam sat khong duoc la nguoi theo doi');
    end if; 

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;
/



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
    l_tontai NUMBER := 0;
BEGIN
    
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO l_khuvuc
    from elec.congdan
    where cccd = :new.cccd;

    if l_khuvuc !=  :new.ma_khu_vuc then
        raise_application_error(-20013,'nguoi lap cu tri chi duoc lap cu tri cho khu vuc dang song');
    end if;

    -- truy xuất xem người lập cử tri có tồn tại trong bảng người giám sát không
    select count(*)
    into l_tontai
    from nguoigiamsat
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20013,'nguoi lap cu tri khong duoc la nguoi giam sat');
    end if;

    -- truy xuất xem người lập cử tri có tồn tại trong bảng người theo dõi không
    select count(*)
    into l_tontai
    from nguoitheodoi
    where :new.cccd = cccd;

    if l_tontai != 0 then 
        raise_application_error(-20013, 'nguoi lap cu tri khong duoc la nguoi theo doi');
    end if;

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;
/


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

    -- truy xuất xem người lap cu tri mới có tồn tại trong các bảng nguoi theo doi hay khong
    select count(*)
    into l_tontai
    from nguoitheodoi
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20021,'nguoi lap cu tri khong duoc  la nguoi theo doi');
    end if;

    -- truy xuất xem người lap cu tri mới có tồn tại trong các bảng nguoi giam sat hay khong
    select count(*)
    into l_tontai
    from nguoigiamsat
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20021,'nguoi lap cu tri khong duoc  la nguoi giam sat');
    end if;

    EXCEPTION  
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND; 
END;
/



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
    l_tontai NUMBER := 0;
BEGIN
    -- truy xuat khu vuc nguoi lap cu tri dang song
    select ma_khu_vuc
    into l_khuvuc
    from elec.congdan  
    where cccd = :new.cccd;

    if l_khuvuc = :new.ma_khu_vuc THEN
        raise_application_error(-20022, 'nguoi giam sat bat buoc giam sat khu vuc khac khu vuc minh dang song');
    end if;

    -- truy xuất xem người giam sat mới có tồn tại trong các bảng lap cu tri hay khong
    select count(*)
    into l_tontai
    from nguoilapcutri
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20022,'nguoi giam sat khong duoc  la nguoi lap cu tri');
    end if;

    -- truy xuất xem người giam sat mới có tồn tại trong các bảng nguoi theo doi hay khong
    select count(*)
    into l_tontai
    from nguoitheodoi
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20022,'nguoi giam sat khong duoc  la nguoi theo doi');
    end if;

    EXCEPTION  
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND; 
END;
/



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
    l_tontai NUMBER := 0;
BEGIN
    -- truy xuat khu vuc nguoi lap cu tri dang song
    select ma_khu_vuc
    into l_khuvuc
    from elec.congdan  
    where cccd = :new.cccd;

    if l_khuvuc = :new.ma_khu_vuc THEN
        raise_application_error(-20023, 'nguoi theo doi bat buoc giam sat khu vuc khac khu vuc minh dang song');
    end if;

    -- truy xuất xem người theo doi mới có tồn tại trong các bảng lap cu tri hay khong
    select count(*)
    into l_tontai
    from nguoilapcutri
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20023,'nguoi theo doi khong duoc  la nguoi lap cu tri');
    end if;

    -- truy xuất xem người theo doi mới có tồn tại trong các bảng giam sat hay khong
    select count(*)
    into l_tontai
    from nguoigiamsat
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20023,'nguoi theo doi khong duoc  la nguoi giam sat');
    end if;   

    EXCEPTION  
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND; 
END;
/



