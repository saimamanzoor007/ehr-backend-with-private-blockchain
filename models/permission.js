'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Permission extends Model {
    static associate(models) {
      // Many-to-One with Role
      Permission.belongsToMany(models.Role, {
        through: 'RolePermissions',
        foreignKey: 'permissionId',
        otherKey: 'roleId'
      });
    }
  }

  Permission.init({
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      allowNull: false,
      primaryKey: true,
    },
    permission: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  }, {
    sequelize,
    modelName: 'Permission',
    timestamps: true,
  });

  return Permission;
};
