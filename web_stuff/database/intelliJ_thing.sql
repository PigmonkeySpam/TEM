Show tables;
SHOW DATABASES;




# DROP TABLE tem_creditor_item_player_total;
DROP TABLE tem_trading_transaction;
DROP TABLE tem_trading_item;
DROP TABLE tem_player;

DROP TABLE tem_trading_item_credit_value;

# SELECT *
# FROM tem_player;
# WHERE playername = :playername;



CREATE TABLE tem_player
(
    id                    int AUTO_INCREMENT
        PRIMARY KEY,
    playername            varchar(255)                             NOT NULL,
    password_hash         varchar(255) DEFAULT 'password init lol' NOT NULL,
    credit_balance        int          DEFAULT 0                   NOT NULL,
    brownie_point_balance int          DEFAULT 0                   NOT NULL,
    test                  tinyint(1)   DEFAULT 0                   NOT NULL,
    CONSTRAINT tem_playername_unq
        UNIQUE (playername)
);

CREATE TABLE tem_trading_item
(
    id           int AUTO_INCREMENT
        PRIMARY KEY,
    identifier   varchar(100)                     NOT NULL,
    pretty_name  varchar(50)                      NULL,
    created_at   datetime   DEFAULT CURRENT_TIME  NOT NULL,
    created_by_id int                             NOT NULL,
    test         tinyint(1) DEFAULT 0             NOT NULL,
    CONSTRAINT tem_trading_item_identifier_unq
        UNIQUE (identifier),
    CONSTRAINT tem_trading_item_created_by_id_tem_player_id_fk
        FOREIGN KEY (created_by_id) REFERENCES tem_player (id)
);
INSERT INTO tem_trading_item (identifier)
    VALUE ('hi')
ON DUPLICATE KEY UPDATE identifier = identifier;

SELECT * FROM tem_trading_item;


CREATE TABLE tem_trading_item_credit_value
(
    id                      int AUTO_INCREMENT,
    trading_item_id         int                   NOT NULL,
    credit_value            int                   NULL,
    brownie_points_value    int                   NULL,
    start_time              DATETIME              NOT NULL,
    end_time                DATETIME              NULL,
    test                    BOOLEAN   DEFAULT 0   NOT NULL,
    CONSTRAINT tem_trading_item_credit_value_pk
        PRIMARY KEY (id),
    CONSTRAINT tem_trading_item_credit_value_tem_trading_item_id_fk
        FOREIGN KEY (trading_item_id) REFERENCES tem_trading_item (id)
);


CREATE TABLE tem_trading_transaction
(
    id                     int AUTO_INCREMENT
        PRIMARY KEY,
    timestamp              timestamp DEFAULT CURRENT_TIMESTAMP() NULL,
    credit_or_debit        varchar(15)                           NOT NULL,
    player_id              int                                   NULL,

    raw                    text                                  NULL,
    note                   varchar(256)                          NULL,
    test                   boolean   DEFAULT FALSE               NOT NULL,
    CONSTRAINT tem_trading_transaction_tem_player_id_fk
        FOREIGN KEY (player_id) REFERENCES tem_player (id),
    CHECK ( credit_or_debit = 'CREDIT' OR credit_or_debit = 'DEBIT' )
);

CREATE TABLE tem_trading_transaction_entry
(
    id                                  int       AUTO_INCREMENT
        PRIMARY KEY,
    parent_transaction_id               int                                   NOT NULL,
    tem_trading_item_credit_value_id    int                                   NOT NULL,
    creditor_item_quantity              int                                   NOT NULL,
    test                                boolean   DEFAULT FALSE               NOT NULL,
    CONSTRAINT tem_trading_transaction_entry_tem_trading_transaction_id_fk
        FOREIGN KEY (parent_transaction_id) REFERENCES tem_trading_transaction (id),
    CONSTRAINT tem_trading_transaction_entry_tem_trading_item_id_fk
        FOREIGN KEY (tem_trading_item_credit_value_id) REFERENCES tem_trading_item_credit_value (id)
);
INSERT INTO tem_player (playername, test) VALUE ('PigmonkeySpamTest', 1);



SELECT date_sub('2020-09-09', INTERVAL 1 DAY);
INSERT INTO tem_trading_item_credit_value (trading_item_id, start_time)
VALUE (:trading_item_id, DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY));

SELECT *
FROM tem_trading_item tti
JOIN tem_trading_item_credit_value tticv ON tticv.trading_item_id = tti.id
WHERE identifier = :identifier
    AND (CURRENT_TIMESTAMP() BETWEEN start_time AND end_time
        OR end_time IS NULL );



-- * Calculated fields are bad practice ...but my query was really cool
-- CREATE TABLE tem_creditor_item_player_total
-- (
--     player_id                 int                                    NOT NULL,
--     creditor_item_id          int                                    NOT NULL,
--     creditor_item_total_count int        DEFAULT 0                   NOT NULL,
--     last_updated              datetime   DEFAULT CURRENT_TIMESTAMP() NOT NULL ON UPDATE CURRENT_TIMESTAMP(),
--     test                      tinyint(1) DEFAULT 0                   NOT NULL,
--     CONSTRAINT tem_creditor_item_player_composite_pk
--         PRIMARY KEY (player_id, creditor_item_id),
--     CONSTRAINT tem_creditor_item_player_total_tem_creditor_item_id_fk
--         FOREIGN KEY (creditor_item_id) REFERENCES tem_creditor_item (id),
--     CONSTRAINT tem_creditor_item_player_total_tem_player_id_fk
--         FOREIGN KEY (player_id) REFERENCES tem_player (id)
-- );
-- SELECT * FROM tem_creditor_item_player_total;
-- INSERT INTO tem_creditor_item_player_total (player_id, creditor_item_id, creditor_item_total_count)
-- VALUE (1,1, 4)
-- ON DUPLICATE KEY UPDATE creditor_item_total_count = creditor_item_total_count + VALUE(creditor_item_total_count);
