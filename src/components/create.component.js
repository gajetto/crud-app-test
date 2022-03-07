import React, { Component } from 'react';
import axios from 'axios';

export default class Create extends Component {
  constructor(props) {
    super(props);
    this.onChangePersonName = this.onChangePersonName.bind(this);
    this.onChangeEmployerName = this.onChangeEmployerName.bind(this);
    this.onChangeIDNumber = this.onChangeIDNumber.bind(this);
    this.onSubmit = this.onSubmit.bind(this);

    this.state = {
      person_name: '',
      employer_name: '',
      employer_id_number:''
    }
  }
  onChangePersonName(e) {
    this.setState({
      person_name: e.target.value
    });
  }
  onChangeEmployerName(e) {
    this.setState({
      employer_name: e.target.value
    })  
  }
  onChangeIDNumber(e) {
    this.setState({
      employer_id_number: e.target.value
    })
  }

  onSubmit(e) {
    e.preventDefault();
    const obj = {
      person_name: this.state.person_name,
      employer_name: this.state.employer_name,
      employer_id_number: this.state.employer_id_number
    };
    //axios.post('http://localhost:4000/employer/add', obj)
     axios.post('http://13.36.140.151:4000/employer/add', obj)
        .then(res => console.log(res.data));
    
    this.setState({
      person_name: '',
      employer_name: '',
      employer_id_number: ''
    })
  }
 
  render() {
    return (
      <div style={{ marginTop: 10 }}>
        <h3 align="center">Add New Employee</h3>
        <form onSubmit={this.onSubmit}>
          <div className="form-group">
            <label>Employee Name:  </label>
            <input 
              type="text" 
              className="form-control" 
              value={this.state.person_name}
              onChange={this.onChangePersonName}
            />
          </div>
          <div className="form-group">
            <label>Employer Name: </label>
            <input type="text" 
              className="form-control"
              placeholder="Super Cool Enterprises, LLC."
              value={this.state.employer_name}
              onChange={this.onChangeEmployerName}
            />
          </div>
          <div className="form-group">
            <label>ID Number: </label>
            <input type="text" className="form-control"
              value={this.state.employer_id_number}
              onChange={this.onChangeIDNumber}
            />
          </div>
          <div className="form-group">
            <input type="submit" className="btn btn-primary"
              value="Register Employee" 
            />
          </div>
        </form>
      </div>
    )
  }
}
