const model = require('../model/index')
res =  model("insert into khuvuc values(199,'1')",{
            user: 'elec',
            password : 'elec',
            connectString: 'localhost/orcl'
})
res.then(console.log)

a =  model("commit",{
    user: 'elec',
    password : 'elec',
    connectString: 'localhost/orcl'
})
a.then(console.log)