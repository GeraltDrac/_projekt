-- MySQL Script generated by MySQL Workbench
-- Wed Dec 23 22:23:58 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema susk
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema susk
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `susk` DEFAULT CHARACTER SET utf8 ;
USE `susk` ;

-- -----------------------------------------------------
-- Table `susk`.`Restauracja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `susk`.`Restauracja` (
  `idRestauracja` INT NOT NULL,
  `Adres_restauracji` VARCHAR(45) NOT NULL,
  `Numer_kontaktowy` INT(9) NOT NULL,
  `Id_wlasciciela` INT(11) NOT NULL,
  PRIMARY KEY (`idRestauracja`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `susk`.`Pracownik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `susk`.`Pracownik` (
  `idPracownik` INT(11) NOT NULL,
  `Imie` VARCHAR(45) NOT NULL,
  `Nazwisko` VARCHAR(45) NOT NULL,
  `Pensja_idPensja` INT NOT NULL,
  `Stanowisko_idStanowisko` INT NOT NULL,
  `Restauracja_idRestauracja` INT NOT NULL,
  PRIMARY KEY (`idPracownik`),
  INDEX `fk_Pracownik_Restauracja1_idx` (`Restauracja_idRestauracja` ASC) VISIBLE,
  CONSTRAINT `fk_Pracownik_Restauracja1`
    FOREIGN KEY (`Restauracja_idRestauracja`)
    REFERENCES `susk`.`Restauracja` (`idRestauracja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `susk`.`Klient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `susk`.`Klient` (
  `idKlient` INT NOT NULL,
  `Imie` VARCHAR(45) NOT NULL,
  `Nazwisko` VARCHAR(45) NOT NULL,
  `Numer_telefonu` INT(9) NOT NULL,
  `Ilosc_gosci` INT(4) NOT NULL,
  `Rodzaj_imprezy` VARCHAR(45) NOT NULL,
  `Restauracja_idRestauracja` INT NOT NULL,
  PRIMARY KEY (`idKlient`),
  INDEX `fk_Klient_Restauracja1_idx` (`Restauracja_idRestauracja` ASC) VISIBLE,
  CONSTRAINT `fk_Klient_Restauracja1`
    FOREIGN KEY (`Restauracja_idRestauracja`)
    REFERENCES `susk`.`Restauracja` (`idRestauracja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `susk`.`Usługi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `susk`.`Usługi` (
  `idUsługi` INT NOT NULL,
  `Catering` VARCHAR(45) NOT NULL,
  `rezerwacja_sali` VARCHAR(45) NOT NULL,
  `Restauracja_idRestauracja` INT NOT NULL,
  PRIMARY KEY (`idUsługi`),
  INDEX `fk_Usługi_Restauracja1_idx` (`Restauracja_idRestauracja` ASC) VISIBLE,
  CONSTRAINT `fk_Usługi_Restauracja1`
    FOREIGN KEY (`Restauracja_idRestauracja`)
    REFERENCES `susk`.`Restauracja` (`idRestauracja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `susk`.`Rezerwacja_sali`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `susk`.`Rezerwacja_sali` (
  `idRezerwacja_sali` INT NOT NULL,
  `Ilosc_osob` INT(4) NOT NULL,
  `Cena` FLOAT NOT NULL,
  `Usługi_idUsługi` INT NOT NULL,
  PRIMARY KEY (`idRezerwacja_sali`),
  INDEX `fk_Rezerwacja_sali_Usługi1_idx` (`Usługi_idUsługi` ASC) VISIBLE,
  CONSTRAINT `fk_Rezerwacja_sali_Usługi1`
    FOREIGN KEY (`Usługi_idUsługi`)
    REFERENCES `susk`.`Usługi` (`idUsługi`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `susk`.`Catering`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `susk`.`Catering` (
  `Usługi_idUsługi` INT NOT NULL,
  `Menu` VARCHAR(45) NOT NULL,
  `Cena` FLOAT NOT NULL,
  `Ilosc_osob` INT(4) NOT NULL,
  INDEX `fk_Catering_Usługi1_idx` (`Usługi_idUsługi` ASC) VISIBLE,
  PRIMARY KEY (`Usługi_idUsługi`),
  CONSTRAINT `fk_Catering_Usługi1`
    FOREIGN KEY (`Usługi_idUsługi`)
    REFERENCES `susk`.`Usługi` (`idUsługi`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

DELIMITER //
CREATE TRIGGER Update_liczba_osob
BEFORE INSERT ON Klient
FOR EACH ROW

BEGIN
  IF NEW.Ilosc_gosci < 0
  THEN
    SET NEW.Ilosc_gosci= (-1)*Ilosc_gosci;
  END IF;
END
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER Insert_Rezerwacja_sali
BEFORE INSERT ON Rezerwacja_sali
FOR EACH ROW
BEGIN
  IF NEW.Ilosc_osob > 100
  THEN
    SET NEW.Cena = 0.75*NEW.Cena;
  END IF;
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Pracownicy_z_pensja_ponad_2000()
BEGIN
	SELECT* from Pracownik WHERE Pensja_idPensja >= 2000;
END; //

DELIMITER //
CREATE FUNCTION suma_pensji()
    RETURNS INTEGER
BEGIN
    DECLARE Suma_pensji INT;
    SELECT SUM(Pensja_idPensja) INTO @MONEY FROM Pracownik;
    RETURN @MONEY;
END //
select suma_pensji();



