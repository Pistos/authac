CREATE TABLE users (
    id SERIAL,
    username VARCHAR( 32 ) NOT NULL UNIQUE,
    realname VARCHAR( 64 ),
    encrypted_password VARCHAR( 128 ) NOT NULL,
    PRIMARY KEY( id )
);

CREATE TABLE flags (
    id SERIAL,
    name VARCHAR( 64 ) NOT NULL UNIQUE,
    description VARCHAR( 256 ),
    PRIMARY KEY( id )
);

CREATE TABLE user_groups (
    id SERIAL,
    name VARCHAR( 64 ) NOT NULL UNIQUE,
    description VARCHAR( 256 ),
    PRIMARY KEY( id )
);

CREATE TABLE user_groups_flags (
    user_group_id INTEGER NOT NULL REFERENCES user_groups( id ),
    flag_id INTEGER NOT NULL REFERENCES flags( id ),
    PRIMARY KEY( user_group_id, flag_id )
);

CREATE TABLE users_groups (
    user_id INTEGER NOT NULL REFERENCES users( id ),
    user_group_id INTEGER NOT NULL REFERENCES user_groups( id ),
    PRIMARY KEY( user_id, user_group_id )
);
