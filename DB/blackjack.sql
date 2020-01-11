-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Φιλοξενητής: 127.0.0.1
-- Χρόνος δημιουργίας: 11 Ιαν 2020 στις 13:11:21
-- Έκδοση διακομιστή: 10.4.8-MariaDB
-- Έκδοση PHP: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Βάση δεδομένων: `blackjack`
--

DELIMITER $$
--
-- Διαδικασίες
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `draw_card` ()  SELECT *
FROM cards c
WHERE c.used=0
ORDER BY RAND() 
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_a_card` (IN `cid` INT)  NO SQL
UPDATE cards c
SET c.used=1
WHERE c.id=cid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_cards` ()  REPLACE INTO `cards`(`id`,`symbol`,`value`,`used`,`sxima`,`player_cards_played`,`dealer_cards_played`) SELECT `id`,`symbol`,`value`,`used`,`sxima`,`player_cards_played`,`dealer_cards_played` FROM `cards_empty`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_points` ()  UPDATE players p
SET p.points=0
WHERE 1=1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_points` (IN `pid` INT, IN `np` INT)  UPDATE `players` p
SET p.points=p.points + np
WHERE p.melos = pid$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cards`
--

CREATE TABLE `cards` (
  `id` int(11) NOT NULL,
  `symbol` enum('1','2','3','4','5','6','7','8','9','10','J','Q','K','A') NOT NULL,
  `value` int(11) NOT NULL,
  `used` tinyint(1) DEFAULT NULL,
  `sxima` enum('Karo','Trifylli','Bastouni','Koupa') DEFAULT NULL,
  `player_cards_played` tinyint(1) DEFAULT NULL,
  `dealer_cards_played` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `cards`
--

INSERT INTO `cards` (`id`, `symbol`, `value`, `used`, `sxima`, `player_cards_played`, `dealer_cards_played`) VALUES
(1, '2', 2, 0, 'Koupa', NULL, NULL),
(2, '3', 3, 0, 'Koupa', NULL, NULL),
(3, '4', 4, 0, 'Koupa', NULL, NULL),
(4, '5', 5, 0, 'Koupa', NULL, NULL),
(5, '6', 6, 0, 'Koupa', NULL, NULL),
(6, '7', 7, 0, 'Koupa', NULL, NULL),
(7, '8', 8, 0, 'Koupa', NULL, NULL),
(8, '9', 9, 0, 'Koupa', NULL, NULL),
(9, '10', 10, 0, 'Koupa', NULL, NULL),
(10, 'J', 10, 0, 'Koupa', NULL, NULL),
(11, 'Q', 10, 0, 'Koupa', NULL, NULL),
(12, 'K', 10, 0, 'Koupa', NULL, NULL),
(13, 'A', 0, 0, 'Koupa', NULL, NULL),
(14, '2', 2, 0, 'Bastouni', NULL, NULL),
(15, '3', 3, 0, 'Bastouni', NULL, NULL),
(16, '4', 4, 0, 'Bastouni', NULL, NULL),
(17, '5', 5, 0, 'Bastouni', NULL, NULL),
(18, '6', 6, 0, 'Bastouni', NULL, NULL),
(19, '7', 7, 0, 'Bastouni', NULL, NULL),
(20, '8', 8, 0, 'Bastouni', NULL, NULL),
(21, '9', 9, 0, 'Bastouni', NULL, NULL),
(22, '10', 10, 0, 'Bastouni', NULL, NULL),
(23, 'J', 10, 0, 'Bastouni', NULL, NULL),
(24, 'Q', 10, 0, 'Bastouni', NULL, NULL),
(25, 'K', 10, 0, 'Bastouni', NULL, NULL),
(26, 'A', 0, 0, 'Bastouni', NULL, NULL),
(28, '2', 2, 0, 'Trifylli', NULL, NULL),
(29, '3', 3, 0, 'Trifylli', NULL, NULL),
(30, '4', 4, 0, 'Trifylli', NULL, NULL),
(31, '5', 5, 0, 'Trifylli', NULL, NULL),
(32, '6', 6, 0, 'Trifylli', NULL, NULL),
(33, '7', 7, 0, 'Trifylli', NULL, NULL),
(34, '8', 8, 0, 'Trifylli', NULL, NULL),
(35, '9', 9, 0, 'Trifylli', NULL, NULL),
(36, '10', 10, 0, 'Trifylli', NULL, NULL),
(37, 'J', 10, 0, 'Trifylli', NULL, NULL),
(38, 'Q', 10, 0, 'Trifylli', NULL, NULL),
(39, 'K', 10, 0, 'Trifylli', NULL, NULL),
(40, 'A', 0, 0, 'Trifylli', NULL, NULL),
(41, '2', 2, 0, 'Karo', NULL, NULL),
(42, '3', 3, 0, 'Karo', NULL, NULL),
(43, '4', 4, 0, 'Karo', NULL, NULL),
(44, '5', 5, 0, 'Karo', NULL, NULL),
(45, '6', 6, 0, 'Karo', NULL, NULL),
(46, '7', 7, 0, 'Karo', NULL, NULL),
(47, '8', 8, 0, 'Karo', NULL, NULL),
(48, '9', 9, 0, 'Karo', NULL, NULL),
(49, '10', 10, 0, 'Karo', NULL, NULL),
(50, 'J', 10, 0, 'Karo', NULL, NULL),
(51, 'Q', 10, 0, 'Karo', NULL, NULL),
(52, 'K', 10, 0, 'Karo', NULL, NULL),
(53, 'A', 0, 0, 'Karo', NULL, NULL);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cards_empty`
--

CREATE TABLE `cards_empty` (
  `id` int(11) NOT NULL,
  `symbol` enum('1','2','3','4','5','6','7','8','9','10','J','Q','K','A') NOT NULL,
  `value` int(11) NOT NULL,
  `used` tinyint(1) DEFAULT NULL,
  `sxima` enum('Karo','Trifylli','Bastouni','Koupa') DEFAULT NULL,
  `player_cards_played` tinyint(1) DEFAULT NULL,
  `dealer_cards_played` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `cards_empty`
--

INSERT INTO `cards_empty` (`id`, `symbol`, `value`, `used`, `sxima`, `player_cards_played`, `dealer_cards_played`) VALUES
(1, '2', 2, 0, 'Koupa', NULL, NULL),
(2, '3', 3, 0, 'Koupa', NULL, NULL),
(3, '4', 4, 0, 'Koupa', NULL, NULL),
(4, '5', 5, 0, 'Koupa', NULL, NULL),
(5, '6', 6, 0, 'Koupa', NULL, NULL),
(6, '7', 7, 0, 'Koupa', NULL, NULL),
(7, '8', 8, 0, 'Koupa', NULL, NULL),
(8, '9', 9, 0, 'Koupa', NULL, NULL),
(9, '10', 10, 0, 'Koupa', NULL, NULL),
(10, 'J', 10, 0, 'Koupa', NULL, NULL),
(11, 'Q', 10, 0, 'Koupa', NULL, NULL),
(12, 'K', 10, 0, 'Koupa', NULL, NULL),
(13, 'A', 0, 0, 'Koupa', NULL, NULL),
(14, '2', 2, 0, 'Bastouni', NULL, NULL),
(15, '3', 3, 0, 'Bastouni', NULL, NULL),
(16, '4', 4, 0, 'Bastouni', NULL, NULL),
(17, '5', 5, 0, 'Bastouni', NULL, NULL),
(18, '6', 6, 0, 'Bastouni', NULL, NULL),
(19, '7', 7, 0, 'Bastouni', NULL, NULL),
(20, '8', 8, 0, 'Bastouni', NULL, NULL),
(21, '9', 9, 0, 'Bastouni', NULL, NULL),
(22, '10', 10, 0, 'Bastouni', NULL, NULL),
(23, 'J', 10, 0, 'Bastouni', NULL, NULL),
(24, 'Q', 10, 0, 'Bastouni', NULL, NULL),
(25, 'K', 10, 0, 'Bastouni', NULL, NULL),
(26, 'A', 0, 0, 'Bastouni', NULL, NULL),
(28, '2', 2, 0, 'Trifylli', NULL, NULL),
(29, '3', 3, 0, 'Trifylli', NULL, NULL),
(30, '4', 4, 0, 'Trifylli', NULL, NULL),
(31, '5', 5, 0, 'Trifylli', NULL, NULL),
(32, '6', 6, 0, 'Trifylli', NULL, NULL),
(33, '7', 7, 0, 'Trifylli', NULL, NULL),
(34, '8', 8, 0, 'Trifylli', NULL, NULL),
(35, '9', 9, 0, 'Trifylli', NULL, NULL),
(36, '10', 10, 0, 'Trifylli', NULL, NULL),
(37, 'J', 10, 0, 'Trifylli', NULL, NULL),
(38, 'Q', 10, 0, 'Trifylli', NULL, NULL),
(39, 'K', 10, 0, 'Trifylli', NULL, NULL),
(40, 'A', 0, 0, 'Trifylli', NULL, NULL),
(41, '2', 2, 0, 'Karo', NULL, NULL),
(42, '3', 3, 0, 'Karo', NULL, NULL),
(43, '4', 4, 0, 'Karo', NULL, NULL),
(44, '5', 5, 0, 'Karo', NULL, NULL),
(45, '6', 6, 0, 'Karo', NULL, NULL),
(46, '7', 7, 0, 'Karo', NULL, NULL),
(47, '8', 8, 0, 'Karo', NULL, NULL),
(48, '9', 9, 0, 'Karo', NULL, NULL),
(49, '10', 10, 0, 'Karo', NULL, NULL),
(50, 'J', 10, 0, 'Karo', NULL, NULL),
(51, 'Q', 10, 0, 'Karo', NULL, NULL),
(52, 'K', 10, 0, 'Karo', NULL, NULL),
(53, 'A', 0, 0, 'Karo', NULL, NULL);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `game_status`
--

CREATE TABLE `game_status` (
  `status` enum('NOT ACTIVE','INITIALIZED','STARTED','ENDED','TERMINATED') NOT NULL DEFAULT 'NOT ACTIVE',
  `turn` enum('Player','Dealer') DEFAULT NULL,
  `result` enum('PW','DW','DRAW') DEFAULT NULL,
  `last_change` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `game_status`
--

INSERT INTO `game_status` (`status`, `turn`, `result`, `last_change`) VALUES
('NOT ACTIVE', NULL, NULL, '2020-01-11 12:10:40');

--
-- Δείκτες `game_status`
--
DELIMITER $$
CREATE TRIGGER `game_status_update` BEFORE UPDATE ON `game_status` FOR EACH ROW SET NEW.last_change=NOW()
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `players`
--

CREATE TABLE `players` (
  `username` varchar(50) NOT NULL,
  `melos` enum('Player','Dealer') NOT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `token` varchar(32) DEFAULT NULL,
  `last_action` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `players`
--

INSERT INTO `players` (`username`, `melos`, `points`, `token`, `last_action`) VALUES
('', 'Player', 0, NULL, '2020-01-11 12:10:40'),
('', 'Dealer', 0, NULL, '2020-01-11 12:10:40');

--
-- Ευρετήρια για άχρηστους πίνακες
--

--
-- Ευρετήρια για πίνακα `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `cards_empty`
--
ALTER TABLE `cards_empty`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `game_status`
--
ALTER TABLE `game_status`
  ADD KEY `turn` (`turn`);

--
-- Ευρετήρια για πίνακα `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`melos`);

--
-- Περιορισμοί για άχρηστους πίνακες
--

--
-- Περιορισμοί για πίνακα `game_status`
--
ALTER TABLE `game_status`
  ADD CONSTRAINT `game_status_ibfk_1` FOREIGN KEY (`turn`) REFERENCES `players` (`melos`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
