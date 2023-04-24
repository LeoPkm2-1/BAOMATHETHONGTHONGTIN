const nguoidanModel = require('../model/nguoidanModels');
const path = require('path')
const argon2 = require('argon2');
const { userInfo } = require('os');

checkMacthUserName = async (req,res) =>{
    try {
        const {username,password} = req.body;
        let userData = await nguoidanModel.getNguoiDanByCCCD(username)
        userData = userData.rows
        if(userData.length){
            hashedPassword = userData[0].MAT_KHAU
            try {
                if (await argon2.verify(hashedPassword, password)) {
                    console.log('dung r')
                    userData = userData[0]
                    cccd_user = userData.CCCD;
                    roles_user = await rolesUser(cccd_user);
                    let userInfo = getUserInforByKey(userData,['CCCD','HO_VA_TEN','NGAY_SINH','SDT','TIEN_AN','BENH_LY','MA_KHU_VUC'],roles_user)
                    console.log(userInfo);

                } else {
                    res.redirect(301, "/login/login.html");
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


getUserInforByKey = (UserData,keys,roles={}) =>{
    let userInfor = {}
    for (let key of keys){
        userInfor[key] = UserData[key]
    }
    return {
        ...userInfor,
        ...roles
    }
}

rolesUser = async (cccd) => {

    let giamsat = await thongtingiamsatvien(cccd);
    let lapcutri = await thongtinlapcutrivien(cccd);
    let theodoi = await thongtintheodoivien(cccd);
    const roles = {
        ... giamsat,
        ... lapcutri,
        ... theodoi
    }

    return {
        'roles': roles
    }
    
}

thongtingiamsatvien = async (cccd) =>{
    try {
        let thongtingiamsat = await nguoidanModel.getNguoiGiamSatByCCCD(cccd);
        thongtingiamsat = thongtingiamsat.rows[0]
        if (thongtingiamsat === undefined ){
            return {
                'giamsat': null
            }
        }
        return {
            'giamsat': (thongtingiamsat.MA_KHU_VUC-100) + 1
        }
    } catch (error) {
        console.log(error);
    }
}

thongtinlapcutrivien = async(cccd) =>{
    try {
        let thongtinlapcutri = await nguoidanModel.getNguoiLapCuTriByCCCD(cccd)
        thongtinlapcutri = thongtinlapcutri.rows[0]
        if (thongtinlapcutri === undefined){
            return {
                'lapcutri': null
            }
        }
        return {
            'lapcutri': (thongtinlapcutri.MA_KHU_VUC - 100) + 1
        }
    } catch (error) {
        console.log(error);
    }
}

thongtintheodoivien = async (cccd) =>{
    try {
        let thongtintheodoi = await nguoidanModel.getNguoiTheoDoiByCCCD(cccd)
        thongtintheodoi = thongtintheodoi.rows[0]
        if (thongtintheodoi === undefined){
            return {
                'theodoi': null
            }
        }
        return {
            'theodoi': (thongtintheodoi.MA_KHU_VUC - 100) + 1
        }
    } catch (error) {
        console.log(error);
    }
}


module.exports = {checkMacthUserName};
