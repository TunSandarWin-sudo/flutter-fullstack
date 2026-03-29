CREATE DATABASE IF NOT EXISTS movie_db;
USE movie_db;

CREATE TABLE movies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  description TEXT,
  image_url TEXT,
  rating FLOAT DEFAULT 0,
  genre VARCHAR(100),
  release_year INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);