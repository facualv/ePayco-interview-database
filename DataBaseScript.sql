CREATE SCHEMA `virtual_wallet_test`;
USE `virtual_wallet_test`;

CREATE TABLE `virtual_wallet_test`.`client` (
  `clientId` VARCHAR(45) NOT NULL,
  `name` VARCHAR(70) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`clientId`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `clientId_UNIQUE` (`clientId` ASC) VISIBLE);

CREATE TABLE `virtual_wallet_test`.`wallet` (
  `walletId` INT NOT NULL AUTO_INCREMENT,
  `clientId` VARCHAR(45) NOT NULL,
  `currentBalance` DECIMAL NOT NULL DEFAULT 0,
  PRIMARY KEY (`walletId`),
  UNIQUE INDEX `clientId_UNIQUE` (`clientId` ASC) VISIBLE,
  CONSTRAINT `fk_client_wallet`
    FOREIGN KEY (`clientId`)
    REFERENCES `virtual_wallet`.`client` (`clientId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `virtual_wallet_test`.`transaction` (
  `transactionId` INT NOT NULL AUTO_INCREMENT,
  `walletId` INT NOT NULL,
  `ammount` DECIMAL NOT NULL DEFAULT 0,
  `type` ENUM('payment', 'recharge') NOT NULL,
  `detail` VARCHAR(100) NULL,
  PRIMARY KEY (`transactionId`),
  INDEX `fk_wallet_transaction_idx` (`walletId` ASC) VISIBLE,
  CONSTRAINT `fk_wallet_transaction`
    FOREIGN KEY (`walletId`)
    REFERENCES `virtual_wallet`.`wallet` (`walletId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


DROP TRIGGER IF EXISTS `virtual_wallet_test`.`tgr_wallet_creator`;
DELIMITER $$
USE `virtual_wallet_test`$$
CREATE DEFINER = CURRENT_USER TRIGGER `virtual_wallet_test`.`tgr_wallet_creator` AFTER INSERT ON `client` FOR EACH ROW
BEGIN
	INSERT INTO wallet
	(
	`clientId`,
	`currentBalance`
	)
	VALUES
	(new.clientId, 0);
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `virtual_wallet_test`.`tgr_balance_updater`;
DELIMITER $$
USE `virtual_wallet`$$
CREATE DEFINER=`root`@`localhost` TRIGGER  `virtual_wallet_test`.`tgr_balance_updater` AFTER INSERT ON `transaction` FOR EACH ROW BEGIN
    IF new.type = 'payment' THEN   
		UPDATE wallet set 
		currentBalance = currentBalance - new.ammount
		where walletId = new.walletId;
	ELSE
		UPDATE wallet set 
		currentBalance = currentBalance + new.ammount
		where walletId = new.walletId;
	END IF;	
END$$
DELIMITER ;



use virtual_wallet_test;

INSERT INTO client
(`clientId`,
`name`,
`phone`,
`email`,
`password`)
VALUES
('30258147','Mariano Alvarez','154741258','toto_alv@gmail.com', 'picos');

select * from client;
select * from wallet;

INSERT INTO client
(`clientId`,
`name`,
`phone`,
`email`,
`password`)
VALUES
('31642858','Luciano Pereyra','15662335','lucho_pere@gmail.com', 'teamomariana');

select * from client;
select * from wallet;

INSERT INTO transaction
(`walletId`,
`ammount`, 
`type`, `detail`)
VALUES
('1', 500, 'recharge','same recharge');

INSERT INTO transaction
(`walletId`,
`ammount`, 
`type`,
`detail`)
VALUES
('1', 500, 'payment','same payment');

select * from transaction;
select * from wallet;

