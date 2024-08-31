const express = require('express'); //to create server
const bodyParser = require('body-parser'); //parse request body
const dotenv = require('dotenv'); //For ENV access
dotenv.config();

const bcrypt = require('bcryptjs'); //encrypt password
const multer = require('multer'); //file upload
const fileType = require('file-type'); //check file type
const cors = require('cors'); //allow connections from allowed origins
const ipfsClient = require('ipfs-http-client'); // IPFS client
const { Op, where } = require('sequelize'); //Database connection

const { encryptBuffer, decryptBuffer } = require('./utills/aesFile'); //Aes encryption helpers
const { authenticateToken, signToken } = require('./middlewares/authentication'); //Auth middleware
const authorize = require('./middlewares/authorize'); //Authorization Middleware
const { addRecordToBlockChain, getBlockChainRecord } = require('./utills/blockChain'); //Blockchain helpers

const { User, Role, Patient, MedicalRecord } = require('./models'); // database Modals 

const ipfs = new ipfsClient({ host: "localhost", post: '5001', protocol: "http" }) //IPFS client 

const app = express();

// Middleware to parse JSON requests
app.use(express.json()); // Built-in middleware in Express to parse JSON

// Middleware to parse URL-encoded data (for form submissions)
app.use(express.urlencoded({ extended: true }));

//Allow All origins
app.use(cors())

// Set up multer to handle files in memory
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

app.use(bodyParser.json());

const PORT = process.env.PORT || 3005;

// Login API
app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        let user = await User.findOne({ where: { email } });
        if (!user) return res.status(404).json({ error: [{ type: "email", message: 'Incorrect Username/Email.' }] });

        if (user.status != "active") return res.status(403).json({ error: [{ type: "email", message: 'User suspended due to failed login attempts.' }] });

        const match = await bcrypt.compare(password, user.password);
        if (!match) {

            user.failedLoginAttempts = user.failedLoginAttempts + 1
            if (user.failedLoginAttempts >= 5) {
                user.status = "suspended"
            }
            await user.save()
            return res.status(401).json([{ type: "password", message: 'Incorrect Password.' }]);
        }
        user.failedLoginAttempts = 0
        await user.save()
        const role = await Role.findOne({ where: { id: user.roleId } })
        user = user.toJSON()
        user.role = role.name
        user.data = {}
        user.data.displayName = user.firstName + " " + user.lastName
        delete user.password
        const token = signToken(user)
        return res.json({ access_token: token, user: user });
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: error.message });
    }
});

// Login with Access token API
app.get('/auth/access-token', authenticateToken, async (req, res) => {

    try {
        delete req.user.iat
        delete req.user.exp
        const token = signToken(req.user)
        return res.json({ access_token: token, user: req.user });
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: error.message });
    }
});

// Login API
app.post('/dashboard', async (req, res) => {
    try {

    } catch (error) {
        console.log(error)
        res.status(500).json({ error: error.message });
    }
});


// Register API
app.post('/register', authenticateToken, authorize("register-user"), async (req, res) => {
    const { username, email, password, firstName, lastName, role, gender, dateOfBirth, phoneNumber, address, emergencyContact } = req.body;
    try {
        const hash = await bcrypt.hash(password, 10);
        const userRole = await Role.findOne({ where: { name: role } });
        const user = await User.create({
            username,
            email,
            password: hash,
            firstName,
            lastName,
            roleId: userRole.id,
        });
        if (userRole.name == "patient") {
            await Patient.create({ userId: user.id, gender, dateOfBirth, phoneNumber, address, emergencyContact })
        }
        res.status(201).json({ message: "user has been created Successfully.", user });
    } catch (error) {
        console.log(error)
        res.status(400).json({ error: error.message });
    }
});


// Get users for admin
app.get('/users/:role', authenticateToken, async (req, res) => {

    try {
        let userType = req.params.role
        let roleName = userType === "patients" ? "patient" : userType === "doctors" ? "doctor" : "labAttendant"
        const users = await User.findAll({
            include: [{ model: Role, where: { name: { [Op.eq]: roleName } }, attributes: [] },
            { model: Patient }
            ], attributes: ["id", "username", "email", "firstName", "lastName", "status", "createdAt"]
        });
        res.json(users);
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: error.message });
    }
});

// Get medical records a logged in patient
app.get('/medical-records', authenticateToken, authorize("get-logged-in-user-medical-records"), async (req, res) => {
    const { id } = req.user;
    try {
        let patient = await Patient.findOne({ where: { userId: id } })
        const medicalRecords = await MedicalRecord.findAll({ where: { patientId: patient.id } });
        res.json(medicalRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


// Get medical records for a patient by admin/doctor
app.get('/patients/:userId/medical-records', authenticateToken, authorize("get-patient-medical-records"), async (req, res) => {
    const { userId } = req.params;

    try {
        let patient = await Patient.findOne({ where: { userId } });
        if (patient) {
            const medicalRecords = await MedicalRecord.findAll({ where: { patientId: patient.id } });
            return res.json(medicalRecords);
        } else {
            return res.json([]);
        }
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: error.message });
    }
});



// Add a medical record
app.post('/medical-records', authenticateToken, authorize("add-patient-medical-records"), upload.single('file'), async (req, res) => {
    const { patientId, recordType, description } = req.body;
    const { id: labTechnicianId } = req.user;
    const file = req.file
    try {
        let patient = await Patient.findOne({ where: { userId: patientId } })
        if (patient) {
            console.time('Function encryptBuffer execution time');
            let encryptedFile = encryptBuffer(file.buffer)
            console.timeEnd('Function encryptBuffer execution time');

            console.time('Function Upload File to IPFS execution time');
            const { path: ipfsFileHash } = await ipfs.add(encryptedFile);
            console.timeEnd('Function Upload File to IPFS execution time');

            const medicalRecord = await MedicalRecord.create({
                patientId: patient.id, recordType, description, labTechnicianId
            });

            console.time('Function Add record to blockchain execution time');
            let data = await addRecordToBlockChain(ipfsFileHash, medicalRecord.id)
            console.timeEnd('Function Add record to blockchain execution time');

            return res.status(201).json(medicalRecord);
        } else {
            res.status(400).json({ error: "Patient not found." });
        }

    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});


// Get medical records for a logged in patient
app.get('/medical-record/:medicalRecordsId', authenticateToken, authorize("get-logged-in-patient-record-file"), async (req, res) => {
    const { medicalRecordsId } = req.params;
    try {
        let { id: patientId } = await Patient.findOne({ where: { userId: req.user.id } })
        console.log(patientId)
        MedicalRecord.findOne({ where: { patientId, id: medicalRecordsId } }).then(async (record) => {
            console.log(record)
            if (record) {
                try {

                    console.time('Get record from blockchain execution time');
                    //Fetch ipfsFileHash from blockchain
                    const { ipfsFileHash } = await getBlockChainRecord(medicalRecordsId)
                    console.timeEnd('Get record from blockchain execution time');

                    console.time('Get encrypted file from IPFS execution time');
                    const file = [];
                    for await (const chunk of ipfs.cat(ipfsFileHash)) {
                        file.push(chunk);
                    }

                    // Combine all chunks into a single buffer
                    const fileBuffer = Buffer.concat(file);

                    console.timeEnd('Get encrypted file from IPFS execution time');

                    console.time('decrypt file execution time');
                    const decryptedBuffer = decryptBuffer(fileBuffer)
                    console.timeEnd('decrypt file execution time');
                    let fileName = Date.now()
                    const { ext = 'bin', mime = 'application/octet-stream' } = await fileType.fromBuffer(decryptedBuffer) || {};
                    const fileNameWithExtension = `medical-record-${fileName}.${ext}`;
                    res.setHeader('Content-Disposition', `attachment; filename="${fileNameWithExtension}"`);
                    res.setHeader('Content-Type', mime);
                    res.setHeader('Access-Control-Allow-Origin', '*');
                    res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition');

                    return res.send(decryptedBuffer);

                } catch (error) {
                    console.log(error)
                    return res.status(500).send("Internal Server Error.");

                }
            } else {
                return res.status(400).send("No record found.");

            }
        })


        // Set headers and send the decrypted buffer
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


// Get medical records for a patient
app.get('/patients/:patientId/medical-record/:medicalRecordsId', authenticateToken, authorize("get-patient-record-file"), async (req, res) => {
    const { patientId, medicalRecordsId } = req.params;

    try {
        let patient = await Patient.findOne({ where: { userId: patientId } })
        console.log(patient)
        if (patient) {
            MedicalRecord.findOne({ where: { patientId: patient.id, id: medicalRecordsId } }).then(async (record) => {
                if (record) {
                    try {

                        console.time('Get record from blockchain execution time');
                        //Fetch ipfsFileHash from blockchain
                        const { ipfsFileHash } = await getBlockChainRecord(medicalRecordsId)
                        console.timeEnd('Get record from blockchain execution time');

                        console.time('Get encrypted file from IPFS execution time');
                        const file = [];
                        for await (const chunk of ipfs.cat(ipfsFileHash)) {
                            file.push(chunk);
                        }

                        // Combine all chunks into a single buffer
                        const fileBuffer = Buffer.concat(file);

                        console.timeEnd('Get encrypted file from IPFS execution time');

                        console.time('decrypt file execution time');
                        const decryptedBuffer = decryptBuffer(fileBuffer)
                        console.timeEnd('decrypt file execution time');
                        let fileName = Date.now()
                        const { ext = 'bin', mime = 'application/octet-stream' } = await fileType.fromBuffer(decryptedBuffer) || {};
                        const fileNameWithExtension = `medical-record-${fileName}.${ext}`;
                        res.setHeader('Content-Disposition', `attachment; filename="${fileNameWithExtension}"`);
                        res.setHeader('Content-Type', mime);

                        res.setHeader('Access-Control-Allow-Origin', '*');
                        res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition')

                        return res.send(decryptedBuffer);

                    } catch (error) {
                        console.log(error)
                        return res.status(500).send("Internal Server Error.");

                    }
                } else {
                    return res.status(400).send("No record found.");
                }
            })

        } else {
            return res.status(400).send("No record found.");
        }

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
