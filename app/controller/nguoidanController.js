const nguoidanModel = require('../model/nguoidanModels');


getNguoiDan = async (req,res) => {
    try {
        const data =await nguoidanModel()
        console.log(data.rows);
        console.log(data.rows);
        res.send(data.rows);
    } catch (error) {
        console.log(error)
    }
}

module.exports = {
    getNguoiDan
};