const nguoidanModel = require('../model/nguoidanModels');
const path = require('path')
const argon2 = require('argon2');

checkMacthUserName = async (req,res) =>{
    try {
        const {username,password} = req.body;
        let userData = await nguoidanModel.getNguoiDanByCCCD(username)
        userData = userData.rows
        console.log(userData)
        if(userData.length){
            hashedPassword = userData[0].MAT_KHAU
            try {
                if (await argon2.verify(hashedPassword, password)) {
                    res.send('match');
                } else {
                    // res.send(__dirname)
                    // res.status(404).sendFile(path.join(__dirname,'/../view/login', '/login.html'))
                    res.writeHead(302, {
                        location: "login/login.html",
                      });
                    res.end();
                }
              } catch (err) {
                    console.log(err)
              }
        }else{
            res.send('not found');
        }
    } catch (error) {
        console.log(error)
    }
}



module.exports = {checkMacthUserName};
