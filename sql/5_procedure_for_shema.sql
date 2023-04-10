-- kết nối với hệ quản trị cơ sở dữ liệu
conn elec/elec;

-- thêm cử tri
CREATE OR REPLACE PROCEDURE pro_them_cu_tri (
    in_cccd_cu_tri IN NUMBER,
    in_ma_nguoi_lap_cu_tri IN NUMBER,
    in_thoi_gian_them IN TIMESTAMP  DEFAULT LOCALTIMESTAMP()
)
is
BEGIN
    insert into cutri(cccd,ma_nguoi_lap_cu_tri,thoi_gian) values(in_cccd_cu_tri,in_ma_nguoi_lap_cu_tri,in_thoi_gian_them);
end;

