require('dotenv').config();


module.exports = {
  replicateApiToken: process.env.REPLICATE_API_KEY,
};

// Bunu exporttan sonra test etmek istersen:
console.log('Exported Token:', module.exports.replicateApiToken);
console.log('ENV Token:', process.env.REPLICATE_API_KEY);
