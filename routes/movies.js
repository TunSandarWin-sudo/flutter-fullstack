const express = require("express");
const router = express.Router();
const db = require("../db");

// GET all
router.get("/", async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM movies");
    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET by ID
router.get("/:id", async (req, res) => {
  try {
    const [rows] = await db.query(
      "SELECT * FROM movies WHERE id = ?",
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Movie not found" });
    }

    res.status(200).json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST
router.post("/", async (req, res) => {
  try {
    const { title, description, image_url, rating, genre, release_year } = req.body;

    const [result] = await db.query(
      "INSERT INTO movies (title, description, image_url, rating, genre, release_year) VALUES (?, ?, ?, ?, ?, ?)",
      [title, description, image_url, rating, genre, release_year]
    );

    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT
router.put("/:id", async (req, res) => {
  try {
    const { title, description, image_url, rating, genre, release_year } = req.body;

    const [result] = await db.query(
      "UPDATE movies SET title=?, description=?, image_url=?, rating=?, genre=?, release_year=? WHERE id=?",
      [title, description, image_url, rating, genre, release_year, req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Movie not found" });
    }

    res.status(200).json({ message: "Updated successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE
router.delete("/:id", async (req, res) => {
  try {
    const [result] = await db.query(
      "DELETE FROM movies WHERE id = ?",
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Movie not found" });
    }

    res.status(200).json({ message: "Deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;