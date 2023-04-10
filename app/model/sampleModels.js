const excuteSql = require('./index');

getdatafromdb = ()=>{
    return excuteSql('select * from khuvuc',{
        user:'elec',
        password: 'elec',
        connectString: 'localhost/orcl'
    });
}

module.exports = getdatafromdb;