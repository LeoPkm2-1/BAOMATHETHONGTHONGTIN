const express = require('express');
const app = express();
const path = require('path');
const port = process.env.PORT ||3000;

// app.use(express.urlencoded({extended: false}));

// app.use(express.json());

// app.use(express.static(path.join(__dirname,'/public')));

const logger = (req,res,next)=>{
    next();
    const med = req.method;
    const url = req.url;
    const time = new Date().getFullYear()
    console.log(med,url,time,'xin chao')

}


app.get('/',(req,res)=>{
    res.sendFile(path.join(__dirname,'view','index.html'));
});



app.get('/*',(req,res)=>{
    res.status(408).send('hehe');
});

app.listen(port, ()=> {
    console.log(`create successfully ${port}`);
});