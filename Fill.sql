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
(null,'Wendjenna'),
(null,'Tubiella'),
(null,'Bathrner Bagna'),
(null,'Tuwave'),
(null,'Cherurner'),
(null,'Turnerhugia');

INSERT INTO oponent VALUES
(null,'Fornvan'),
(null,'Survans'),
(null,'Walkerpus'),
(null,'Jonevaca'),
(null,'Betraychez'),
(null,'Harrisonula');

INSERT INTO level VALUES
(1),(2),(3),(4),(5),(6);

INSERT INTO object VALUES
(1,'Wall',null),
(2,'Grass',null),
(3,'Roof',null),
(4,'Water',null),
(5,'Bush',null),
(6,'Tree',null);

INSERT INTO character_has_skill VALUES
(3,201),
(3,301),
(3,302);