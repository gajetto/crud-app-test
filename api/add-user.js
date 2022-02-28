const User = require("./employer.model");

const saveUser = async ({ person_name, employer_name, person_id_number }) => {
  const count = await User.countDocuments({ person_id_number });
  if(count > 0) throw new Error("User with profileId already exists");
  const user = await new User({
    person_name,
    employer_name,
    person_id_number,
  }).save();
  return user;
}


const getUser = async ({ person_id_number }) => {
  const user = await User.findOne({ person_id_number });
  if(!user) throw new Error("No user not found with given profileId");

  return { person_name, employer_name, person_id_number }
}

module.exports.saveUser = saveUser;
module.exports.getUser = getUser;