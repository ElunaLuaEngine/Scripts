DROP TABLE IF EXISTS `redemption`;
CREATE TABLE `redemption` (
`passphrase` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
`type` int(32) NOT NULL DEFAULT '0',
`entry` int(32) NOT NULL DEFAULT '0',
`count` int(32) NOT NULL DEFAULT '0',
`redeemed` int(32) NOT NULL DEFAULT '0',
`player_guid` int(32) DEFAULT NULL,
`date` varchar(32) DEFAULT NULL,
PRIMARY KEY (`passphrase`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;