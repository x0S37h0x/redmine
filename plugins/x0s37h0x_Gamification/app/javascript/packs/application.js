// plugins/x0s37h0x_Gamification/app/javascript/packs/application.js
import React from 'react';
import ReactDOM from 'react-dom';
import Dashboard from '../components/Dashboard';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<Dashboard />, document.getElementById('gamification-dashboard'));
});
