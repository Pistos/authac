INSERT INTO users (
    username, encrypted_password
) VALUES (
    'Pistos', 'd033e22ae348aeb5660fc2140aec35850c4da997' -- 'admin'
);
INSERT INTO users (
    username, encrypted_password
) VALUES (
    'manveru', '8843d7f92416211de9ebb963ff4ce28125932878' -- 'foobar'
);

INSERT INTO flags (
    name, description
) VALUES (
    'membership', 'Site membership (non-guest).'
);
INSERT INTO flags (
    name, description
) VALUES (
    'moderate', 'Ability to moderate things.'
);
INSERT INTO flags (
    name, description
) VALUES (
    'upload', 'Ability to upload files.'
);
INSERT INTO flags (
    name, description
) VALUES (
    'approve-user', 'Ability to approve new users.'
);
INSERT INTO flags (
    name, description
) VALUES (
    'ban-user', 'Ability to ban users.'
);
INSERT INTO flags (
    name, description
) VALUES (
    'see-admin', 'Access to administration area.'
);
INSERT INTO flags (
    name, description
) VALUES (
    'submit-article', 'Ability to submit articles.'
);

INSERT INTO user_groups (
    name, description
) VALUES (
    'admins', 'Administrators'
);
INSERT INTO user_groups (
    name, description
) VALUES (
    'moderators', 'Moderators'
);
INSERT INTO user_groups (
    name, description
) VALUES (
    'members', 'Regular Members'
);
INSERT INTO user_groups (
    name, description
) VALUES (
    'guests', 'Guests'
);

INSERT INTO user_groups_flags (
    user_group_id,
    flag_id
) SELECT
    ( SELECT id FROM user_groups WHERE name = 'admins' ),
    id
FROM
    flags
;

INSERT INTO user_groups_flags (
    user_group_id, flag_id
) VALUES (
    ( SELECT id FROM user_groups WHERE name = 'moderators' ),
    ( SELECT id FROM flags WHERE name = 'moderate' )
);
INSERT INTO user_groups_flags (
    user_group_id, flag_id
) VALUES (
    ( SELECT id FROM user_groups WHERE name = 'moderators' ),
    ( SELECT id FROM flags WHERE name = 'upload' )
);
INSERT INTO user_groups_flags (
    user_group_id, flag_id
) VALUES (
    ( SELECT id FROM user_groups WHERE name = 'moderators' ),
    ( SELECT id FROM flags WHERE name = 'submit-article' )
);
INSERT INTO user_groups_flags (
    user_group_id, flag_id
) VALUES (
    ( SELECT id FROM user_groups WHERE name = 'moderators' ),
    ( SELECT id FROM flags WHERE name = 'membership' )
);

INSERT INTO user_groups_flags (
    user_group_id, flag_id
) VALUES (
    ( SELECT id FROM user_groups WHERE name = 'members' ),
    ( SELECT id FROM flags WHERE name = 'submit-article' )
);
INSERT INTO user_groups_flags (
    user_group_id, flag_id
) VALUES (
    ( SELECT id FROM user_groups WHERE name = 'members' ),
    ( SELECT id FROM flags WHERE name = 'membership' )
);

INSERT INTO users_groups (
    user_id, user_group_id
) VALUES (
    ( SELECT id FROM users WHERE username = 'Pistos' ),
    ( SELECT id FROM user_groups WHERE name = 'admins' )
);
INSERT INTO users_groups (
    user_id, user_group_id
) VALUES (
    ( SELECT id FROM users WHERE username = 'manveru' ),
    ( SELECT id FROM user_groups WHERE name = 'moderators' )
);
