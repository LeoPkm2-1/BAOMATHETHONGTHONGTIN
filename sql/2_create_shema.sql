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
    mat_khau VARCHAR2 (256) DEFAULT '$argon2id$v=19$m=65536,t=3,p=4$WGMdijBQUz6k8r4j3JFobQ$gQ2uACA8Xk+TInepyJKpzFYAQhRoG2svlMHWjm3PxCs' NOT NULL, -- 123456
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



-- mot bang can co primary key nen de 
create table phieubau(
    cccd_cutri NUMBER NOT NULL PRIMARY KEY,
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