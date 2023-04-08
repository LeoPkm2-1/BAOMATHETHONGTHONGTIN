-- kết nối với hệ quản trị cơ sở dữ liệu
conn elec/elec;

-- khuvuc
create table khuvuc(
    ma_khu_vuc NUMBER DEFAULT 100 PRIMARY KEY,
    ten_khu_vuc VARCHAR2(50) DEFAULT '' not NULL UNIQUE
);
