USE `game` ;

DELETE FROM character_has_skill;
DELETE FROM oponent_has_skill;

DELETE FROM skill;
DELETE FROM `game`.`character`;
DELETE FROM oponent;

DELETE FROM level;
DELETE FROM object;

INSERT INTO skill VALUES
(100,'crimson tempest'),
(201,'divine hymn'),
(301,'charge'),
(302,'execute'),
(101,'raise dead'),
(1501,'Pumpkin Pie');

INSERT INTO `game`.`character` VALUES
(1,'Wendjenna'),
(2,'Tubiella'),
(3,'Bathrner Bagna'),
(4,'Tuwave'),
(5,'Cherurner'),
(6,'Turnerhugia');

INSERT INTO oponent VALUES
(1,'Fornvan'),
(2,'Survans'),
(3,'Walkerpus'),
(4,'Jonevaca'),
(5,'Betraychez'),
(6,'Harrisonula');

INSERT INTO level VALUES
(null),(null),(null),(null),(null),(null);

INSERT INTO object VALUES
(1,'Wall',null),
(2,'Grass',null),
(3,'Roof',null),
(4,'Water',null),
(5,'Bush',null),
(6,'Tree',null);