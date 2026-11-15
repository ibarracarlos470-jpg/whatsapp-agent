const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Agent = sequelize.define('Agent', {
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
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  systemPrompt: {
    type: DataTypes.TEXT,
    allowNull: false,
    defaultValue: 'Eres un asistente de atención al cliente amable y profesional.',
  },
  personality: {
    type: DataTypes.JSON,
    defaultValue: {
      tone: 'professional',
      language: 'es',
    },
  },
  capabilities: {
    type: DataTypes.JSON,
    defaultValue: {
      answerQuestions: true,
      scheduleMeetings: false,
      processPayments: false,
    },
  },
  maxContextLength: {
    type: DataTypes.INTEGER,
    defaultValue: 5,
  },
  temperature: {
    type: DataTypes.FLOAT,
    defaultValue: 0.7,
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
}, {
  tableName: 'agents',
  timestamps: true,
});

module.exports = Agent;
