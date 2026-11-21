DROP TABLE IF EXISTS anime_producers;
DROP TABLE IF EXISTS anime_genres;
DROP TABLE IF EXISTS anime;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS sources;
DROP TABLE IF EXISTS studios;
DROP TABLE IF EXISTS producers;
DROP TABLE IF EXISTS types;
DROP TABLE IF EXISTS genres;

CREATE TABLE genres (
    genre_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE types (
    type_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE producers (
    producer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    producer_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE studios (
    studio_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE sources (
    source_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE ratings (
    rating_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rating_name VARCHAR(100) NOT NULL UNIQUE,
    rating_age INT NOT NULL,
    rating_description TEXT NOT NULL
);

INSERT INTO genres (genre_name) VALUES ('Action'), ('Adventure'), ('Drama'), ('Sci-Fi'), ('Space'), ('Shounen'), ('Military');
INSERT INTO types (type_name) VALUES ('TV'), ('Movie');
INSERT INTO producers (producer_name) 
VALUES ('Bandai Visual'), ('Sunrise'), ('TV Tokyo'), ('Shueisha'), ('Fuji TV'), ('Sotsu'), ('Sony Music'), ('Entertainment');
INSERT INTO studios (studio_name) VALUES ('Sunrise'), ('Bones'), ('Studio Pierrot'), ('Toei Animation');
INSERT INTO sources (source_name) VALUES ('Original'), ('Manga');
INSERT INTO ratings (rating_name, rating_age, rating_description) VALUES 
    ('R - 17+', 17, 'violence & profanity'),
    ('PG-13 -', 13, 'Teens 13 or older'),
    ('PG -', 10, 'Parental Guidance Suggested'),
    ('G -', 0, 'All Ages');

CREATE TABLE anime (
    anime_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    english_name VARCHAR(100) NOT NULL,
    score DECIMAL(3, 2) NOT NULL,
    -- genre_id INT[] NOT NULL REFERENCES genres(genre_id),
    type_id INT NOT NULL REFERENCES types(type_id),
    episodes INT DEFAULT NULL,
    aired_start DATE NOT NULL,
    aired_end DATE DEFAULT NULL,
    premiered VARCHAR(100) DEFAULT NULL,
    -- producer_id INT[] NOT NULL REFERENCES producers(producer_id),
    studio_id INT NOT NULL REFERENCES studios(studio_id),
    source_id INT NOT NULL REFERENCES sources(source_id),
    duration_per_episode INTERVAL NOT NULL,
    total_duration INTERVAL GENERATED ALWAYS AS (duration_per_episode * episodes) STORED,
    rating_id INT NOT NULL REFERENCES ratings(rating_id),
    ranked DECIMAL(5, 1) DEFAULT NULL,
    popularity INT DEFAULT NULL
);

CREATE TABLE anime_genres (
    anime_id INT NOT NULL REFERENCES anime(anime_id),
    genre_id INT NOT NULL REFERENCES genres(genre_id),
    PRIMARY KEY (anime_id, genre_id)
);

CREATE TABLE anime_producers (
    anime_id INT NOT NULL REFERENCES anime(anime_id),
    producer_id INT NOT NULL REFERENCES producers(producer_id),
    PRIMARY KEY (anime_id, producer_id)
);

INSERT INTO anime (
    english_name, score, type_id, episodes, aired_start, aired_end, premiered, studio_id, source_id, duration_per_episode, rating_id, ranked, popularity
)
VALUES
    ('Cowboy Bebop',                    8.78, 1, 24,   '1998-04-03', '1998-04-24', 'Spring 1998', 1, 1, '00:24:00', 1, 28,   39),
    ('Cowboy Bebop: The Movie',         8.39, 2, 1,    '2001-09-01', NULL,         'Fall 2001',   2, 1, '01:55:00', 1, 159,  518),
    ('Naruto',                          7.91, 1, 220,  '2002-10-03', '2007-02-08', 'Fall 2002',   3, 2, '00:23:00', 2, 660,  8),
    ('One Piece',                       8.52, 1, NULL, '1999-10-20', NULL,         'Fall 1999',   4, 2, '00:24:00', 2, 95,   31),
    ('Mobile Suit Gundam SEED',         7.79, 1, 50,   '2002-10-05', '2003-09-27', 'Fall 2002',   1, 1, '00:24:00', 2, 850,  1057),
    ('Mobile Suit Gundam SEED Destiny', 7.22, 1, 50,   '2004-10-09', '2005-10-01', 'Fall 2004',   1, 1, '00:24:00', 2, 2687, 1530);

INSERT INTO anime_genres (anime_id, genre_id)
SELECT a.anime_id, g
FROM (VALUES
    ('Cowboy Bebop',                    ARRAY[1, 2, 3, 4, 5]),
    ('Cowboy Bebop: The Movie',         ARRAY[1, 3, 4, 5]),
    ('Naruto',                          ARRAY[1, 2, 6]),
    ('One Piece',                       ARRAY[1, 2, 6]),
    ('Mobile Suit Gundam SEED',         ARRAY[1, 3, 4, 5]),
    ('Mobile Suit Gundam SEED Destiny', ARRAY[1, 3, 4, 5])
) AS v(name, genres)
JOIN anime a ON a.english_name = v.name
CROSS JOIN unnest(v.genres) AS g;

INSERT INTO anime_producers (anime_id, producer_id)
SELECT a.anime_id, p
FROM (VALUES
    ('Cowboy Bebop',                    ARRAY[1]),
    ('Cowboy Bebop: The Movie',         ARRAY[2, 1]),
    ('Naruto',                          ARRAY[3, 4]),
    ('One Piece',                       ARRAY[5, 4]),
    ('Mobile Suit Gundam SEED',         ARRAY[6, 7]),
    ('Mobile Suit Gundam SEED Destiny', ARRAY[6, 7])
) AS v(name, producers)
JOIN anime a ON a.english_name = v.name
CROSS JOIN unnest(v.producers) AS p;
