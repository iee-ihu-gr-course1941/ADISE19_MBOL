-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Φιλοξενητής: 127.0.0.1
-- Χρόνος δημιουργίας: 28 Δεκ 2019 στις 12:32:41
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_cards` ()  REPLACE INTO `cards`(`id`,`symbol`,`value`,`color`,`used`,`sxima`,`player_cards_played`,`dealer_cards_played`) SELECT `id`,`symbol`,`value`,`color`,`used`,`sxima`,`player_cards_played`,`dealer_cards_played` FROM `cards_empty`$$

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
  `color` enum('B','R') DEFAULT NULL,
  `used` tinyint(1) DEFAULT NULL,
  `sxima` enum('Karo','Trifylli','Bastouni','Koupa') DEFAULT NULL,
  `player_cards_played` tinyint(1) DEFAULT NULL,
  `dealer_cards_played` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `cards`
--

INSERT INTO `cards` (`id`, `symbol`, `value`, `color`, `used`, `sxima`, `player_cards_played`, `dealer_cards_played`) VALUES
(1, '2', 2, 'R', 0, 'Koupa', NULL, NULL),
(2, '3', 3, 'R', 0, 'Koupa', NULL, NULL),
(3, '4', 4, 'R', 0, 'Koupa', NULL, NULL),
(4, '5', 5, 'R', 0, 'Koupa', NULL, NULL),
(5, '6', 6, 'R', 0, 'Koupa', NULL, NULL),
(6, '7', 7, 'R', 0, 'Koupa', NULL, NULL),
(7, '8', 8, 'R', 0, 'Koupa', NULL, NULL),
(8, '9', 9, 'R', 0, 'Koupa', NULL, NULL),
(9, '10', 10, 'R', 0, 'Koupa', NULL, NULL),
(10, 'J', 10, 'R', 0, 'Koupa', NULL, NULL),
(11, 'Q', 10, 'R', 0, 'Koupa', NULL, NULL),
(12, 'K', 10, 'R', 0, 'Koupa', NULL, NULL),
(13, 'A', 1, 'R', 0, 'Koupa', NULL, NULL),
(14, '2', 2, 'B', 0, 'Bastouni', NULL, NULL),
(15, '3', 3, 'B', 0, 'Bastouni', NULL, NULL),
(16, '4', 4, 'B', 0, 'Bastouni', NULL, NULL),
(17, '5', 5, 'B', 0, 'Bastouni', NULL, NULL),
(18, '6', 6, 'B', 0, 'Bastouni', NULL, NULL),
(19, '7', 7, 'B', 0, 'Bastouni', NULL, NULL),
(20, '8', 8, 'B', 0, 'Bastouni', NULL, NULL),
(21, '9', 9, 'B', 0, 'Bastouni', NULL, NULL),
(22, '10', 10, 'B', 0, 'Bastouni', NULL, NULL),
(23, 'J', 10, 'B', 0, 'Bastouni', NULL, NULL),
(24, 'Q', 10, 'B', 0, 'Bastouni', NULL, NULL),
(25, 'K', 10, 'B', 0, 'Bastouni', NULL, NULL),
(26, 'A', 1, 'B', 0, 'Bastouni', NULL, NULL),
(28, '2', 2, 'B', 0, 'Trifylli', NULL, NULL),
(29, '3', 3, 'B', 0, 'Trifylli', NULL, NULL),
(30, '4', 4, 'B', 0, 'Trifylli', NULL, NULL),
(31, '5', 5, 'B', 0, 'Trifylli', NULL, NULL),
(32, '6', 6, 'B', 0, 'Trifylli', NULL, NULL),
(33, '7', 7, 'B', 0, 'Trifylli', NULL, NULL),
(34, '8', 8, 'B', 0, 'Trifylli', NULL, NULL),
(35, '9', 9, 'B', 0, 'Trifylli', NULL, NULL),
(36, '10', 10, 'B', 0, 'Trifylli', NULL, NULL),
(37, 'J', 10, 'B', 0, 'Trifylli', NULL, NULL),
(38, 'Q', 10, 'B', 0, 'Trifylli', NULL, NULL),
(39, 'K', 10, 'B', 0, 'Trifylli', NULL, NULL),
(40, 'A', 1, 'B', 0, 'Trifylli', NULL, NULL),
(41, '2', 2, 'R', 0, 'Karo', NULL, NULL),
(42, '3', 3, 'R', 0, 'Karo', NULL, NULL),
(43, '4', 4, 'R', 0, 'Karo', NULL, NULL),
(44, '5', 5, 'R', 0, 'Karo', NULL, NULL),
(45, '6', 6, 'R', 0, 'Karo', NULL, NULL),
(46, '7', 7, 'R', 0, 'Karo', NULL, NULL),
(47, '8', 8, 'R', 0, 'Karo', NULL, NULL),
(48, '9', 9, 'R', 0, 'Karo', NULL, NULL),
(49, '10', 10, 'R', 0, 'Karo', NULL, NULL),
(50, 'J', 10, 'R', 0, 'Karo', NULL, NULL),
(51, 'Q', 10, 'R', 0, 'Karo', NULL, NULL),
(52, 'K', 10, 'R', 0, 'Karo', NULL, NULL),
(53, 'A', 1, 'R', 0, 'Karo', NULL, NULL);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cards_empty`
--

CREATE TABLE `cards_empty` (
  `id` int(11) NOT NULL,
  `symbol` enum('1','2','3','4','5','6','7','8','9','10','J','Q','K','A') NOT NULL,
  `value` int(11) NOT NULL,
  `color` enum('B','R') DEFAULT NULL,
  `used` tinyint(1) DEFAULT NULL,
  `sxima` enum('Karo','Trifylli','Bastouni','Koupa') DEFAULT NULL,
  `player_cards_played` tinyint(1) DEFAULT NULL,
  `dealer_cards_played` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `cards_empty`
--

INSERT INTO `cards_empty` (`id`, `symbol`, `value`, `color`, `used`, `sxima`, `player_cards_played`, `dealer_cards_played`) VALUES
(1, '2', 2, 'R', 0, 'Koupa', NULL, NULL),
(2, '3', 3, 'R', 0, 'Koupa', NULL, NULL),
(3, '4', 4, 'R', 0, 'Koupa', NULL, NULL),
(4, '5', 5, 'R', 0, 'Koupa', NULL, NULL),
(5, '6', 6, 'R', 0, 'Koupa', NULL, NULL),
(6, '7', 7, 'R', 0, 'Koupa', NULL, NULL),
(7, '8', 8, 'R', 0, 'Koupa', NULL, NULL),
(8, '9', 9, 'R', 0, 'Koupa', NULL, NULL),
(9, '10', 10, 'R', 0, 'Koupa', NULL, NULL),
(10, 'J', 10, 'R', 0, 'Koupa', NULL, NULL),
(11, 'Q', 10, 'R', 0, 'Koupa', NULL, NULL),
(12, 'K', 10, 'R', 0, 'Koupa', NULL, NULL),
(13, 'A', 1, 'R', 0, 'Koupa', NULL, NULL),
(14, '2', 2, 'B', 0, 'Bastouni', NULL, NULL),
(15, '3', 3, 'B', 0, 'Bastouni', NULL, NULL),
(16, '4', 4, 'B', 0, 'Bastouni', NULL, NULL),
(17, '5', 5, 'B', 0, 'Bastouni', NULL, NULL),
(18, '6', 6, 'B', 0, 'Bastouni', NULL, NULL),
(19, '7', 7, 'B', 0, 'Bastouni', NULL, NULL),
(20, '8', 8, 'B', 0, 'Bastouni', NULL, NULL),
(21, '9', 9, 'B', 0, 'Bastouni', NULL, NULL),
(22, '10', 10, 'B', 0, 'Bastouni', NULL, NULL),
(23, 'J', 10, 'B', 0, 'Bastouni', NULL, NULL),
(24, 'Q', 10, 'B', 0, 'Bastouni', NULL, NULL),
(25, 'K', 10, 'B', 0, 'Bastouni', NULL, NULL),
(26, 'A', 1, 'B', 0, 'Bastouni', NULL, NULL),
(28, '2', 2, 'B', 0, 'Trifylli', NULL, NULL),
(29, '3', 3, 'B', 0, 'Trifylli', NULL, NULL),
(30, '4', 4, 'B', 0, 'Trifylli', NULL, NULL),
(31, '5', 5, 'B', 0, 'Trifylli', NULL, NULL),
(32, '6', 6, 'B', 0, 'Trifylli', NULL, NULL),
(33, '7', 7, 'B', 0, 'Trifylli', NULL, NULL),
(34, '8', 8, 'B', 0, 'Trifylli', NULL, NULL),
(35, '9', 9, 'B', 0, 'Trifylli', NULL, NULL),
(36, '10', 10, 'B', 0, 'Trifylli', NULL, NULL),
(37, 'J', 10, 'B', 0, 'Trifylli', NULL, NULL),
(38, 'Q', 10, 'B', 0, 'Trifylli', NULL, NULL),
(39, 'K', 10, 'B', 0, 'Trifylli', NULL, NULL),
(40, 'A', 1, 'B', 0, 'Trifylli', NULL, NULL),
(41, '2', 2, 'R', 0, 'Karo', NULL, NULL),
(42, '3', 3, 'R', 0, 'Karo', NULL, NULL),
(43, '4', 4, 'R', 0, 'Karo', NULL, NULL),
(44, '5', 5, 'R', 0, 'Karo', NULL, NULL),
(45, '6', 6, 'R', 0, 'Karo', NULL, NULL),
(46, '7', 7, 'R', 0, 'Karo', NULL, NULL),
(47, '8', 8, 'R', 0, 'Karo', NULL, NULL),
(48, '9', 9, 'R', 0, 'Karo', NULL, NULL),
(49, '10', 10, 'R', 0, 'Karo', NULL, NULL),
(50, 'J', 10, 'R', 0, 'Karo', NULL, NULL),
(51, 'Q', 10, 'R', 0, 'Karo', NULL, NULL),
(52, 'K', 10, 'R', 0, 'Karo', NULL, NULL),
(53, 'A', 1, 'R', 0, 'Karo', NULL, NULL);

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
('ENDED', NULL, NULL, '2019-12-28 11:30:41');

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
('Stavros', 'Player', 0, '1a602bbf77395c0c99c499f05efeb4d3', '2019-12-28 10:31:30'),
('Koulis', 'Dealer', 0, '702fbd8e6ea97ee4f62de17306e2b4d7', '2019-12-28 10:31:41');

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
