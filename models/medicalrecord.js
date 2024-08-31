'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class MedicalRecord extends Model {
    static associate(models) {
      // Many-to-One with Patient
      MedicalRecord.belongsTo(models.Patient, {
        foreignKey: 'patientId',
      });
      // Many-to-One with User (as LabTechnician)
      MedicalRecord.belongsTo(models.User, {
        foreignKey: 'labTechnicianId',
      });
    }
  }

  MedicalRecord.init({
    id: {
      type: DataTypes.INTEGER,
      defaultValue: DataTypes.UUIDV4,
      allowNull: false,
      primaryKey: true,
    },
    patientId: {
      type: DataTypes.UUID,
      allowNull: false,
      references: {
        model: 'Patients',
        key: 'id',
      },
    },
    labTechnicianId: {
      type: DataTypes.UUID,
      allowNull: true,
      references: {
        model: 'Users',
        key: 'id',
      },
    },
    recordType: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    }
  }, {
    sequelize,
    modelName: 'MedicalRecord',
    timestamps: true,
  });

  return MedicalRecord;
};
