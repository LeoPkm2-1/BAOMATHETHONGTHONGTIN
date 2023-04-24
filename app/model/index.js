const oracledb = require('oracledb');
oracledb.autoCommit = true;
const getEnv = require('../config/config');

excuteSql = async (sql_statment,db_infor,binding=[],isObject=false) =>{
    let poolcon;
    let successful = false;
    let result = null;
    try {
        poolcon = await oracledb.createPool({
            user: db_infor.user,
            password : db_infor.password,
            connectString: db_infor.connectString
        });
        let connection;
        try {
            connection =await poolcon.getConnection();
            if(isObject){
                result = await connection.execute(
                    sql_statment,binding,
                    { outFormat: oracledb.OUT_FORMAT_OBJECT }
                );
            }
            else{
                result = await connection.execute(
                    sql_statment,
                    binding);
            }
        } catch (error) {
            throw (error)
        } finally{
            if(connection){
                try {
                    await connection.close();
                }
                catch(error){
                    throw(error)
                }
            }
        }
    } catch (error) {
        console.error(error.message);
    } finally{
        await poolcon.close();
    }
    return result;
}

module.exports = excuteSql;