-- users and their bb points
select u.user_id, u.username, bb.points
from users as u join blast_beats as bb on u.user_id = bb.user_id
order by bb.points DESC;

-- article with authors
select*
from thread_post;

select*
from band_author;  


select* 
from forum_threads join forum_posts using(thread_id)
order by thread_id;

SELECT u.user_id, u.username, u.role, u.email, ub.earned_at, b.badge_id, b.badge_name, b.bb_amount, b.description
FROM users u
JOIN user_badges ub USING(user_id)
JOIN badges b USING(badge_id);


SELECT u.user_id, u.username, u.role, u.email, bb.points, bb.level
FROM users u
JOIN blast_beats bb USING(user_id)
order by points desc;

SELECT u.user_id, u.username, u.role, u.email, c.created_at, c.comment_id, c.content, c.article_id, a.title
FROM users u
JOIN comments c USING(user_id)
join articles a using(article_id)
order by user_id;

select* from article_author;

select count(*) from users;

select sum(likes)
from article_author
where user_id = 1;

select get_likes_for_article_per_user(2);

select* from areactions;

call dislike_article(2,1);

select* from user_level;
select* from user_badge;

call award_badge(2, 25);

select* from blast_beats;




