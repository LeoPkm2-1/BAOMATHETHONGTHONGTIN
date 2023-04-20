const  {sha256} = require('crypto-hash')


async function f() {
    console.log(await sha256('🦄'));
  }
  
f();