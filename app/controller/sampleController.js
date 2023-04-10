const sampleModel = require('../model/sampleModels');
sampleController_1 = (req,res)=>{
    res.send('this is sample 1')
}

sampleController_2 = async (req,res)=>{
    
    try {
        const data = await sampleModel();
        console.log(JSON.stringify(data.metaData))
        res.send(JSON.stringify(data.metaData))
    } catch (error) {
        console.log(error)
    }
}

module.exports = {
    sampleController_1,
    sampleController_2
};