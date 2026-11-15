const jwt = require('jsonwebtoken');
const config = require('../config');

const authMiddleware = (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const decoded = jwt.verify(token, config.jwt.secret);
    req.user = decoded;
    req.companyId = decoded.companyId;

    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};

const generateToken = (companyId, userId) => {
  return jwt.sign(
    { companyId, userId },
    config.jwt.secret,
    { expiresIn: '30d' }
  );
};

module.exports = {
  authMiddleware,
  generateToken,
};
