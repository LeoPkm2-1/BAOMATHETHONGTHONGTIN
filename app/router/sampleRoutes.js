const express = require('express');
const router = express.Router();

const sampleControls = require('../controller/sampleController');

router.get('/',(req,res)=>{
    res.send('this is sample');
});

router.get('/1',sampleControls.sampleController_1)
router.get('/2',sampleControls.sampleController_2)

module.exports = router;