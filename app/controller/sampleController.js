const sampleModel = require('../model/sampleModels');
sampleController_1 = (req,res)=>{
    res.send('this is sample 1')
}

sampleController_2 = async (req,res)=>{
    
    try {
        const data = await sampleModel.getdatafromdb_2();
        console.log(JSON.stringify(data.metaData))
        res.send(JSON.stringify(data.metaData))
    } catch (error) {
        console.log(error)
    }
}; 

sampleController_3 = async (req,res)=>{
    
    try {
        const data = await sampleModel.getdatafromdb_3();
        console.log(data.rows[0][2])
        let a = 10;
        res.send(`${data.rows[0][1]}`);
        // res.send(JSON.stringify(data.metaData))
    } catch (error) {
        console.log(error)
    }
}; 


module.exports = {
    sampleController_1,
    sampleController_2,
    sampleController_3,
};