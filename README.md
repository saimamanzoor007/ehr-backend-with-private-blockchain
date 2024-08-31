# EHR Management System with Blockchain and AES Encryption

## Overview

This project is an **Electronic Health Record (EHR) Management System** designed to ensure the security and privacy of patient data. It integrates **Private blockchain technology** for immutable data storage and **AES-256 encryption** to protect sensitive information. The backend is built using **Node.js** with **Express.js**, interacting with a **Quorum private blockchain** and **IPFS** for decentralized file storage.

## Features

- **JWT Authentication**: Secure user login and session management.
- **Role-Based Access Control (RBAC)**: Fine-grained control over user permissions based on roles.
- **AES-256 Encryption**: Strong encryption for sensitive patient data before storage.
- **IPFS Integration**: Decentralized storage of encrypted medical records.
- **Quorum Blockchain**: Immutable storage of IPFS hashes and medical record metadata.
- **Suspension Mechanism**: Automatic suspension of user accounts after multiple failed login attempts.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Node.js** (v14.x or later)
- **NPM** (v6.x or later)
- **Docker** and **Docker Compose** (for Quorum blockchain setup)
- **IPFS** (for decentralized file storage)
- **MySQL** (for relational database management)

## Backend Setup

Follow these steps to set up and run the backend server:

### 1. Install Dependencies

Use npm to install the necessary dependencies:

```bash
npm install
```

### 2. Configure Environment Variables

PORT=3000

#### Database configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=your_db_username
DB_PASS=your_db_password
DB_NAME=your_db_name

#### JWT Secret
JWT_SECRET=your_jwt_secret_key

#### Blockchain configuration
QUORUM_NODE_URL=http://localhost:22000 (Your Node URL)
MNEMONIC=your_metamask_mnemonic

#### IPFS Configuration
IPFS_API_URL=http://localhost:5001

#### Encryption key
ENCRYPTION_KEY=your_256_bit_encryption_key
ENCRYPTION_IV=your_256_bit_encryption_iv

#### Deployed Smart contract address
CONTRACT_ADDRESS=your_deployed_smart_contract address


### 3. Setup the Database
Ensure your MySQL database is running, then initialize the database schema using Sequelize migrations:

```bash
npx sequelize-cli db:migrate
```

Database backup (ehr_db.sql) added for quick start in database folder. You can import db to your mysql. 

#### Users: 
Admin User:
Email: admin@gmail.com
Password: admin@123

Doctor User:
Email: doctor@gmail.com
Password: doctor@123

Patient User:
Email: patient@gmail.com
Password: patient@123

### 4. Set Up Quorum Blockchain
Clone the Quorum examples repository and start the network:

```bash
git clone https://github.com/Consensys/quorum-examples
cd quorum-examples
docker-compose up -d
```

### 5. Compile and Deploy Smart Contracts
Compile and deploy the smart contracts to your Quorum network:

```bash
truffle compile
truffle migrate --network quorum
```


### 6. Run the Backend Server
Start the backend server:

```bash
npm start
```
