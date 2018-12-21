import React, { Component } from 'react';
import axios from 'axios';

export default class Edit extends Component {
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

  componentDidMount() {
    axios.get('http://localhost:4000/employer/edit/'+this.props.match.params.id)
      .then(response => {
        this.setState({ 
          person_name: response.data.person_name, 
          employer_name: response.data.employer_name,
          employer_id_number: response.data.employer_id_number });
        })
      .catch(function (error) {
        console.log(error);
      })
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
    axios.post('http://localhost:4000/employer/update/'+this.props.match.params.id, obj)
        .then(res => console.log(res.data));
    
    this.props.history.push('/index');
  }
 
  render() {
    return (
      <div style={{ marginTop: 10 }}>
        <h3 align="center">Update Info</h3>
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
              value={this.state.employer_name}
              onChange={this.onChangeEmployerName}
            />
          </div>
          <div className="form-group">
            <label>ID Number: </label>
            <input type="text" 
              className="form-control"
              value={this.state.employer_id_number}
              onChange={this.onChangeIDNumber}
            />
          </div>
          <div className="form-group">
            <input type="submit" 
              value="Update Employee" 
              className="btn btn-primary"/>
          </div>
        </form>
      </div>
    )
  }
}