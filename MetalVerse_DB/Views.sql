-- 												VIEWS
-- article an authors
CREATE VIEW `article_author` AS
select u.user_id, u.username, u.role, u.email, a.article_id, a.title, a.article_type, a.content, a.created_at, a.likes, a.dislikes    
from articles a join users u using (user_id);

-- views by article types with authors details
-- band articles 
CREATE VIEW `band_author` AS
select*
from band_articles as ba join (select*
from article_author a 
where article_type = "band") as ab using (article_id);

-- albumn articles 
CREATE VIEW `album_author` AS
select*
from album_articles as aa join (select*
from article_author a 
where article_type = "album") as ab using (article_id);

-- concert articles 
CREATE VIEW `concert_author` AS
select*
from concert_articles as ca join (select*
from article_author a 
where article_type = "concert") as ab using (article_id);

-- general articles 
CREATE VIEW `general_author` AS
select*
from general_articles as ga join (select*
from article_author a 
where article_type = "general") as ab using (article_id);

-- threads with corresponding posts
CREATE VIEW `thread_post` AS
SELECT 
    ft.thread_id,
    ft.title AS thread_title,
    ft.user_id AS thread_user_id,  -- Alias for user_id from forum_threads
    ft.likes AS thread_likes,      -- Alias for likes from forum_threads
    ft.dislikes AS thread_dislikes, -- Alias for dislikes from forum_threads
    fp.post_id,
    fp.content AS post_content,
    fp.user_id AS post_user_id,    -- Alias for user_id from forum_posts
    fp.likes AS post_likes,        -- Alias for likes from forum_posts
    fp.dislikes AS post_dislikes,  -- Alias for dislikes from forum_posts
    fp.created_at AS post_created_at
FROM forum_threads ft
JOIN forum_posts fp USING (thread_id)
ORDER BY ft.thread_id;

-- users with badges detailed
create view	`user_badge` AS
SELECT u.user_id, u.username, u.role, u.email, ub.earned_at, b.badge_id, b.badge_name, b.bb_amount, b.description
FROM users u
JOIN user_badges ub USING(user_id)
JOIN badges b USING(badge_id);

-- users and their levels with bb points
create view `user_level` AS
SELECT u.user_id, u.username, u.role, u.email, bb.level, bb.points, bb.blast_beats_id
FROM users u
JOIN blast_beats bb USING(user_id)
order by points desc;

-- liked articles threads and posts and comments similar logic
create view `user_like_article` AS
SELECT u.user_id, u.username, u.role, u.email, ar.type, ar.created_at, ar.article_id, a.title
FROM users u
JOIN areactions ar USING(user_id)
join articles a using(article_id)
order by user_id;

create view `user_like_thread` AS
SELECT u.user_id, u.username, u.role, u.email, ar.type, ar.created_at, ar.thread_id, f.title
FROM users u
JOIN treactions ar USING(user_id)
join forum_threads f using(thread_id)
order by user_id;

create view `user_like_post` AS
SELECT u.user_id, u.username, u.role, u.email, ar.type, ar.created_at, ar.post_id
FROM users u
JOIN preactions ar USING(user_id)
order by user_id;

create view `user_comment` AS
SELECT u.user_id, u.username, u.role, u.email, c.created_at, c.comment_id, c.content, c.article_id, a.title
FROM users u
JOIN comments c USING(user_id)
join articles a using(article_id)
order by user_id;

