const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Conversation = sequelize.define('Conversation', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  companyId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'companies',
      key: 'id',
    },
  },
  agentId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'agents',
      key: 'id',
    },
  },
  customerId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  customerName: {
    type: DataTypes.STRING,
  },
  customerPhone: {
    type: DataTypes.STRING,
  },
  platform: {
    type: DataTypes.ENUM('whatsapp', 'instagram', 'facebook'),
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('active', 'closed', 'escalated'),
    defaultValue: 'active',
  },
  context: {
    type: DataTypes.JSON,
    defaultValue: [],
  },
  lastMessageAt: {
    type: DataTypes.DATE,
  },
}, {
  tableName: 'conversations',
  timestamps: true,
});

module.exports = Conversation;
