const express = require ('express');
const router = express.Router()



const sampleRoutes = require('./sampleRoutes');
const nguoidanRoutes = require('./nguoidanRoutes');




router.use('/sample',sampleRoutes);
router.use('/nguoidan',nguoidanRoutes);

module.exports = router;
