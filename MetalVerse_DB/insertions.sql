-- Insertions for Metalverse
USE metalverse;

INSERT INTO users(username, email, password_hash, role, created_at) VALUES
('metalhead101', 'metalhead101@example.com', 'hashedpassword1', 'normie', NOW()),
('admin123', 'admin@example.com', 'hashedpassword2', 'admin', NOW()),
('dirtyhorn11', 'dirty_horn11@example.com', 'hashedpassword3', 'normie', NOW()),
('headbanger92', 'headbanger92@example.com', 'hashedpassword4', 'normie', NOW()),
('riffenjoyer', 'rifenjoyer@example.com', 'hashedpassword5', 'normie', NOW());

INSERT INTO articles (article_id, article_type, title, content, created_at, user_id, likes, dislikes) VALUES
(1, 'Band', 'Iron Maiden: Legends of Metal', 'An in-depth look at the history of Iron Maiden...', NOW(), 1, 10, 2),
(2, 'Album', 'Black Sabbath - Paranoid Review', 'Reviewing one of the most iconic metal albums...', NOW(), 2, 15, 1),
(3, 'Concert', 'Colafest in Erevan', 'Reviewing one of the most iconic metal fests in Erevan...', NOW(), 3, 5, 5),
(4, 'Band', 'Isole: Underground Everest', 'Reviewing one of the most powerful doom metal bands...', NOW(), 2, 33, 1),
(5, 'General', 'The Influence of Heavy Metal on Culture', 'Exploring how heavy metal has influenced society...', NOW(), 3, 20, 3);

INSERT INTO band_articles (band_article_id, article_id, band_name, genre, formation_year) VALUES
(1, 1, 'Iron Maiden', 'Heavy Metal', 1975),
(2, 4, 'Isole', 'Doom Metal', 1990);

INSERT INTO album_articles (album_article_id, article_id, band_name, album_name, genre, release_year) VALUES
(1, 2, 'Black Sabbath', 'Paranoid', 'Heavy Metal', 1970);

INSERT INTO concert_articles (article_id, concert_name, concert_date, venue, city, country)
VALUES
(3, 'ColaFest 2022', '2022-08-27', 'Havayi Stadion', 'Erevan', 'Aemenia');

INSERT INTO general_articles (general_article_id, article_id, topic) VALUES
(1, 5, 'Heavy Metal Culture');

INSERT INTO reacts (article_id, user_id, type, created_at) VALUES
(1, 3, 'like', NOW()),
(1, 2, 'dislike', NOW()),
(1, 4, 'like', NOW()),
(1, 5, 'like', NOW()),
(2, 4, 'like', NOW()),
(2, 3, 'like', NOW()),
(2, 1, 'like', NOW()),
(2, 5, 'dislike', NOW()),
(3, 4, 'like', NOW()),
(3, 1, 'dislike', NOW()),
(3, 2, 'dislike', NOW()),
(3, 5, 'dislike', NOW()),
(4, 1, 'like', NOW()),
(4, 2, 'like', NOW()),
(4, 5, 'like', NOW()),
(4, 3, 'like', NOW()),
(5, 1, 'like', NOW()),
(5, 2, 'like', NOW()),
(5, 5, 'like', NOW()),
(5, 3, 'like', NOW()),
(5, 4, 'like', NOW());

INSERT INTO comments (comment_id, article_id, user_id, content, created_at) VALUES

(1, 1, 2, 'This article is amazing! Up the Irons!', NOW()),
(2, 2, 1, 'Paranoid is my favorite album!', NOW()),
(3, 5, 4, 'Great analysis of metal culture!', NOW());

INSERT INTO forum_threads (thread_id, title, user_id, created_at) VALUES
(1, 'Best Metal Albums of All Time?', 1, NOW()),
(2, 'Favorite Metal Subgenres?', 2, NOW());

INSERT INTO forum_posts (post_id, thread_id, content, user_id, created_at) VALUES
(3, 1, 'For me, it has to be Sad but true!', 4, NOW()),
(1, 1, 'For me, it has to be Master of Puppets!', 3, NOW()),
(2, 2, 'Death Metal is the best!', 1, NOW());

INSERT INTO badges (badge_id, badge_name, description, bb_amount) VALUES
-- Article Writing Badges
(1, 'Scribe of Steel', 'Awarded for writing 3 articles.', 300),
(2, 'Lyrical Chronicler', 'Awarded for writing 10 articles.', 600),
(3, 'Metalverse Historian', 'Awarded for writing 25 articles.', 1000),
(4, 'Eternal Archivist', 'Awarded for writing 50 articles.', 1500),

-- Commenting Badges
(5, 'Echo of the Pit', 'Awarded for writing 10 comments.', 200),
(6, 'Voice of the Masses', 'Awarded for writing 50 comments.', 500),
(7, 'Forum Prophet', 'Awarded for writing 150 comments.', 900),
(8, 'The Comment Overlord', 'Awarded for writing 300 comments.', 1400),

-- Forum Thread Creation Badges
(9, 'Forge of Debate', 'Awarded for starting 3 forum threads.', 300),
(10, 'Council Summoner', 'Awarded for starting 10 forum threads.', 700),
(11, 'Master of Discourse', 'Awarded for starting 25 forum threads.', 1200),
(12, 'Architect of the Forum', 'Awarded for starting 50 forum threads.', 1800),

-- Forum Post Contribution Badges
(13, 'Whisperer of the Void', 'Awarded for posting 10 times in forum threads.', 250),
(14, 'Riffsmith of Discussions', 'Awarded for posting 50 times in forum threads.', 600),
(15, 'Amplifier of the Masses', 'Awarded for posting 150 times in forum threads.', 1100),
(16, 'The Forum Amplifier', 'Awarded for posting 300 times in forum threads.', 1600),

-- Popular Article Badges (Likes)
(17, 'Cult Following', 'Awarded when an article receives 10 likes.', 400),
(18, 'Metal Icon', 'Awarded when an article receives 50 likes.', 900),
(19, 'Legend of the Scene', 'Awarded when an article receives 150 likes.', 1400),
(20, 'Immortal Wordsmith', 'Awarded when an article receives 300 likes.', 2000),

-- Controversial Article Badges (Dislikes)
(21, 'Rogue Thinker', 'Awarded when an article receives 10 dislikes.', 300),
(22, 'Provocateur of the Pit', 'Awarded when an article receives 50 dislikes.', 800),
(23, 'The Rebellious Pen', 'Awarded when an article receives 150 dislikes.', 1300),
(24, 'Unholy Scribe', 'Awarded when an article receives 300 dislikes.', 1800),

-- gift from creator
(25, 'Blessing of the Metal God', 'A special badge granted personally by the creator.', 500);


-- users with their badges 
INSERT INTO user_badges (user_id, badge_id) VALUES
(1, 25);

INSERT INTO blast_beats (blast_beats_id, user_id, points, level) VALUES
(1, 1, 675, 5),
(2, 2, 150, 10),
(3, 3, 125, 3),
(4, 4, 120, 3),
(5, 5, 100, 3);

update blast_beats
SET points = points +25
where user_id = 4;

-- article is 100 BB, comment is 20BB, Thread is 30BB, thread posts 25BB, every badge has unique blast beats points











SET SQL_SAFE_UPDATES = 1;

UPDATE blast_beats
SET level = 2		
WHERE points > 500;












