-- FUNCTIONS & PORCEDURES
DELIMITER $$
-- FUNCTION gets total likes made by user, takes user_id
CREATE function `get_likes_for_article_per_user`(input_user_id INT)
returns int
deterministic
begin
	declare like_count int; 
    
    select count(*)
    into like_count
    from areactions
    where type = "like" and user_id = input_user_id;
    
    return like_count;
end$$
DELIMITER ;

-- FUNCTION gets total dislikes made by user, takes user_id
DELIMITER $$
create function `get_dislikes_for_article_per_user`(input_user_id int)
returns int
deterministic
begin
	declare dislike_count int;
    select count(*)
    into dislike_count
    from areactions
    where type = "dislike" and user_id = input_user_id;
    
    return dislike_count;
end$$
DELIMITER ;

-- same as articles only this time threads and posts
DELIMITER $$
create function `get_likes_for_thread_per_user`(input_user_id int)
returns int
deterministic
begin
	declare like_count int;
    select count(*)
    into like_count
    from treactions
    where type = "like" and user_id = input_user_id;
    
    return like_count;
end$$
DELIMITER ;


DELIMITER $$
create function `get_dislikes_for_thread_per_user`(input_user_id int)
returns int
deterministic
begin
	declare dislike_count int;
    select count(*)
    into dislike_count
    from treactions
    where type = "dislike" and user_id = input_user_id;
    
    return dislike_count;
end$$
DELIMITER ;

DELIMITER $$
create function `get_likes_for_post_per_user`(input_user_id int)
returns int
deterministic
begin
	declare like_count int;
    select count(*)
    into like_count
    from preactions
    where type = "like" and user_id = input_user_id;
    
    return like_count;
end$$
DELIMITER ;

DELIMITER $$
create function `get_dislikes_for_post_per_user`(input_user_id int)
returns int
deterministic
begin
	declare dislike_count int;
    select count(*)
    into dislike_count
    from preactions
    where type = "dislike" and user_id = input_user_id;
    
    return dislike_count;
end$$
DELIMITER ;

-- returns number of comments made by user

DELIMITER $$
create function `total_comments` (input_user_id INT)
returns int
deterministic
begin
	declare count int;
    
    select count(*)
    into count
    from comments
    where user_id = input_user_id;
    
    return count;
    

end$$
delimiter ;


-- returns how many likes a user recieved by written articles, threads, posts 

delimiter $$
create function `user_gained_likes` (input_user_id int) 
returns int
deterministic
begin
	declare count int default 0;
    
        -- Add likes from article_author
    select coalesce(sum(likes), 0) into count
    from article_author
    where user_id = input_user_id;
    
        -- Add likes from forum_threads
    select coalesce(sum(likes), 0) into @tmp
    from forum_threads
    where user_id = input_user_id;
    set count = count + @tmp;
    
        -- Add likes from forum_posts
	select coalesce(sum(likes), 0) into @tmp
    from forum_posts
    where user_id = input_user_id;
	set count = count + @tmp;

    return count;
end $$
delimiter ;

-- returns how many DISLIKES a user recieved by written articles, threads, posts 
delimiter $$
create function `user_gained_dislikes` (input_user_id int) 
returns int
deterministic
begin
	declare count int default 0;
    
        -- Add likes from article_author
    select coalesce(sum(dislikes), 0) into count
    from article_author
    where user_id = input_user_id;
    
        -- Add likes from forum_threads
    select coalesce(sum(dislikes), 0) into @tmp
    from forum_threads
    where user_id = input_user_id;
    set count = count + @tmp;
    
        -- Add likes from forum_posts
	select coalesce(sum(dislikes), 0) into @tmp
    from forum_posts
    where user_id = input_user_id;
	set count = count + @tmp;

    return count;
end $$
delimiter ;


-- PROCEDURES 

-- User management 
-- add user
DELIMITER $$

CREATE PROCEDURE add_user(
    IN p_username VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255), -- Consider hashing passwords before inserting
    IN p_role ENUM('admin', 'moderator', 'user')
)
BEGIN
    INSERT INTO users (username, email, password, role)
    VALUES (p_username, p_email, p_password, p_role);
END $$

DELIMITER ;

-- delete user smart guy told me that on delete cascade is not enough 

DELIMITER $$

CREATE PROCEDURE delete_user(IN user_id INT)
BEGIN
    -- Deleting related records from reacts (articles)
    DELETE FROM reacts WHERE user_id = user_id;

    -- Deleting related records from comments (articles)
    DELETE FROM comments WHERE user_id = user_id;

    -- Deleting related records from forum threads
    DELETE FROM forum_threads WHERE user_id = user_id;

    -- Deleting related records from forum posts
    DELETE FROM forum_posts WHERE user_id = user_id;

    -- Deleting related records from user badges
    DELETE FROM user_badges WHERE user_id = user_id;

    -- Deleting the user itself
    DELETE FROM users WHERE user_id = user_id;
    
END $$

DELIMITER ;

-- change roll 

DELIMITER $$

CREATE PROCEDURE change_user_role(IN p_user_id INT, IN p_new_role ENUM('normie', 'admin'))
BEGIN
    -- Update the user's role in the 'users' table
    UPDATE users
    SET role = p_new_role
    WHERE user_id = p_user_id;
END $$

DELIMITER ;

-- article management 
DELIMITER $$
-- base articel
CREATE PROCEDURE add_article(
    IN p_user_id INT, 
    IN p_title VARCHAR(255), 
    IN p_content TEXT, 
    IN p_article_type ENUM('band', 'album', 'concert', 'general')
)
BEGIN
    -- Insert base article into the articles table
    INSERT INTO articles (user_id, title, content, article_type)
    VALUES (p_user_id, p_title, p_content, p_article_type);
	UPDATE blast_beats SET points = points + 100 WHERE user_id = p_user_id;

END $$
DELIMITER ;

-- band article details

DELIMITER $$

CREATE PROCEDURE add_band_article(
    IN p_article_id INT,
    IN p_band_name VARCHAR(100),
    IN p_genre VARCHAR(50),
    IN p_formation_year YEAR
)
BEGIN
    -- Insert band-specific details into the band_articles table
    INSERT INTO band_articles (article_id, band_name, genre, formation_year)
    VALUES (p_article_id, p_band_name, p_genre, p_formation_year);
END $$

DELIMITER ;

DELIMITER $$

CREATE procedure add_album_article(
IN p_article_id INT,
IN p_band_name varchar(100),
in p_album_name varchar(100),
in p_genre varchar(100),
in p_release_year YEAR
)
Begin 
-- insert
insert into album_articles(article_id, band_name, album_name, genre, release_year)
values (p_article_id, p_band_name, p_album_name, p_genre, p_release_year);

end $$

Delimiter $$

CREATE PROCEDURE add_concert_article(
    IN p_article_id INT,
    IN p_concert_name VARCHAR(100),
    IN p_concert_date DATE,
    IN p_venue VARCHAR(100),
    IN p_city VARCHAR(50),
    IN p_country VARCHAR(50)
)
BEGIN
    -- Insert concert-specific details into the concert_articles table
    INSERT INTO concert_articles (article_id, concert_name, concert_date, venue, city, country)
    VALUES (p_article_id, p_concert_name, p_concert_date, p_venue, p_city, p_country);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE add_general_article(
    IN p_article_id INT,
    IN p_topic VARCHAR(100)
)
BEGIN
    -- Insert general article-specific details into the general_articles table
    INSERT INTO general_articles (article_id, topic)
    VALUES (p_article_id, p_topic);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE delete_article(
    IN p_article_id INT, 
    IN p_article_type ENUM('band', 'album', 'concert', 'general')
)
BEGIN
    -- First, delete from the subtype tables based on the article type
    IF p_article_type = 'band' THEN
        DELETE FROM band_articles WHERE article_id = p_article_id;
    ELSEIF p_article_type = 'album' THEN
        DELETE FROM album_articles WHERE article_id = p_article_id;
    ELSEIF p_article_type = 'concert' THEN
        DELETE FROM concert_articles WHERE article_id = p_article_id;
    ELSEIF p_article_type = 'general' THEN
        DELETE FROM general_articles WHERE article_id = p_article_id;
    END IF;

    -- Then, delete the article itself from the articles table
    DELETE FROM articles WHERE article_id = p_article_id;
    -- update user's bb_points
	UPDATE blast_beats SET points =GREATEST(0, points - 110) WHERE user_id = p_user_id;

END $$
DELIMITER ;

DELIMITER $$

-- Add a new thread
CREATE PROCEDURE add_thread(
    IN p_user_id INT,
    IN p_title VARCHAR(255),
    IN p_content TEXT
)
BEGIN
    INSERT INTO forum_threads (user_id, title, content)
    VALUES (p_user_id, p_title, p_content);
    -- update bb_points
	UPDATE blast_beats SET points = points + 30 WHERE user_id = p_user_id;

END $$
DELIMITER ;

DELIMITER $$
-- Delete a thread and its related posts
CREATE PROCEDURE delete_thread(
    IN p_thread_id INT
)
BEGIN
    DELETE FROM forum_threads WHERE thread_id = p_thread_id;
    -- update bb_points
    UPDATE blast_beats SET points = GREATEST(0, points - 40) WHERE user_id = p_user_id;
END $$

DELIMITER ;

DELIMITER $$
-- Add a new post to an existing thread
CREATE PROCEDURE add_post(
    IN p_user_id INT,
    IN p_thread_id INT,
    IN p_content TEXT
)
BEGIN
    INSERT INTO forum_posts (user_id, thread_id, content)
    VALUES (p_user_id, p_thread_id, p_content);
    -- UPDATE bb_points
    UPDATE blast_beats SET points = points + 25 WHERE user_id = p_user_id;
END $$

DELIMITER ;

DELIMITER $$

-- Delete a post from a thread
CREATE PROCEDURE delete_post(
    IN p_post_id INT
)
BEGIN
    DELETE FROM forum_posts WHERE post_id = p_post_id;
    
    UPDATE blast_beats SET points = GREATEST(0, points - 30) WHERE user_id = p_user_id;
END $$

DELIMITER ;

-- reactions 

DELIMITER $$

CREATE PROCEDURE like_article(IN p_user_id INT, IN p_article_id INT)
BEGIN
    DECLARE current_reaction ENUM('like', 'dislike');

    -- Check if the user has already reacted
    SELECT type INTO current_reaction 
    FROM areactions 
    WHERE user_id = p_user_id AND article_id = p_article_id;

    -- If user already liked, remove the like
    IF current_reaction = 'like' THEN
        DELETE FROM areactions WHERE user_id = p_user_id AND article_id = p_article_id;
        UPDATE articles SET likes = likes - 1 WHERE article_id = p_article_id;
    
    -- If user disliked before, switch to like
    ELSEIF current_reaction = 'dislike' THEN
        UPDATE areactions SET type = 'like' WHERE user_id = p_user_id AND article_id = p_article_id;
        UPDATE articles SET dislikes = dislikes - 1, likes = likes + 1 WHERE article_id = p_article_id;

    -- If no reaction exists, add like
    ELSE
        INSERT INTO areactions (user_id, article_id, type) VALUES (p_user_id, p_article_id, 'like');
        UPDATE articles SET likes = likes + 1 WHERE article_id = p_article_id;
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE dislike_article(IN p_user_id INT, IN p_article_id INT)
BEGIN
    DECLARE current_reaction ENUM('like', 'dislike');

    -- Check if the user has already reacted
    SELECT type INTO current_reaction 
    FROM areactions 
    WHERE user_id = p_user_id AND article_id = p_article_id;

    -- If user already disliked, remove the dislike
    IF current_reaction = 'dislike' THEN
        DELETE FROM areactions WHERE user_id = p_user_id AND article_id = p_article_id;
        UPDATE articles SET dislikes = dislikes - 1 WHERE article_id = p_article_id;
    
    -- If user liked before, switch to dislike
    ELSEIF current_reaction = 'like' THEN
        UPDATE areactions SET type = 'dislike' WHERE user_id = p_user_id AND article_id = p_article_id;
        UPDATE articles SET likes = likes - 1, dislikes = dislikes + 1 WHERE article_id = p_article_id;

    -- If no reaction exists, add dislike
    ELSE
        INSERT INTO areactions (user_id, article_id, type) VALUES (p_user_id, p_article_id, 'dislike');
        UPDATE articles SET dislikes = dislikes + 1 WHERE article_id = p_article_id;
    END IF;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE like_thread(IN p_user_id INT, IN p_thread_id INT)
BEGIN
    DECLARE current_reaction ENUM('like', 'dislike');

    -- Check if the user has already reacted
    SELECT type INTO current_reaction 
    FROM treactions 
    WHERE user_id = p_user_id AND thread_id = p_thread_id;

    -- If user already liked, remove the like
    IF current_reaction = 'like' THEN
        DELETE FROM treactions WHERE user_id = p_user_id AND thread_id = p_thread_id;
        UPDATE forum_threads SET likes = likes - 1 WHERE thread_id = p_thread_id;
    
    -- If user disliked before, switch to like
    ELSEIF current_reaction = 'dislike' THEN
        UPDATE treactions SET type = 'like' WHERE user_id = p_user_id AND thread_id = p_thread_id;
        UPDATE forum_threads SET dislikes = dislikes - 1, likes = likes + 1 WHERE thread_id = p_thread_id;

    -- If no reaction exists, add like
    ELSE
        INSERT INTO treactions (user_id, thread_id, type) VALUES (p_user_id, p_thread_id, 'like');
        UPDATE forum_threads SET likes = likes + 1 WHERE thread_id = p_thread_id;
    END IF;
END $$

DELIMITER ;


DElIMITER $$

create procedure dislike_thread(IN p_user_id int, IN p_thread_id INT) 
	begin	
    declare reaction enum("like", "dislike");
    -- chack current reaction
    select type into reaction
    from treactions
    where user_id = p_user_id AND thread_id = p_thread_id;
    
    -- scenario disliked
    if reaction = "dislike" THEN
    delete from treactions where user_id = p_user_id AND thread_id = p_thread_id;
    update forum_threads set dislikes = dislikes - 1 where thread_id = p_thread_id;

	 -- liked
    elseif reaction = "like" THEN
    update treactions set type = "dislike" where user_id = p_user_id AND thread_id = p_thread_id;
    update forum_forum threads set dislikes = dislikes + 1, likes = likes -1 where thread_id = p_thread_id;
    
    -- regular scenario
    
    else
    insert into treactions(user_id, thread_id, type) values(p_user_id, p_thread_id, 'dislike');
    update forum_threads set dislikes = dislikes +1 where thread_id = p_thread_id;
    END if;
    END $$
    
    DELIMITER $$

CREATE PROCEDURE like_post(IN p_user_id INT, IN p_post_id INT)
BEGIN
    DECLARE current_reaction ENUM('like', 'dislike');

    -- Check if the user has already reacted
    SELECT type INTO current_reaction 
    FROM preactions 
    WHERE user_id = p_user_id AND post_id = p_post_id;

    -- If user already liked, remove the like
    IF current_reaction = 'like' THEN
        DELETE FROM preactions WHERE user_id = p_user_id AND post_id = p_post_id;
        UPDATE forum_posts SET likes = likes - 1 WHERE post_id = p_post_id;
    
    -- If user disliked before, switch to like
    ELSEIF current_reaction = 'dislike' THEN
        UPDATE preactions SET type = 'like' WHERE user_id = p_user_id AND post_id = p_post_id;
        UPDATE forum_posts SET dislikes = dislikes - 1, likes = likes + 1 WHERE post_id = p_post_id;

    -- If no reaction exists, add like
    ELSE
        INSERT INTO preactions (user_id, post_id, type) VALUES (p_user_id, p_post_id, 'like');
        UPDATE forum_posts SET likes = likes + 1 WHERE post_id = p_post_id;
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE dislike_post(IN p_user_id INT, IN p_post_id INT)
BEGIN
    DECLARE current_reaction ENUM('like', 'dislike');

    -- Check if the user has already reacted
    SELECT type INTO current_reaction 
    FROM preactions 
    WHERE user_id = p_user_id AND post_id = p_post_id;

    -- If user already disliked, remove the dislike
    IF current_reaction = 'dislike' THEN
        DELETE FROM preactions WHERE user_id = p_user_id AND post_id = p_post_id;
        UPDATE forum_posts SET dislikes = dislikes - 1 WHERE post_id = p_post_id;
    
    -- If user liked before, switch to dislike
    ELSEIF current_reaction = 'like' THEN
        UPDATE preactions SET type = 'dislike' WHERE user_id = p_user_id AND post_id = p_post_id;
        UPDATE forum_posts SET likes = likes - 1, dislikes = dislikes + 1 WHERE post_id = p_post_id;

    -- If no reaction exists, add dislike
    ELSE
        INSERT INTO preactions (user_id, post_id, type) VALUES (p_user_id, p_post_id, 'dislike');
        UPDATE forum_posts SET dislikes = dislikes + 1 WHERE post_id = p_post_id;
    END IF;
END $$

DELIMITER ;

-- add/delete comment
DELIMITER $$

CREATE PROCEDURE add_comment(IN p_user_id INT, IN p_article_id INT, IN p_content TEXT)
BEGIN
    INSERT INTO comments (user_id, article_id, content, created_at)
    VALUES (p_user_id, p_article_id, p_content, NOW());
    
    UPDATE blast_beats SET points = points + 20 WHERE user_id = p_user_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE delete_comment(IN p_comment_id INT)
BEGIN
    DELETE FROM comments WHERE comment_id = p_comment_id;
    
    UPDATE blast_beats SET points = GREATEST(0, points - 30) WHERE user_id = p_user_id;
END $$

DELIMITER ;

-- badges
DELIMITER $$

CREATE PROCEDURE award_badge(IN p_user_id INT, IN p_badge_id INT)
BEGIN
    DECLARE v_bb_amount INT;

    -- Get the blast_beats value of the badge
    SELECT bb_amount INTO v_bb_amount FROM badges WHERE badge_id = p_badge_id;

    -- Check if the user already has the badge
    IF NOT EXISTS (SELECT 1 FROM user_badges WHERE user_id = p_user_id AND badge_id = p_badge_id) THEN
        -- Assign the badge to the user
        INSERT INTO user_badges (user_id, badge_id, earned_at) 
        VALUES (p_user_id, p_badge_id, NOW());

        -- Update the user's blast_beats points
        UPDATE blast_beats SET points = points + v_bb_amount WHERE user_id = p_user_id;
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE remove_badge(IN p_user_id INT, IN p_badge_id INT)
BEGIN
    DECLARE v_bb_amount INT;

    -- Get the blast_beats value of the badge
    SELECT bb_amount INTO v_bb_amount FROM badges WHERE badge_id = p_badge_id;

    -- Remove the badge
    DELETE FROM user_badges WHERE user_id = p_user_id AND badge_id = p_badge_id;

    -- Decrease the user's blast_beats points
    UPDATE blast_beats SET points = points - v_bb_amount WHERE user_id = p_user_id AND points >= v_bb_amount;
END $$

DELIMITER ;














    