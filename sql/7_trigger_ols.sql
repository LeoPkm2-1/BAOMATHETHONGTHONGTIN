conn sys/4GTuqhecnELH3qoI as sysdba;
grant create any trigger to elec_admin_full;

conn elec_admin_full/elec_admin_full;

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
    tien_an char(1) := 'N';
    benh_ly char(1) := 'N';
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
    from elec.nguoigiamsat
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20013,'nguoi lap cu tri khong duoc la nguoi giam sat');
    end if;

    -- truy xuất xem người lập cử tri có tồn tại trong bảng người theo dõi không
    select count(*)
    into l_tontai
    from elec.nguoitheodoi
    where :new.cccd = cccd;

    if l_tontai != 0 then 
        raise_application_error(-20013, 'nguoi lap cu tri khong duoc la nguoi theo doi');
    end if;

    select tien_an
    into tien_an
    from elec.congdan
    where cccd = :new.cccd;

    if tien_an != 'N' then
        raise_application_error(-20013,'cong dan nay co tien an nen khong them nam trong to lap cu tri');
    end if;

    select benh_ly
    into benh_ly
    from elec.congdan
    where cccd = :new.cccd;

    if benh_ly != 'N' then
        raise_application_error(-20013,'cong dan co van de ve suc khoe nen khong the nam trong doi lap cu tri');
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
    l_tontai NUMBER := 0;
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
    from elec.nguoitheodoi
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20021,'nguoi lap cu tri khong duoc  la nguoi theo doi');
    end if;

    -- truy xuất xem người lap cu tri mới có tồn tại trong các bảng nguoi giam sat hay khong
    select count(*)
    into l_tontai
    from elec.nguoigiamsat
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

-- nguoi72 theo doi khong dc la nguoi lap cu tri voi nguoi giam sat va cung khong o trong khu vuc ho dang song
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
    tien_an char(1) := 'N';
    benh_ly char(1) := 'N';    
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
    from elec.nguoilapcutri
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20011,'nguoi theo doi khong duoc  la nguoi lap cu tri');
    end if;

    -- truy xuất xem người theo doi mới có tồn tại trong các bảng giam sat hay khong
    select count(*)
    into l_tontai
    from elec.nguoigiamsat
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20011,'nguoi theo doi khong duoc  la nguoi giam sat');
    end if;    

    select tien_an
    into tien_an
    from elec.congdan
    where cccd = :new.cccd;

    if tien_an != 'N' then
        raise_application_error(-20013,'cong dan nay co tien an nen khong the lam nguoi theo doi');
    end if;

    select benh_ly
    into benh_ly
    from elec.congdan
    where cccd = :new.cccd;

    if benh_ly != 'N' then
        raise_application_error(-20013,'cong dan co van de ve suc khoe nen khong the lam nguoi theo doi');
    end if;

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;
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
    from elec.nguoilapcutri
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20023,'nguoi theo doi khong duoc  la nguoi lap cu tri');
    end if;

    -- truy xuất xem người theo doi mới có tồn tại trong các bảng giam sat hay khong
    select count(*)
    into l_tontai
    from elec.nguoigiamsat
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
    tien_an char(1) := 'N';
    benh_ly char(1) := 'N';    
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
    from elec.nguoilapcutri
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20012,'nguoi giam sat khong duoc la nguoi lap cu tri');
    end if;

    -- truy xuất xem người giám sát mới có tồn tại trong bảng người theo dõi không
    select count(*)
    into l_tontai
    from elec.nguoitheodoi
    where :new.cccd = cccd;

    if l_tontai != 0 then 
        raise_application_error(-20012, 'nguoi giam sat khong duoc la nguoi theo doi');
    end if; 


    select tien_an
    into tien_an
    from elec.congdan
    where cccd = :new.cccd;

    if tien_an != 'N' then
        raise_application_error(-20013,'cong dan nay co tien an nen khong the lam nguoi dam sat');
    end if;

    select benh_ly
    into benh_ly
    from elec.congdan
    where cccd = :new.cccd;

    if benh_ly != 'N' then
        raise_application_error(-20013,'cong dan co van de ve suc khoe nen khong the lam nguoi dam sat');
    end if;    

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;
end;
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
    from elec.nguoilapcutri
    where :new.cccd = cccd;

    if l_tontai != 0 then
        raise_application_error(-20022,'nguoi giam sat khong duoc  la nguoi lap cu tri');
    end if;

    -- truy xuất xem người giam sat mới có tồn tại trong các bảng nguoi theo doi hay khong
    select count(*)
    into l_tontai
    from elec.nguoitheodoi
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




-- cử tri và người them cử tri phải cùng khu vực
create or REPLACE trigger tri_them_cutri_1
    before insert
    on elec.cutri
    for EACH ROW
DECLARE
    -- tao exception
    e_vi_pham_khuvuc EXCEPTION;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20013 );
    khuvuccongdan NUMBER := 0;
    khuvuclcutri NUMBER := 0;
    tien_an char(1) := 'N';
    benh_ly char(1) := 'N';
begin
    -- truy xuat khu vuc dang song hien tai va luu gia tri vao l_khuvuc
    select ma_khu_vuc
    INTO khuvuccongdan
    from elec.congdan
    where cccd = :new.cccd;

    select ma_khu_vuc
    into khuvuclcutri
    from elec.nguoilapcutri
    where cccd = :new.ma_nguoi_lap_cu_tri;

    if khuvuccongdan != khuvuclcutri then
        raise_application_error(-20013,'nguoi lap cu tri va cu tri phai cung khu vuc');
    end if;

    select tien_an
    into tien_an
    from elec.congdan
    where cccd = :new.cccd;

    if tien_an != 'N' then
        raise_application_error(-20013,'cong dan nay co tien an nen khong the di bau cu');
    end if;

    select benh_ly
    into benh_ly
    from elec.congdan
    where cccd = :new.cccd;

    if benh_ly != 'N' then
        raise_application_error(-20013,'cong dan co van de ve suc khoe nen khong the lam cu tri de bau cu');
    end if;

    EXCEPTION
        -- xu ly khi cccd khong ton tai
        when NO_DATA_FOUND then
            raise NO_DATA_FOUND;    
end;
/




-- thêm vào bảng lich sử chon cư tri
create  OR REPLACE TRIGGER tri_lschoncutri
    after INSERT 
    on elec.cutri
    for EACH ROW
DECLARE
    row_label varchar2(100);
BEGIN
    SELECT sa_session.row_label('access_election')
    into row_label
    FROM dual;
    insert into elec.lichsuchoncutri values (:new.cccd,:new.ma_nguoi_lap_cu_tri,:new.thoi_gian,'INSERT',char_to_label('access_election',row_label));
    commit;
end;
/



-- thêm vào bảng phiếu bầu, cử tri chỉ dc bấu cho ứng cử viên cùng khu vực
create or replace trigger tri_themphieubau_1
    before insert
    on elec.phieubau
    for each row
DECLARE
    e_vi_pham_khuvuc exception;
    PRAGMA exception_init( e_vi_pham_khuvuc, -20013);
    khuvuccutri number := 0;
    khuvucungcu number := 0;
    tontaicutri number := 0;
    tontaiungcuvien number := 0;
begin
    -- kiểm tra cử tri tồn tại
    select count(cccd)
    into tontaicutri
    from elec.cutri
    where cccd = :new.cccd_cutri;

    if tontaicutri = 0 then
        raise_application_error(-20013,'cu tri khong ton tai');
    end if;

    -- kiểm tra ứng cử viên tồn tại
    select count(ma_ung_cu_vien)
    into tontaiungcuvien
    from elec.ungcuvien
    where ma_ung_cu_vien = :new.ma_ungcuvien;

    if tontaiungcuvien = 0 then
        raise_application_error(-20013,'ung cu vien khong ton tai');
    end if;


    select ma_khu_vuc
    into khuvuccutri
    from elec.congdan
    where cccd = :new.cccd_cutri;

    select ma_khu_vuc
    into khuvucungcu
    from elec.ungcuvien
    where ma_ung_cu_vien = :new.ma_ungcuvien;

    if khuvuccutri != khuvucungcu then
        raise_application_error(-20013,'cu tri va ung cu vien phai cung khu vuc');
    end if;
end;
/


create or replace trigger tri_lsbaucu
    after insert
    on elec.phieubau
    for each row
DECLARE
    row_label varchar2(100);
BEGIN
    SELECT sa_session.row_label('access_election')
    into row_label
    FROM dual;
    insert into elec.lichsubaucu values(:new.cccd_cutri, :new.ma_ungcuvien,:new.thoi_gian,'INSERT',char_to_label('access_election',row_label));
    commit;
end;
/


create or replace trigger tri_trangthaicutri
    after insert
    on elec.phieubau
    for each row
DECLARE
    comp_write varchar2(100);
    level_write varchar2(100);
BEGIN
    SELECT sa_session.comp_write('access_election')
    into comp_write
    FROM dual;
    -- dbms_output.put_line(comp_write);
    -- dbms_output.put_line(comp_write);
    SELECT sa_session.max_level('access_election')
    into level_write
    FROM dual;

    SELECT
        REPLACE(comp_write, ',BC', '' )
    into comp_write
    FROM
    dual;
    insert into elec.trangthaicutri values(:new.cccd_cutri, 'Y',char_to_label('access_election',level_write||':' || comp_write));
    commit;
end;
/


create or replace trigger tri_capnhatsophieu
    after insert
    on elec.phieubau
    for each row
DECLARE
    comp_write varchar2(100);
    level_write varchar2(100);
    ton_tai number := 0;
    sophieuhientai number := 0;
BEGIN

    select count(ma_ung_cu_vien)
    into ton_tai
    from elec.sophieu
    where ma_ung_cu_vien = :new.ma_ungcuvien;

    if ton_tai != 0 then
        select so_phieu
        into sophieuhientai
        from  elec.sophieu
        where ma_ung_cu_vien = :new.ma_ungcuvien;

        sophieuhientai := sophieuhientai + 1;
        update elec.sophieu set so_phieu = sophieuhientai where ma_ung_cu_vien = :new.ma_ungcuvien;
    ELSE
        SELECT sa_session.comp_write('access_election')
        into comp_write
        FROM dual;

        SELECT sa_session.max_level('access_election')
        into level_write
        FROM dual;

        SELECT REPLACE(comp_write, ',BC', '' )
        into comp_write
        FROM dual; 

        insert into elec.sophieu values(:new.ma_ungcuvien, 1, char_to_label('access_election',level_write||':' || comp_write));      
    end if;
    commit;

end;
/



-- create or replace trigger tri_xoaphieubau
--     after delete
--     on elec.phieubau
--     for each row
-- DECLARE
--     tontai number := 0 ;
--     ex_chua_di_bau_cu exception;
--     PRAGMA exception_init( ex_chua_di_bau_cu, -20013);    
-- begin
--     select count(cccd_cutri)
--     into tontai
--     from elec.phieubau
--     where  cccd_cutri = :old.cccd_cutri;

--     if tontai = 0 then
--         raise_application_error(-20013,'Cong dan chua tien hanh bo phieu');
--     end if;
-- end;
-- /



create or replace trigger tri_cntragthaisauxoa
    after delete
    on elec.phieubau
    for each row
DECLARE 
begin
    delete elec.trangthaicutri where cccd = :old.cccd_cutri;
end;
/


create or replace trigger tri_cpsophieusauxoa
    after delete
    on elec.phieubau
    for each row
DECLARE
    sophieuhientai number := 0;
begin
    select so_phieu
    into sophieuhientai
    from elec.sophieu
    where ma_ung_cu_vien = :old.ma_ungcuvien;

    if sophieuhientai > 1 then
        sophieuhientai := sophieuhientai - 1;
        update elec.sophieu set so_phieu = sophieuhientai where  ma_ung_cu_vien = :old.ma_ungcuvien;
    ELSE
        delete elec.sophieu where ma_ung_cu_vien = :old.ma_ungcuvien;
    end if;
    commit;
end;
/