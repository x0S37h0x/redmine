// plugins/x0s37h0x_Gamification/app/javascript/components/DailyTodos.jsx
import React, { useEffect, useState } from 'react';

const DailyTodos = () => {
    const [dailyTodos, setDailyTodos] = useState([]);

    // Fetch the list of daily todos when the component mounts
    useEffect(() => {
        fetch('/api/daily_todos')
            .then(response => response.json())
            .then(data => setDailyTodos(data))
            .catch(error => console.error('Error fetching daily todos:', error));
    }, []);

    return (
        <div>
            <h2>Daily ToDos</h2>
            <ul>
                {dailyTodos.map(todo => (
                    <li key={todo.id}>
                        <strong>{todo.title}</strong>
                        <p>{todo.description}</p>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default DailyTodos;
