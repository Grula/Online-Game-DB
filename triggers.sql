
AFTER INSERT CHARACTER
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`character_AFTER_INSERT` AFTER INSERT ON `character`
FOR EACH ROW
BEGIN
	insert into character_has_skill
	set character_id = new.id,
	skill_id = ( Select id from skill Where name like 'Spell1' );
END

AFTER INSERT OPONENT
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`oponent_AFTER_INSERT` AFTER INSERT ON `oponent` 
FOR EACH ROW 
BEGIN 
	insert into oponent_has_skill 
	set oponent_id = new.id, 
	skill_id = ( Select id from skill Where name like 'Spell1' ); 
END