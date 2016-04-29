CREATE DATABASE BucketList;

GRANT ALL PRIVILEGES ON BucketList.* TO 'app'@'localhost' identified by 'app';

CREATE TABLE `BucketList`.`tbl_user` (
  `user_id` BIGINT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NULL,
  `user_username` VARCHAR(45) NULL,
  `user_password` VARCHAR(160) NULL,
  PRIMARY KEY (`user_id`));

use BucketList;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createUser`(
    IN p_name VARCHAR(20),
    IN p_username VARCHAR(20),
    IN p_password VARCHAR(160)
)
BEGIN
    if ( select exists (select 1 from tbl_user where user_username = p_username) ) THEN

        select 'Username Exists !!';

    ELSE

        insert into tbl_user
        (
            user_name,
            user_username,
            user_password
        )
        values
        (
            p_name,
            p_username,
            p_password
        );

    END IF;
END$$
DELIMITER ;


use BucketList;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validateLogin`(
IN p_username VARCHAR(20)
)
BEGIN
    select * from tbl_user where user_username = p_username;
END$$
DELIMITER ;

use BucketList;
CREATE TABLE `tbl_wish` (
  `wish_id` int(11) NOT NULL AUTO_INCREMENT,
  `wish_title` varchar(45) DEFAULT NULL,
  `wish_description` varchar(5000) DEFAULT NULL,
  `wish_user_id` int(11) DEFAULT NULL,
  `wish_date` datetime DEFAULT NULL,
  PRIMARY KEY (`wish_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

USE `BucketList`;
DROP procedure IF EXISTS `BucketList`.`sp_addWish`;
DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addWish`(
    IN p_title varchar(45),
    IN p_description varchar(1000),
    IN p_user_id bigint
)
BEGIN
    insert into tbl_wish(
        wish_title,
        wish_description,
        wish_user_id,
        wish_date
    )
    values
    (
        p_title,
        p_description,
        p_user_id,
        NOW()
    );
END$$
DELIMITER ;

USE `BucketList`;
DROP procedure IF EXISTS `sp_GetWishByUser`;

DELIMITER $$
USE `BucketList`$$
CREATE PROCEDURE `sp_GetWishByUser` (
IN p_user_id bigint
)
BEGIN
    select * from tbl_wish where wish_user_id = p_user_id;
END$$
DELIMITER ;


USE `BucketList`;
DROP procedure IF EXISTS `sp_GetWishByUser`;

DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishByUser`(
IN p_user_id bigint,
IN p_limit int,
IN p_offset int
)
BEGIN
    SET @t1 = CONCAT( 'select * from tbl_wish where wish_user_id = ', p_user_id, ' order by wish_date desc limit ',p_limit,' offset ',p_offset);
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt1;
END$$

DELIMITER ;

USE `BucketList`;
DROP procedure IF EXISTS `sp_GetWishByUser`;

DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishByUser`(
IN p_user_id bigint,
IN p_limit int,
IN p_offset int,
out p_total bigint
)
BEGIN

    select count(*) into p_total from tbl_wish where wish_user_id = p_user_id;

    SET @t1 = CONCAT( 'select * from tbl_wish where wish_user_id = ', p_user_id, ' order by wish_date desc limit ',p_limit,' offset ',p_offset);
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

ALTER TABLE `BucketList`.`tbl_wish`
ADD COLUMN `wish_file_path` VARCHAR(200) NULL AFTER `wish_date`,
ADD COLUMN `wish_accomplished` INT NULL DEFAULT 0 AFTER `wish_file_path`,
ADD COLUMN `wish_private` INT NULL DEFAULT 0 AFTER `wish_accomplished`;

USE `BucketList`;
DROP procedure IF EXISTS `sp_addWish`;

DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addWish`(
    IN p_title varchar(45),
    IN p_description varchar(1000),
    IN p_user_id bigint,
    IN p_file_path varchar(200),
    IN p_is_private int,
    IN p_is_done int
)
BEGIN
    insert into tbl_wish(
        wish_title,
        wish_description,
        wish_user_id,
        wish_date,
        wish_file_path,
        wish_private,
        wish_accomplished
    )
    values
    (
        p_title,
        p_description,
        p_user_id,
        NOW(),
        p_file_path,
        p_is_private,
        p_is_done
    );
END$$

DELIMITER ;

USE `BucketList`;
DROP procedure IF EXISTS `sp_updateWish`;

DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateWish`(
IN p_title varchar(45),
IN p_description varchar(1000),
IN p_wish_id bigint,
In p_user_id bigint,
IN p_file_path varchar(200),
IN p_is_private int,
IN p_is_done int
)
BEGIN
update tbl_wish set
    wish_title = p_title,
    wish_description = p_description,
    wish_file_path = p_file_path,
    wish_private = p_is_private,
    wish_accomplished = p_is_done
    where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$

DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishById`(
IN p_wish_id bigint,
In p_user_id bigint
)
BEGIN select wish_id,wish_title,wish_description,wish_file_path,wish_private,wish_accomplished from tbl_wish where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

DELIMITER $$
USE `BucketList`$$
CREATE PROCEDURE `sp_deleteWish` (
IN p_wish_id bigint,
IN p_user_id bigint
)
BEGIN
delete from tbl_wish where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateWish`(
IN p_title varchar(45),
IN p_description varchar(1000),
IN p_wish_id bigint,
In p_user_id bigint,
IN p_file_path varchar(200),
IN p_is_private int,
IN p_is_done int
)
BEGIN
update tbl_wish set
    wish_title = p_title,
    wish_description = p_description,
    wish_file_path = p_file_path,
    wish_private = p_is_private,
    wish_accomplished = p_is_done
    where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

USE `BucketList`;
DROP procedure IF EXISTS `sp_GetAllWishes`;

DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAllWishes`()
BEGIN
    select wish_id,wish_title,wish_description,wish_file_path from tbl_wish where wish_private = 0;
END$$

DELIMITER ;

CREATE TABLE `BucketList`.`tbl_likes` (
  `wish_id` INT NOT NULL,
  `like_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `wish_like` INT NULL DEFAULT 0,
  PRIMARY KEY (`like_id`));

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddUpdateLikes`(
    p_wish_id int,
    p_user_id int,
    p_like int
)
BEGIN
    if (select exists (select 1 from tbl_likes where wish_id = p_wish_id and user_id = p_user_id)) then

        update tbl_likes set wish_like = p_like where wish_id = p_wish_id and user_id = p_user_id;

    else

        insert into tbl_likes(
            wish_id,
            user_id,
            wish_like
        )
        values(
            p_wish_id,
            p_user_id,
            p_like
        );

    end if;
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_addWish`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addWish`(
    IN p_title varchar(45),
    IN p_description varchar(1000),
    IN p_user_id bigint,
    IN p_file_path varchar(200),
    IN p_is_private int,
    IN p_is_done int
)
BEGIN
    insert into tbl_wish(
        wish_title,
        wish_description,
        wish_user_id,
        wish_date,
        wish_file_path,
        wish_private,
        wish_accomplished
    )
    values
    (
        p_title,
        p_description,
        p_user_id,
        NOW(),
        p_file_path,
        p_is_private,
        p_is_done
    );

    SET @last_id = LAST_INSERT_ID();
    insert into tbl_likes(
        wish_id,
        user_id,
        wish_like
    )
    values(
        @last_id,
        p_user_id,
        0
    );


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSum`(
    p_wish_id int
) RETURNS int(11)
BEGIN
    select sum(wish_like) into @sm from tbl_likes where wish_id = p_wish_id;
RETURN @sm;
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_GetAllWishes`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAllWishes`()
BEGIN
    select wish_id,wish_title,wish_description,wish_file_path,getSum(wish_id)
    from tbl_wish where wish_private = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `hasLiked`(
    p_wish int,
    p_user int
) RETURNS int(11)
BEGIN

    select wish_like into @myval from tbl_likes where wish_id =  p_wish and user_id = p_user;
RETURN @myval;
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_GetAllWishes`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAllWishes`(
    p_user int
)
BEGIN
    select wish_id,wish_title,wish_description,wish_file_path,getSum(wish_id),hasLiked(wish_id,p_user)
    from tbl_wish where wish_private = 0;
END$$
DELIMITER ;

DROP procedure IF EXISTS `sp_AddUpdateLikes`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddUpdateLikes`(
    p_wish_id int,
    p_user_id int,
    p_like int
)
BEGIN

    if (select exists (select 1 from tbl_likes where wish_id = p_wish_id and user_id = p_user_id)) then


        select wish_like into @currentVal from tbl_likes where wish_id = p_wish_id and user_id = p_user_id;

        if @currentVal = 0 then
            update tbl_likes set wish_like = 1 where wish_id = p_wish_id and user_id = p_user_id;
        else
            update tbl_likes set wish_like = 0 where wish_id = p_wish_id and user_id = p_user_id;
        end if;

    else

        insert into tbl_likes(
            wish_id,
            user_id,
            wish_like
        )
        values(
            p_wish_id,
            p_user_id,
            p_like
        );


    end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getLikeStatus`(
    IN p_wish_id int,
    IN p_user_id int
)
BEGIN
    select getSum(p_wish_id),hasLiked(p_wish_id,p_user_id);
END$$
DELIMITER ;
