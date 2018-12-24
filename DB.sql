-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema game
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema game
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `game` DEFAULT CHARACTER SET utf8 ;
USE `game` ;

-- -----------------------------------------------------
-- Table `game`.`player`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`player` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(15) NOT NULL,
  `password` VARCHAR(40) NOT NULL,
  `nickname` VARCHAR(45) NOT NULL,
  `email` VARCHAR(120) NOT NULL,
  `active_logins` INT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `user_name_UNIQUE` (`user_name` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`level`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`level` (
  `id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`map` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `time_created` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`game_instance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`game_instance` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `player_id` INT NOT NULL,
  `level_id` INT NOT NULL,
  `map_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_game_instance_player_idx` (`player_id` ASC),
  INDEX `fk_game_instance_level1_idx` (`level_id` ASC),
  INDEX `fk_game_instance_map1_idx` (`map_id` ASC),
  CONSTRAINT `fk_game_instance_player`
    FOREIGN KEY (`player_id`)
    REFERENCES `game`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_instance_level1`
    FOREIGN KEY (`level_id`)
    REFERENCES `game`.`level` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_instance_map1`
    FOREIGN KEY (`map_id`)
    REFERENCES `game`.`map` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`character`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`character` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`character_used`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`character_used` (
  `character_id` INT NOT NULL,
  `game_instance_id` INT NOT NULL,
  PRIMARY KEY (`character_id`, `game_instance_id`),
  INDEX `fk_character_has_game_instance_game_instance1_idx` (`game_instance_id` ASC),
  INDEX `fk_character_has_game_instance_character1_idx` (`character_id` ASC),
  CONSTRAINT `fk_character_has_game_instance_character1`
    FOREIGN KEY (`character_id`)
    REFERENCES `game`.`character` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_character_has_game_instance_game_instance1`
    FOREIGN KEY (`game_instance_id`)
    REFERENCES `game`.`game_instance` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`skill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`skill` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`character_has_skill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`character_has_skill` (
  `character_id` INT NOT NULL,
  `skill_id` INT NOT NULL,
  PRIMARY KEY (`character_id`, `skill_id`),
  INDEX `fk_character_has_skill_skill1_idx` (`skill_id` ASC),
  INDEX `fk_character_has_skill_character1_idx` (`character_id` ASC),
  CONSTRAINT `fk_character_has_skill_character1`
    FOREIGN KEY (`character_id`)
    REFERENCES `game`.`character` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_character_has_skill_skill1`
    FOREIGN KEY (`skill_id`)
    REFERENCES `game`.`skill` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`object`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`object` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `object_image` BLOB NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`map_has_object`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`map_has_object` (
  `map_id` INT NOT NULL,
  `object_id` INT NOT NULL,
  `position` TEXT NULL,
  PRIMARY KEY (`map_id`, `object_id`),
  INDEX `fk_map_has_object_object1_idx` (`object_id` ASC),
  INDEX `fk_map_has_object_map1_idx` (`map_id` ASC),
  CONSTRAINT `fk_map_has_object_map1`
    FOREIGN KEY (`map_id`)
    REFERENCES `game`.`map` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_map_has_object_object1`
    FOREIGN KEY (`object_id`)
    REFERENCES `game`.`object` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`oponent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`oponent` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`level_has_oponent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`level_has_oponent` (
  `level_id` INT NOT NULL,
  `oponent_id` INT NOT NULL,
  `oponent_no` INT NULL,
  `oponent_order` INT NULL DEFAULT 0,
  PRIMARY KEY (`level_id`, `oponent_id`),
  INDEX `fk_level_has_oponent_oponent1_idx` (`oponent_id` ASC),
  INDEX `fk_level_has_oponent_level1_idx` (`level_id` ASC),
  CONSTRAINT `fk_level_has_oponent_level1`
    FOREIGN KEY (`level_id`)
    REFERENCES `game`.`level` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_level_has_oponent_oponent1`
    FOREIGN KEY (`oponent_id`)
    REFERENCES `game`.`oponent` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`oponent_has_skill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`oponent_has_skill` (
  `oponent_id` INT NOT NULL,
  `skill_id` INT NOT NULL,
  PRIMARY KEY (`oponent_id`, `skill_id`),
  INDEX `fk_oponent_has_skill_skill1_idx` (`skill_id` ASC),
  INDEX `fk_oponent_has_skill_oponent1_idx` (`oponent_id` ASC),
  CONSTRAINT `fk_oponent_has_skill_oponent1`
    FOREIGN KEY (`oponent_id`)
    REFERENCES `game`.`oponent` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_oponent_has_skill_skill1`
    FOREIGN KEY (`skill_id`)
    REFERENCES `game`.`skill` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`login_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`login_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `player_id` INT NOT NULL,
  `login_time` DATETIME NULL,
  `logout_time` DATETIME NULL,
  `login_data` TEXT NULL,
  PRIMARY KEY (`id`, `player_id`),
  INDEX `fk_login_history_player1_idx` (`player_id` ASC),
  CONSTRAINT `fk_login_history_player1`
    FOREIGN KEY (`player_id`)
    REFERENCES `game`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`player_friends`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`player_friends` (
  `player_id` INT NOT NULL,
  `player_id1` INT NOT NULL,
  PRIMARY KEY (`player_id`, `player_id1`),
  INDEX `fk_player_has_player_player2_idx` (`player_id1` ASC),
  INDEX `fk_player_has_player_player1_idx` (`player_id` ASC),
  CONSTRAINT `fk_player_has_player_player1`
    FOREIGN KEY (`player_id`)
    REFERENCES `game`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_has_player_player2`
    FOREIGN KEY (`player_id1`)
    REFERENCES `game`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`highscore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`highscore` (
  `player_id` INT NOT NULL,
  `map_id` INT NOT NULL,
  `score` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`player_id`, `map_id`),
  INDEX `fk_player_has_map_map1_idx` (`map_id` ASC),
  INDEX `fk_player_has_map_player1_idx` (`player_id` ASC),
  CONSTRAINT `fk_player_has_map_player1`
    FOREIGN KEY (`player_id`)
    REFERENCES `game`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_has_map_map1`
    FOREIGN KEY (`map_id`)
    REFERENCES `game`.`map` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `game`;

DELIMITER $$
USE `game`$$
CREATE DEFINER = CURRENT_USER TRIGGER `game`.`character_AFTER_INSERT` AFTER INSERT ON `character` FOR EACH ROW
BEGIN
	insert into character_has_skill
    set character_id = new.id,
		skill_id = ( Select id from skill Where name like 'Pumpkin Pie' );
END$$

USE `game`$$
CREATE DEFINER = CURRENT_USER TRIGGER `game`.`oponent_AFTER_INSERT` AFTER INSERT ON `oponent` FOR EACH ROW
BEGIN
insert into oponent_has_skill
    set oponent_id = new.id,
		skill_id = ( Select id from skill Where name like 'Pumpkin Pie' );
END$$

USE `game`$$
CREATE DEFINER = CURRENT_USER TRIGGER `game`.`login_history_AFTER_INSERT` AFTER INSERT ON `login_history` FOR EACH ROW
BEGIN
	Update player
	set active_logins = active_logins + 1
    where new.player_id = id;
END$$

USE `game`$$
CREATE DEFINER = CURRENT_USER TRIGGER `game`.`player_friends_BEFORE_INSERT` BEFORE INSERT ON `player_friends` FOR EACH ROW
BEGIN
	if exists( Select * from player_friends Where player_id = new.player_id1 and player_id1 = new.player_id ) then
		signal sqlstate '45000' set message_text = 'Already friends with player';
    end if;
END$$


DELIMITER ;
