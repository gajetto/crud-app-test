const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Define collection and schema for Business
let Employer = new Schema({
  person_name: {
    type: String
  },
  employer_name: {
    type: String
  },
  employer_id_number: {
    type: Number
  }
},{
    collection: 'employer'
});

module.exports = mongoose.model('Employer', Employer);