const { saveUser } = require("./add-user");
const employerRoute = require('./employer.route');
const Employer = require('./employer.model');
const { expect } = require("chai");
const mongoose = require("mongoose");
const env = require('dotenv').config();

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
});

const db = mongoose.connection;
db.on("error", console.error.bind(console, "connection error: "));
db.once("open", async function () {
  console.log("Connected successfully");
});

describe("User Service Unit Tests", function () {
    describe("Save User functionality", function () {
      it("should successfully add a user if the number of users in the DB with the same profiled is zero", async function () {
        const person_name = "Helmut Schmutz";
        const employer_name = "Lockhead Avionics";
        const person_id_number = 578
        const returnedUser = await saveUser({
          person_name,
          employer_name,
          person_id_number
      });
      expect(returnedUser.person_name).to.equal(person_name);
    });
      it("should throw an error if the number of users with the same profileId is not zero", async function () {});
  });
});
