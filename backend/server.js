const express = require("express");
const cors = require("cors");
const bcrypt = require("bcrypt");
const Database = require("better-sqlite3");
const path = require("path");

const app = express();

// Port et emplacement de la base configurables (Docker, local, etc.)
const PORT = Number(process.env.PORT || 3000);
const DATABASE_PATH =
  process.env.DATABASE_PATH || path.join(__dirname, "alternative_transport.db");

// Middleware
app.use(cors());
app.use(express.json());

// Database
const db = new Database(DATABASE_PATH);
db.pragma("journal_mode = WAL");

db.exec(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL COLLATE NOCASE UNIQUE,
    password_hash TEXT NOT NULL,
    email_verified INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  );
`);

// Compte de démonstration, créé une seule fois au démarrage.
const DEMO_EMAIL = "demo@alternative.tn";
const DEMO_PASSWORD = "demo1234";

function seedDemoUser() {
  const existing = db
    .prepare("SELECT id FROM users WHERE email = ?")
    .get(DEMO_EMAIL);

  if (existing) return;

  db.prepare(
    `INSERT INTO users (first_name, last_name, email, password_hash, email_verified)
     VALUES (?, ?, ?, ?, 1)`
  ).run(
    "Ahmed Nour",
    "Sdiri",
    DEMO_EMAIL,
    bcrypt.hashSync(DEMO_PASSWORD, 12)
  );

  console.log(`Compte de démonstration prêt : ${DEMO_EMAIL} / ${DEMO_PASSWORD}`);
}

seedDemoUser();

// Health check
app.get("/api/health", (req, res) => {
  res.json({
    success: true,
    message: "Alternative Transport Backend is running",
  });
});

// Register
app.post("/api/register", async (req, res) => {
  try {
    const { firstName, lastName, email, password } = req.body;

    if (!firstName || !lastName || !email || !password) {
      return res.status(400).json({
        success: false,
        message: "Tous les champs sont obligatoires.",
      });
    }

    const normalizedEmail = String(email).trim().toLowerCase();

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalizedEmail)) {
      return res.status(400).json({
        success: false,
        message: "Adresse e-mail invalide.",
      });
    }

    if (String(password).length < 8) {
      return res.status(400).json({
        success: false,
        message: "Le mot de passe doit contenir au moins 8 caractères.",
      });
    }

    if (Buffer.byteLength(String(password), "utf8") > 72) {
      return res.status(400).json({
        success: false,
        message: "Le mot de passe est trop long.",
      });
    }

    const passwordHash = await bcrypt.hash(String(password), 12);

    const result = db
      .prepare(
        `INSERT INTO users (first_name, last_name, email, password_hash)
         VALUES (?, ?, ?, ?)`
      )
      .run(
        String(firstName).trim(),
        String(lastName).trim(),
        normalizedEmail,
        passwordHash
      );

    return res.status(201).json({
      success: true,
      message: "Compte créé avec succès.",
      user: {
        id: result.lastInsertRowid,
        firstName: String(firstName).trim(),
        lastName: String(lastName).trim(),
        email: normalizedEmail,
      },
    });
  } catch (error) {
    if (error.code === "SQLITE_CONSTRAINT_UNIQUE") {
      return res.status(409).json({
        success: false,
        message: "Cette adresse e-mail est déjà utilisée.",
      });
    }

    console.error("Register error:", error);

    return res.status(500).json({
      success: false,
      message: "Erreur interne du serveur.",
    });
  }
});

// Login
app.post("/api/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "L'e-mail et le mot de passe sont obligatoires.",
      });
    }

    const normalizedEmail = String(email).trim().toLowerCase();

    const user = db
      .prepare(
        `SELECT id, first_name, last_name, email, password_hash
         FROM users
         WHERE email = ?`
      )
      .get(normalizedEmail);

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "E-mail ou mot de passe incorrect.",
      });
    }

    const passwordMatches = await bcrypt.compare(
      String(password),
      user.password_hash
    );

    if (!passwordMatches) {
      return res.status(401).json({
        success: false,
        message: "E-mail ou mot de passe incorrect.",
      });
    }

    return res.json({
      success: true,
      message: "Connexion réussie.",
      user: {
        id: user.id,
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error("Login error:", error);

    return res.status(500).json({
      success: false,
      message: "Erreur interne du serveur.",
    });
  }
});

// 404
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route introuvable.",
  });
});

// Start server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Backend running on http://127.0.0.1:${PORT}`);
  console.log(`Health check: http://127.0.0.1:${PORT}/api/health`);
});
