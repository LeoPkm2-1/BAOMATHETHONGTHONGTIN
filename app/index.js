const express = require('express');
const app = express();
const path = require('path');
const port = process.env.PORT ||3000;
const routes = require('./router');

const oracledb = require('oracledb');

app.use(express.static('public'));

// jump to router.
app.use('/',routes)




app.listen(port, ()=> {
    console.log(`create successfully ${port}`);
});