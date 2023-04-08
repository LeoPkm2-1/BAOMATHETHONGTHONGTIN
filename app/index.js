const express = require('express');
const app = express();
const path = require('path');
const port = process.env.PORT ||3000;

app.get('/',(req,res)=>{
    res.send(__dirname);
});

app.get('/*',(req,res)=>{
    res.status(404).send('hihi');
});

app.listen(port, ()=> {
    console.log(`create successfully ${port}`);
});