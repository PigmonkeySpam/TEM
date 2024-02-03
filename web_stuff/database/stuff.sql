USE assdb;
CREATE TABLE TEM_mob_grinder_control (
    id                  INT         NOT NULL    PRIMARY KEY AUTO_INCREMENT,
    mob_name            VARCHAR(50) NOT NULL,
    automatic_control   BOOLEAN     NOT NULL    DEFAULT 1,
    turn_off_time       BIGINT      NOT NULL    DEFAULT 0
);

DROP TABLE TEM_mob_grinder_control;


INSERT INTO TEM_mob_grinder_control (mob_name) 
VALUES 
    ("spider"), 
    ("zombie"),
    ("creeper"),
    ("blizz"),
    ("blitz"),
    ("basalz"),
    ("blaze"),
    ("witch"),
    ("slime");

SELECT *
FROM TEM_mob_grinder_control;

SELECT UNIX_TIMESTAMP();