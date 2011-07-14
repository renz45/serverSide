# Sequel Pro dump
# Version 2492
# http://code.google.com/p/sequel-pro
#
# Host: 127.0.0.1 (MySQL 5.0.41)
# Database: projectDevelopment
# Generation Time: 2010-09-21 15:23:43 -0400
# ************************************************************

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table pm_project_notes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_project_notes`;

CREATE TABLE `pm_project_notes` (
  `content` text,
  `projects_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `date_added` datetime default NULL,
  `project_note_id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`project_note_id`),
  KEY `projects_id` (`projects_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `pm_project_notes_ibfk_1` FOREIGN KEY (`projects_id`) REFERENCES `pm_projects` (`projects_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pm_project_notes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `pm_users` (`users_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `pm_project_notes` WRITE;
/*!40000 ALTER TABLE `pm_project_notes` DISABLE KEYS */;
INSERT INTO `pm_project_notes` (`content`,`projects_id`,`user_id`,`date_added`,`project_note_id`)
VALUES
	('We just started this project. Hopefully progress keeps progressing.',1,1,'2010-09-21 14:12:26',8),
	('BEARS',7,6,'2010-09-21 15:11:49',9),
	('How are the assets coming?',2,1,'2010-09-21 15:17:57',10);

/*!40000 ALTER TABLE `pm_project_notes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pm_projects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_projects`;

CREATE TABLE `pm_projects` (
  `projects_id` int(11) NOT NULL auto_increment,
  `title` varchar(60) default NULL,
  `description` text,
  `date_created` datetime default NULL,
  `date_completed` datetime default NULL,
  `manager_id` int(11) default NULL,
  `image_url` varchar(40) default NULL,
  `gh_repository_id` varchar(50) default NULL,
  `status` int(11) default NULL,
  PRIMARY KEY  (`projects_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `pm_projects` WRITE;
/*!40000 ALTER TABLE `pm_projects` DISABLE KEYS */;
INSERT INTO `pm_projects` (`projects_id`,`title`,`description`,`date_created`,`date_completed`,`manager_id`,`image_url`,`gh_repository_id`,`status`)
VALUES
	(1,'Portfolio remake','Redoing a art portfolio','2010-09-21 14:04:28',NULL,1,'url.jpg','rickosborne',1),
	(2,'Flash game site','Let\'s make the next awesome casual game site','2010-09-21 14:19:06',NULL,3,'punchingchickencolor.jpg','rickosborne',1),
	(3,'Rock and roll promotion site','A group asked us to make their promotional site for us.','2010-09-21 14:24:33','2010-09-21 14:24:42',3,'7837954.gif','rickosborne',1),
	(4,'Backloggery Remake','Recoding the Backloggery','2010-09-21 14:35:09',NULL,10,'baklaag.gif','rickosborne',1),
	(5,'Backloggery','Creating a site to track games','2010-09-21 14:39:38','2010-09-21 14:40:36',11,'beaten.gif','rickosborne',1),
	(6,'maistre','The project management site','2010-09-21 14:54:10','2010-09-21 14:57:46',1,'','rickosborne',1),
	(7,'Video streaming site','I think we should call it \"Bear\"','2010-09-21 15:11:14',NULL,6,'Animals_06.jpg','rickosborne',1);

/*!40000 ALTER TABLE `pm_projects` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pm_projects_to_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_projects_to_users`;

CREATE TABLE `pm_projects_to_users` (
  `user_id` int(11) default NULL,
  `projects_id` int(11) default NULL,
  KEY `user_id` (`user_id`),
  KEY `projects_id` (`projects_id`),
  CONSTRAINT `pm_projects_to_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `pm_users` (`users_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pm_projects_to_users_ibfk_2` FOREIGN KEY (`projects_id`) REFERENCES `pm_projects` (`projects_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `pm_projects_to_users` WRITE;
/*!40000 ALTER TABLE `pm_projects_to_users` DISABLE KEYS */;
INSERT INTO `pm_projects_to_users` (`user_id`,`projects_id`)
VALUES
	(1,1),
	(2,1),
	(3,2),
	(1,2),
	(2,2),
	(3,3),
	(10,4),
	(11,4),
	(11,5),
	(10,5),
	(8,1),
	(7,1),
	(1,6),
	(3,6),
	(2,6),
	(5,6),
	(4,2),
	(6,3),
	(9,3),
	(6,7),
	(4,7),
	(7,7),
	(7,4);

/*!40000 ALTER TABLE `pm_projects_to_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pm_tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_tasks`;

CREATE TABLE `pm_tasks` (
  `tasks_id` int(11) NOT NULL auto_increment,
  `title` varchar(60) default NULL,
  `description` text,
  `priority` int(11) default NULL,
  `status` int(11) default NULL,
  `project_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `date_added` datetime default NULL,
  PRIMARY KEY  (`tasks_id`),
  KEY `user_id` (`user_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `pm_tasks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `pm_users` (`users_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pm_tasks_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `pm_projects` (`projects_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `pm_tasks` WRITE;
/*!40000 ALTER TABLE `pm_tasks` DISABLE KEYS */;
INSERT INTO `pm_tasks` (`tasks_id`,`title`,`description`,`priority`,`status`,`project_id`,`user_id`,`date_added`)
VALUES
	(1677,'Wireframes','Create wireframes for site layout',4,1,1,1,'2010-09-21 14:12:43'),
	(1678,'Create assets','Make a player and some enemies.',4,1,2,3,'2010-09-21 14:19:28'),
	(1679,'Create story','Every good game has a story',3,1,2,2,'2010-09-21 14:19:59'),
	(1680,'Learn AJAX','Necessary to make the site awesome',5,5,4,10,'2010-09-21 14:35:41'),
	(1681,'Bug fixing','This will come later',3,1,4,11,'2010-09-21 14:38:06'),
	(1682,'New layout','Using CSS 3 is awesome.',4,5,4,11,'2010-09-21 14:38:22'),
	(1683,'Code the site','Coding',5,5,5,11,'2010-09-21 14:39:51'),
	(1684,'Site launch','Get it out into the world!',5,5,5,11,'2010-09-21 14:40:10'),
	(1685,'Bug fixing','Going around the site, looking for bugs',4,1,6,1,'2010-09-21 14:54:54'),
	(1686,'Design comp','Coming up with the design',3,5,6,3,'2010-09-21 14:55:05'),
	(1687,'ColdFusion Code','Changing the HTML to CF',5,5,6,2,'2010-09-21 14:55:24'),
	(1688,'HTML, CSS, and JS','Getting a prototype site done',4,5,6,5,'2010-09-21 14:55:50'),
	(1689,'Header code','Create the header section',3,5,6,1,'2010-09-21 15:08:00'),
	(1690,'Make login','Create login',3,1,7,7,'2010-09-21 15:12:21'),
	(1691,'Make website for game','Let\'s put it on the web!',2,1,2,1,'2010-09-21 15:17:32'),
	(1692,'Site testing','Test to make sure there\'s no bugs',3,1,4,7,'2010-09-21 15:20:16');

/*!40000 ALTER TABLE `pm_tasks` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pm_tasks_notes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_tasks_notes`;

CREATE TABLE `pm_tasks_notes` (
  `content` text,
  `user_id` int(11) NOT NULL default '0',
  `commit_id` char(40) default NULL,
  `task_id` int(11) NOT NULL default '0',
  `date_posted` datetime default NULL,
  `task_note_id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`task_note_id`),
  KEY `task_id` (`task_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `pm_tasks_notes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `pm_users` (`users_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pm_tasks_notes_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `pm_tasks` (`tasks_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `pm_tasks_notes` WRITE;
/*!40000 ALTER TABLE `pm_tasks_notes` DISABLE KEYS */;
INSERT INTO `pm_tasks_notes` (`content`,`user_id`,`commit_id`,`task_id`,`date_posted`,`task_note_id`)
VALUES
	('First shot at iTunes Exporter',1,'ad147882ef33f44b1694f431fd5dd6b47b03f9e9',1677,'2010-09-21 14:15:26',255),
	('Updated iTunes2Db README with explicit licensing information',1,'231f36cd97944a656375d717c547566504a75a53',1677,'2010-09-21 14:15:35',256),
	('Added message component and changed watch to refs/heads',3,'a565132929c303b1813276435f7b19b22b10e0de',1679,'2010-09-21 14:20:24',257),
	('Took a bit of reading, but I got it done.',10,'',1680,'2010-09-21 14:35:54',258),
	('README for itunes2db',11,'6d903babfa016e5998486834bcace08db05c3354',1682,'2010-09-21 14:38:31',259),
	('Nice job!',11,'',1680,'2010-09-21 14:38:46',260),
	('Add a section for project notes',1,'',1686,'2010-09-21 14:56:12',261),
	('I edited the portfolio link',5,'',1689,'2010-09-21 15:08:15',262),
	('First shot at iTunes Exporter',5,'ad147882ef33f44b1694f431fd5dd6b47b03f9e9',1689,'2010-09-21 15:08:17',263),
	('Included some test info for the Adidas miCoach site',5,'98fc7c0eb1980a27a17d5f0317cc674033f153a8',1689,'2010-09-21 15:08:20',264);

/*!40000 ALTER TABLE `pm_tasks_notes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pm_user_portfolios
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_user_portfolios`;

CREATE TABLE `pm_user_portfolios` (
  `user_id` int(11) NOT NULL default '0',
  `project_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`user_id`,`project_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `pm_user_portfolios_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `pm_users` (`users_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pm_user_portfolios_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `pm_projects` (`projects_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `pm_user_portfolios` WRITE;
/*!40000 ALTER TABLE `pm_user_portfolios` DISABLE KEYS */;
INSERT INTO `pm_user_portfolios` (`user_id`,`project_id`)
VALUES
	(3,3),
	(10,5),
	(11,5),
	(1,6),
	(2,6),
	(3,6),
	(5,6);

/*!40000 ALTER TABLE `pm_user_portfolios` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pm_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_users`;

CREATE TABLE `pm_users` (
  `users_id` int(11) NOT NULL auto_increment,
  `user_name` varchar(60) default NULL,
  `password` char(32) default NULL,
  `email` varchar(60) default NULL,
  `gh_username` varchar(60) default NULL,
  `description` text,
  `image_url` varchar(200) default NULL,
  `date_added` datetime default NULL,
  PRIMARY KEY  (`users_id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `pm_users` WRITE;
/*!40000 ALTER TABLE `pm_users` DISABLE KEYS */;
INSERT INTO `pm_users` (`users_id`,`user_name`,`password`,`email`,`gh_username`,`description`,`image_url`,`date_added`)
VALUES
	(1,'lucaslea','5F4DCC3B5AA765D61D8327DEB882CF99','kariohki@comcast.net','rickosborne','I do things like wireframes, layouts, and basic code.','http://www.gravatar.com/avatar/6a644e2f0c14b9a633e00a1f4887c075','2010-09-21 14:03:29'),
	(2,'arensel','5F4DCC3B5AA765D61D8327DEB882CF99','renz45@hotmail.com','rickosborne','Too busy for a description.','adam.jpg','2010-09-21 14:13:38'),
	(3,'tlieberman','5F4DCC3B5AA765D61D8327DEB882CF99','tlieberman@gmail.com','rickosborne',NULL,'tim.jpg','2010-09-21 14:17:36'),
	(4,'rarutos','5F4DCC3B5AA765D61D8327DEB882CF99','r@gmail.com','rickosborne','Buk buk buk','rarutos.png','2010-09-21 14:25:17'),
	(5,'zacharynicoll','5F4DCC3B5AA765D61D8327DEB882CF99','zacharynicoll@gmail.com','rickosborne',':V','http://www.gravatar.com/avatar/d8537a5c77a809e0c818e5a24631c9ea','2010-09-21 14:27:03'),
	(6,'sobou','5F4DCC3B5AA765D61D8327DEB882CF99','s@gmail.com','rickosborne','I\'m a bear','sobou.gif','2010-09-21 14:27:37'),
	(7,'lyndis','5F4DCC3B5AA765D61D8327DEB882CF99','lyn@gmail.com','rickosborne','I work, you watch','lyndis.gif','2010-09-21 14:28:25'),
	(8,'dystorce','22E5AB5743EA52CAF34ABCC02C0F161D','danstorce@gmail.com','rickosborne',NULL,'dystorce.png','2010-09-21 14:29:05'),
	(9,'pixelate','5F4DCC3B5AA765D61D8327DEB882CF99','pixel@gmail.com','rickosborne',NULL,'pixelate.jpg','2010-09-21 14:29:46'),
	(10,'drumble','5F4DCC3B5AA765D61D8327DEB882CF99','drumble@gmail.com','rickosborne',':ahoy:','drumble.gif','2010-09-21 14:30:12'),
	(11,'try4ce','5F4DCC3B5AA765D61D8327DEB882CF99','forky@gmail.com','rickosborne',':gentlemen:','try4ce.jpg','2010-09-21 14:30:42');

/*!40000 ALTER TABLE `pm_users` ENABLE KEYS */;
UNLOCK TABLES;





/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
