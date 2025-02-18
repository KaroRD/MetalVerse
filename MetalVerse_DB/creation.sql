USE metalverse;

-- Create User Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('normie', 'admin') NOT NULL DEFAULT 'normie',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Article Table (Supertype)
CREATE TABLE articles (
    article_id INT PRIMARY KEY AUTO_INCREMENT,
    article_type ENUM('band', 'album', 'concert', 'general') NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    likes INT DEFAULT 0,
    dislikes INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create Band Article Table (Subtype)
CREATE TABLE band_articles (
    band_article_id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT UNIQUE NOT NULL,
    band_name VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    formation_year YEAR,
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE
);

-- Create Album Article Table (Subtype)
CREATE TABLE album_articles (
    album_article_id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT UNIQUE NOT NULL,
    band_name VARCHAR(100) NOT NULL,
    album_name VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    release_year YEAR,
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE
);

-- Create Concert Article Table (Subtype)
CREATE TABLE concert_articles (
    concert_article_id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT UNIQUE NOT NULL,
    concert_name VARCHAR(100) NOT NULL,
    concert_date DATE NOT NULL,
    venue VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE
);

-- Create General Article Table (Subtype)
CREATE TABLE general_articles (
    general_article_id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT UNIQUE NOT NULL,
    topic VARCHAR(100) NOT NULL,
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE
);

-- Create React Table (Likes & Dislikes)
CREATE TABLE reacts (
    article_id INT NOT NULL,
    user_id INT NOT NULL,
    type ENUM('like', 'dislike') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (article_id, user_id),
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create Comment Table
CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create Forum Thread Table
CREATE TABLE forum_threads (
    thread_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create Forum Post Table
CREATE TABLE forum_posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    thread_id INT NOT NULL,
    content TEXT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES forum_threads(thread_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create Blast Beats Table
CREATE TABLE blast_beats (
    blast_beats_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    points INT DEFAULT 0,
    level INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create user badges table
CREATE TABLE user_badges (
    user_id INT NOT NULL,
    badge VARCHAR(100) NOT NULL,
    earned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, badge),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);











