CREATE DATABASE  IF NOT EXISTS `ngInsta` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ngInsta`;
-- MySQL dump 10.13  Distrib 5.7.26, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: ngInsta
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.18.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aliases`
--

DROP TABLE IF EXISTS `aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aliases` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '6b9bd7f0-eacf-45f8-aa40-cba33ff8893a',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `aliasId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `followRequested` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `aliases_ibfk_2` (`aliasId`),
  CONSTRAINT `aliases_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `aliases_ibfk_2` FOREIGN KEY (`aliasId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aliases`
--

LOCK TABLES `aliases` WRITE;
/*!40000 ALTER TABLE `aliases` DISABLE KEYS */;
INSERT INTO `aliases` VALUES ('3c8ab787-b4b4-44d2-a625-63c5fea2f0e4','2019-06-26 14:30:33','2019-06-26 14:30:33','8d4fdc8f-d393-498b-a078-08fc304c6c9c','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3',0),('50785a11-53f0-4eb3-8036-4d80c41cf25c','2019-07-04 17:54:04','2019-07-04 18:15:27','7afe83a4-58e9-4fb8-8135-2db88224caba','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3',0),('61664b8b-5682-44f8-a295-6e9174eb8c31','2019-06-27 18:01:35','2019-06-27 18:01:35','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c',0),('77b248b2-21d9-4dcf-b505-1bbb2aac225a','2019-06-29 16:45:37','2019-06-29 16:45:37','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','969d94c9-69a5-4757-807a-1e57f6e516e1',0),('c71bbc4f-f0e7-40ff-8d45-f8fae3b47cb3','2019-06-26 15:19:06','2019-06-26 15:19:06','969d94c9-69a5-4757-807a-1e57f6e516e1','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3',0),('da5fa61b-7604-4c77-86e0-e23e3c692f4d','2019-07-01 18:09:52','2019-07-01 18:09:55','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','7fb55c72-ff40-4492-974b-33e3309de25d',0),('e6619b09-430c-47ca-b8ad-0af4d7102f80','2019-06-29 15:37:01','2019-06-29 15:37:01','969d94c9-69a5-4757-807a-1e57f6e516e1','8d4fdc8f-d393-498b-a078-08fc304c6c9c',0),('ee282f97-8e30-472b-8544-ea320324d54a','2019-07-06 06:15:55','2019-07-06 06:16:16','7fb55c72-ff40-4492-974b-33e3309de25d','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3',0);
/*!40000 ALTER TABLE `aliases` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ngInsta`.`user_followed_insert` AFTER INSERT ON `aliases` FOR EACH ROW
BEGIN
	IF (NEW.followRequested IS NOT NULL AND NEW.followRequested = 0) THEN
		
		CALL addFollowStatus(new.userId, new.aliasId);
	
		INSERT INTO notifications(id, userId, aliasId, postId, type, status) VALUES( (SELECT UUID()), new.userId, new.aliasId, null, 'other-userfollowed', false);
    
    ELSE
    
    INSERT INTO notifications(id, userId, aliasId, postId, type, status) VALUES((SELECT UUID()), new.userId, new.aliasId , null, 'followrequest', false);
	
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ngInsta`.`user_followed_update` AFTER UPDATE ON `aliases` FOR EACH ROW
BEGIN
 IF (NEW.followRequested IS NOT NULL AND NEW.followRequested = 0) THEN
            CALL addFollowStatus(new.userId, new.aliasId);
			DELETE FROM notifications where userId = new.userId and aliasId = new.aliasId and type = 'followrequest';
            INSERT INTO notifications(id, userId, aliasId, postId, type, status) VALUES((SELECT UUID()), new.aliasId, new.userId , null, 'other-followaccepted', false);
      END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger user_unfollowed after delete on aliases
for each row begin
	CALL removeFollowStatus(old.userId, old.aliasId, old.followRequested);
	DELETE FROM notifications where userId = old.userId and aliasId = old.aliasId and (type = 'other-userfollowed' or type = 'other-followaccepted' or type = 'followrequest');

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '77a7a357-b879-40e3-8e98-22dc9ba13fd1',
  `commentText` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `postId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `postId` (`postId`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES ('0051cace-8253-42fb-9e00-073adc496062','np.','2019-07-03 04:11:21','2019-07-03 04:11:21','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','b22ada84-8440-401d-971f-93f3680e6146'),('18e16cac-7ec9-4246-8cba-ae700affecf0','welcome','2019-07-03 04:09:15','2019-07-03 04:09:15','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','b22ada84-8440-401d-971f-93f3680e6146'),('1d639576-9b62-4339-85ec-b76ccfca6470','This is a test comment.','2019-07-02 16:23:45','2019-07-02 16:23:45','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('37ee6241-1a2c-4f71-9fcd-5a5959c912b2','Good Luck!!','2019-07-04 03:50:27','2019-07-04 03:50:27','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','43c230ba-6f02-4909-9c7d-8177ac631735'),('38aa55a3-7942-4ed3-8fa4-7f83d89debd1','Haha.','2019-07-06 03:03:27','2019-07-06 03:03:27','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('453df6f5-61f5-4b52-a8d2-11d2cb40529d','awesome post man','2019-07-02 16:28:42','2019-07-02 16:28:42','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('5e0a6e59-2138-420d-b0b9-8198e3b0c4fc','it is 9:30 pm','2019-07-03 16:56:30','2019-07-03 16:56:30','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('64e7c4cc-f81c-4461-8e74-af87293c2082','great artwork buddy.','2019-07-03 02:19:44','2019-07-03 02:19:44','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','94be1f24-fe88-4171-8647-aeae875161e7'),('68912f33-b24a-402b-b086-3e4531be7c65','hey bro aja ghumna jaam hai','2019-07-02 16:44:18','2019-07-02 16:44:18','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('7438f4c2-eade-4110-b9f9-8f0c4257de0e','i am also saying the same thing','2019-07-02 16:44:40','2019-07-02 16:44:40','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('8571edeb-10f1-4551-8777-39af863bfbca','Every day man. Everyday.','2019-06-28 01:52:19','2019-06-28 01:52:19','969d94c9-69a5-4757-807a-1e57f6e516e1','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('85b727e3-284f-48b4-ad0f-72e1fd4f3fa3','thanks.','2019-07-03 04:04:25','2019-07-03 04:04:25','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','b22ada84-8440-401d-971f-93f3680e6146'),('86ca2a03-923d-4ac8-850d-eacfd74dc6eb','amazing view','2019-07-02 18:33:20','2019-07-02 18:33:20','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','b22ada84-8440-401d-971f-93f3680e6146'),('95014494-ba8b-41b3-aabf-028e881b89c7','ok','2019-07-03 02:17:39','2019-07-03 02:17:39','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','94be1f24-fe88-4171-8647-aeae875161e7'),('9a9d9c34-f995-4009-adb3-fdebb18b82ee','Beautiful place','2019-07-03 16:57:55','2019-07-03 16:57:55','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','b22ada84-8440-401d-971f-93f3680e6146'),('c0568acb-e165-47af-8bb3-b538b7bfe965','test comment','2019-07-03 16:53:05','2019-07-03 16:53:05','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('db9ed0e9-b7ca-4901-846f-56dc0347b8ef','yeah. I agree','2019-07-02 16:45:28','2019-07-02 16:45:28','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('f7aa6964-e9ad-4c71-8ee0-a5cc7984312e','No support for emoji for now','2019-07-02 16:54:16','2019-07-02 16:54:16','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('faea9150-6be1-4ede-92cc-62763ec83c02','this is a bug fix comment','2019-07-02 16:44:02','2019-07-02 16:44:02','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('fe26a7df-255f-45e8-a1a8-d2e4dde25ba2','yeah.. we have to go there\nWe have to go there','2019-07-06 06:17:30','2019-07-06 06:17:30','7fb55c72-ff40-4492-974b-33e3309de25d','b22ada84-8440-401d-971f-93f3680e6146');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger new_comment_added after insert on comments
for each row begin

   declare uid CHAR(36);
   
	update posts set commentsNo = commentsNo +1 where id = NEW.postId;
    
    SELECT userId into uid from posts where posts.id = new.postId;
    
    IF (uid != new.userId ) THEN
    
    INSERT INTO notifications(id, userId, aliasId, postId, type, status) VALUES((SELECT UUID()), new.userId, uid , new.postId, 'other-comment', false);
    
    END IF;
    
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger comment_deleted after delete on comments
for each row begin
	update posts set commentsNo = commentsNo -1 where id = old.postId;
     DELETE FROM notifications where userId = old.userId and postId = old.postId and type = 'other-comment';
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '8e26ab66-ed2a-4b94-89a8-3523c79bb8b2',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `postId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `postId` (`postId`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES ('087eb7da-4391-46c6-916e-1612f26c37be','2019-07-04 03:50:00','2019-07-04 03:50:00','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('31ef3c69-7801-40aa-afd8-9048a6a86111','2019-07-04 04:03:08','2019-07-04 04:03:08','969d94c9-69a5-4757-807a-1e57f6e516e1','d8abbd6e-fe43-467c-b77e-31e9537a9f19'),('3beaec68-281e-4b04-bcc2-ab11d1241ba2','2019-07-04 04:02:44','2019-07-04 04:02:44','969d94c9-69a5-4757-807a-1e57f6e516e1','5ca07f3e-839e-43a2-b99f-792d97073194'),('46e3830c-8c30-4797-9a3b-f22a2a05f896','2019-07-06 06:16:58','2019-07-06 06:16:58','7fb55c72-ff40-4492-974b-33e3309de25d','5ca07f3e-839e-43a2-b99f-792d97073194'),('5e396aa2-ff90-4582-83ff-51809eac7348','2019-07-04 04:03:06','2019-07-04 04:03:06','969d94c9-69a5-4757-807a-1e57f6e516e1','9852b6ce-51f2-43c2-9455-611b30e2d415'),('a18d2149-d139-4af1-bcd5-f9ec6bc35af0','2019-07-03 15:26:05','2019-07-03 15:26:05','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','1ee01367-9786-4a43-8fef-4f05318e3756'),('a350313b-81e2-4bf7-b0c2-39f6f319a48e','2019-07-04 18:40:14','2019-07-04 18:40:14','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','b286c773-5868-48c7-9c83-484630f646cf'),('aae88a63-313c-41b7-bf28-cc65c3307692','2019-07-03 15:02:15','2019-07-03 15:02:15','969d94c9-69a5-4757-807a-1e57f6e516e1','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('ae6b2a47-0aa0-4b0c-ad05-c82e8a914767','2019-07-01 16:52:01','2019-07-01 16:52:01','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8c187fb9-317c-4a3f-922e-1f6b3969ce41'),('b173431f-cc9b-44c1-b2ed-3642e3913863','2019-07-04 04:03:10','2019-07-04 04:03:10','969d94c9-69a5-4757-807a-1e57f6e516e1','b22ada84-8440-401d-971f-93f3680e6146'),('bfb560cb-5686-4c69-bfae-5195c1a8143d','2019-07-06 06:17:00','2019-07-06 06:17:00','7fb55c72-ff40-4492-974b-33e3309de25d','9852b6ce-51f2-43c2-9455-611b30e2d415'),('c74f7917-0a5d-4d20-a6ed-d2ba46706dc1','2019-07-06 06:17:02','2019-07-06 06:17:02','7fb55c72-ff40-4492-974b-33e3309de25d','d8abbd6e-fe43-467c-b77e-31e9537a9f19'),('d2ac7fa9-1618-4411-8ab9-e3d69c6b7941','2019-07-03 02:20:51','2019-07-03 02:20:51','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','94be1f24-fe88-4171-8647-aeae875161e7'),('e0cfaf55-ae3c-4c70-8f3a-0fb7f449b7bf','2019-07-04 18:15:43','2019-07-04 18:15:43','7afe83a4-58e9-4fb8-8135-2db88224caba','5ca07f3e-839e-43a2-b99f-792d97073194'),('f25c7b14-298f-4a6f-8367-e523ea055da5','2019-07-06 06:17:03','2019-07-06 06:17:03','7fb55c72-ff40-4492-974b-33e3309de25d','b22ada84-8440-401d-971f-93f3680e6146');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger post_liked after insert on likes
for each row begin

	declare id CHAR(36);
    
    SELECT userId into id from posts where posts.id = new.postId;
    
	update posts set likesNo = likesNo +1 where posts.id = new.postId;
    
    INSERT INTO notifications(id, userId, aliasId, postId, type, status) VALUES((SELECT UUID()), new.userId, id , new.postId, 'other-like', false);
    
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger post_unliked after delete on likes
for each row begin
    
	update posts set likesNo = likesNo -1 where id = old.postId;
    
    DELETE FROM notifications where userId = old.userId and postId = old.postId and type = 'other-like';
        
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '860684a0-a666-4d5b-93a2-088cfc918310',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL,
  `userId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `aliasId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `postId` char(36) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `aliasId` (`aliasId`),
  KEY `postId` (`postId`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`aliasId`) REFERENCES `users` (`id`),
  CONSTRAINT `notifications_ibfk_3` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES ('05bf8b10-9d39-11e9-8611-448a5b901424',1,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-03 02:19:44','2019-07-04 17:45:10','94be1f24-fe88-4171-8647-aeae875161e7'),('06c80b5e-9cea-11e9-8611-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-02 16:54:16','2019-07-02 16:54:16','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('0723230f-9db3-11e9-924a-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-03 16:53:05','2019-07-03 16:53:05','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('2968576a-9e8b-11e9-a9d1-448a5b901424',0,'other-like','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-04 18:40:14','2019-07-04 18:40:14','b286c773-5868-48c7-9c83-484630f646cf'),('2d93188d-9d39-11e9-8611-448a5b901424',0,'other-like','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-03 02:20:51','2019-07-03 02:20:51','94be1f24-fe88-4171-8647-aeae875161e7'),('6dbcdb96-9c2b-11e9-87de-448a5b901424',1,'other-followaccepted','7fb55c72-ff40-4492-974b-33e3309de25d','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-01 18:09:55','2019-07-04 18:08:13',NULL),('7482b481-9ce6-11e9-8611-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-02 16:28:42','2019-07-02 16:28:42','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('812aa469-9db3-11e9-924a-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-03 16:56:30','2019-07-03 16:56:30','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('8c4da168-9c20-11e9-87de-448a5b901424',0,'other-like','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-01 16:52:01','2019-07-01 16:52:01','8c187fb9-317c-4a3f-922e-1f6b3969ce41'),('9005ddb4-9fb5-11e9-b007-448a5b901424',0,'other-followaccepted','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','7fb55c72-ff40-4492-974b-33e3309de25d','2019-07-06 06:16:16','2019-07-06 06:16:16',NULL),('93dda0d3-9e10-11e9-bbb6-448a5b901424',1,'other-like','969d94c9-69a5-4757-807a-1e57f6e516e1','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-04 04:02:44','2019-07-04 18:08:13','5ca07f3e-839e-43a2-b99f-792d97073194'),('98c12708-9ce8-11e9-8611-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-02 16:44:02','2019-07-02 16:44:02','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('a08d4d27-9f9a-11e9-b007-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-06 03:03:27','2019-07-06 03:03:27','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('a10b0afc-9e10-11e9-bbb6-448a5b901424',1,'other-like','969d94c9-69a5-4757-807a-1e57f6e516e1','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-04 04:03:06','2019-07-04 18:08:13','9852b6ce-51f2-43c2-9455-611b30e2d415'),('a1be9112-9e10-11e9-bbb6-448a5b901424',1,'other-like','969d94c9-69a5-4757-807a-1e57f6e516e1','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-04 04:03:08','2019-07-04 18:04:53','d8abbd6e-fe43-467c-b77e-31e9537a9f19'),('a2730bce-9ce8-11e9-8611-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-02 16:44:18','2019-07-02 16:44:18','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('a2f154e8-9e10-11e9-bbb6-448a5b901424',1,'other-like','969d94c9-69a5-4757-807a-1e57f6e516e1','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-04 04:03:10','2019-07-04 18:04:53','b22ada84-8440-401d-971f-93f3680e6146'),('a5b022ef-9d47-11e9-8611-448a5b901424',1,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-03 04:04:25','2019-07-04 18:08:13','b22ada84-8440-401d-971f-93f3680e6146'),('a948490d-9fb5-11e9-b007-448a5b901424',1,'other-like','7fb55c72-ff40-4492-974b-33e3309de25d','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-06 06:16:58','2019-07-06 06:17:51','5ca07f3e-839e-43a2-b99f-792d97073194'),('aa324d67-9fb5-11e9-b007-448a5b901424',1,'other-like','7fb55c72-ff40-4492-974b-33e3309de25d','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-06 06:17:00','2019-07-06 06:17:51','9852b6ce-51f2-43c2-9455-611b30e2d415'),('ab3ca6e4-9fb5-11e9-b007-448a5b901424',1,'other-like','7fb55c72-ff40-4492-974b-33e3309de25d','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-06 06:17:02','2019-07-06 06:17:51','d8abbd6e-fe43-467c-b77e-31e9537a9f19'),('ac13a20c-9fb5-11e9-b007-448a5b901424',1,'other-like','7fb55c72-ff40-4492-974b-33e3309de25d','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-06 06:17:03','2019-07-06 06:17:51','b22ada84-8440-401d-971f-93f3680e6146'),('afb574aa-9ce8-11e9-8611-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-02 16:44:40','2019-07-02 16:44:40','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('b2e9970f-9e87-11e9-a9d1-448a5b901424',1,'other-followaccepted','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','7afe83a4-58e9-4fb8-8135-2db88224caba','2019-07-04 18:15:27','2019-07-04 18:15:34',NULL),('bafc1b87-9d38-11e9-8611-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-03 02:17:39','2019-07-03 02:17:39','94be1f24-fe88-4171-8647-aeae875161e7'),('bbe6d17a-9fb5-11e9-b007-448a5b901424',1,'other-comment','7fb55c72-ff40-4492-974b-33e3309de25d','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-06 06:17:30','2019-07-06 06:17:51','b22ada84-8440-401d-971f-93f3680e6146'),('bcb124d9-9e87-11e9-a9d1-448a5b901424',1,'other-like','7afe83a4-58e9-4fb8-8135-2db88224caba','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-04 18:15:43','2019-07-04 18:15:53','5ca07f3e-839e-43a2-b99f-792d97073194'),('c3a5b992-9ce5-11e9-8611-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-02 16:23:45','2019-07-02 16:23:45','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('cc2b44dc-9e0e-11e9-bbb6-448a5b901424',0,'other-like','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-04 03:50:00','2019-07-04 03:50:00','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('cc47f0bb-9ce8-11e9-8611-448a5b901424',0,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-02 16:45:28','2019-07-02 16:45:28','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec'),('dc3f792d-9e0e-11e9-bbb6-448a5b901424',1,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','7afe83a4-58e9-4fb8-8135-2db88224caba','2019-07-04 03:50:27','2019-07-04 18:15:34','43c230ba-6f02-4909-9c7d-8177ac631735'),('ddb2f6d8-9cf7-11e9-8611-448a5b901424',1,'other-comment','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','2019-07-02 18:33:20','2019-07-04 18:08:13','b22ada84-8440-401d-971f-93f3680e6146'),('dfa18033-9da6-11e9-924a-448a5b901424',0,'other-like','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','8d4fdc8f-d393-498b-a078-08fc304c6c9c','2019-07-03 15:26:05','2019-07-03 15:26:05','1ee01367-9786-4a43-8fef-4f05318e3756');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '9448d2d6-de4a-4e21-86dc-2d8803742cb0',
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `postImage` varchar(255) NOT NULL,
  `caption` varchar(255) NOT NULL,
  `likesNo` int(11) DEFAULT '0',
  `commentsNo` int(11) DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `location` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES ('1ee01367-9786-4a43-8fef-4f05318e3756',NULL,NULL,'uploads/posts/1ee01367-9786-4a43-8fef-4f05318e3756-1561659242950.png','post by admin dev-3',1,0,'2019-06-27 18:11:15','2019-06-27 18:14:02','8d4fdc8f-d393-498b-a078-08fc304c6c9c',NULL),('43c230ba-6f02-4909-9c7d-8177ac631735',NULL,NULL,'uploads/posts/4c6ac085-707c-4c7a-8476-11d74aad3b00-1561659233087.jpeg','Out of Copa America. Next TIme.',0,1,'2019-07-04 03:48:12','2019-07-04 03:48:12','7afe83a4-58e9-4fb8-8135-2db88224caba',NULL),('4c6ac085-707c-4c7a-8476-11d74aad3b00',NULL,NULL,'uploads/posts/4c6ac085-707c-4c7a-8476-11d74aad3b00-1561659233087.jpeg','post by admin dev-4',0,0,'2019-06-27 18:11:19','2019-06-27 18:13:53','8d4fdc8f-d393-498b-a078-08fc304c6c9c',NULL),('5ca07f3e-839e-43a2-b99f-792d97073194',27.7172,NULL,'uploads/posts/5ca07f3e-839e-43a2-b99f-792d97073194-1562212399256.jpeg','My Profle Picture',3,0,'2019-07-04 03:53:18','2019-07-04 03:53:19','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','Kathmandu'),('71f901fe-e21e-40bd-a9e8-cd04beab188f',NULL,NULL,'uploads/posts/71f901fe-e21e-40bd-a9e8-cd04beab188f-1561659267572.jpeg','post by admin dev-2',0,0,'2019-06-27 18:11:10','2019-06-27 18:14:27','8d4fdc8f-d393-498b-a078-08fc304c6c9c',NULL),('8c187fb9-317c-4a3f-922e-1f6b3969ce41',NULL,NULL,'uploads/posts/8c187fb9-317c-4a3f-922e-1f6b3969ce41-1561659279800.png','post by admin dev-1',1,0,'2019-06-27 18:11:03','2019-06-27 18:14:39','8d4fdc8f-d393-498b-a078-08fc304c6c9c',NULL),('94be1f24-fe88-4171-8647-aeae875161e7',NULL,NULL,'uploads/posts/94be1f24-fe88-4171-8647-aeae875161e7-1561603948680.png','post by admin dev',1,0,'2019-06-25 17:55:53','2019-06-27 02:52:28','8d4fdc8f-d393-498b-a078-08fc304c6c9c',NULL),('9852b6ce-51f2-43c2-9455-611b30e2d415',27.7172,NULL,'uploads/posts/9852b6ce-51f2-43c2-9455-611b30e2d415-1562205923769.png','After 4 years of Bachelor!!!',2,0,'2019-07-04 02:05:23','2019-07-04 02:05:23','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','Kathmandu'),('b22ada84-8440-401d-971f-93f3680e6146',123,NULL,'uploads/posts/b22ada84-8440-401d-971f-93f3680e6146-1561747920866.jpg','Switzerland !!',2,6,'2019-06-28 18:51:57','2019-06-28 18:52:01','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3',NULL),('b286c773-5868-48c7-9c83-484630f646cf',NULL,NULL,'uploads/posts/b286c773-5868-48c7-9c83-484630f646cf-1561659216245.png','post by admin dev-5',1,0,'2019-06-27 18:11:24','2019-06-27 18:13:36','8d4fdc8f-d393-498b-a078-08fc304c6c9c',NULL),('c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec',NULL,NULL,'uploads/posts/c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec-1561659203244.jpg','post by admin dev-6',2,11,'2019-06-27 18:11:28','2019-06-27 18:13:23','8d4fdc8f-d393-498b-a078-08fc304c6c9c','Home'),('d8abbd6e-fe43-467c-b77e-31e9537a9f19',27.7172,NULL,'uploads/posts/d8abbd6e-fe43-467c-b77e-31e9537a9f19-1562177410363.png','1 year back!!!',2,0,'2019-07-03 18:10:10','2019-07-03 18:10:10','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger new_post_added after insert on posts
for each row begin
	update users set noOfPosts = noOfPosts +1 where id = NEW.userId;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger new_post_deleted after delete on posts
for each row begin
	update users set noOfPosts = noOfPosts -1 where id = OLD.userId;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `saveposts`
--

DROP TABLE IF EXISTS `saveposts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `saveposts` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT 'af371a73-4335-4f28-9bd2-a87f6f6f53e0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `postId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `postId` (`postId`),
  CONSTRAINT `saveposts_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `saveposts_ibfk_2` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saveposts`
--

LOCK TABLES `saveposts` WRITE;
/*!40000 ALTER TABLE `saveposts` DISABLE KEYS */;
INSERT INTO `saveposts` VALUES ('c28bce1c-8c39-497a-bf6a-e4388ac251ed','2019-07-03 18:13:43','2019-07-03 18:13:43','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','c2d2706d-f6c5-4c9d-b410-ebfb7daad4ec');
/*!40000 ALTER TABLE `saveposts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3',
  `username` varchar(255) NOT NULL,
  `displayName` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `userImage` varchar(255) DEFAULT 'uploads/profile/default-user.png',
  `privateProfile` tinyint(1) NOT NULL DEFAULT '0',
  `followers` int(11) DEFAULT '0',
  `following` int(11) DEFAULT '0',
  `noOfPosts` int(11) DEFAULT '0',
  `bio` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3','anupbista','Anup Bista','$2b$10$lLRIJXtj0fMQFqufq99O4u21lsPY34IaKGfkLwd5vlchuIiB9XD5u','bistaanup77@gmail.com','uploads/profile/1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3-1562293788941.png',1,4,3,4,'This is a clone project made by me.','www.anupbista.com.np',NULL,'Male','2019-06-24 14:37:49','2019-07-05 02:29:49'),('7afe83a4-58e9-4fb8-8135-2db88224caba','messi','Lional Messi','$2b$10$kSFVg8E3YtmWhZcztFycsuFDgmDN6mIRS.K2vEXiU8IlzXldyWSPC','messi@gmail.com','uploads/profile/default-user.png',0,0,1,1,NULL,NULL,NULL,NULL,'2019-07-03 03:20:37','2019-07-03 03:20:37'),('7fb55c72-ff40-4492-974b-33e3309de25d','ronaldo','Cristiano Ronaldo','$2b$10$eKDL1b3n0fEDUJwCFRRpl.RJUvKIkUwZw0SB22utYCGac6tJmkT8O','ronaldo@gmail.com','uploads/profile/default-user.png',1,1,1,0,NULL,NULL,NULL,NULL,'2019-07-01 15:03:59','2019-07-01 15:03:59'),('8d4fdc8f-d393-498b-a078-08fc304c6c9c','admindev','Admin Dev','$2b$10$oN26RGdO72x.b8Vt1Bx/d.zoyTMwSZ4viBOgXD0EFCyyz7PK3gDCi','admin-dev@gmail.com','uploads/profile/8d4fdc8f-d393-498b-a078-08fc304c6c9c-1561604082586.png',0,2,1,7,NULL,NULL,NULL,NULL,'2019-06-25 17:43:10','2019-06-27 02:54:42'),('969d94c9-69a5-4757-807a-1e57f6e516e1','adrsh1234','Adarsha Bista','$2b$10$saTY.8DJYLf9uZtwxMlHDO7w6eqCLK.jmrX.c5pl8BuIJrEQC7ogC','adrsh07@gmail.com','uploads/profile/969d94c9-69a5-4757-807a-1e57f6e516e1-1561783194121.jpeg',1,1,2,0,'A Scary Crow',NULL,NULL,NULL,'2019-06-24 14:48:20','2019-07-04 04:01:49'),('d297acc2-b886-4044-8e98-f7fe1e1567af','benzema','Karim Benzema','$2b$10$FRktRzZoL60uHSZLUIBWx.KcfQKAjYCoWBNGzQjvth8WdO8ndbMnC','benzema@gmail.com','uploads/profile/969d94c9-69a5-4757-807a-1e57f6e516e1-1561783194121.jpeg',0,0,0,0,NULL,NULL,NULL,NULL,'2019-07-04 18:19:50','2019-07-04 18:19:50'),('dddca940-3e44-411d-9875-ab200ddbb1fc','hazard','Eden Hazard','$2b$10$OpHlNQHMbubRPHRCwCslBuqFeQIYhk5Ori3uOa0Ra/nIfsqMMb0Mu','hazard@gmail.com','uploads/profile/default-user.png',0,0,0,0,NULL,NULL,NULL,NULL,'2019-07-04 18:22:56','2019-07-04 18:22:56'),('f956dff3-0704-47b3-8fcf-7df7b63cd94a','modric','Luka Modric','$2b$10$WmwG1U87EDOvShSPdabh7.dc82Baifs5dKny4VaJd6E2eW1jzlHJG','modric@gmail.com','uploads/profile/default-user.png',0,0,0,0,NULL,'Real Madrid C.F. Player',NULL,NULL,'2019-07-04 18:37:37','2019-07-04 18:38:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usertokens`
--

DROP TABLE IF EXISTS `usertokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usertokens` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '9c49e7f0-684b-415b-9c85-8ea6ab05563d',
  `token` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `usertokens_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usertokens`
--

LOCK TABLES `usertokens` WRITE;
/*!40000 ALTER TABLE `usertokens` DISABLE KEYS */;
INSERT INTO `usertokens` VALUES ('2009d663-43c7-44c7-98c6-7173668e6e19','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuZ0luc3RhIiwic3ViIjoiMWE0ZjVhY2ItOWQyMS00NzIzLWJmYjAtZmUyZWVhODRjOWQzIiwiaWF0IjoxNTYyMzgzNzk1NDQwLCJleHAiOjE1NjI0NzAxOTU0NDB9.ww2vYbzxwRXHDyqRv3FjweQMrIAI2nMs4kJV3A9-tNk','2019-07-06 03:29:55','2019-07-06 03:29:55','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3'),('218a5f01-195b-4050-b60c-59cb310603f0','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuZ0luc3RhIiwic3ViIjoiN2ZiNTVjNzItZmY0MC00NDkyLTk3NGItMzNlMzMwOWRlMjVkIiwiaWF0IjoxNTYyMjU2ODYwNTM3LCJleHAiOjE1NjIzNDMyNjA1Mzd9.lyP4fQGjOsOTFWmJcW3HuZ615_GHCmIGYu0D1KyEEwM','2019-07-04 16:14:20','2019-07-04 16:14:20','7fb55c72-ff40-4492-974b-33e3309de25d'),('26f59ff9-156e-4b41-9d0c-507dea8dd6ee','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuZ0luc3RhIiwic3ViIjoiMWE0ZjVhY2ItOWQyMS00NzIzLWJmYjAtZmUyZWVhODRjOWQzIiwiaWF0IjoxNTYyMjU5NTcwMzM0LCJleHAiOjE1NjIzNDU5NzAzMzR9.Vbu4Kwanq_euqJnBTSmu7U5lVR9aBcNUUmLDQ8YPswY','2019-07-04 16:59:30','2019-07-04 16:59:30','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3'),('33a60d82-f2a5-4752-8c4d-e7b75b99a1f5','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuZ0luc3RhIiwic3ViIjoiN2FmZTgzYTQtNThlOS00ZmI4LTgxMzUtMmRiODgyMjRjYWJhIiwiaWF0IjoxNTYyMjY0MTMzMDczLCJleHAiOjE1NjIzNTA1MzMwNzN9.JmFFMA6N7voODJyP6dgEY2zM51BRyYadqcTpAUdqYT0','2019-07-04 18:15:33','2019-07-04 18:15:33','7afe83a4-58e9-4fb8-8135-2db88224caba'),('c6c86630-da01-4eed-a43f-4eccc2069114','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuZ0luc3RhIiwic3ViIjoiMWE0ZjVhY2ItOWQyMS00NzIzLWJmYjAtZmUyZWVhODRjOWQzIiwiaWF0IjoxNTYyMzg0MDQwMjcyLCJleHAiOjE1NjI0NzA0NDAyNzJ9.Og6HzI20LUvEWEA0ckqMZt9JGhpz--stiDZD3EorCd4','2019-07-06 03:34:00','2019-07-06 03:34:00','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3'),('d9117811-c7c4-43e9-83e3-4b3b058f1c8d','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuZ0luc3RhIiwic3ViIjoiMWE0ZjVhY2ItOWQyMS00NzIzLWJmYjAtZmUyZWVhODRjOWQzIiwiaWF0IjoxNTYyMjY1NTAxMDgyLCJleHAiOjE1NjIzNTE5MDEwODJ9.kqfYGHsv8UibNOMFRWHOD5DgjSkyMUl4Yc5RgAqsm5c','2019-07-04 18:38:21','2019-07-04 18:38:21','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3'),('dc53b384-2a4b-488f-8bf8-ce62bff1e630','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuZ0luc3RhIiwic3ViIjoiMWE0ZjVhY2ItOWQyMS00NzIzLWJmYjAtZmUyZWVhODRjOWQzIiwiaWF0IjoxNTYyMjU3NTIwMTA4LCJleHAiOjE1NjIzNDM5MjAxMDh9.4OAIPV8W13XGG_XpXK4ngoXiuz2hStP_pCIlkoaCj8Q','2019-07-04 16:25:20','2019-07-04 16:25:20','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3'),('e82b9b2e-f207-4cd6-8856-515c2421f107','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuZ0luc3RhIiwic3ViIjoiMWE0ZjVhY2ItOWQyMS00NzIzLWJmYjAtZmUyZWVhODRjOWQzIiwiaWF0IjoxNTYyMjUyNjE2MzMyLCJleHAiOjE1NjIzMzkwMTYzMzJ9.LHiOEpYViCYh_UaB3lRF_Qi5egW1tPHP_znnFTsS3zc','2019-07-04 15:03:36','2019-07-04 15:03:36','1a4f5acb-9d21-4723-bfb0-fe2eea84c9d3');
/*!40000 ALTER TABLE `usertokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ngInsta'
--

--
-- Dumping routines for database 'ngInsta'
--
/*!50003 DROP PROCEDURE IF EXISTS `addFollowStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addFollowStatus`(userId CHAR(36), aliasId CHAR(36))
BEGIN
	update users set following = following +1 where id = userId;
    update users set followers = followers +1 where id = aliasId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `removeFollowStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `removeFollowStatus`(userId CHAR(36), aliasId CHAR(36), followRequested TINYINT(1))
BEGIN
	IF followRequested = 0 THEN
	update users set following = following -1 where id = userId;
    update users set followers = followers -1 where id = aliasId;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-06 12:09:31
