// plugins/x0s37h0x_Gamification/app/javascript/components/GeneralTodos.jsx
import React, { useEffect, useState } from 'react';

const GeneralTodos = () => {
    const [todos, setTodos] = useState([]);

    // Fetch the list of general todos when the component mounts
    useEffect(() => {
        fetch('/api/general_todos')
            .then(response => response.json())
            .then(data => setTodos(data))
            .catch(error => console.error('Error fetching general todos:', error));
    }, []);

    return (
        <div>
            <h2>General ToDos</h2>
            <ul>
                {todos.map(todo => (
                    <li key={todo.id}>
                        <strong>{todo.title}</strong>
                        <p>{todo.description}</p>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default GeneralTodos;
