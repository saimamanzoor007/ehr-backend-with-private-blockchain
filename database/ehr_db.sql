/*
 Navicat Premium Data Transfer

 Source Server         : New Connection
 Source Server Type    : MySQL
 Source Server Version : 80031
 Source Host           : localhost:3306
 Source Schema         : ehr_db

 Target Server Type    : MySQL
 Target Server Version : 80031
 File Encoding         : 65001

 Date: 31/08/2024 02:14:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for medicalrecords
-- ----------------------------
DROP TABLE IF EXISTS `medicalrecords`;
CREATE TABLE `medicalrecords`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `patientId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `labTechnicianId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `recordType` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `patientId`(`patientId` ASC) USING BTREE,
  INDEX `labTechnicianId`(`labTechnicianId` ASC) USING BTREE,
  CONSTRAINT `medicalrecords_ibfk_1` FOREIGN KEY (`patientId`) REFERENCES `patients` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `medicalrecords_ibfk_2` FOREIGN KEY (`labTechnicianId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medicalrecords
-- ----------------------------
INSERT INTO `medicalrecords` VALUES ('1828153c-f37d-40cd-ae03-7e3d1f3b6479', '6af4991a-c789-4686-88ff-bd9eb3e26da7', 'ef54679e-22a9-4b84-80f5-26b0ce8f2c65', 'x ray', 'chest x ray', '2024-08-30 22:00:17', '2024-08-30 22:00:17');
INSERT INTO `medicalrecords` VALUES ('3cf10fc2-5667-4618-9cfc-2808d8f458cb', '6af4991a-c789-4686-88ff-bd9eb3e26da7', 'ef54679e-22a9-4b84-80f5-26b0ce8f2c65', 'X ray chest', 'Chest X ray', '2024-08-31 00:49:20', '2024-08-31 00:49:20');
INSERT INTO `medicalrecords` VALUES ('497fda69-00bd-4513-a357-38296cc0c695', '6af4991a-c789-4686-88ff-bd9eb3e26da7', 'ef54679e-22a9-4b84-80f5-26b0ce8f2c65', 'test', 'akhdas', '2024-08-30 22:12:54', '2024-08-30 22:12:54');
INSERT INTO `medicalrecords` VALUES ('6eeec7ff-e5af-4921-a54e-3c9100847ed9', '6af4991a-c789-4686-88ff-bd9eb3e26da7', '98ac4c69-e6b2-45c2-b199-f482efc4403c', 'Add by doctor', 'Tetsing doctor add', '2024-08-30 22:09:55', '2024-08-30 22:09:55');
INSERT INTO `medicalrecords` VALUES ('a60402ff-f520-4293-88d4-80cfdfeb918b', '6af4991a-c789-4686-88ff-bd9eb3e26da7', 'ef54679e-22a9-4b84-80f5-26b0ce8f2c65', 'test', 'halkd', '2024-08-30 22:16:28', '2024-08-30 22:16:28');
INSERT INTO `medicalrecords` VALUES ('ad4f47de-6453-43cf-aef6-1ddf09bde9fe', '6af4991a-c789-4686-88ff-bd9eb3e26da7', '98ac4c69-e6b2-45c2-b199-f482efc4403c', 'Doctor Test', 'aasdasdas', '2024-08-31 00:52:12', '2024-08-31 00:52:12');
INSERT INTO `medicalrecords` VALUES ('f94eddd6-a2f5-4b5b-8ecd-2e6ee6990b74', '6af4991a-c789-4686-88ff-bd9eb3e26da7', 'ef54679e-22a9-4b84-80f5-26b0ce8f2c65', 'dssdf', '', '2024-08-30 22:50:13', '2024-08-30 22:50:13');

-- ----------------------------
-- Table structure for patients
-- ----------------------------
DROP TABLE IF EXISTS `patients`;
CREATE TABLE `patients`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `userId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `dateOfBirth` datetime NOT NULL,
  `gender` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `phoneNumber` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `emergencyContact` json NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `userId`(`userId` ASC) USING BTREE,
  CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of patients
-- ----------------------------
INSERT INTO `patients` VALUES ('6af4991a-c789-4686-88ff-bd9eb3e26da7', '546d95c0-834b-4f79-b993-32c7d7d46517', '1996-01-14 00:00:00', 'male', NULL, NULL, NULL, '2024-08-19 23:36:20', '2024-08-19 23:36:20');

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT 'uuid()',
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES ('1e643f16-5e88-11ef-aa26-00be4311b9c9', 'get-users', '2024-08-20 01:06:59', '2024-08-20 01:06:59');
INSERT INTO `permissions` VALUES ('566bf783-661a-11ef-9b46-00be4311b9c9', 'get-logged-in-patient-record-file', '2024-08-29 16:21:17', '2024-08-29 16:21:32');
INSERT INTO `permissions` VALUES ('67c4e2ce-6711-11ef-9b46-00be4311b9c9', 'get-patient-medical-records', '2024-08-30 21:49:52', '2024-08-30 21:49:52');
INSERT INTO `permissions` VALUES ('6fa4d9d7-6616-11ef-9b46-00be4311b9c9', 'get-logged-in-user-medical-records', '2024-08-29 15:53:21', '2024-08-29 15:53:21');
INSERT INTO `permissions` VALUES ('8f9b1efa-634c-11ef-ad11-00be4311b9c9', 'get-patient-record-file', '2024-08-26 02:43:14', '2024-08-26 02:43:14');
INSERT INTO `permissions` VALUES ('94f9c720-634a-11ef-ad11-00be4311b9c9', 'add-patient-medical-records', '2024-08-26 02:29:04', '2024-08-26 02:29:04');
INSERT INTO `permissions` VALUES ('fab9d66f-5e86-11ef-aa26-00be4311b9c9', 'register-user', '2024-08-20 00:58:49', '2024-08-20 00:58:49');

-- ----------------------------
-- Table structure for rolepermissions
-- ----------------------------
DROP TABLE IF EXISTS `rolepermissions`;
CREATE TABLE `rolepermissions`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT 'uuid()',
  `roleId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `permissionId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `roleId`(`roleId` ASC) USING BTREE,
  INDEX `permissionId`(`permissionId` ASC) USING BTREE,
  CONSTRAINT `rolepermissions_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rolepermissions_ibfk_2` FOREIGN KEY (`permissionId`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rolepermissions
-- ----------------------------
INSERT INTO `rolepermissions` VALUES ('0f219cd8-5e87-11ef-aa26-00be4311b9c9', 'dfbfee19-1560-489f-8d25-09b6afc0aea1', '1e643f16-5e88-11ef-aa26-00be4311b9c9', '2024-08-20 00:59:23', '2024-08-20 01:07:39');
INSERT INTO `rolepermissions` VALUES ('2f545eb6-671c-11ef-9b46-00be4311b9c9', '23f1881e-7d45-4d82-a7e2-107ba2103235', '8f9b1efa-634c-11ef-ad11-00be4311b9c9', '2024-08-30 23:07:02', '2024-08-30 23:07:02');
INSERT INTO `rolepermissions` VALUES ('3850ebf1-671c-11ef-9b46-00be4311b9c9', '23f1881e-7d45-4d82-a7e2-107ba2103235', '67c4e2ce-6711-11ef-9b46-00be4311b9c9', '2024-08-30 23:07:17', '2024-08-30 23:07:26');
INSERT INTO `rolepermissions` VALUES ('570d1f25-634a-11ef-ad11-00be4311b9c9', 'dfbfee19-1560-489f-8d25-09b6afc0aea1', 'fab9d66f-5e86-11ef-aa26-00be4311b9c9', '2024-08-26 02:27:21', '2024-08-26 02:27:34');
INSERT INTO `rolepermissions` VALUES ('6bc26cbd-661a-11ef-9b46-00be4311b9c9', '3ca28e59-386b-4765-8801-1d15e2022056', '566bf783-661a-11ef-9b46-00be4311b9c9', '2024-08-29 16:21:53', '2024-08-29 16:22:03');
INSERT INTO `rolepermissions` VALUES ('6f35d185-6711-11ef-9b46-00be4311b9c9', 'dfbfee19-1560-489f-8d25-09b6afc0aea1', '67c4e2ce-6711-11ef-9b46-00be4311b9c9', '2024-08-30 21:50:04', '2024-08-30 21:50:13');
INSERT INTO `rolepermissions` VALUES ('79abd9b8-6616-11ef-9b46-00be4311b9c9', '3ca28e59-386b-4765-8801-1d15e2022056', '6fa4d9d7-6616-11ef-9b46-00be4311b9c9', '2024-08-29 15:53:38', '2024-08-29 15:54:51');
INSERT INTO `rolepermissions` VALUES ('88bc3512-671c-11ef-9b46-00be4311b9c9', '23f1881e-7d45-4d82-a7e2-107ba2103235', '94f9c720-634a-11ef-ad11-00be4311b9c9', '2024-08-30 23:09:32', '2024-08-30 23:09:32');
INSERT INTO `rolepermissions` VALUES ('961edbf5-634c-11ef-ad11-00be4311b9c9', 'dfbfee19-1560-489f-8d25-09b6afc0aea1', '8f9b1efa-634c-11ef-ad11-00be4311b9c9', '2024-08-26 02:43:25', '2024-08-26 02:43:45');
INSERT INTO `rolepermissions` VALUES ('9b798e4f-634a-11ef-ad11-00be4311b9c9', 'dfbfee19-1560-489f-8d25-09b6afc0aea1', '94f9c720-634a-11ef-ad11-00be4311b9c9', '2024-08-26 02:29:15', '2024-08-26 02:32:59');

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES ('23f1881e-7d45-4d82-a7e2-107ba2103235', 'doctor', '2024-08-19 23:32:17', '2024-08-19 23:32:17');
INSERT INTO `roles` VALUES ('3ca28e59-386b-4765-8801-1d15e2022056', 'patient', '2024-08-19 23:32:17', '2024-08-19 23:32:17');
INSERT INTO `roles` VALUES ('dfbfee19-1560-489f-8d25-09b6afc0aea1', 'admin', '2024-08-19 23:32:17', '2024-08-19 23:32:17');
INSERT INTO `roles` VALUES ('e551d0dd-ce3e-4f41-95d5-ae3b65f8b027', 'labAttendant', '2024-08-19 23:32:17', '2024-08-19 23:32:17');

-- ----------------------------
-- Table structure for sequelizemeta
-- ----------------------------
DROP TABLE IF EXISTS `sequelizemeta`;
CREATE TABLE `sequelizemeta`  (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`name`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sequelizemeta
-- ----------------------------
INSERT INTO `sequelizemeta` VALUES ('20240817220819-create-roles.js');
INSERT INTO `sequelizemeta` VALUES ('20240817220918-create-users.js');
INSERT INTO `sequelizemeta` VALUES ('20240817220929-create-patients.js');
INSERT INTO `sequelizemeta` VALUES ('20240817220939-create-medical-records.js');
INSERT INTO `sequelizemeta` VALUES ('20240817220950-create-permissions.js');
INSERT INTO `sequelizemeta` VALUES ('20240819231657-create-role-permissions-table.js');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `firstName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `lastName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` enum('active','suspended') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active',
  `failedLoginAttempts` int NOT NULL DEFAULT 0,
  `roleId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  INDEX `roleId`(`roleId` ASC) USING BTREE,
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('546d95c0-834b-4f79-b993-32c7d7d46517', 'patient@gmail.com', '$2a$10$b7Uoi5rBuYW1pUo7Hynrx.EYlNuWRsetHLMYxE7iKoM5CUIK/LH7m', 'Patient', 'One', 'active', 0, '3ca28e59-386b-4765-8801-1d15e2022056', '2024-08-19 23:36:20', '2024-08-19 23:36:20', NULL);
INSERT INTO `users` VALUES ('76358e17-c0f2-40df-bbf9-d684b09b7939', 'labattendant@gmail.com', '$2a$10$sVJ.k0/2W4p8D65oMSCvmekN3WsL4tSAVbElHwaIOGJMOGaa0yVAy', 'Lab Attendant', 'One', 'active', 0, 'e551d0dd-ce3e-4f41-95d5-ae3b65f8b027', '2024-08-30 22:12:29', '2024-08-30 22:12:29', NULL);
INSERT INTO `users` VALUES ('98ac4c69-e6b2-45c2-b199-f482efc4403c', 'doctor@gmail.com', '$2a$10$3/x4dt2BBXgmHpo.cGtu5uhfdqQ2KF4WdJmQzT5w73LABjriMleV2', 'Doctor', 'One', 'active', 0, '23f1881e-7d45-4d82-a7e2-107ba2103235', '2024-08-19 23:39:02', '2024-08-19 23:39:02', NULL);
INSERT INTO `users` VALUES ('ef54679e-22a9-4b84-80f5-26b0ce8f2c65', 'admin@gmail.com', '$2a$10$a32X/I4urTyrQF6rQ6LZ5.FCtvW5a8O14NjBxGmUh4Yd80LSZh5Ay', 'Super', 'Admin', 'active', 0, 'dfbfee19-1560-489f-8d25-09b6afc0aea1', '2024-08-19 23:33:34', '2024-08-29 12:27:09', NULL);

SET FOREIGN_KEY_CHECKS = 1;
