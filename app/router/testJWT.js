const jwt = require('jsonwebtoken');
const express = require('express');
const router = express.Router();
const getEnv = require('./../config/config');

const JWT_KEY = getEnv('JWT_KEY');
// let jsont = jwt.sign({ name: 'leo',age:1 },JWT_KEY,{ expiresIn: '1800s' } );
// console.log(jsont);
jsont = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoibGVvIiwiYWdlIjoxLCJpYXQiOjE2ODIwNTI2ODgsImV4cCI6MTY4MjA1NDQ4OH0._RT5SnbQO-9eUtS8bziUtxI3yItVG1ak9KUyeBYEf1Y';
// verify a token symmetric
jwt.verify(jsont, JWT_KEY, function(err, decoded) {
    console.log(decoded) // bar
  });