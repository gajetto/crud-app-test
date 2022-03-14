const express = require('express');
const app = express();
const env = require('dotenv').config();
const bodyParser = require('body-parser');
const PORT = 4000;
const cors = require('cors');
const mongoose = require('mongoose');
const employerRoute = require('./employer.route');
const Employer = require('./employer.model')

mongoose.Promise = global.Promise;

let password =  process.env.DB_PASSWORD;
let user = process.env.DB_USER;
let dbname = process.env.DB_NAME;


mongoose.connect(dbname,
{
  user: user,
  pass: password,
  useNewUrlParser: true, 
  useUnifiedTopology: true, 
  useCreateIndex: true
}
  ).then(
  () => {console.log('Database is connected') },
  err => { console.log('Can not connect to the database'+ err)}
);
  

app.use(cors());  
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use('/employer', employerRoute);

app.listen(PORT, function(){
  console.log('Server is running on Port:',PORT);
});
