'use strict';

const { v4: uuidv4 } = require('uuid');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const roles = [
      { id: uuidv4(), name: 'admin', createdAt: new Date(), updatedAt: new Date() },
      { id: uuidv4(), name: 'patient', createdAt: new Date(), updatedAt: new Date() },
      { id: uuidv4(), name: 'doctor', createdAt: new Date(), updatedAt: new Date() },
      { id: uuidv4(), name: 'labAttendant', createdAt: new Date(), updatedAt: new Date() },
    ];

    await queryInterface.bulkInsert('Roles', roles, {});
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('Roles', {
      name: { [Sequelize.Op.in]: ['admin', 'patient', 'doctor', 'labAttendant'] }
    }, {});
  }
};
