DROP TABLE lastActivity;
DROP TABLE reportcount;
DROP TABLE counts;
DROP TABLE hashtag_post;
DROP TABLE hashtag;
DROP TABLE reply;
DROP TABLE board;
DROP TABLE word;
DROP TABLE users;


CREATE TABLE users (
  user_key int PRIMARY KEY AUTO_INCREMENT,
  user_id varchar(20) NOT NULL,
  user_name varchar(50) NOT NULL,
  user_email varchar(50) NOT NULL,
  user_password varchar(20) NOT NULL,
  user_ageRange varchar(20),
  user_profilePhoto varchar(250),
  user_status CHAR(1)
);

CREATE TABLE word (
  word_key int PRIMARY KEY AUTO_INCREMENT,
  user_key int NOT NULL,
  word_title varchar(50) NOT NULL,
  word_content varchar(250) NOT NULL,
  word_exSentence varchar(250) NOT NULL,
  word_date timestamp NOT NULL,
  word_gif varchar(250)
);

CREATE TABLE board (
  board_key int PRIMARY KEY AUTO_INCREMENT,
  user_key int NOT NULL,
  board_title varchar(100) NOT NULL,
  board_content varchar(250) NOT NULL,
  board_gif varchar(250),
  board_date timestamp NOT NULL,
  BOARD_READCOUNT int default 0
);

CREATE TABLE reply (
  reply_key int PRIMARY KEY AUTO_INCREMENT,
  user_key int NOT NULL,
  board_key int NOT NULL,
  reply_content varchar(250) NOT NULL,
  reply_date timestamp NOT NULL,
  reply_re_ref int,
  reply_re_lev int,
  REPLY_RE_SEQ int
);

CREATE TABLE hashtag (
  hash_key int PRIMARY KEY AUTO_INCREMENT,
  hash_title varchar(100)
);

CREATE TABLE hashtag_post (
  hash_key int NOT NULL,
  word_key int
);

CREATE TABLE counts (
  user_key int,
  count_type varchar(10) NOT NULL,
  post_type varchar(10) NOT NULL,
  count_date timestamp NOT NULL,
  board_key int,
  word_key int
);

CREATE TABLE reportcount (
  user_key int,
  report_date timestamp,
  report_reason varchar(250),
  board_key int,
  word_key int
);

CREATE TABLE lastActivity (
  user_key int,
  lastAct timestamp NOT NULL
);

ALTER TABLE word ADD FOREIGN KEY (user_key) REFERENCES users (user_key);

ALTER TABLE board ADD FOREIGN KEY (user_key) REFERENCES users (user_key);

ALTER TABLE reply ADD FOREIGN KEY (user_key) REFERENCES users (user_key);

ALTER TABLE reply ADD FOREIGN KEY (board_key) REFERENCES board (board_key) on delete cascade;

ALTER TABLE hashtag_post ADD FOREIGN KEY (hash_key) REFERENCES hashtag (hash_key);

ALTER TABLE hashtag_post ADD FOREIGN KEY (word_key) REFERENCES word (word_key);

ALTER TABLE counts ADD FOREIGN KEY (user_key) REFERENCES users (user_key);

ALTER TABLE counts ADD FOREIGN KEY (board_key) REFERENCES board (board_key) on delete cascade;

ALTER TABLE counts ADD FOREIGN KEY (word_key) REFERENCES word (word_key);

ALTER TABLE reportcount ADD FOREIGN KEY (user_key) REFERENCES users (user_key);

ALTER TABLE reportcount ADD FOREIGN KEY (board_key) REFERENCES board (board_key) on delete cascade;

ALTER TABLE reportcount ADD FOREIGN KEY (word_key) REFERENCES word (word_key);

ALTER TABLE lastActivity ADD FOREIGN KEY (user_key) REFERENCES users (user_key);

-- CREATE OR REPLACE VIEW WORDLIST AS
-- SELECT W.WORD_KEY, W.USER_KEY, W.WORD_TITLE, W.WORD_CONTENT, W.WORD_EXSENTENCE, W.WORD_DATE, W.WORD_GIF,
-- CL.LIKECOUNT, CH.HATECOUNT
-- FROM word W
-- JOIN (SELECT COUNT(*) AS LIKECOUNT, WORD_KEY FROM count WHERE POST_TYPE = 'word' AND COUNT_TYPE = 'like' GROUP BY WORD_KEY) CL
-- ON CL.WORD_KEY = W.WORD_KEY
-- JOIN (SELECT COUNT(*) AS HATECOUNT, WORD_KEY FROM count WHERE POST_TYPE = 'word' AND COUNT_TYPE = 'hate' GROUP BY WORD_KEY) CH
-- ON CH.WORD_KEY = W.WORD_KEY;

CREATE OR REPLACE VIEW likecount AS
SELECT count(*) AS likecount, word_key FROM counts WHERE post_type = 'word' AND count_type='like' GROUP BY word_key;


CREATE OR REPLACE VIEW hatecount AS
SELECT count(*) AS hatecount, word_key FROM counts WHERE post_type = 'word' AND count_type='hate' GROUP BY word_key;

CREATE OR REPLACE VIEW wordlist AS
SELECT word.*, likecount.likecount AS likecount, hatecount.hatecount AS hatecount
FROM word LEFT JOIN likecount ON word.word_key = likecount.word_key
        LEFT JOIN hatecount ON word.word_key = hatecount.word_key
UNION ALL
SELECT word.*, likecount.likecount AS likecount, hatecount.hatecount AS hatecount
FROM likecount LEFT JOIN word ON word.word_key = likecount.word_key
        LEFT JOIN hatecount ON likecount.word_key = hatecount.word_key
WHERE word.word_key IS NULL
UNION ALL
SELECT word.*, likecount.likecount AS likecount, hatecount.hatecount AS hatecount
FROM hatecount LEFT JOIN word ON word.word_key = hatecount.word_key
        LEFT JOIN likecount ON likecount.word_key = hatecount.word_key
WHERE word.word_key IS NULL AND likecount.word_key IS NULL;