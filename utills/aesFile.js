const crypto = require('crypto');

// Load environment variables
const key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');
const iv = Buffer.from(process.env.ENCRYPTION_IV, 'hex');

// Function to encrypt a file
function encryptBuffer(inputBuffer) {
    // Create a cipher using AES-256-CBC
    const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);

    // Encrypt the buffer
    let encrypted = cipher.update(inputBuffer);
    encrypted = Buffer.concat([encrypted, cipher.final()]);

    return encrypted;
}

// Function to decrypt a file
function decryptBuffer(encryptedBuffer) {
    // Create a decipher using AES-256-CBC
    const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);

    // Decrypt the buffer
    let decrypted = decipher.update(encryptedBuffer);
    decrypted = Buffer.concat([decrypted, decipher.final()]);

    return decrypted;
}


module.exports = {
    encryptBuffer,
    decryptBuffer
};