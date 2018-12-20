// employer.route.js

const express = require('express');
const employerRoutes = express.Router();

// Employer DB Model
let Employer = require('./employer.model');

// ADD Method
employerRoutes.route('/add').post(function (req, res) {
  let employer = new Employer(req.body);
  employer.save()
    .then(employer => {
      res.status(200).json({'employer': 'employee added successfully'});
    })
    .catch(err => {
      res.status(400).send("unable to save to database");
    });
});

// GET Data(list or index)
employerRoutes.route('/').get(function (req, res) {
    Employer.find(function(err, employers){
    if(err){
      console.log(err);
    }
    else {
      res.json(employers);
    }
  });
});

// Edit Method
employerRoutes.route('/edit/:id').get(function (req, res) {
  let id = req.params.id;
  Employer.findById(id, function (err, employer){
      res.json(employer);
  });
});

//  Update Method
employerRoutes.route('/update/:id').post(function (req, res) {
  Employer.findById(req.params.id, function(err, employer) {
    if (!employer)
      res.status(404).send("data is not found");
    else {
      employer.person_name = req.body.person_name;
      employer.employer_name = req.body.employer_name;
      employer.employer_id_number = req.body.employer_id_number;

      employer.save().then(employer => {
        res.json('Update complete');
      })
      .catch(err => {
        res.status(400).send("unable to update the database");
      });
    }
  });
});

// Delete method
employerRoutes.route('/delete/:id').get(function (req, res) {
  Employer.findByIdAndRemove({_id: req.params.id}, function(err, employer){
        if(err) res.json(err);
        else res.json('Successfully removed');
    });
});

module.exports = employerRoutes;
