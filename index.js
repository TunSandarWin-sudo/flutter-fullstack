require("dotenv").config();
const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

// routes
const movieRoutes = require("./routes/movies");
app.use("/api/movies", movieRoutes);

// root
app.get("/", (req, res) => {
  res.json({ message: "Movie API is running ✅" });
});

// error handler
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: "Internal Server Error" });
});

// start server (local only)
if (process.env.NODE_ENV !== "production") {
  const PORT = process.env.PORT || 3333;
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

module.exports = app;