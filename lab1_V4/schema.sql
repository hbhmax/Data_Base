CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    birth_date DATE,
    registered_at DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    release_year INT NOT NULL CHECK (release_year BETWEEN 1900 AND 2100),
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    rating NUMERIC(3,1) CHECK (rating BETWEEN 0 AND 10),
    genre_id INT NOT NULL REFERENCES genres(genre_id) ON DELETE RESTRICT
);

CREATE TABLE subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    plan_type VARCHAR(20) NOT NULL CHECK (plan_type IN ('basic', 'standard', 'premium')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price NUMERIC(8,2) NOT NULL CHECK (price > 0),
    CHECK (end_date > start_date)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    movie_id INT NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 10),
    comment TEXT,
    review_date DATE NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (user_id, movie_id)
);

CREATE TABLE viewing_history (
    history_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    movie_id INT NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    watched_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    progress_percent INT NOT NULL CHECK (progress_percent BETWEEN 0 AND 100)
);
