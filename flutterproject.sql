-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               11.5.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for tradeon
CREATE DATABASE IF NOT EXISTS `tradeon` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `tradeon`;

-- Dumping structure for table tradeon.item_infos
CREATE TABLE IF NOT EXISTS `item_infos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` longtext DEFAULT NULL,
  `discription` longtext DEFAULT NULL,
  `imagepath` longtext DEFAULT NULL,
  `user_info_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_item_infos_deleted_at` (`deleted_at`),
  KEY `fk_item_infos_user_info` (`user_info_id`),
  CONSTRAINT `fk_item_infos_user_info` FOREIGN KEY (`user_info_id`) REFERENCES `user_infos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tradeon.item_infos: ~15 rows (approximately)
REPLACE INTO `item_infos` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `discription`, `imagepath`, `user_info_id`) VALUES
	(4, '2025-01-19 08:07:03.173', '2025-01-19 08:07:03.173', NULL, 'ช็อกโกแลต', 'ใช้แลกกับเครื่องดื่มหรือขนมหวานอื่นๆ', '/item/1737274023171729300-userID1.jpg', 1),
	(5, '2025-01-19 08:07:16.564', '2025-01-19 08:07:16.564', NULL, 'กระเป๋าผ้า', 'สามารถแลกกับการช่วยถือของหรือแลกกับเครื่องเขียน', '/item/1737274036563136300-userID1.jpg', 1),
	(6, '2025-01-19 08:07:42.438', '2025-01-19 08:07:42.438', NULL, 'ชุดทำอาหาร', 'เอามาแลกกับการช่วยทำอาหารหรือลองสูตรใหม่ๆ', '/item/1737274062437832800-userID1.jpg', 1),
	(7, '2025-01-19 08:08:01.170', '2025-01-19 08:08:01.170', NULL, 'ตุ๊กตาหมี', 'เอามาแลกกับการช่วยจัดการงานหรือแลกกับขนม', '/item/1737274081169305300-userID1.jpg', 1),
	(8, '2025-01-19 08:08:10.452', '2025-01-19 08:08:10.452', NULL, 'เสื้อยืด', 'สามารถแลกกับการช่วยทำงานบ้านหรือแลกกับสิ่งของอื่นๆ', '/item/1737274090451434600-userID1.png', 1),
	(9, '2025-01-19 08:13:01.979', '2025-01-19 08:13:01.979', NULL, 'สมุดโน๊ต', 'ใช้แลกกับการช่วยสรุปข้อมูลหรือแลกกับอุปกรณ์การเรียนอื่นๆ', '/item/1737274381978399300-userID2.jpg', 2),
	(10, '2025-01-19 08:13:30.479', '2025-01-19 08:13:30.479', NULL, 'แว่นตากันแดด', 'สามารถแลกกับการช่วยจองที่นั่งหรือแลกกับของใช้ส่วนตัว', '/item/1737274410478889200-userID2.jpg', 2),
	(11, '2025-01-19 08:13:56.061', '2025-01-19 08:13:56.061', NULL, 'น้ำหอม', 'ใช้แลกกับการช่วยจัดระเบียบห้องหรือแลกกับความช่วยเหลือในงานต่างๆ', '/item/1737274436060656000-userID2.jpg', 2),
	(12, '2025-01-19 08:14:36.710', '2025-01-19 08:14:36.710', NULL, 'ลิปสติก', 'สามารถแลกกับการช่วยเลือกของขวัญหรือแลกกับการช่วยงาน', '/item/1737274476709854400-userID2.jpg', 2),
	(13, '2025-01-19 08:14:55.010', '2025-01-19 08:14:55.010', NULL, 'ชุดกีฬา', 'เอามาแลกกับการฝึกซ้อมหรือแลกกับอุปกรณ์กีฬาอื่นๆ', '/item/1737274495009801600-userID2.png', 2),
	(14, '2025-01-19 08:20:03.085', '2025-01-19 08:20:03.085', NULL, 'ค้อน', 'ใช้แลกกับการช่วยงานก่อสร้างหรือซ่อมแซมสิ่งของต่างๆ', '/item/1737274803083586400-userID3.jpg', 3),
	(15, '2025-01-19 08:20:15.611', '2025-01-19 08:20:15.611', NULL, 'ไขควง', 'สามารถแลกกับการช่วยซ่อมเครื่องใช้ไฟฟ้าหรือแลกกับเครื่องมืออื่นๆ', '/item/1737274815610287100-userID3.jpg', 3),
	(16, '2025-01-19 08:20:35.453', '2025-01-19 08:20:35.453', NULL, 'ปืนลม', 'ใช้แลกกับการช่วยทำความสะอาดหรือจัดการเครื่องจักร', '/item/1737274835452620600-userID3.jpg', 3),
	(17, '2025-01-19 08:20:50.777', '2025-01-19 08:20:50.777', NULL, 'ตะปู', 'สามารถแลกกับการให้คำแนะนำในการสร้างงานประดิษฐ์หรือการซ่อมแซม', '/item/1737274850776460100-userID3.jpg', 3),
	(18, '2025-01-19 08:21:23.330', '2025-01-19 08:21:23.330', NULL, 'กรรไกร', 'ใช้แลกกับการช่วยตัดวัสดุหรือแลกกับเครื่องมือการทำงานอื่นๆ', '/item/1737274883329226100-userID3.jpg', 3);

-- Dumping structure for table tradeon.sending_addings
CREATE TABLE IF NOT EXISTS `sending_addings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `dealer_id` bigint(20) unsigned DEFAULT NULL,
  `user_post_id` bigint(20) unsigned DEFAULT NULL,
  `more_add` longtext DEFAULT NULL,
  `box_add` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sending_addings_deleted_at` (`deleted_at`),
  KEY `fk_sending_addings_user_id` (`user_post_id`),
  KEY `fk_sending_addings_trade_id` (`dealer_id`),
  CONSTRAINT `fk_sending_addings_trade_id` FOREIGN KEY (`dealer_id`) REFERENCES `trade_infos` (`id`),
  CONSTRAINT `fk_sending_addings_user_id` FOREIGN KEY (`user_post_id`) REFERENCES `user_infos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tradeon.sending_addings: ~1 rows (approximately)
REPLACE INTO `sending_addings` (`id`, `created_at`, `updated_at`, `deleted_at`, `dealer_id`, `user_post_id`, `more_add`, `box_add`) VALUES
	(1, '2025-01-19 20:05:06.352', '2025-01-19 20:05:06.352', NULL, 2, 3, 'facebook:chanachol', '45 พะเยา 5600 หน้ามอ');

-- Dumping structure for table tradeon.trade_infos
CREATE TABLE IF NOT EXISTS `trade_infos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `user_trader_id` bigint(20) unsigned DEFAULT NULL,
  `user_owner_id` bigint(20) unsigned DEFAULT NULL,
  `owner_item_id` bigint(20) unsigned DEFAULT NULL,
  `trade_item_id` bigint(20) unsigned DEFAULT NULL,
  `status_trade` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_trade_infos_deleted_at` (`deleted_at`),
  KEY `fk_trade_infos_user1` (`user_trader_id`),
  KEY `fk_trade_infos_user2` (`user_owner_id`),
  KEY `fk_trade_infos_item1` (`owner_item_id`),
  KEY `fk_trade_infos_item2` (`trade_item_id`),
  CONSTRAINT `fk_trade_infos_item1` FOREIGN KEY (`owner_item_id`) REFERENCES `item_infos` (`id`),
  CONSTRAINT `fk_trade_infos_item2` FOREIGN KEY (`trade_item_id`) REFERENCES `item_infos` (`id`),
  CONSTRAINT `fk_trade_infos_user1` FOREIGN KEY (`user_trader_id`) REFERENCES `user_infos` (`id`),
  CONSTRAINT `fk_trade_infos_user2` FOREIGN KEY (`user_owner_id`) REFERENCES `user_infos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tradeon.trade_infos: ~2 rows (approximately)
REPLACE INTO `trade_infos` (`id`, `created_at`, `updated_at`, `deleted_at`, `user_trader_id`, `user_owner_id`, `owner_item_id`, `trade_item_id`, `status_trade`) VALUES
	(1, '2025-01-19 17:20:16.842', '2025-01-19 17:20:16.842', NULL, 2, 3, 17, 9, 'waiting'),
	(2, '2025-01-19 17:21:52.925', '2025-01-19 19:15:23.564', NULL, 2, 3, 14, 10, 'dealer');

-- Dumping structure for table tradeon.user_infos
CREATE TABLE IF NOT EXISTS `user_infos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` longtext DEFAULT NULL,
  `email` longtext DEFAULT NULL,
  `password` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_infos_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tradeon.user_infos: ~4 rows (approximately)
REPLACE INTO `user_infos` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `email`, `password`) VALUES
	(1, '2025-01-19 07:44:26.946', '2025-01-19 07:44:26.946', NULL, 'A .banana', 'a.banana@gmail.com', '$2a$10$ZMnuec22uwLsVqIQfqT8H.SozgYUWT0gYiUbodYrj2fCLzgOeobLe'),
	(2, '2025-01-19 07:44:32.411', '2025-01-19 07:44:32.411', NULL, 'B banana', 'b.banana@gmail.com', '$2a$10$4oSQReaA9W6vCOODNB.EQeUv.Gi633cRcNapYoIRQMVMYtpoiDhoK'),
	(3, '2025-01-19 07:57:09.036', '2025-01-19 07:57:09.036', NULL, 'C banana', 'c.banana@gmail.com', '$2a$10$/lkYpPwLsysuHxgqyghhvey3bPyL77zQKQOe5KIFM9VJCIv0.BDoe'),
	(4, '2025-01-19 15:29:13.373', '2025-01-19 15:29:13.373', NULL, 'tester', 'testter@gmail.com', '$2a$10$v2L8p.x411PAiO6TtdPtMeIO2J73pZ7sBiwSRZgPSQyrqJ5KWZajC');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
