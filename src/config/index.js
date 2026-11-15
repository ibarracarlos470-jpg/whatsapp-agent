require('dotenv').config();

module.exports = {
  database: {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    name: process.env.DB_NAME || 'whatsapp_agent',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD,
  },
  meta: {
    whatsappToken: process.env.WHATSAPP_API_TOKEN,
    phoneNumberId: process.env.WHATSAPP_PHONE_NUMBER_ID,
    businessAccountId: process.env.WHATSAPP_BUSINESS_ACCOUNT_ID,
    verifyToken: process.env.META_VERIFY_TOKEN,
  },
  gemini: {
    apiKey: process.env.GEMINI_API_KEY,
  },
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
  },
  server: {
    port: process.env.PORT || 3000,
    nodeEnv: process.env.NODE_ENV || 'development',
  },
  jwt: {
    secret: process.env.JWT_SECRET,
  },
  app: {
    name: process.env.APP_NAME || 'WhatsApp Agent',
    url: process.env.APP_URL,
  },
};
