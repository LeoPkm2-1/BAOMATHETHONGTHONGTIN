const excuteSql = require('./index');
const a = require('crypto').randomBytes(64).toString('hex')


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

console.log(a);
module.exports = {getNguoiDan,getNguoiDanByCCCD};