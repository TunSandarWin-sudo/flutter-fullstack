const express = require("express");
const router = express.Router();
const db = require("../db");

// ✅ GET ALL
router.get("/", async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM movies ORDER BY id DESC");
    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ GET BY ID
router.get("/:id", async (req, res) => {
  try {
    const [rows] = await db.query(
      "SELECT * FROM movies WHERE id = ?",
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Movie not found" });
    }

    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ CREATE (NO NULL ALLOWED)
router.post("/", async (req, res) => {
  try {
    const {
      title,
      description,
      image_url,
      rating = 0,
      genre,
      release_year,
    } = req.body;

    if (!title || !image_url) {
      return res.status(400).json({
        error: "Title and image_url are required",
      });
    }

    const [result] = await db.query(
      `INSERT INTO movies 
      (title, description, image_url, rating, genre, release_year)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [title, description, image_url, rating, genre, release_year]
    );

    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ UPDATE (FIXED — NO DATA LOSS)
router.put("/:id", async (req, res) => {
  try {
    const { title, description, image_url, rating, genre, release_year } =
      req.body;

    const [existing] = await db.query(
      "SELECT * FROM movies WHERE id = ?",
      [req.params.id]
    );

    if (existing.length === 0) {
      return res.status(404).json({ message: "Movie not found" });
    }

    const movie = existing[0];

    // 🔥 KEEP OLD VALUES IF NOT PROVIDED
    const updated = {
      title: title ?? movie.title,
      description: description ?? movie.description,
      image_url: image_url ?? movie.image_url,
      rating: rating ?? movie.rating,
      genre: genre ?? movie.genre,
      release_year: release_year ?? movie.release_year,
    };

    await db.query(
      `UPDATE movies SET
        title = ?,
        description = ?,
        image_url = ?,
        rating = ?,
        genre = ?,
        release_year = ?
       WHERE id = ?`,
      [
        updated.title,
        updated.description,
        updated.image_url,
        updated.rating,
        updated.genre,
        updated.release_year,
        req.params.id,
      ]
    );

    res.json({ message: "Updated successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ DELETE
router.delete("/:id", async (req, res) => {
  try {
    await db.query("DELETE FROM movies WHERE id = ?", [req.params.id]);
    res.json({ message: "Deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;