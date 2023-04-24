const excuteSql = require('./index');


getNguoiDan = () =>{
    return excuteSql(
        'select * from elec.congdan',{
        user:'elec_dan_q1',
        password:'elec_dan_q1',
        connectString: 'localhost/orcl'

    });
};

getNguoiDanByCCCD = (cccd) =>{
    return excuteSql(
        `select * from elec.congdan where cccd = :cccd`,{
        user:'elec_admin_full',
        password:'elec_admin_full',
        connectString: 'localhost/orcl'
    },[cccd],true);
};

getNguoiGiamSatByCCCD = (cccd) =>{
    return excuteSql(
        `select * from elec.nguoigiamsat where cccd = :cccd`,{
            user:'elec_admin_full',
            password:'elec_admin_full',
            connectString: 'localhost/orcl'            
        },[cccd],true)
}

getNguoiLapCuTriByCCCD = (cccd) =>{
    return excuteSql(
        `select * from elec.nguoilapcutri where cccd = :cccd`,{
            user:'elec_admin_full',
            password:'elec_admin_full',
            connectString: 'localhost/orcl'            
        },[cccd],true)
}

getNguoiTheoDoiByCCCD = (cccd) =>{
    return excuteSql(
        `select * from elec.nguoitheodoi where cccd = :cccd`,{
            user:'elec_admin_full',
            password:'elec_admin_full',
            connectString: 'localhost/orcl'            
        },[cccd],true)

}


module.exports = {
    getNguoiDan,
    getNguoiDanByCCCD,
    getNguoiGiamSatByCCCD,
    getNguoiLapCuTriByCCCD,
    getNguoiTheoDoiByCCCD
};