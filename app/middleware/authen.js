const express = require ('express');
const Cookies = require('js-cookie');


authenHandler = (req,res,next) =>{
    auth = Cookies.get('auth');
    if (auth === undefined){
        res.redirect(302, "/login/login.html");

    }else{
        console.log(' da dang nhap65');
    }

    next()
}

module.exports = {
    authenHandler
}

