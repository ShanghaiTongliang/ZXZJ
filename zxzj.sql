-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2018-12-03 13:14:39
-- 服务器版本： 10.2.13-MariaDB-log
-- PHP 版本： 7.2.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `zxzj`
--

-- --------------------------------------------------------

--
-- 表的结构 `cheXing`
--

CREATE TABLE `cheXing` (
  `id` smallint(6) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `cheZhong` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `cheXing`
--

INSERT INTO `cheXing` (`id`, `name`, `cheZhong`) VALUES
(1, 'test', 1);

-- --------------------------------------------------------

--
-- 表的结构 `cheZhong`
--

CREATE TABLE `cheZhong` (
  `id` smallint(6) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `daBuWei`
--

CREATE TABLE `daBuWei` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `dengJi`
--

CREATE TABLE `dengJi` (
  `id` tinyint(4) UNSIGNED NOT NULL,
  `name` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `guZhang`
--

CREATE TABLE `guZhang` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `daBuWei` tinyint(3) UNSIGNED DEFAULT NULL,
  `cheZhong` smallint(5) UNSIGNED DEFAULT NULL,
  `xiaoBuWei` smallint(5) UNSIGNED DEFAULT NULL,
  `juTiBuWei` smallint(5) UNSIGNED DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `desc` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `lingBuJianChouJian`
--

CREATE TABLE `lingBuJianChouJian` (
  `id` int(10) UNSIGNED NOT NULL,
  `date` date DEFAULT NULL,
  `xiuCheng` tinyint(3) UNSIGNED DEFAULT NULL,
  `guZhang` smallint(5) UNSIGNED DEFAULT NULL,
  `dengJi` tinyint(3) UNSIGNED DEFAULT NULL,
  `zhiJianYuan` varchar(16) DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `lingBuJianFuJian`
--

CREATE TABLE `lingBuJianFuJian` (
  `id` int(10) UNSIGNED NOT NULL,
  `date` date DEFAULT NULL,
  `xiuCheng` tinyint(3) UNSIGNED DEFAULT NULL,
  `guZhang` smallint(5) UNSIGNED DEFAULT NULL,
  `dengJi` tinyint(3) UNSIGNED DEFAULT NULL,
  `zhiJianYuan` varchar(16) DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `lingBuJianJiaoJian`
--

CREATE TABLE `lingBuJianJiaoJian` (
  `id` int(10) UNSIGNED NOT NULL,
  `date` date DEFAULT NULL,
  `xiuCheng` tinyint(3) UNSIGNED DEFAULT NULL,
  `guZhang` smallint(5) UNSIGNED DEFAULT NULL,
  `dengJi` tinyint(3) UNSIGNED DEFAULT NULL,
  `zhiJianYuan` varchar(16) DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE `user` (
  `id` smallint(6) NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `password` varchar(64) NOT NULL,
  `token` smallint(5) UNSIGNED DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL,
  `buMen` tinyint(3) UNSIGNED DEFAULT NULL,
  `banZu` tinyint(3) UNSIGNED DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `name`, `password`, `token`, `danWei`, `buMen`, `banZu`, `cheJian`) VALUES
(1, 'oblind', 'ddHSDUw8lB75s', 55511, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `xiuCheng`
--

CREATE TABLE `xiuCheng` (
  `id` smallint(6) NOT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `zhengCheJiaoJian`
--

CREATE TABLE `zhengCheJiaoJian` (
  `id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `xiuCheng` tinyint(4) DEFAULT NULL,
  `guZhang` smallint(5) UNSIGNED DEFAULT NULL,
  `dengJi` tinyint(3) UNSIGNED DEFAULT NULL,
  `zhiJianYuan` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转储表的索引
--

--
-- 表的索引 `cheXing`
--
ALTER TABLE `cheXing`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `cheZhong`
--
ALTER TABLE `cheZhong`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `daBuWei`
--
ALTER TABLE `daBuWei`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `dengJi`
--
ALTER TABLE `dengJi`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `guZhang`
--
ALTER TABLE `guZhang`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `lingBuJianChouJian`
--
ALTER TABLE `lingBuJianChouJian`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `lingBuJianFuJian`
--
ALTER TABLE `lingBuJianFuJian`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `lingBuJianJiaoJian`
--
ALTER TABLE `lingBuJianJiaoJian`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xiuCheng`
--
ALTER TABLE `xiuCheng`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `zhengCheJiaoJian`
--
ALTER TABLE `zhengCheJiaoJian`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `cheXing`
--
ALTER TABLE `cheXing`
  MODIFY `id` smallint(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `cheZhong`
--
ALTER TABLE `cheZhong`
  MODIFY `id` smallint(6) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `daBuWei`
--
ALTER TABLE `daBuWei`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `dengJi`
--
ALTER TABLE `dengJi`
  MODIFY `id` tinyint(4) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `guZhang`
--
ALTER TABLE `guZhang`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `lingBuJianChouJian`
--
ALTER TABLE `lingBuJianChouJian`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `lingBuJianFuJian`
--
ALTER TABLE `lingBuJianFuJian`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `lingBuJianJiaoJian`
--
ALTER TABLE `lingBuJianJiaoJian`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `user`
--
ALTER TABLE `user`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `xiuCheng`
--
ALTER TABLE `xiuCheng`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `zhengCheJiaoJian`
--
ALTER TABLE `zhengCheJiaoJian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
