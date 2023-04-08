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
    ho_va_ten VARCHAR2 ( 255) NOT NULL,
    ngay_sinh DATE NOT NULL,
    sdt NUMBER,
    que_quan VARCHAR2 ( 255) NOT NULL,
    quoc_tich VARCHAR2 ( 255) NOT NULL,
    thuong_tru VARCHAR2 ( 255) NOT NULL,
    tam_tru VARCHAR2 ( 255) NOT NULL,
    tien_an CHAR ( 1) DEFAULT 'N' NOT NULL,
    benh_ly CHAR ( 1) DEFAULT 'N' NOT NULL,
    ma_khu_vuc NUMBER DEFAULT 100 NOT NULL,
    CONSTRAINT fk_khuvuc_congdan
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);

create table cutri(
    cccd NUMBER PRIMARY KEY,
    CONSTRAINT fk_cccd_cutri
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE
);

create table ungcuvien(
    cccd NUMBER NOT NULL,
    ma_ung_cu_vien NUMBER PRIMARY KEY,
    ma_khu_vuc NUMBER DEFAULT 100 NOT NULL,
    CONSTRAINT fk_cccd_ungcuvien
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_khuvuc_ungcuvien
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);

create table nguoitheodoi(
    cccd NUMBER PRIMARY KEY,
    ma_khu_vuc NUMBER DEFAULT 100 NOT NULL,
    CONSTRAINT fk_cccd_nguoitheodoi
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_khuvuc_nguoitheodoi
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);

create table nguoigiamsat(
    cccd NUMBER PRIMARY KEY,
    ma_khu_vuc NUMBER DEFAULT 100 NOT NULL,
    CONSTRAINT fk_cccd_nguoigiamsat
        FOREIGN KEY(cccd)
        REFERENCES congdan ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_khuvuc_nguoigiamsat
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
    CONSTRAINT fk_khuvuc_nguoilapcutri
        FOREIGN KEY( ma_khu_vuc )
        REFERENCES khuvuc ( ma_khu_vuc )
        ON DELETE CASCADE
);

-- mot bang can co primary key nen de ma_phieu là so thu tu cua phieu
create table phieubau(
    ma_phieu NUMBER PRIMARY KEY,
    cccd_cutri NUMBER NOT NULL,
    ma_ungcuvien NUMBER NOT NULL,
    thoi_gian DATE NOT NULL,
    CONSTRAINT fk_cccd_cutri_bo_phieu
        FOREIGN KEY(cccd_cutri)
        REFERENCES cutri ( cccd)
        ON DELETE CASCADE,
    CONSTRAINT fk_ma_ungcuvien
        FOREIGN KEY( ma_ungcuvien )
        REFERENCES ungcuvien ( ma_ung_cu_vien)
        ON DELETE CASCADE
);