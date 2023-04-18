-- user onwer of schema
conn sys/123456 as sysdba
create user elec 
    IDENTIFIED by elec
    DEFAULT TABLESPACE Users
    QUOTA  UNLIMITED ON Users;

GRANT CONNECT TO elec;
GRANT CREATE SESSION to elec;
grant create table to elec;
grant create view, create procedure, create TRIGGER,create sequence to elec;



-- kết nối với hệ quản trị cơ sở dữ liệu
conn elec/elec;

-- khuvuc
create table khuvuc(
    ma_khu_vuc NUMBER DEFAULT 100 PRIMARY KEY,
    ten_khu_vuc VARCHAR2(50) DEFAULT '' not NULL UNIQUE
);

-- cong dan
create table congdan(
    cccd NUMBER PRIMARY KEY,
    ho_va_ten VARCHAR2 ( 50) NOT NULL,
    ngay_sinh DATE NOT NULL,
    sdt NUMBER,
    que_quan VARCHAR2 ( 50) NOT NULL,
    quoc_tich VARCHAR2 ( 50) NOT NULL,
    thuong_tru VARCHAR2 ( 255)  DEFAULT 'hanoi' NOT NULL,
    tam_tru VARCHAR2 ( 255) DEFAULT 'hanoi' NOT NULL,
    tien_an CHAR ( 1) DEFAULT 'N' NOT NULL,
    benh_ly CHAR ( 1) DEFAULT 'N' NOT NULL,
    ma_khu_vuc NUMBER  NOT NULL,
    mat_khau VARCHAR2 (256) DEFAULT '123456' NOT NULL,
    CONSTRAINT fk_congdan_khuvuc
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);

create table nguoilapcutri(
    cccd NUMBER PRIMARY KEY,
    ma_khu_vuc NUMBER DEFAULT 100 NOT NULL,
    CONSTRAINT fk_cccd_nguoilapcutri
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_nguoilapcutri_khuvuc
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);

create table cutri(
    cccd NUMBER PRIMARY KEY,
    ma_nguoi_lap_cu_tri NUMBER NOT NULL,
    thoi_gian TIMESTAMP  not null,
    CONSTRAINT fk_cutri_congdan
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_cutri_nguoilapcutri
        FOREIGN KEY(ma_nguoi_lap_cu_tri)
        REFERENCES nguoilapcutri ( cccd)
        ON DELETE CASCADE        
);

create table ungcuvien(
    cccd NUMBER NOT NULL,
    ma_ung_cu_vien NUMBER PRIMARY KEY,
    ma_khu_vuc NUMBER NOT NULL,
    CONSTRAINT fk_ungcuvien_cccd
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_ungcuvien_khuvuc
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);

create table nguoitheodoi(
    cccd NUMBER PRIMARY KEY,
    ma_khu_vuc NUMBER NOT NULL,
    CONSTRAINT fk_cccd_nguoitheodoi
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_nguoitheodoi_khuvuc
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);

create table nguoigiamsat(
    cccd NUMBER PRIMARY KEY,
    ma_khu_vuc NUMBER DEFAULT 100 NOT NULL,
    CONSTRAINT fk_nguoigiamsat_cccd
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_nguoigiamsat_khuvuc
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);



-- mot bang can co primary key nen de ma_phieu là so thu tu cua phieu
create table phieubau(
    ma_phieu NUMBER PRIMARY KEY,
    cccd_cutri NUMBER NOT NULL,
    ma_ungcuvien NUMBER NOT NULL,
    thoi_gian TIMESTAMP  NOT NULL,
    CONSTRAINT fk_cccd_cutri_bo_phieu
        FOREIGN KEY(cccd_cutri)
        REFERENCES cutri ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_ungcuvien_ma
        FOREIGN KEY( ma_ungcuvien )
        REFERENCES ungcuvien ( ma_ung_cu_vien)
        ON DELETE CASCADE
);


create table lichsubaucu (
    cccd_cutri NUMBER NOT NULL,
    ma_ungcuvien NUMBER NOT NULL,
    thoi_gian TIMESTAMP  NOT NULL,
    loai_thao_tac VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_lichsubaucu_cutri
        FOREIGN KEY(cccd_cutri)
        REFERENCES cutri ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_lichsubaucu_ungvien
        FOREIGN KEY( ma_ungcuvien )
        REFERENCES ungcuvien ( ma_ung_cu_vien)
        ON DELETE CASCADE,
    PRIMARY KEY (cccd_cutri,ma_ungcuvien,thoi_gian)

);

create table lichsuchoncutri(
    cccd_cong_dan NUMBER NOT NULL,
    ma_nguoi_lap NUMBER NOT NULL,
    thoi_gian TIMESTAMP  NOT NULL,
    loai_thao_tac VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_lschoncutri_cd
        FOREIGN key (cccd_cong_dan)
        REFERENCES congdan(cccd)
        on DELETE CASCADE,
    CONSTRAINT fk_lschoncutri_nlct
        FOREIGN key (ma_nguoi_lap)
        REFERENCES nguoilapcutri(cccd)
        on DELETE CASCADE,
    primary key(cccd_cong_dan,ma_nguoi_lap,thoi_gian)
);

create table trangthaicutri(
    cccd NUMBER NOT NULL,
    da_bau CHAR ( 1) DEFAULT 'N' NOT NULL,
    CONSTRAINT fk_trangthaict_ct
        FOREIGN KEY(cccd)
        REFERENCES cutri (cccd)
        on DELETE CASCADE
);

create table sophieu(
    ma_ung_cu_vien NUMBER NOT NULL,
    so_phieu NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT fk_sophieu_ungvien
        FOREIGN KEY (ma_ung_cu_vien)
        REFERENCES ungcuvien (ma_ung_cu_vien)
        on DELETE CASCADE
);

commit;

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


-- kết nối với hệ quản trị cơ sở dữ liệu
conn elec/elec;

-- khuvuc
insert into khuvuc (ma_khu_vuc, ten_khu_vuc) values (100, 'Quan 1');
insert into khuvuc (ma_khu_vuc, ten_khu_vuc) values (101, 'Quan 2');
insert into khuvuc (ma_khu_vuc, ten_khu_vuc) values (102, 'Quan 3');
insert into khuvuc (ma_khu_vuc, ten_khu_vuc) values (103, 'Quan 4');
insert into khuvuc (ma_khu_vuc, ten_khu_vuc) values (104, 'Quan 5');

-- quan 1
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000000, 'Pham Huu Phuc', to_date('21-SEP-16','DD-MON-RR'), 0913635407, 'Thai Binh', 'Viet Nam', 'Quan 1', 'Quan 2', 'Y', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000002, 'Pham Huu Phu', to_date('21-SEP-16','DD-MON-RR'), 0913632364, 'Thai Binh', 'Viet Nam', 'Quan 1', 'Quan 3', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000003, 'Pham Dinh Phuc', to_date('21-SEP-16','DD-MON-RR'), 0939635407, 'Thai Binh', 'Viet Nam', 'Quan 1', 'Quan 4', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000001, 'Phoung Huu Phuc', to_date('21-SEP-16','DD-MON-RR'), 0913664407, 'Thai Binh', 'Viet Nam', 'Quan 1', 'Quan 5', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000004, 'Nguyen Van A', to_date('21-SEP-16','DD-MON-RR'), 0913635407, 'Thai Binh', 'Viet Nam', 'Quan 1', 'Quan 4', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000005, 'Pham Huu B', to_date('21-SEP-16','DD-MON-RR'), 0913345407, 'Ha Noi', 'Viet Nam', 'Quan 1', 'Quan 2', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000006, 'Pham Huu C', to_date('21-SEP-16','DD-MON-RR'), 0913630207, 'Ha Noi', 'Viet Nam', 'Quan 1', 'Quan 2', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000007, 'Pham Huu D', to_date('21-SEP-16','DD-MON-RR'), 0913630207, 'Ha Noi', 'Viet Nam', 'Quan 1', 'Quan 4', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000008, 'Pham Hieu Minh', to_date('21-SEP-16','DD-MON-RR'), 0912330207, 'Ha Noi', 'Viet Nam', 'Quan 1', 'Quan 3', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000009, 'Pham Huu E', to_date('21-SEP-16','DD-MON-RR'), 0913665407, 'Ha Noi', 'Viet Nam', 'Quan 1', 'Quan 4', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000010, 'Pham Huu F', to_date('21-SEP-16','DD-MON-RR'), 0913120207, 'Ha Noi', 'Viet Nam', 'Quan 1', 'Quan 2', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000011, 'Pham Huu G', to_date('21-SEP-16','DD-MON-RR'), 0916530207, 'Ha Noi', 'Viet Nam', 'Quan 1', 'Quan 2', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000012, 'Pham Huu R', to_date('21-SEP-16','DD-MON-RR'), 0913630207, 'Bac Ninh', 'Viet Nam', 'Quan 1', 'Quan 3', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000013, 'Pham Huu H', to_date('21-SEP-16','DD-MON-RR'), 0913230207, 'Bac Ninh', 'Viet Nam', 'Quan 1', 'Quan 3', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000014, 'Pham Huu Q', to_date('21-SEP-16','DD-MON-RR'), 0913630207, 'Bac Ninh', 'Viet Nam', 'Quan 1', 'Quan 1', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000015, 'Pham Huu X', to_date('21-SEP-16','DD-MON-RR'), 0913020207, 'Bac Ninh', 'Viet Nam', 'Quan 1', 'Quan 3', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000016, 'Pham Huu R', to_date('21-SEP-16','DD-MON-RR'), 0913010207, 'Bac Ninh', 'Viet Nam', 'Quan 1', 'Quan 4', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000017, 'Pham Huu Z', to_date('21-SEP-16','DD-MON-RR'), 0910630207, 'Bac Ninh', 'Viet Nam', 'Quan 1', 'Quan 3', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000018, 'Pham Huu R', to_date('21-SEP-16','DD-MON-RR'), 0913630307, 'Bac Ninh', 'Viet Nam', 'Quan 1', 'Quan 2', 'N', 'N', 100);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000000019, 'Pham Huu R', to_date('21-SEP-16','DD-MON-RR'), 0910030207, 'Bac Ninh', 'Viet Nam', 'Quan 1', 'Quan 4', 'N', 'N', 100);
-- quan 2
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000100, 'Nguyen Huu Phuc', to_date('21-SEP-16','DD-MON-RR'), 0912355407, 'Thai Binh', 'Viet Nam', 'Quan 2', 'Quan 2', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000202, 'Nguyen Huu Phu', to_date('21-SEP-16','DD-MON-RR'), 0915624364, 'Thai Binh', 'Viet Nam', 'Quan 2', 'Quan 3', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000303, 'Nguyen Dinh Phuc', to_date('21-SEP-16','DD-MON-RR'), 0924635407, 'Thai Binh', 'Viet Nam', 'Quan 2', 'Quan 4', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000401, 'Nguyen Huu Phuc', to_date('21-SEP-16','DD-MON-RR'), 093644407, 'Thai Binh', 'Viet Nam', 'Quan 2', 'Quan 5', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000504, 'Nguyen Van F', to_date('21-SEP-16','DD-MON-RR'), 091625407, 'Thai Binh', 'Viet Nam', 'Quan 2', 'Quan 4', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000605, 'Nguyen Huu B', to_date('21-SEP-16','DD-MON-RR'), 0913421507, 'Ha Noi', 'Viet Nam', 'Quan 2', 'Quan 2', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000706, 'Nguyen Huu C', to_date('21-SEP-16','DD-MON-RR'), 0914125207, 'Ha Noi', 'Viet Nam', 'Quan 2', 'Quan 2', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000807, 'Nguyen Huu D', to_date('21-SEP-16','DD-MON-RR'), 09165240207, 'Ha Noi', 'Viet Nam', 'Quan 2', 'Quan 4', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100000908, 'Nguyen Hieu Minh', to_date('21-SEP-16','DD-MON-RR'), 0964330207, 'Ha Noi', 'Viet Nam', 'Quan 2', 'Quan 3', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100001009, 'Nguyen Huu E', to_date('21-SEP-16','DD-MON-RR'), 0913654127, 'Ha Noi', 'Viet Nam', 'Quan 2', 'Quan 4', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100001110, 'Pham Thi F', to_date('21-SEP-16','DD-MON-RR'), 0913645207, 'Ha Noi', 'Viet Nam', 'Quan 2', 'Quan 2', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000001211, 'Pham Huu G', to_date('21-SEP-16','DD-MON-RR'), 091320207, 'Ha Noi', 'Viet Nam', 'Quan 2', 'Quan 2', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000001312, 'Pham Van R', to_date('21-SEP-16','DD-MON-RR'), 0913142207, 'Bac Ninh', 'Viet Nam', 'Quan 2', 'Quan 3', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000001413, 'Phan Huu H', to_date('21-SEP-16','DD-MON-RR'), 0913965207, 'Bac Ninh', 'Viet Nam', 'Quan 2', 'Quan 3', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000001514, 'Phan Huu Q', to_date('21-SEP-16','DD-MON-RR'), 0913417207, 'Bac Ninh', 'Viet Nam', 'Quan 2', 'Quan 1', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000001615, 'Phan Huu X', to_date('21-SEP-16','DD-MON-RR'), 0913260207, 'Bac Ninh', 'Viet Nam', 'Quan 2', 'Quan 3', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000001716, 'Phuong Huu R', to_date('21-SEP-16','DD-MON-RR'), 0913074507, 'Bac Ninh', 'Viet Nam', 'Quan 2', 'Quan 4', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000001817, 'Ta Huu Z', to_date('21-SEP-16','DD-MON-RR'), 0910417207, 'Bac Ninh', 'Viet Nam', 'Quan 2', 'Quan 3', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000001918, 'Tran Huu R', to_date('21-SEP-16','DD-MON-RR'), 0913987307, 'Bac Ninh', 'Viet Nam', 'Quan 2', 'Quan 2', 'N', 'N', 101);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000002019, 'Tran Huu R', to_date('21-SEP-16','DD-MON-RR'), 0910431207, 'Bac Ninh', 'Viet Nam', 'Quan 2', 'Quan 4', 'N', 'N', 101);
-- quan 3
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100001100, 'Tran Huu Phuc', to_date('22-SEP-16','DD-MON-RR'), 0912478407, 'Quang Binh', 'Viet Nam', 'Quan 3', 'Quan 2', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100002202, 'Nguyen Van Phu', to_date('22-SEP-16','DD-MON-RR'), 091536254364, 'Quang Binh', 'Viet Nam', 'Quan 3', 'Quan 3', 'N', 'Y', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100003303, 'Trieu Dinh Phuc', to_date('23-SEP-16','DD-MON-RR'), 0941735407, 'Hai Giang', 'Viet Nam', 'Quan 3', 'Quan 4', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100004401, 'Ta Huu Phuc', to_date('24-SEP-16','DD-MON-RR'), 0952144407, 'Thai Binh', 'Viet Nam', 'Quan 3', 'Quan 5', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100005504, 'Nguyen Thi F', to_date('21-SEP-16','DD-MON-RR'), 093625407, 'Son La', 'Viet Nam', 'Quan 3', 'Quan 4', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100006605, 'Truong Huu B', to_date('21-SEP-16','DD-MON-RR'), 09134687507, 'Ha Noi', 'Viet Nam', 'Quan 3', 'Quan 2', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100007706, 'Tran Huu C', to_date('22-SEP-16','DD-MON-RR'), 0914417207, 'Ha Noi', 'Viet Nam', 'Quan 3', 'Quan 2', 'N', 'Y', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100008807, 'Dang Huu D', to_date('23-SEP-16','DD-MON-RR'), 09164170207, 'Quang Ngai', 'Viet Nam', 'Quan 3', 'Quan 4', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100009908, 'Van Hieu Minh', to_date('21-SEP-16','DD-MON-RR'), 0964362107, 'Ha Noi', 'Viet Nam', 'Quan 3', 'Quan 3', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100101009, 'Phan Huu E', to_date('21-SEP-16','DD-MON-RR'), 0913614127, 'Quang Tri', 'Viet Nam', 'Quan 3', 'Quan 4', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100111110, 'Pham Thi F', to_date('21-SEP-16','DD-MON-RR'), 0913985207, 'Phu Yen', 'Viet Nam', 'Quan 3', 'Quan 2', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000121211, 'Pham Huu G', to_date('22-SEP-16','DD-MON-RR'), 091327807, 'Ha Noi', 'Viet Nam', 'Quan 3', 'Quan 2', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000131312, 'Phang Van R', to_date('21-SEP-16','DD-MON-RR'), 0914142207, 'Bac Ninh', 'Viet Nam', 'Quan 3', 'Quan 3', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000141413, 'Phuong Huu H', to_date('23-SEP-16','DD-MON-RR'), 0918765207, 'Nam Dinh', 'Viet Nam', 'Quan 3', 'Quan 3', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000151514, 'Mai Huu Q', to_date('24-SEP-16','DD-MON-RR'), 0913657207, 'Tay Ninh', 'Viet Nam', 'Quan 3', 'Quan 1', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000161615, 'Le Huu X', to_date('21-SEP-16','DD-MON-RR'), 0913298207, 'Bac Ninh', 'Viet Nam', 'Quan 3', 'Quan 3', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000171716, 'Ho Huu R', to_date('21-SEP-16','DD-MON-RR'), 0913014507, 'Bac Ninh', 'Viet Nam', 'Quan 3', 'Quan 4', 'Y', 'Y', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000181817, 'Ta Huu Y', to_date('22-SEP-16','DD-MON-RR'), 0910464207, 'Quang Ninh', 'Viet Nam', 'Quan 3', 'Quan 3', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000191918, 'Tran Huu Y', to_date('22-SEP-16','DD-MON-RR'), 0913417307, 'Tay Ninh', 'Viet Nam', 'Quan 3', 'Quan 2', 'N', 'N', 102);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1000202019, 'Tran Huu Q', to_date('21-SEP-16','DD-MON-RR'), 0910433207, 'Bac Ninh', 'Viet Nam', 'Quan 3', 'Quan 4', 'N', 'N', 102);
-- quan 4
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100011100, 'Truong Huu Phuc', to_date('22-SEP-16','DD-MON-RR'), 0913478407, 'Quang Binh', 'Viet Nam', 'Quan 4', 'Quan 2', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100022202, 'Phan Van Phu', to_date('22-SEP-16','DD-MON-RR'), 091336254364, 'Quang Binh', 'Viet Nam', 'Quan 4', 'Quan 3', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100033303, 'Trieu Hieu Phuc', to_date('23-SEP-16','DD-MON-RR'), 0944735407, 'Hai Giang', 'Viet Nam', 'Quan 4', 'Quan 4', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100044401, 'Ta Huu Phuoc', to_date('24-SEP-16','DD-MON-RR'), 0952174407, 'Thai Binh', 'Viet Nam', 'Quan 4', 'Quan 5', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100055504, 'Ta Thi F', to_date('21-SEP-16','DD-MON-RR'), 093635407, 'Son La', 'Viet Nam', 'Quan 4', 'Quan 4', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100066605, 'Truong Hieu B', to_date('21-SEP-16','DD-MON-RR'), 09137687507, 'Ha Noi', 'Viet Nam', 'Quan 4', 'Quan 2', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100077706, 'Tran Huu X', to_date('22-SEP-16','DD-MON-RR'), 0914418207, 'Ha Noi', 'Viet Nam', 'Quan 4', 'Quan 2', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100088807, 'Dang Huu K', to_date('23-SEP-16','DD-MON-RR'), 09164120207, 'Quang Ngai', 'Viet Nam', 'Quan 4', 'Quan 4', 'N', 'y', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100099908, 'Tran Hieu Minh', to_date('21-SEP-16','DD-MON-RR'), 0964462107, 'Ha Noi', 'Viet Nam', 'Quan 4', 'Quan 3', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (110101009, 'Phan Hieu E', to_date('21-SEP-16','DD-MON-RR'), 0913617127, 'Quang Tri', 'Viet Nam', 'Quan 4', 'Quan 4', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (111111110, 'Lai Thi F', to_date('21-SEP-16','DD-MON-RR'), 0913985207, 'Phu Yen', 'Viet Nam', 'Quan 4', 'Quan 2', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1012121211, 'Lai Huu G', to_date('22-SEP-16','DD-MON-RR'), 091327807, 'Ha Noi', 'Viet Nam', 'Quan 4', 'Quan 2', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1013131312, 'Tran Van R', to_date('21-SEP-16','DD-MON-RR'), 0914142207, 'Bac Ninh', 'Viet Nam', 'Quan 4', 'Quan 3', 'Y', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1014141413, 'Phuong Huu P', to_date('23-SEP-16','DD-MON-RR'), 0918765207, 'Nam Dinh', 'Viet Nam', 'Quan 4', 'Quan 3', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1015151514, 'Mai Huu O', to_date('24-SEP-16','DD-MON-RR'), 0913657207, 'Tay Ninh', 'Viet Nam', 'Quan 4', 'Quan 1', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1016161615, 'Le Huu I', to_date('21-SEP-16','DD-MON-RR'), 0913498207, 'Bac Ninh', 'Viet Nam', 'Quan 4', 'Quan 3', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1017171716, 'Ho Huu W', to_date('21-SEP-16','DD-MON-RR'), 0913015507, 'Bac Ninh', 'Viet Nam', 'Quan 4', 'Quan 4', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1018181817, 'Ta Huu V', to_date('22-SEP-16','DD-MON-RR'), 0910466207, 'Quang Ninh', 'Viet Nam', 'Quan 4', 'Quan 3', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1019191918, 'Tran Huu N', to_date('22-SEP-16','DD-MON-RR'), 0913617307, 'Tay Ninh', 'Viet Nam', 'Quan 4', 'Quan 2', 'N', 'N', 103);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1020202019, 'Tran Huu M', to_date('21-SEP-16','DD-MON-RR'), 0916433207, 'Bac Ninh', 'Viet Nam', 'Quan 4', 'Quan 4', 'N', 'N', 103);
-- quan 5
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (110011100, 'Truong Van Phuc', to_date('22-SEP-16','DD-MON-RR'), 0917478407, 'Quang Binh', 'Viet Nam', 'Quan 5', 'Quan 2', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (120022202, 'Lai Van Phu', to_date('22-SEP-16','DD-MON-RR'), 09836254364, 'Quang Binh', 'Viet Nam', 'Quan 5', 'Quan 3', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (130033303, 'Trieu Vien Phuc', to_date('23-SEP-16','DD-MON-RR'), 0944738407, 'Hai Giang', 'Viet Nam', 'Quan 5', 'Quan 4', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (140044401, 'Ta Hieu Phuoc', to_date('24-SEP-16','DD-MON-RR'), 095217497, 'Thai Binh', 'Viet Nam', 'Quan 5', 'Quan 5', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (150055504, 'Ta Thuong F', to_date('21-SEP-16','DD-MON-RR'), 0936355647, 'Son La', 'Viet Nam', 'Quan 4', 'Quan 5', 'Y', 'Y', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (160066605, 'Truong Hieu X', to_date('21-SEP-16','DD-MON-RR'), 0913747507, 'Ha Noi', 'Viet Nam', 'Quan 5', 'Quan 2', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (170077706, 'Tran Huu K', to_date('22-SEP-16','DD-MON-RR'), 0914423207, 'Ha Noi', 'Viet Nam', 'Quan 5', 'Quan 2', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (180088807, 'Dang Huu L', to_date('23-SEP-16','DD-MON-RR'), 0916474207, 'Quang Ngai', 'Viet Nam', 'Quan 5', 'Quan 4', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (190099908, 'Tran Hieu Minh', to_date('21-SEP-16','DD-MON-RR'), 0964362107, 'Ha Noi', 'Viet Nam', 'Quan 5', 'Quan 3', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (100101009, 'Phan Hieu X', to_date('21-SEP-16','DD-MON-RR'), 0913619127, 'Quang Tri', 'Viet Nam', 'Quan 5', 'Quan 4', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (211111110, 'Lai Van F', to_date('21-SEP-16','DD-MON-RR'), 0913915207, 'Phu Yen', 'Viet Nam', 'Quan 5', 'Quan 2', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1212121211, 'Lai Huu B', to_date('22-SEP-16','DD-MON-RR'), 0913241807, 'Ha Noi', 'Viet Nam', 'Quan 5', 'Quan 2', 'Y', 'Y', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1313131312, 'Tran Van J', to_date('21-SEP-16','DD-MON-RR'), 0914542207, 'Bac Ninh', 'Viet Nam', 'Quan 5', 'Quan 3', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1414141413, 'Phuong Huu H', to_date('23-SEP-16','DD-MON-RR'), 0918465207, 'Nam Dinh', 'Viet Nam', 'Quan 5', 'Quan 3', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1515151514, 'Mai An O', to_date('24-SEP-16','DD-MON-RR'), 0913437207, 'Tay Ninh', 'Viet Nam', 'Quan 5', 'Quan 1', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1616161615, 'Le Tran I', to_date('21-SEP-16','DD-MON-RR'), 0913748207, 'Bac Ninh', 'Viet Nam', 'Quan 5', 'Quan 3', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1717171716, 'Ho Hieu W', to_date('21-SEP-16','DD-MON-RR'), 0913915507, 'Bac Ninh', 'Viet Nam', 'Quan 5', 'Quan 4', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1818181817, 'Ta Huu M', to_date('22-SEP-16','DD-MON-RR'), 0910486207, 'Quang Ninh', 'Viet Nam', 'Quan 5', 'Quan 3', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (1919191918, 'Tran Quang N', to_date('22-SEP-16','DD-MON-RR'), 0913717307, 'Tay Ninh', 'Viet Nam', 'Quan 5', 'Quan 2', 'N', 'N', 104);
insert into congdan (cccd, ho_va_ten, ngay_sinh, sdt, que_quan, quoc_tich, thuong_tru, tam_tru, tien_an, benh_ly, ma_khu_vuc)
values (2020202019, 'Tran Van M', to_date('21-SEP-16','DD-MON-RR'), 0916633207, 'Bac Ninh', 'Viet Nam', 'Quan 5', 'Quan 4', 'N', 'N', 104);

-- ungcuvien
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (100000002, 1001, 100);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (100000010, 1002, 100);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (100000100, 2001, 101);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (100000202, 2002, 101);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (100004401, 3001, 102);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (100101009, 3002, 102);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (1019191918, 4001, 103);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (1014141413, 4002, 103);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (170077706, 5001, 104);
insert into ungcuvien (cccd, ma_ung_cu_vien, ma_khu_vuc) values (211111110, 5002, 104);

insert into nguoitheodoi (cccd, ma_khu_vuc) values (2020202019, 100);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1020202019, 100);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1000202019, 101);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1000000019, 101);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1000002019, 102);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1919191918, 102);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1818181817, 103);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1000000012, 103);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1000000015, 104);
insert into nguoitheodoi (cccd, ma_khu_vuc) values (1000000016, 104);

insert into nguoigiamsat (cccd, ma_khu_vuc) values (100000003, 104);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (100000303, 104);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (100003303, 101);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (100033303, 101);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (130033303, 100);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (100000401, 100);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (100000001, 102);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (100044401, 102);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (140044401, 103);
insert into nguoigiamsat (cccd, ma_khu_vuc) values (100000004, 103);

insert into nguoilapcutri (cccd, ma_khu_vuc) values (110011100, 104);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (120022202, 104);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (100000100, 101);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (100000202, 101);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (100000000, 100);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (100000002, 100);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (100001100, 102);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (100002202, 102);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (100011100, 103);
insert into nguoilapcutri (cccd, ma_khu_vuc) values (100022202, 103);

commit;

