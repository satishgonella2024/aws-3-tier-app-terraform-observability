import React, { useEffect, useState } from 'react';

function App() {
  const [data, setData] = useState([]);
  const [name, setName] = useState('');
  const [value, setValue] = useState('');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = () => {
    fetch('http://localhost:5000/data')
      .then((response) => response.json())
      .then((data) => setData(data))
      .catch((error) => console.error('Error fetching data:', error));
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    fetch('http://localhost:5000/data', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, value }),
    })
      .then(() => {
        setName('');
        setValue('');
        fetchData(); // Refresh the data
      })
      .catch((error) => console.error('Error adding data:', error));
  };

  return (
    <div className="App">
      <h1>3-Tier Application</h1>
      <h2>Data from Backend</h2>
      <ul>
        {data.map((item) => (
          <li key={item[0]}>
            {item[1]} - {item[2]}
          </li>
        ))}
      </ul>
      <h2>Add New Data</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <input
          type="text"
          placeholder="Value"
          value={value}
          onChange={(e) => setValue(e.target.value)}
        />
        <button type="submit">Add</button>
      </form>
    </div>
  );
}

export default App;
