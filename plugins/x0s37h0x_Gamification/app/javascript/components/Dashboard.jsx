import React from 'react';
import Habits from './Habits';
import DailyTodos from './DailyTodos';
import GeneralTodos from './GeneralTodos';

const Dashboard = () => {
  return (
    <div>
      <h1>Dashboard</h1>
      <div>
        <h2>Habits</h2>
        <Habits />
      </div>
      <div>
        <h2>Daily To-Dos</h2>
        <DailyTodos />
      </div>
      <div>
        <h2>To-Dos</h2>
        <GeneralTodos />
      </div>
    </div>
  );
};

export default Dashboard;
