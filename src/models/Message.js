const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Message = sequelize.define('Message', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  conversationId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'conversations',
      key: 'id',
    },
  },
  sender: {
    type: DataTypes.ENUM('customer', 'agent'),
    allowNull: false,
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  messageId: {
    type: DataTypes.STRING,
    unique: true,
  },
  mediaUrl: {
    type: DataTypes.STRING,
  },
  mediaType: {
    type: DataTypes.ENUM('text', 'image', 'audio', 'video', 'document'),
    defaultValue: 'text',
  },
  status: {
    type: DataTypes.ENUM('sent', 'delivered', 'read'),
    defaultValue: 'sent',
  },
}, {
  tableName: 'messages',
  timestamps: true,
});

module.exports = Message;
