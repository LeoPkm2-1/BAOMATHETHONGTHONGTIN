const express = require ('express');
const router = express.Router()



const sampleRoutes = require('./sampleRoutes');




router.use('/sample',sampleRoutes)

module.exports = router;
