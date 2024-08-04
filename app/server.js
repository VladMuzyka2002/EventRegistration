const pg = require("pg");
const express = require("express");
const app = express();
const cookieParser = require("cookie-parser");
const session = require('express-session');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const port = 3000;
const hostname = "localhost";

const env = require("../env.json");
const Pool = pg.Pool;
const pool = new Pool(env);
pool.connect().then(function () {
  console.log(`Connected to database ${env.database}`);
});
app.use(express.json());
app.use(express.static("public"));
app.use(cookieParser());

app.use(session({
  secret: env.session_key,
  saveUninitialized: true,
  resave: true
}));

// User registration endpoint
app.post('/register', async (req, res) => {
  const { username, email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query('INSERT INTO users (username, email, hashedPassword) VALUES ($1, $2, $3) RETURNING id', [username, email, hashedPassword]);
    res.status(201).json({ userId: result.rows[0].id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// User login endpoint
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    if (result.rows.length > 0) {
      const user = result.rows[0];
      const match = await bcrypt.compare(password, user.hashedPassword);
      if (match) {
        const token = jwt.sign({ userId: user.id }, env.session_key, { expiresIn: '1h' });
        res.cookie('token', token, {
          httpOnly: true,
          secure: false
        });
        await pool.query('UPDATE users SET sessionToken = $1 WHERE id = $2', [token, user.id]);
        res.redirect('/home.html');
      } else {
        res.status(401).json({ error: 'Invalid password' });
      }
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/publicevents', async (req, res) => {
  const userId = req.params.id;
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