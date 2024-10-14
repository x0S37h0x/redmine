// plugins/x0s37h0x_Gamification/app/javascript/components/Main.jsx
import React from 'react';
import Habits from './Habits';
import DailyTodos from './DailyTodos';
import GeneralTodos from './GeneralTodos';

const Main = () => (
  <div>
    <h1>Gamification Dashboard</h1>
    <Habits />
    <DailyTodos />
    <GeneralTodos />
  </div>
);

export default Main;
