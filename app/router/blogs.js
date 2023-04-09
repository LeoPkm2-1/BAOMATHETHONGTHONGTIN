const express = require('express')
const router = express.Router();

router.get('/',(req,res)=>{
    res.send('All Blogs');
});

// router.get('/:id',(req,res)=>{
//     res.send('View Blogs' + req.params.id);
// });

module.exports = router;