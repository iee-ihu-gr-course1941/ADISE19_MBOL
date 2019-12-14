-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Φιλοξενητής: 127.0.0.1
-- Χρόνος δημιουργίας: 14 Δεκ 2019 στις 13:31:46
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_cards` ()  REPLACE INTO `cards`(`id`,`symbol`,`value`,`color`,`used`,`sxima`) SELECT `id`,`symbol`,`value`,`color`,`used`,`sxima` FROM `cards_empty`$$

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
  `sxima` enum('Karo','Trifylli','Bastouni','Koupa') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `cards`
--

INSERT INTO `cards` (`id`, `symbol`, `value`, `color`, `used`, `sxima`) VALUES
(1, '2', 2, 'R', 0, 'Koupa'),
(2, '3', 3, 'R', 0, 'Koupa'),
(3, '4', 4, 'R', 0, 'Koupa'),
(4, '5', 5, 'R', 0, 'Koupa'),
(5, '6', 6, 'R', 0, 'Koupa'),
(6, '7', 7, 'R', 0, 'Koupa'),
(7, '8', 8, 'R', 0, 'Koupa'),
(8, '9', 9, 'R', 0, 'Koupa'),
(9, '10', 10, 'R', 0, 'Koupa'),
(10, 'J', 10, 'R', 0, 'Koupa'),
(11, 'Q', 10, 'R', 0, 'Koupa'),
(12, 'K', 10, 'R', 0, 'Koupa'),
(13, 'A', 1, 'R', 0, 'Koupa'),
(14, '2', 2, 'B', 0, 'Bastouni'),
(15, '3', 3, 'B', 0, 'Bastouni'),
(16, '4', 4, 'B', 0, 'Bastouni'),
(17, '5', 5, 'B', 0, 'Bastouni'),
(18, '6', 6, 'B', 0, 'Bastouni'),
(19, '7', 7, 'B', 0, 'Bastouni'),
(20, '8', 8, 'B', 0, 'Bastouni'),
(21, '9', 9, 'B', 0, 'Bastouni'),
(22, '10', 10, 'B', 0, 'Bastouni'),
(23, 'J', 10, 'B', 0, 'Bastouni'),
(24, 'Q', 10, 'B', 0, 'Bastouni'),
(25, 'K', 10, 'B', 0, 'Bastouni'),
(26, 'A', 1, 'B', 0, 'Bastouni'),
(28, '2', 2, 'B', 0, 'Trifylli'),
(29, '3', 3, 'B', 0, 'Trifylli'),
(30, '4', 4, 'B', 0, 'Trifylli'),
(31, '5', 5, 'B', 0, 'Trifylli'),
(32, '6', 6, 'B', 0, 'Trifylli'),
(33, '7', 7, 'B', 0, 'Trifylli'),
(34, '8', 8, 'B', 0, 'Trifylli'),
(35, '9', 9, 'B', 0, 'Trifylli'),
(36, '10', 10, 'B', 0, 'Trifylli'),
(37, 'J', 10, 'B', 0, 'Trifylli'),
(38, 'Q', 10, 'B', 0, 'Trifylli'),
(39, 'K', 10, 'B', 0, 'Trifylli'),
(40, 'A', 1, 'B', 0, 'Trifylli'),
(41, '2', 2, 'R', 0, 'Karo'),
(42, '3', 3, 'R', 0, 'Karo'),
(43, '4', 4, 'R', 0, 'Karo'),
(44, '5', 5, 'R', 0, 'Karo'),
(45, '6', 6, 'R', 0, 'Karo'),
(46, '7', 7, 'R', 0, 'Karo'),
(47, '8', 8, 'R', 0, 'Karo'),
(48, '9', 9, 'R', 0, 'Karo'),
(49, '10', 10, 'R', 0, 'Karo'),
(50, 'J', 10, 'R', 0, 'Karo'),
(51, 'Q', 10, 'R', 0, 'Karo'),
(52, 'K', 10, 'R', 0, 'Karo'),
(53, 'A', 1, 'R', 0, 'Karo');

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
  `sxima` enum('Karo','Trifylli','Bastouni','Koupa') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `cards_empty`
--

INSERT INTO `cards_empty` (`id`, `symbol`, `value`, `color`, `used`, `sxima`) VALUES
(1, '2', 2, 'R', 0, 'Koupa'),
(2, '3', 3, 'R', 0, 'Koupa'),
(3, '4', 4, 'R', 0, 'Koupa'),
(4, '5', 5, 'R', 0, 'Koupa'),
(5, '6', 6, 'R', 0, 'Koupa'),
(6, '7', 7, 'R', 0, 'Koupa'),
(7, '8', 8, 'R', 0, 'Koupa'),
(8, '9', 9, 'R', 0, 'Koupa'),
(9, '10', 10, 'R', 0, 'Koupa'),
(10, 'J', 10, 'R', 0, 'Koupa'),
(11, 'Q', 10, 'R', 0, 'Koupa'),
(12, 'K', 10, 'R', 0, 'Koupa'),
(13, 'A', 1, 'R', 0, 'Koupa'),
(14, '2', 2, 'B', 0, 'Bastouni'),
(15, '3', 3, 'B', 0, 'Bastouni'),
(16, '4', 4, 'B', 0, 'Bastouni'),
(17, '5', 5, 'B', 0, 'Bastouni'),
(18, '6', 6, 'B', 0, 'Bastouni'),
(19, '7', 7, 'B', 0, 'Bastouni'),
(20, '8', 8, 'B', 0, 'Bastouni'),
(21, '9', 9, 'B', 0, 'Bastouni'),
(22, '10', 10, 'B', 0, 'Bastouni'),
(23, 'J', 10, 'B', 0, 'Bastouni'),
(24, 'Q', 10, 'B', 0, 'Bastouni'),
(25, 'K', 10, 'B', 0, 'Bastouni'),
(26, 'A', 1, 'B', 0, 'Bastouni'),
(28, '2', 2, 'B', 0, 'Trifylli'),
(29, '3', 3, 'B', 0, 'Trifylli'),
(30, '4', 4, 'B', 0, 'Trifylli'),
(31, '5', 5, 'B', 0, 'Trifylli'),
(32, '6', 6, 'B', 0, 'Trifylli'),
(33, '7', 7, 'B', 0, 'Trifylli'),
(34, '8', 8, 'B', 0, 'Trifylli'),
(35, '9', 9, 'B', 0, 'Trifylli'),
(36, '10', 10, 'B', 0, 'Trifylli'),
(37, 'J', 10, 'B', 0, 'Trifylli'),
(38, 'Q', 10, 'B', 0, 'Trifylli'),
(39, 'K', 10, 'B', 0, 'Trifylli'),
(40, 'A', 1, 'B', 0, 'Trifylli'),
(41, '2', 2, 'R', 0, 'Karo'),
(42, '3', 3, 'R', 0, 'Karo'),
(43, '4', 4, 'R', 0, 'Karo'),
(44, '5', 5, 'R', 0, 'Karo'),
(45, '6', 6, 'R', 0, 'Karo'),
(46, '7', 7, 'R', 0, 'Karo'),
(47, '8', 8, 'R', 0, 'Karo'),
(48, '9', 9, 'R', 0, 'Karo'),
(49, '10', 10, 'R', 0, 'Karo'),
(50, 'J', 10, 'R', 0, 'Karo'),
(51, 'Q', 10, 'R', 0, 'Karo'),
(52, 'K', 10, 'R', 0, 'Karo'),
(53, 'A', 1, 'R', 0, 'Karo');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `game_status`
--

CREATE TABLE `game_status` (
  `status` enum('NOT ACTIVE','INITIALIZED','STARTED','ENDED','TERMINATED') NOT NULL DEFAULT 'NOT ACTIVE',
  `turn` enum('1','2') NOT NULL,
  `result` enum('P1W','P2W','DRAW') NOT NULL,
  `last_change` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  `melos` enum('1','2') NOT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `token` varchar(32) DEFAULT NULL,
  `last_action` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `players`
--

INSERT INTO `players` (`username`, `melos`, `points`, `token`, `last_action`) VALUES
('Stavros', '1', 0, NULL, '2019-12-14 12:25:30'),
('Giwrgos', '2', 0, NULL, '2019-12-14 12:25:30');

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
-- Ευρετήρια για πίνακα `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`melos`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
