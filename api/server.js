const express = require('express');
const app = express();
const env = require('dotenv').config();
const bodyParser = require('body-parser');
const PORT = 4000;
const cors = require('cors');
const mongoose = require('mongoose');
//const config = require('./DB.js');
const employerRoute = require('./employer.route');
const Employer = require('./employer.model')

mongoose.Promise = global.Promise;

let password =  process.env.DB_PASSWORD;
let user = process.env.DB_USER;


mongoose.connect('mongodb+srv://cluster0.xi2k0.mongodb.net/react-db?retryWrites=true&w=majority',
{
  //user: process.env.DB_USER,
  //pass: process.env.DB_PASSWORD,
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
