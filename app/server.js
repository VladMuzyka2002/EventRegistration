const pg = require("pg");
const express = require("express");
const path = require("path");
const app = express();

const port = 3000;
const hostname = "localhost";

const env = require("../env.json"); // Ensure the path to env.json is correct
const Pool = pg.Pool;
const pool = new Pool(env);
pool.connect().then(function () {
  console.log(`Connected to database ${env.database}`);
}).catch(err => {
  console.error('Error connecting to the database:', err.message);
});

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

app.post('/createEvent', async (req, res) => {
  const { eventName, eventDate, eventTime, eventDescription, isPrivate, ytLink, adminId, address, created_at } = req.body;

  try {
    console.log("Before");
    console.log(eventName, eventDate, eventTime, eventDescription, isPrivate, ytLink, adminId, address, created_at);
    const result = await pool.query(
      `insert into events("isPrivate", "ytLink", "adminId", "eventName", "description", created_at, address, event_date)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8);`,
      [isPrivate, ytLink, adminId, eventName, eventDescription, created_at, address, eventDate]
    );
    console.log("After");
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error executing query:', err.message, err.stack);
    res.status(500).json({ error: err.message });
  }
});

app.get('/publicevents', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM events WHERE "isPrivate" = false');
    if (result.rows.length > 0) {
      res.json({ username: result.rows });
    } else {
      res.status(404).json({ error: 'No public events were found' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://${hostname}:${port}`);
});
