-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2018-12-11 13:47:56
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

--
-- 转存表中的数据 `cheZhong`
--

INSERT INTO `cheZhong` (`id`, `name`) VALUES
(1, '通用型号'),
(2, 'C车'),
(3, 'P车'),
(4, 'G车'),
(5, 'N车');

-- --------------------------------------------------------

--
-- 表的结构 `daBuWei`
--

CREATE TABLE `daBuWei` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `daBuWei`
--

INSERT INTO `daBuWei` (`id`, `name`) VALUES
(1, '车体'),
(2, '底架'),
(3, '转向架'),
(4, '基础制动装置'),
(5, '空气制动装置'),
(6, '制动阀内部装置'),
(7, '车钩缓冲装置'),
(8, '轮轴'),
(9, '整车落成检查');

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
  `cheZhong` smallint(5) UNSIGNED DEFAULT NULL,
  `daBuWei` tinyint(5) UNSIGNED DEFAULT NULL,
  `xiaoBuWei` smallint(5) UNSIGNED DEFAULT NULL,
  `juTiBuWei` smallint(5) UNSIGNED DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `desc` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `guZhang`
--

INSERT INTO `guZhang` (`id`, `cheZhong`, `daBuWei`, `xiaoBuWei`, `juTiBuWei`, `name`, `desc`) VALUES
(1, 1, 1, 1, 1, 'test', 'test'),
(2, 1, 1, 1, 1, 'aaa', 'aaa');

-- --------------------------------------------------------

--
-- 表的结构 `juTiBuWei`
--

CREATE TABLE `juTiBuWei` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `name` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `juTiBuWei`
--

INSERT INTO `juTiBuWei` (`id`, `name`) VALUES
(1, '缓解阀拉杆座螺栓'),
(2, '扶手'),
(3, '漏雨试验'),
(4, '水压试验'),
(5, '安全阀试验');

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
(1, 'oblind', 'ddHSDUw8lB75s', 19784, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `xiaoBuWei`
--

CREATE TABLE `xiaoBuWei` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `xiaoBuWei`
--

INSERT INTO `xiaoBuWei` (`id`, `name`) VALUES
(1, '缓解阀拉杆座'),
(2, '车体检查'),
(3, '地板'),
(4, '端墙'),
(5, '侧墙');

-- --------------------------------------------------------

--
-- 表的结构 `xiuCheng`
--

CREATE TABLE `xiuCheng` (
  `id` smallint(6) NOT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `xiuCheng`
--

INSERT INTO `xiuCheng` (`id`, `name`) VALUES
(1, '入段厂修'),
(2, '段修'),
(3, '辅修'),
(4, '临修'),
(5, '大修'),
(6, '新造');

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
-- 转存表中的数据 `zhengCheJiaoJian`
--

INSERT INTO `zhengCheJiaoJian` (`id`, `date`, `xiuCheng`, `guZhang`, `dengJi`, `zhiJianYuan`) VALUES
(1, '2018-12-11', 1, 1, 1, '一班');

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
-- 表的索引 `juTiBuWei`
--
ALTER TABLE `juTiBuWei`
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
-- 表的索引 `xiaoBuWei`
--
ALTER TABLE `xiaoBuWei`
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
  MODIFY `id` smallint(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `daBuWei`
--
ALTER TABLE `daBuWei`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- 使用表AUTO_INCREMENT `dengJi`
--
ALTER TABLE `dengJi`
  MODIFY `id` tinyint(4) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `guZhang`
--
ALTER TABLE `guZhang`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `juTiBuWei`
--
ALTER TABLE `juTiBuWei`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
-- 使用表AUTO_INCREMENT `xiaoBuWei`
--
ALTER TABLE `xiaoBuWei`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `xiuCheng`
--
ALTER TABLE `xiuCheng`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用表AUTO_INCREMENT `zhengCheJiaoJian`
--
ALTER TABLE `zhengCheJiaoJian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
