ALTER TABLE users ADD COLUMN phone VARCHAR(20) UNIQUE;

CREATE TABLE movie_genres (
    movie_id INT NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    genre_id INT NOT NULL REFERENCES genres(genre_id) ON DELETE RESTRICT,
    PRIMARY KEY (movie_id, genre_id)
);

INSERT INTO movie_genres (movie_id, genre_id)
SELECT movie_id, genre_id FROM movies WHERE genre_id IS NOT NULL;

ALTER TABLE movies DROP COLUMN genre_id;
