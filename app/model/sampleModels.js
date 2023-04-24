const excuteSql = require('./index');

getdatafromdb_2 = ()=>{
    return excuteSql('select * from khuvuc',{
        user:'elec',
        password: 'elec',
        connectString: 'localhost/orcl'
    });
}


getdatafromdb_3 = ()=>{
    return excuteSql('select * from elec.congdan where cccd = 100000000',{
        user:'elec_dan_q1',
        password: 'elec_dan_q1',
        connectString: 'localhost/orcl'
    });
}
module.exports = {getdatafromdb_2,getdatafromdb_3};