const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const PORT = 4000;
const cors = require('cors');
const mongoose = require('mongoose');
//const config = require('./DB.js');
const employerRoute = require('./employer.route');
const Employer = require('./employer.model')
//const DbURI = "mongodb://localhost:27017/test";

mongoose.Promise = global.Promise;
// locahost connection
//mongoose.connect(DbURI, { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true }).then(
//  () => {console.log('Database is connected') },
//  err => { console.log('Can not connect to the database'+ err)}
//);

mongoose.connect('mongodb+srv://cluster0.xi2k0.mongodb.net/react-db?retryWrites=true&w=majority',
{
  user: 'gajetto',
  pass: 'Hjh65gfds*Uds',
  useNewUrlParser: true, 
  useUnifiedTopology: true, 
  useCreateIndex: true
}
  )
  

app.use(cors());  
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use('/employer', employerRoute);

app.listen(PORT, function(){
  console.log('Server is running on Port:',PORT);
});

//app.get('/add', (req, res) => {
//  const employee = new Employer({
//    person_name:"Peter Parcoeur",
//    employer_name:"Marvel and Ninjas Ink Corportation",
//    employer_id_number:20
//  });
//  employee.save()
//    .then((result) => {
//      res.send(result)
//    })
//    .catch((err) => {
//      console.log(err);
//    });
//})