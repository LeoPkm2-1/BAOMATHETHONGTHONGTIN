const argon2 =require("argon2");


async function a() {
    console.log(await argon2.hash('password', {
        type: argon2.argon2id,
        memoryCost: 2 ** 16,
        timeCost: 4,
        hashLength: 100,
    }));
}

a();