USE `game` ;

DELETE FROM skill;
DELETE FROM character;
DELETE FROM opponent;

DELETE FROM level;
DELETE FROM object;

INSERT INTO skill VALUES
(00100,'crimson tempest'),
(00201,'divine hymn'),
(00301,'charge'),
(00302,'execute'),
(00101,'raise dead'),
(01501,'Pumpkin Pie');

INSERT INTO character VALUES
(01,'Wendjenna'),
(02,'Tubiella'),
(03,'Bathrner Bagna'),
(4,'Tuwave'),
(5,'Cherurner'),
(6,'Turnerhugia');

INSERT INTO opponent VALUES
(1,'Fornvan'),
(2,'Survans'),
(3,'Walkerpus'),
(4,'Jonevaca'),
(5,'Betraychez'),
(6,'Harrisonula');

INSERT INTO level VALUES
(1), (2), (3), (4), (5), (6);

INSERT INTO object VALUES
(1,'Wall'),
(2,'Grass'),
(3,'Roof'),
(4,'Water'),
(5,'Bush'),
(6,'Tree');