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

-- Create badges table
CREATE TABLE badges (
    badge_id INT PRIMARY KEY AUTO_INCREMENT,
    badge_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    bb_amount INT NOT NULL
);


-- Create user badges table
CREATE TABLE user_badges (
    user_id INT NOT NULL,
    badge_id INT NOT NULL,
    earned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, badge_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
	FOREIGN KEY (badge_id) REFERENCES badges(badge_id) ON DELETE CASCADE    
);



alter table articles modify column article_type ENUM('Band', 'Album', 'Concert', 'General');

alter table reacts rename areactions;

create table treactions(
	user_id INT NOT NULL,
    thread_id INT NOT NULL,
    type ENUM("like", "dislike") NOT NULL,
    created_at DATETIME DEFAULT current_timestamp,
    primary key(user_id, thread_id),
    foreign key(user_id) references users(user_id) on delete cascade,
    foreign key(thread_id) references forum_threads(thread_id) on delete cascade 
);

create table preactions(
	user_id INT NOT NULL,
    post_id INT NOT NULL,
    type ENUM("like", "dislike") NOT NULL,
    created_at DATETIME DEFAULT current_timestamp,
    primary key(user_id, post_id),
    foreign key(user_id) references users(user_id) on delete cascade,
    foreign key(post_id) references forum_posts(post_id) on delete cascade 
);

-- corrections due to my stupidity 
alter table forum_posts
add likes INT default 0,
add dislikes INT default 0;  

alter table forum_threads
add likes INT default 0,
add dislikes INT default 0; 

ALTER TABLE forum_threads MODIFY user_id INT DEFAULT NULL;
ALTER TABLE forum_threads DROP FOREIGN KEY forum_threads_ibfk_1;


ALTER TABLE forum_threads 
DROP FOREIGN KEY user_id, 
ADD CONSTRAINT user_id
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL;

SHOW CREATE TABLE forum_threads;


ALTER TABLE forum_posts 
DROP FOREIGN KEY forum_posts_ibfk_2, 
ADD CONSTRAINT forum_posts_ibfk_2 
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;


SHOW CREATE TABLE forum_posts;

ALTER TABLE forum_posts DROP FOREIGN KEY forum_posts_ibfk_1;
ALTER TABLE forum_posts DROP FOREIGN KEY forum_posts_ibfk_2;
	
ALTER TABLE forum_posts
ADD CONSTRAINT forum_posts_ibfk_1
FOREIGN KEY (thread_id) REFERENCES forum_threads(thread_id) ON DELETE CASCADE;

ALTER TABLE forum_posts
ADD CONSTRAINT forum_posts_ibfk_2
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;

-- change level logic
alter table blast_beats add column level int as (floor(sqrt(points/100))) virtual;

