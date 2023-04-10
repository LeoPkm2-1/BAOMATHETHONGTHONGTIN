import argon2 from 'argon2';

class AuthController {
    static async hashPassword(password) {
        return argon2.hash(password, {
            type: argon2.argon2id,
            memoryCost: 2 ** 16,
            timeCost: 4,
            hashLength: 100,
        });
    }

    static async verifyPassword(password, hash) {
        return argon2.verify(hash, password);
    }
}

exports.module = AuthController;