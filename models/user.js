'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    static associate(models) {
      // One-to-One with Patient
      User.hasOne(models.Patient, {
        foreignKey: 'userId',
      });
      // Many-to-One with Role
      User.belongsTo(models.Role, {
        foreignKey: 'roleId'
      });
      // One-to-Many with MedicalRecord (as LabTechnician)
      User.hasMany(models.MedicalRecord, {
        foreignKey: 'labTechnicianId',
      });
    }
  }

  User.init({
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      allowNull: false,
      primaryKey: true,
    },
    username: {
      type: DataTypes.STRING,
      allowNull: true
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    firstName: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    lastName: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM,
      values: ["active", "suspended"],
      defaultValue: 'active',
      allowNull: false,
    },
    failedLoginAttempts: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      allowNull: false,
    },
    roleId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'Roles',
        key: 'id',
      },
    },
  }, {
    sequelize,
    modelName: 'User',
    timestamps: true,
  });

  return User;
};
