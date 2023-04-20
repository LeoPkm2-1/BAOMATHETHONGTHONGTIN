const excuteSql = require('./index');


getNguoiDan = () =>{
    return excuteSql(
        'select * from elec.congdan',{
        user:'elec_dan_q1',
        password:'elec_dan_q1',
        connectString: 'localhost/orcl'

    });
}


module.exports = getNguoiDan;