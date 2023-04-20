const express = require ('express');
const router = express.Router()


const a= require('./vertifylogin');
const sampleRoutes = require('./sampleRoutes');
const nguoidanRoutes = require('./nguoidanRoutes');



router.use('/vertifylogin',a);
router.use('/sample',sampleRoutes);
router.use('/nguoidan',nguoidanRoutes);


module.exports = router;
