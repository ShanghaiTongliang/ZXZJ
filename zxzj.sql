-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2019-05-28 12:52:51
-- 服务器版本： 10.3.13-MariaDB
-- PHP 版本： 7.2.16

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
-- 表的结构 `cheJian`
--

CREATE TABLE `cheJian` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- 转存表中的数据 `cheJian`
--

INSERT INTO `cheJian` (`id`, `name`, `danWei`) VALUES
(1, '南翔站修', 1),
(2, '阜阳站修', 1),
(3, '合肥东站修', 1),
(4, '连云港站修', 2),
(5, '徐州站修', 2),
(6, '蚌埠站修', 2),
(7, '南京东站修', 2),
(8, '芜湖站修', 1),
(9, '乔司站修', 1),
(10, '金华站修', 1);

-- --------------------------------------------------------

--
-- 表的结构 `cheXing`
--

CREATE TABLE `cheXing` (
  `id` smallint(6) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- 转存表中的数据 `cheXing`
--

INSERT INTO `cheXing` (`id`, `name`) VALUES
(1, 'C100'),
(2, 'C100A'),
(3, 'C100AH'),
(4, 'C100H'),
(5, 'C16AK'),
(6, 'C16K'),
(7, 'C50'),
(8, 'C61'),
(9, 'C61E'),
(10, 'C61K'),
(11, 'C61T'),
(12, 'C61YK'),
(13, 'C62'),
(14, 'C62A'),
(15, 'C62AK'),
(16, 'C62AT'),
(17, 'C62B'),
(18, 'C62BK'),
(19, 'C62BT'),
(20, 'C62M'),
(21, 'C63'),
(22, 'C63A'),
(23, 'C64'),
(24, 'C64AT'),
(25, 'C64H'),
(26, 'C64K'),
(27, 'C64T'),
(28, 'C65'),
(29, 'C70'),
(30, 'C70A'),
(31, 'C70B'),
(32, 'C70C'),
(33, 'C70E'),
(34, 'C70EF'),
(35, 'C76'),
(36, 'C76A'),
(37, 'C76B'),
(38, 'C76C'),
(39, 'C76H'),
(40, 'C80'),
(41, 'C80A(H)'),
(42, 'C80B'),
(43, 'C80BF'),
(44, 'C80C'),
(45, 'C80CA'),
(46, 'C80DH'),
(47, 'C80E'),
(48, 'C80EF'),
(49, 'C80EH'),
(50, 'C80H'),
(51, 'C96'),
(52, 'C96H'),
(53, 'P62K'),
(54, 'P62NK'),
(55, 'P64GH'),
(56, 'P13'),
(57, 'P50'),
(58, 'P60'),
(59, 'P61'),
(60, 'P62'),
(61, 'P62N'),
(62, 'P62NT'),
(63, 'P62T'),
(64, 'P63'),
(65, 'P64'),
(66, 'P64A'),
(67, 'P64AK'),
(68, 'P64AT'),
(69, 'P64GK'),
(70, 'P64GT'),
(71, 'P64K'),
(72, 'P64T'),
(73, 'P65'),
(74, 'P65S'),
(75, 'P66H'),
(76, 'P66K'),
(77, 'P70'),
(78, 'P70A'),
(79, 'P70B'),
(80, 'P80'),
(81, 'PT'),
(82, 'N'),
(83, 'N12'),
(84, 'N15'),
(85, 'N16'),
(86, 'N17'),
(87, 'N17A'),
(88, 'N17AK'),
(89, 'N17AT'),
(90, 'N17G'),
(91, 'N17GK'),
(92, 'N17GT'),
(93, 'N17K'),
(94, 'N17T'),
(95, 'N30'),
(96, 'N6'),
(97, 'N60'),
(98, 'NA1'),
(99, 'NF1H'),
(100, 'NJ10'),
(101, 'NJ3'),
(102, 'NJ4'),
(103, 'NJ5'),
(104, 'NJ6'),
(105, 'NJ7'),
(106, 'NJ8'),
(107, 'NJ9'),
(108, 'NP70'),
(109, 'NT'),
(110, 'X1K'),
(111, 'X2H'),
(112, 'X2K'),
(113, 'X3K'),
(114, 'X3TEU'),
(115, 'X4K'),
(116, 'X6A'),
(117, 'X6B'),
(118, 'X6BK'),
(119, 'X6BT'),
(120, 'X6C'),
(121, 'X6CK'),
(122, 'X6CT'),
(123, 'X6DH'),
(124, 'X6K'),
(125, 'X70'),
(126, 'NX17'),
(127, 'NX17A'),
(128, 'NX17AK'),
(129, 'NX17AT'),
(130, 'NX17B'),
(131, 'NX17BH'),
(132, 'NX17BK'),
(133, 'NX17BT'),
(134, 'NX17K'),
(135, 'NX17T'),
(136, 'NX70'),
(137, 'NX70A（N70)'),
(138, 'NX70H'),
(139, 'NX80'),
(140, 'G10'),
(141, 'G11'),
(142, 'G11A'),
(143, 'G11B'),
(144, 'G11BK'),
(145, 'G11E'),
(146, 'G11J'),
(147, 'G11JE'),
(148, 'G11JK'),
(149, 'G11JT'),
(150, 'G11K'),
(151, 'G11S'),
(152, 'G11SE'),
(153, 'G11SK'),
(154, 'G11ST'),
(155, 'G11T'),
(156, 'G14'),
(157, 'G16'),
(158, 'G17'),
(159, 'G17B'),
(160, 'G17BK'),
(161, 'G17BT'),
(162, 'G17D'),
(163, 'G17DK'),
(164, 'G17DT'),
(165, 'G17E'),
(166, 'G17GK'),
(167, 'G17GT'),
(168, 'G17K'),
(169, 'G17S'),
(170, 'G17SK'),
(171, 'G17T'),
(172, 'G19'),
(173, 'G50'),
(174, 'G60'),
(175, 'G60A'),
(176, 'G60E'),
(177, 'G60H'),
(178, 'G60HK'),
(179, 'G60K'),
(180, 'G60LB'),
(181, 'G60LBK'),
(182, 'G60T'),
(183, 'G60X'),
(184, 'G60XK'),
(185, 'G70'),
(186, 'G70A'),
(187, 'G70AK'),
(188, 'G70B'),
(189, 'G70D'),
(190, 'G70E'),
(191, 'G70H'),
(192, 'G70K'),
(193, 'G70T'),
(194, 'G73'),
(195, 'G75K'),
(196, 'GALK'),
(197, 'GF'),
(198, 'GF1'),
(199, 'GF18K'),
(200, 'GF1E'),
(201, 'GF1K'),
(202, 'GF1M'),
(203, 'GF1MK'),
(204, 'GF1T'),
(205, 'GF2'),
(206, 'GF2K'),
(207, 'GF2T'),
(208, 'GF3'),
(209, 'GF3K'),
(210, 'GF70'),
(211, 'GF70H'),
(212, 'GF80'),
(213, 'GFA'),
(214, 'GFAE'),
(215, 'GFAK'),
(216, 'GFAT'),
(217, 'GH'),
(218, 'GH17'),
(219, 'GH17K'),
(220, 'GH40'),
(221, 'GH40LK'),
(222, 'GH50AK'),
(223, 'GH50K'),
(224, 'GH60'),
(225, 'GH60CK'),
(226, 'GH60DK'),
(227, 'GH60EK'),
(228, 'GH60K'),
(229, 'GH65K'),
(230, 'GH70A'),
(231, 'GH70B'),
(232, 'GH70C'),
(233, 'GHA70'),
(234, 'GHA70A'),
(235, 'GHB55K'),
(236, 'GHB70'),
(237, 'GHE'),
(238, 'GHK'),
(239, 'GHL60K'),
(240, 'GHT'),
(241, 'GJ70'),
(242, 'GL'),
(243, 'GL60K'),
(244, 'GL70'),
(245, 'GLA'),
(246, 'GLAK'),
(247, 'GLB'),
(248, 'GLBE'),
(249, 'GLBK'),
(250, 'GLBT'),
(251, 'GLCE'),
(252, 'GLCK'),
(253, 'GLCT'),
(254, 'GLK'),
(255, 'GN17'),
(256, 'GN70'),
(257, 'GN70A'),
(258, 'GN70H'),
(259, 'GN80'),
(260, 'GNK'),
(261, 'GQ'),
(262, 'GQ70'),
(263, 'GQ70A'),
(264, 'GQ70H'),
(265, 'GQ80'),
(266, 'GS'),
(267, 'GS70'),
(268, 'GSK'),
(269, 'GW70'),
(270, 'GY100K'),
(271, 'GY100SK'),
(272, 'GY40SK'),
(273, 'GY45'),
(274, 'GY45S'),
(275, 'GY45SK'),
(276, 'GY48'),
(277, 'GY48K'),
(278, 'GY48S'),
(279, 'GY60'),
(280, 'GY60K'),
(281, 'GY60S'),
(282, 'GY60SK'),
(283, 'GY70K'),
(284, 'GY70S'),
(285, 'GY70SK'),
(286, 'GY80'),
(287, 'GY80E'),
(288, 'GY80K'),
(289, 'GY80S'),
(290, 'GY80SE'),
(291, 'GY80SK'),
(292, 'GY80ST'),
(293, 'GY80T'),
(294, 'GY95'),
(295, 'GY95A'),
(296, 'GY95AK'),
(297, 'GY95K'),
(298, 'GY95S'),
(299, 'GY95SK'),
(300, 'GYA70'),
(301, 'GYA70A'),
(302, 'GYA70AS'),
(303, 'GYA70B'),
(304, 'GYA70C'),
(305, 'GYA70S'),
(306, 'GYC70'),
(307, 'GYC70S'),
(308, 'K13AK'),
(309, 'K13AT'),
(310, 'K13B'),
(311, 'K13BK'),
(312, 'K13K'),
(313, 'K13N'),
(314, 'K13NA'),
(315, 'K13NK'),
(316, 'K13NT'),
(317, 'K13T'),
(318, 'K14E'),
(319, 'K14K'),
(320, 'K14T'),
(321, 'K16'),
(322, 'K16A'),
(323, 'K18'),
(324, 'K18AK'),
(325, 'K18AT'),
(326, 'K18BK'),
(327, 'K18DA'),
(328, 'K18DG(N)'),
(329, 'K18DK'),
(330, 'K18DT'),
(331, 'K18F'),
(332, 'K18k'),
(333, 'KF5-100'),
(334, 'KF60'),
(335, 'KF60AK'),
(336, 'KF60H'),
(337, 'KF60N'),
(338, 'KF60NH'),
(339, 'KF60Q'),
(340, 'KF60QK'),
(341, 'KM70A'),
(342, 'KM70B'),
(343, 'KM70'),
(344, 'KM80H'),
(345, 'KM98'),
(346, 'KM98AH'),
(347, 'KZ70系列'),
(348, 'KZ80H'),
(349, 'SQ1'),
(350, 'SQ1K'),
(351, 'SQ2'),
(352, 'SQ2K'),
(353, 'SQ3'),
(354, 'SQ3K'),
(355, 'SQ4'),
(356, 'SQ4K'),
(357, 'SQ5'),
(358, 'SQ6'),
(359, 'SQ7'),
(360, 'SQ8');

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
(1, '车体及底架'),
(2, '车钩缓冲装置'),
(3, '基础制动装置'),
(4, '空气制动装置'),
(5, '轮轴'),
(6, '转向架'),
(7, '其他');

-- --------------------------------------------------------

--
-- 表的结构 `danWei`
--

CREATE TABLE `danWei` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `danWei`
--

INSERT INTO `danWei` (`id`, `name`) VALUES
(1, '杭州北车辆段'),
(2, '南京东车辆段');

-- --------------------------------------------------------

--
-- 表的结构 `dianWen`
--

CREATE TABLE `dianWen` (
  `id` int(10) UNSIGNED NOT NULL,
  `poster` smallint(5) UNSIGNED DEFAULT 0,
  `cheJian` varchar(1024) DEFAULT NULL,
  `title` varchar(64) DEFAULT NULL,
  `detail` varchar(16384) DEFAULT NULL,
  `attachments` varchar(1024) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `checkin` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- 转存表中的数据 `dianWen`
--

INSERT INTO `dianWen` (`id`, `poster`, `cheJian`, `title`, `detail`, `attachments`, `date`, `checkin`) VALUES
(1, 1, '[1,2,8,9]', 'test', 'ssss\nddddd', '[{\"name\":\"desktop.ini\",\"size\":402},{\"name\":\"执行器设置参数说明.doc\",\"size\":408064}]', '2019-05-01', '[{\"id\":3,\"date\":\"2019-05-20\"}]'),
(2, 1, '[1,2,3,4]', 'dgdfgdf', 'wetrwetre', '[{\"name\":\"950751881.jpg\",\"size\":391552}]', '2019-05-13', '[{\"id\":3,\"date\":\"2019-05-20\"}]'),
(3, 7, '[1,2,3,8,9,10]', '试试看', '    看来还是可以的，但是需要增加附件的功能', '[]', '2019-05-22', '[{\"id\":3,\"date\":\"2019-05-26\"}]');

-- --------------------------------------------------------

--
-- 表的结构 `group`
--

CREATE TABLE `group` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `cheJian` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `group`
--

INSERT INTO `group` (`id`, `name`, `cheJian`) VALUES
(1, '杭州北车辆段管理员', '[{\"id\":1,\"permission\":128},{\"id\":2,\"permission\":128},{\"id\":3,\"permission\":128},{\"id\":9,\"permission\":128},{\"id\":10,\"permission\":128},{\"id\":8,\"permission\":128}]'),
(2, '南京东车辆段管理员', '[{\"id\":4,\"permission\":128},{\"id\":5,\"permission\":128},{\"id\":7,\"permission\":128},{\"id\":6,\"permission\":128}]'),
(3, '杭州北-南翔站修质检', '[{\"id\":1,\"permission\":1}]'),
(4, '杭州北-南翔站修检修', '[{\"id\":1,\"permission\":2}]'),
(5, '杭州北-阜阳站修质检', '[{\"id\":2,\"permission\":1}]'),
(6, '杭州北-阜阳站修检修', '[{\"id\":2,\"permission\":2}]'),
(7, '杭州北-合肥东站修质检', '[{\"id\":3,\"permission\":1}]'),
(8, '杭州北-合肥东站修检修', '[{\"id\":3,\"permission\":2}]'),
(9, '杭州北-乔司站修质检', '[{\"id\":9,\"permission\":1}]'),
(10, '杭州北-乔司站修检修', '[{\"id\":9,\"permission\":2}]'),
(11, '杭州北-金华站修质检', '[{\"id\":10,\"permission\":1}]'),
(12, '杭州北-金华站修检修', '[{\"id\":10,\"permission\":2}]'),
(13, '杭州北-芜湖站修质检', '[{\"id\":8,\"permission\":1}]'),
(14, '杭州北-芜湖站修检修', '[{\"id\":8,\"permission\":2}]'),
(15, '南京东-连云港站修质检', '[{\"id\":4,\"permission\":1}]'),
(16, '南京东-连云港站修检修', '[{\"id\":4,\"permission\":2}]'),
(17, '南京东-南京东站修质检', '[{\"id\":7,\"permission\":1}]'),
(18, '南京东-南京东站修检修', '[{\"id\":7,\"permission\":2}]'),
(19, '南京东-蚌埠站修质检', '[{\"id\":6,\"permission\":1}]'),
(20, '南京东-蚌埠站修检修', '[{\"id\":6,\"permission\":2}]'),
(21, '南京东-徐州站修质检', '[{\"id\":5,\"permission\":1}]'),
(22, '南京东-徐州站修检修', '[{\"id\":5,\"permission\":2}]'),
(254, '路局领导', '[{\"id\":5,\"permission\":4},{\"id\":1,\"permission\":4},{\"id\":2,\"permission\":4},{\"id\":3,\"permission\":4},{\"id\":8,\"permission\":4},{\"id\":9,\"permission\":4},{\"id\":10,\"permission\":4},{\"id\":4,\"permission\":4},{\"id\":6,\"permission\":4},{\"id\":7,\"permission\":4}]'),
(255, '管理员', '[]');

-- --------------------------------------------------------

--
-- 表的结构 `guZhang`
--

CREATE TABLE `guZhang` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `dengJi` tinyint(3) UNSIGNED DEFAULT NULL,
  `daBuWei` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `guZhang`
--

INSERT INTO `guZhang` (`id`, `name`, `dengJi`, `daBuWei`) VALUES
(1, '小横梁折断', 2, 1),
(2, '小横梁弯曲变形', 2, 1),
(3, '小横梁裂纹', 2, 1),
(4, '小横梁开焊', 3, 1),
(5, '小横梁腹板腐蚀穿孔', 2, 1),
(6, '下侧门组装圆销漏装', 1, 1),
(7, '下侧门组装圆销垫片漏焊', 1, 1),
(8, '下侧门组装圆销与折页座轴向间隙超限', 3, 1),
(9, '下侧门组装圆销垫片焊接不到位', 2, 1),
(10, '下侧门折页座折断', 2, 1),
(11, '下侧门折页座裂纹', 2, 1),
(12, '下侧门折页座开焊', 2, 1),
(13, '下侧门折页折断', 2, 1),
(14, '下侧门折页裂纹', 3, 1),
(15, '下侧门折页开焊', 3, 1),
(16, '下侧门未关', 3, 1),
(17, '下侧门外胀', 3, 1),
(18, '下侧门破损', 2, 1),
(19, '下侧门间隙超限', 3, 1),
(20, '下侧门腐蚀', 2, 1),
(21, '下侧门吊环开口未焊', 3, 1),
(22, '下侧门吊环开焊', 3, 1),
(23, '下侧门吊环丢失', 3, 1),
(24, '下侧门吊环变形失效', 3, 1),
(25, '下侧门搭扣座螺栓折断', 3, 1),
(26, '下侧门搭扣座裂损', 2, 1),
(27, '下侧门搭扣折断', 2, 1),
(28, '下侧门搭扣未入槽', 3, 1),
(29, '下侧门搭扣螺栓未焊固', 3, 1),
(30, '下侧门搭扣螺栓松动', 3, 1),
(31, '下侧门搭扣裂损', 3, 1),
(32, '下侧门搭扣丢失', 3, 1),
(33, '下侧梁开焊', 3, 1),
(34, '手扶梯座折断', 3, 1),
(35, '手扶梯座脱焊', 2, 1),
(36, '手扶梯座裂纹', 3, 1),
(37, '绳栓折断', 3, 1),
(38, '绳栓弯曲变形', 3, 1),
(39, '绳栓松动', 3, 1),
(40, '绳栓铆钉丢失', 3, 1),
(41, '绳栓丢失', 3, 1),
(42, '上心盘铆钉折断', 3, 1),
(43, '上端梁裂损', 3, 1),
(44, '上端梁开焊', 2, 1),
(45, '上侧梁裂损', 2, 1),
(46, '上侧梁开焊', 2, 1),
(47, '色票框开裂', 3, 1),
(48, '人力制动机座开焊', 2, 1),
(49, '人力制动机未涂打装用标记', 2, 1),
(50, '墙板裂损', 2, 1),
(51, '棚车侧开门滑道弯曲', 2, 1),
(52, '木地板压条螺丝松动', 3, 1),
(53, '木地板破损', 3, 1),
(54, '临修标记未涂打', 2, 1),
(55, '临修标记涂打错误', 3, 1),
(56, '临修标记涂打不清', 3, 1),
(57, '临修标记涂打不规范', 3, 1),
(58, '脚蹬折断', 2, 1),
(59, '脚蹬弯曲变形', 3, 1),
(60, '脚蹬裂损', 2, 1),
(61, '脚蹬护铁弯曲变形', 3, 1),
(62, '脚蹬护铁破损', 3, 1),
(63, '脚蹬护铁开焊', 3, 1),
(64, '滑轮脱出', 3, 1),
(65, '焊接后未按规定涂抹防锈漆', 3, 1),
(66, '钢地板未按要求挖补', 2, 1),
(67, '钢地板破损', 2, 1),
(68, '辅助粱弯曲变形', 3, 1),
(69, '扶梯折断', 2, 1),
(70, '扶梯弯曲变形', 3, 1),
(71, '扶梯铆钉折断', 3, 1),
(72, '扶梯丢失', 3, 1),
(73, '防火板开焊', 3, 1),
(74, '防盗罩螺栓未焊', 3, 1),
(75, '端墙加强筋开焊', 3, 1),
(76, '端墙板破损', 3, 1),
(77, '端墙板开焊', 3, 1),
(78, '导轨弯曲变形', 3, 1),
(79, '大小车号不符', 3, 1),
(80, '大横梁下翼板开焊', 2, 1),
(81, '从板座裂损', 3, 1),
(82, '承载胺未涂打装用标记', 2, 1),
(83, '侧柱纵向裂纹', 3, 1),
(84, '侧柱铆钉折断', 3, 1),
(85, '侧柱铆钉丢失', 2, 1),
(86, '侧柱裂损', 2, 1),
(87, '侧柱开焊', 3, 1),
(88, '侧墙板外胀', 3, 1),
(89, '侧墙板破损', 2, 1),
(90, '侧墙板开焊', 3, 1),
(91, '侧梁开焊', 2, 1),
(92, '侧开门组装圆销漏装', 1, 1),
(93, '侧开门组装圆销垫片漏焊', 1, 1),
(94, '侧开门作用不良', 3, 1),
(95, '侧开门组装圆销垫片焊接不到位', 2, 1),
(96, '侧开门止档丢失', 3, 1),
(97, '侧开门折页座折断', 2, 1),
(98, '侧开门折页座裂损', 2, 1),
(99, '侧开门折页座开焊', 2, 1),
(100, '侧开门折页折断', 2, 1),
(101, '侧开门折页裂损', 3, 1),
(102, '侧开门下锁座焊缝开焊', 2, 1),
(103, '侧开门未关', 3, 1),
(104, '侧开门外胀', 3, 1),
(105, '侧开门锁座园销垫片未焊', 2, 1),
(106, '侧开门锁失效', 3, 1),
(107, '侧开门破损', 3, 1),
(108, '侧开门开闭作用不良', 3, 1),
(109, '侧开门开闭杆止档弹簧丢失', 3, 1),
(110, '侧开门开闭杆止挡铁破损', 3, 1),
(111, '侧开门开闭杆止挡失效', 2, 1),
(112, '侧开门开闭杆弯曲变形', 3, 1),
(113, '侧开门开闭杆锁盒开焊', 3, 1),
(114, '侧开门开闭杆手柄折断', 3, 1),
(115, '侧开门开闭杆手柄弯曲', 3, 1),
(116, '侧开门开闭杆手柄开焊', 3, 1),
(117, '侧开门开闭杆搭接量不足', 2, 1),
(118, '侧开门间隙超限', 3, 1),
(119, '侧开门滑道弯曲变形', 3, 1),
(120, '侧开门插销与上侧梁搭载量超限', 2, 1),
(121, '车号自动识别标签丢失', 1, 1),
(122, '车号自动识别标签失效', 1, 1),
(123, '车号自动识别标签信息与现车不符', 1, 1),
(124, '罐车卡带裂损', 1, 1),
(125, '罐车卡带调整器裂损', 1, 1),
(126, '提钩杆弯曲变形', 2, 2),
(127, '钩尾销托板螺栓开口销丢失', 3, 2),
(128, '钩尾框悬空', 3, 2),
(129, '钩尾框托板螺栓松动', 3, 2),
(130, '钩尾框托板螺栓开口销角度不良', 3, 2),
(131, '钩尾框托板螺栓开口销丢失', 2, 2),
(132, '钩尾框磨耗板开焊', 2, 2),
(133, '钩尾框磨耗板丢失', 2, 2),
(134, '钩托梁磨耗板丢失', 3, 2),
(135, '钩托梁螺栓松动', 3, 2),
(136, '钩托梁螺栓开口销角度不良', 3, 2),
(137, '钩托梁螺栓开口销丢失', 3, 2),
(138, '钩提杆座螺栓松动', 3, 2),
(139, '钩提杆座螺栓焊接不到位', 3, 2),
(140, '钩提杆座裂损', 3, 2),
(141, '钩提杆作用不良', 3, 2),
(142, '钩提杆弯曲变形', 3, 2),
(143, '钩提杆松余量超限', 2, 2),
(144, '钩提杆横动量超限', 2, 2),
(145, '钩提杆复位弹簧座开焊', 3, 2),
(146, '钩提杆复位弹簧折断', 3, 2),
(147, '钩舌圆销开口销折断', 3, 2),
(148, '钩舌圆销开口销丢失', 3, 2),
(149, '钩舌圆销丢失', 3, 2),
(150, '钩腔内未涂抹二硫化钼', 3, 2),
(151, '钩钩提杆与座凹槽间隙超限', 3, 2),
(152, '防跳插销作用不良', 2, 2),
(153, '防跳插销折断', 3, 2),
(154, '防跳插销裂损', 3, 2),
(155, '防跳插销吊链开裂', 3, 2),
(156, '车钩中心高度超限', 2, 2),
(157, '车钩支撑座尼龙磨耗板窜出', 3, 2),
(158, '车钩支撑座磨耗板开焊', 3, 2),
(159, '车钩支撑座磨耗板丢失', 3, 2),
(160, '车钩支撑座螺栓松动', 3, 2),
(161, '车钩三态作用不良', 2, 2),
(162, '车钩开锁作用不良', 2, 2),
(163, '车钩横动量、松余量、钩高尺寸未标注', 3, 2),
(164, '车钩防跳插销丢失', 3, 2),
(165, '车钩闭锁不良', 2, 2),
(166, '车钩安全托吊开焊', 2, 2),
(167, '制动梁裂纹', 1, 3),
(168, '固定杠杆支点座裂纹', 1, 3),
(169, '制动梁闸瓦托松动', 1, 3),
(170, '制动梁支柱螺栓松动', 1, 3),
(171, '制动梁安全链螺母松动', 3, 3),
(172, '制动缸链环脱落', 2, 3),
(173, '制动缸后杠杆开口销折断', 2, 3),
(174, '制动缸后杠杆开口销角度不良', 2, 3),
(175, '制动缸鞲鞴行程超限', 2, 3),
(176, '闸瓦折断', 3, 3),
(177, '闸瓦缺损', 2, 3),
(178, '闸瓦磨耗过限', 3, 3),
(179, '闸瓦厚度差超限', 3, 3),
(180, '闸瓦丢失', 2, 3),
(181, '闸瓦插销未入槽', 3, 3),
(182, '闸瓦插销丢失', 2, 3),
(183, '闸调器作用不良', 2, 3),
(184, '闸调器未涂打装车标记', 3, 3),
(185, '闸调器开口销折断', 2, 3),
(186, '闸调器开口销角度不良', 2, 3),
(187, '脱轨拉环拉铆钉窜出', 2, 3),
(188, '手制动踏板开焊', 3, 3),
(189, '上拉杆圆销与平垫圈组装不正位', 2, 3),
(190, '上拉杆与托架抗衡', 3, 3),
(191, '上拉杆未卡入托架', 2, 3),
(192, '上拉杆托架作用不良', 3, 3),
(193, '上拉杆托架折断', 3, 3),
(194, '上拉杆托架弯曲变形', 3, 3),
(195, '软管吊链裂纹', 3, 3),
(196, '人力制动机座固定螺栓漏焊', 2, 3),
(197, '人力制动机作用不良', 3, 3),
(198, '人力制动机转动不良', 3, 3),
(199, '人力制动机轴链折断', 2, 3),
(200, '人力制动机轴链裂纹', 2, 3),
(201, '人力制动机轴链卷入量超限', 3, 3),
(202, '人力制动机轴链丢失', 2, 3),
(203, '人力制动机制止锤丢失', 3, 3),
(204, '人力制动机制动盘丢失', 2, 3),
(205, '人力制动机踏板折断', 3, 3),
(206, '人力制动机踏板弯曲变形', 3, 3),
(207, '人力制动机踏板托架开焊', 2, 3),
(208, '人力制动机踏板螺栓松动', 3, 3),
(209, '人力制动机手轮丢失', 3, 3),
(210, '人力制动机手柄折断', 3, 3),
(211, '人力制动机链长超限', 3, 3),
(212, '人力制动机链轮座开焊', 3, 3),
(213, '人力制动机拉杆弯曲变形', 3, 3),
(214, '人力制动机拉杆托架弯曲变形', 3, 3),
(215, '人力制动机拉杆托架裂纹', 3, 3),
(216, '人力制动机拉杆链马蹄环丢失', 2, 3),
(217, '人力制动机导架座开焊', 3, 3),
(218, '人力制动机导架折断', 3, 3),
(219, '人力制动机导架弯曲变形', 2, 3),
(220, '人力制动机导架螺栓松动', 3, 3),
(221, '基础制动圆销未给油', 3, 3),
(222, '缓解阀拉杆作用不良', 3, 3),
(223, '缓解阀拉杆弯曲变形', 3, 3),
(224, '缓解阀拉杆丢失', 2, 3),
(225, '横跨梁螺栓垂直移动量超限', 3, 3),
(226, '主管裂纹', 1, 4),
(227, '主管折断', 1, 4),
(228, '支管裂纹', 1, 4),
(229, '支管折断', 1, 4),
(230, '主管漏泄', 2, 4),
(231, '主管卡箍松动', 3, 4),
(232, '制动软管吊链组成脱落', 3, 4),
(233, '制动缸前盖螺栓松动', 3, 4),
(234, '制动缸链环裂损', 2, 4),
(235, '制动缸吊架螺母松动', 2, 4),
(236, '制动缸吊架螺母丢失', 2, 4),
(237, '支管卡箍松动', 3, 4),
(238, '折角塞门手把作用不良', 3, 4),
(239, '折角塞门手把销折断', 3, 4),
(240, '折角塞门漏泄', 2, 4),
(241, '脱轨自动制动阀球阀关闭', 2, 4),
(242, '脱轨自动制动阀顶梁弯曲', 3, 4),
(243, '脱轨拉环与车轴△y2值超限', 2, 4),
(244, '脱轨拉环破损', 2, 4),
(245, '脱轨拉环铆钉折断', 3, 4),
(246, '脱轨拉环铆钉磨耗过限', 2, 4),
(247, '脱轨拉环铆钉丢失', 2, 4),
(248, '脱轨拉环铆钉错装', 3, 4),
(249, '脱轨拉环漏装', 2, 4),
(250, '脱轨拉环变形', 3, 4),
(251, '调整阀触头与横跨梁磨耗板间隙超限', 3, 4),
(252, '软管松动', 3, 4),
(253, '软管混用', 3, 4),
(254, '软管过期', 3, 4),
(255, '软管吊链作用不良', 3, 4),
(256, '软管吊链丢失', 3, 4),
(257, '软管垫圈窜出', 3, 4),
(258, '空重车指示牌丢失', 3, 4),
(259, '缓解阀作用不良', 3, 4),
(260, '缓解阀漏泄', 2, 4),
(261, '缓解阀拉杆座弯曲变形', 3, 4),
(262, '缓解阀拉杆座开焊', 2, 4),
(263, '缓解阀拉杆座丢失', 2, 4),
(264, '缓解阀拉杆托架开焊', 3, 4),
(265, '缓解阀拉杆开焊', 3, 4),
(266, '横跨梁螺栓开口销丢失', 3, 4),
(267, '横跨梁开口销角度不良', 2, 4),
(268, '风缸吊架螺栓松动', 3, 4),
(269, '风缸吊架裂损', 2, 4),
(270, '法兰螺栓松动', 3, 4),
(271, '传感阀防尘帽破损', 3, 4),
(272, '传感阀防尘帽丢失', 3, 4),
(273, '传感阀触头与横跨梁间隙超限', 3, 4),
(274, '传感阀触头开口销角度不良', 2, 4),
(275, '120防盗罩座裂', 3, 4),
(276, '120防盗罩螺栓安装座折断', 2, 4),
(277, '120防盗罩螺栓安装座裂损', 3, 4),
(278, '120防盗罩耳裂纹', 3, 4),
(279, '120阀防盗罩破损', 3, 4),
(280, '120阀防盗罩丢失', 3, 4),
(281, '车轮裂纹', 1, 5),
(282, '车轮缺损', 1, 5),
(283, '车轴纵、横裂纹', 1, 5),
(284, '轴颈弯曲', 1, 5),
(285, '轴承外圈裂纹', 1, 5),
(286, '轴承外圈电蚀', 1, 5),
(287, '轮缘厚度超限', 1, 5),
(288, '轴端螺栓松动', 2, 5),
(289, '轴承施封锁折断', 2, 5),
(290, '轴承施封锁丢失', 3, 5),
(291, '轴承前盖变形', 1, 5),
(292, '轴承密封失效', 2, 5),
(293, '踏面圆周磨耗过限', 1, 5),
(294, '踏面擦伤', 1, 5),
(295, '踏面剥离', 1, 5),
(296, '轮轴左端未在车辆奇数位', 2, 5),
(297, '轮辋厚度过限', 1, 5),
(298, '轮卡漏填', 2, 5),
(299, '轮卡错填', 2, 5),
(300, '轮对信息录入错误', 2, 5),
(301, '摇枕裂纹', 1, 6),
(302, '侧架裂纹', 1, 6),
(303, '承载鞍裂纹', 1, 6),
(304, '侧架立柱磨耗板铆钉松动', 1, 6),
(305, '侧架立柱磨耗板铆钉折断', 1, 6),
(306, '侧架立柱磨耗板铆钉丢失', 1, 6),
(307, '交叉杆裂纹', 1, 6),
(308, '闸瓦插销磨耗过限', 3, 6),
(309, '闸瓦插销环丢失', 3, 6),
(310, '摇枕弹簧折断', 3, 6),
(311, '摇枕弹簧错装', 1, 6),
(312, '摇枕弹簧窜出', 3, 6),
(313, '心盘磨耗盘破损', 3, 6),
(314, '心盘螺栓开口销折断', 3, 6),
(315, '心盘螺栓开口销丢失', 3, 6),
(316, '心盘螺栓丢失', 3, 6),
(317, '斜楔破损', 2, 6),
(318, '上旁承下平面与支撑麽耗板间隙超限', 3, 6),
(319, '上拉杆托架圆销开口销丢失', 3, 6),
(320, '旁承座折断', 3, 6),
(321, '旁承磨耗板丢失', 2, 6),
(322, '挡键折断', 3, 6),
(323, '挡键松动', 3, 6),
(324, '挡键螺栓丢失', 3, 6),
(325, '挡键漏装', 2, 6),
(326, '挡键开口销折断', 3, 6),
(327, '挡键开口销角度不良', 3, 6),
(328, '挡键间隙不符合要求', 3, 6),
(329, '挡键丢失', 2, 6),
(330, '承载鞍未正位', 3, 6),
(331, '承载鞍裂损', 2, 6),
(332, '临修故障未处理', 1, 7);

-- --------------------------------------------------------

--
-- 表的结构 `jiaoJian`
--

CREATE TABLE `jiaoJian` (
  `id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `cheHao` varchar(16) DEFAULT NULL,
  `xiuCheng` tinyint(4) DEFAULT NULL,
  `cheXing` smallint(5) UNSIGNED DEFAULT NULL,
  `guZhang` smallint(5) UNSIGNED DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL,
  `user` smallint(5) UNSIGNED DEFAULT NULL,
  `state` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `jiaoJian`
--

INSERT INTO `jiaoJian` (`id`, `date`, `cheHao`, `xiuCheng`, `cheXing`, `guZhang`, `danWei`, `cheJian`, `user`, `state`) VALUES
(1, '2018-12-11', '1234c', 1, 5, 7, 1, 1, 3, NULL),
(2, '2018-12-11', '4321', 2, 1, 6, 1, 3, 4, 1),
(4, '2018-12-30', '1111', 1, 1, 1, 1, 3, 3, NULL),
(5, '2018-12-31', '2222', 1, 5, 6, 1, 3, 3, NULL),
(6, '2019-01-02', '3333', 1, 2, 2, 1, 2, 4, 4),
(7, '2019-01-05', '4444', 1, 5, 318, 1, 3, 5, 3),
(8, '2019-03-01', '4332', 1, 1, 1, 1, 3, 4, NULL),
(10, '2019-03-01', 'njd', 2, 3, 169, 2, 4, 4, NULL),
(11, '2019-03-01', '334455', 4, 7, 6, 1, 1, 10, 2),
(12, '2019-03-03', '4433356', 3, 132, 172, 1, 1, 10, NULL),
(13, '2019-03-07', '3322556', 4, 2, 290, 1, 1, 10, 3),
(14, '2019-05-01', '3322442', 1, 79, 127, 1, 1, 3, 4),
(15, '2019-05-09', '4332566', 1, 137, 175, 1, 8, 4, NULL),
(16, '2019-05-15', '5533446', 1, 365, 222, 1, 8, 4, NULL),
(17, '2019-05-15', '4433552', 1, 247, 128, 1, 1, 3, 3),
(18, '2019-05-22', '5555', 1, 202, 313, 1, 1, 3, 1);

-- --------------------------------------------------------

--
-- 表的结构 `jiaoJianChuLi`
--

CREATE TABLE `jiaoJianChuLi` (
  `id` int(10) UNSIGNED NOT NULL,
  `state` tinyint(3) UNSIGNED DEFAULT NULL,
  `cheHao` varchar(16) DEFAULT NULL,
  `cheXing` smallint(5) UNSIGNED DEFAULT NULL,
  `xiuCheng` tinyint(3) UNSIGNED DEFAULT NULL,
  `danWei` tinyint(4) UNSIGNED DEFAULT NULL,
  `cheJian` tinyint(4) UNSIGNED DEFAULT NULL,
  `guZhang` smallint(6) UNSIGNED DEFAULT NULL,
  `xiaFaShiJian` timestamp NULL DEFAULT NULL,
  `xiaFaRen` smallint(5) UNSIGNED DEFAULT NULL,
  `chuLiShiJian` timestamp NULL DEFAULT NULL,
  `chuLiRen` smallint(5) UNSIGNED DEFAULT NULL,
  `chuLi` varchar(64) DEFAULT NULL,
  `yanZhiYuanYin` varchar(64) DEFAULT NULL,
  `fuJianShiJian` timestamp NULL DEFAULT NULL,
  `fuJianRen` smallint(5) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `jiaoJianChuLi`
--

INSERT INTO `jiaoJianChuLi` (`id`, `state`, `cheHao`, `cheXing`, `xiuCheng`, `danWei`, `cheJian`, `guZhang`, `xiaFaShiJian`, `xiaFaRen`, `chuLiShiJian`, `chuLiRen`, `chuLi`, `yanZhiYuanYin`, `fuJianShiJian`, `fuJianRen`) VALUES
(2, 1, '4321', 1, 2, 1, 3, 6, '2019-03-13 08:42:18', 4, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 4, '3333', 2, 1, 1, 2, 2, '2019-03-07 11:30:24', 4, '2019-03-07 13:15:00', 7, NULL, NULL, '2019-03-07 13:15:00', 3),
(7, 3, '4444', 5, 1, 1, 3, 318, '2019-03-12 13:13:41', 5, '2019-03-17 18:44:00', 7, NULL, NULL, '2019-03-17 18:51:00', 3),
(11, 2, '3344556', 7, 4, 1, 1, 4, '2019-03-18 05:57:44', 10, '2019-04-08 09:39:00', 1, 'test', NULL, NULL, NULL),
(13, 3, '3322556', 2, 4, 1, 1, 290, '2019-03-19 01:50:41', 10, '2019-03-19 01:53:00', 20, NULL, NULL, '2019-03-19 01:55:00', 10),
(14, 4, '3322442', 79, 1, 1, 1, 127, '2019-05-22 03:47:34', 3, '2019-05-27 13:25:00', 1, '已修复11', '延滞原因延滞原因延滞原因', '2019-05-27 13:26:00', 1),
(17, 3, '4433552', 247, 1, 1, 1, 128, '2019-05-22 03:49:13', 3, '2019-05-27 02:32:00', 1, '已修复已修复', NULL, '2019-05-27 11:17:00', 1),
(18, 1, '5555', 202, 1, 1, 1, 313, '2019-05-27 06:17:59', 3, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `jiaoJianCount`
--

CREATE TABLE `jiaoJianCount` (
  `id` int(10) UNSIGNED NOT NULL,
  `month` varchar(8) DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL,
  `count` smallint(5) UNSIGNED DEFAULT NULL,
  `counts` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `jiaoJianCount`
--

INSERT INTO `jiaoJianCount` (`id`, `month`, `cheJian`, `count`, `counts`) VALUES
(1, '2018-12', 3, 90, '{}'),
(2, '2019-03', 3, 101, '{}'),
(3, '2019-01', 3, 26, '{}'),
(4, '2018-07', 1, 33, '{}'),
(5, '2019-03', 4, 11, '{}'),
(6, '2019-03', 7, 21, '{}'),
(7, '2019-03', 1, 22, '{}'),
(8, '2018-12', 1, 45, '{}'),
(9, '2019-02', 1, 333, '{}'),
(10, '2019-04', 1, 2, '{\"0\":0,\"3\":2}'),
(11, '2019-01', 2, 5, '{\"0\":5}'),
(12, '2019-05', 1, 163, '{\"0\":10,\"1\":13,\"2\":12,\"5\":14,\"6\":15,\"7\":13,\"8\":10,\"9\":13,\"12\":14,\"13\":13,\"14\":14,\"15\":22}'),
(13, '2019-05', 8, 240, '{\"0\":21,\"1\":20,\"2\":19,\"5\":21,\"6\":22,\"7\":23,\"8\":21,\"9\":23,\"12\":24,\"13\":21,\"14\":25}');

-- --------------------------------------------------------

--
-- 表的结构 `option`
--

CREATE TABLE `option` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `options` varchar(16384) DEFAULT NULL,
  `state` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- 转存表中的数据 `option`
--

INSERT INTO `option` (`id`, `options`, `state`) VALUES
(0, '{\"zhiJianYuan\":{\"uploadMaxSize\":4194306}}', '{\"guZhangTime\":\"2019-04-25 03:20:00\",\"cheXingTime\":\"2019-04-30 16:11:36\"}');

-- --------------------------------------------------------

--
-- 表的结构 `peiJian`
--

CREATE TABLE `peiJian` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `leiBie` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `peiJian`
--

INSERT INTO `peiJian` (`id`, `name`, `leiBie`) VALUES
(2, '侧架', 1),
(3, '侧架组成', 1),
(4, '摇枕', 1),
(5, '摇枕组成', 1),
(6, '车钩', 1),
(7, '钩舌', 1),
(8, '钩舌圆销', 1),
(9, '钩舌推铁', 1),
(10, '钩锁铁', 1),
(11, '钩锁铁组成', 1),
(12, '上作用钩锁销及杆', 1),
(13, '上锁销', 1),
(14, '上锁销装配', 1),
(15, '下作用钩锁销及杆', 1),
(16, '车钩下锁销', 1),
(17, '下锁销杆', 1),
(18, '下锁销转轴', 1),
(19, '下锁销装配', 1),
(20, '下锁销组成', 1),
(21, '横跨梁', 2),
(22, '横跨梁组成', 2),
(23, '制动梁', 2),
(24, '组合制动梁', 2),
(25, '组合式制动梁', 2),
(26, '闸调器', 2),
(27, '交叉杆', 2),
(28, '交叉支撑组成', 2),
(29, '上交叉杆组成', 2),
(30, '下交叉杆组成', 2),
(31, '交叉杆组成', 2),
(32, '弹簧托板', 2),
(33, '弹簧托板组成', 2),
(34, '摇动座', 2),
(35, '导框摇动座', 2),
(36, '分离式斜楔', 2),
(37, '斜楔', 2),
(38, '组合式斜楔', 2),
(39, '斜楔体', 2),
(40, '斜楔针状贝氏体', 2),
(41, '斜楔针状马氏体', 2),
(42, '斜楔组成', 2),
(43, '组合斜楔', 2),
(44, '制动软管总成', 2),
(45, '空重车自动调整装置', 2),
(46, '主阀组成', 2),
(47, '传感阀', 2),
(48, '调整阀', 2),
(49, '紧急阀组成', 2),
(50, '旁承座', 2),
(51, '承载鞍', 2),
(52, '侧架立柱磨耗板', 2);

-- --------------------------------------------------------

--
-- 表的结构 `ruKuFuJian`
--

CREATE TABLE `ruKuFuJian` (
  `id` int(10) UNSIGNED NOT NULL,
  `date` date DEFAULT NULL,
  `xingHao` smallint(5) UNSIGNED DEFAULT NULL,
  `ruKuShuLiang` int(10) UNSIGNED DEFAULT NULL,
  `fuJianShuLiang` tinyint(3) UNSIGNED DEFAULT NULL,
  `bianHao` varchar(255) DEFAULT NULL,
  `jieGuo` tinyint(3) UNSIGNED DEFAULT NULL,
  `remark` varchar(256) DEFAULT NULL,
  `user` smallint(5) UNSIGNED DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `ruKuFuJian`
--

INSERT INTO `ruKuFuJian` (`id`, `date`, `xingHao`, `ruKuShuLiang`, `fuJianShuLiang`, `bianHao`, `jieGuo`, `remark`, `user`, `cheJian`) VALUES
(1, '2019-03-08', 1, 5, 1, '111', 1, NULL, 3, 1),
(2, '2019-04-12', 48, 2, 2, 'ww', 1, NULL, 8, 1),
(3, '2019-04-15', 197, 299, 6, '333', 4, NULL, 3, 1),
(4, '2019-04-15', 201, 99, 3, NULL, 1, NULL, 1, 1),
(5, '2019-05-16', 46, 100, 100, '33224,44335', 0, 'xxxx', 3, 1),
(6, '2019-05-17', 194, 66, 66, '333', 4, 'xxxx', 3, 1),
(7, '2019-05-20', 197, 100, 2, '4433-9', 2, NULL, 3, 1),
(8, '2019-05-22', 194, 133, 3, '3322,55678', 3, '5555', 3, 1),
(9, '2019-05-27', 43, 10, 10, '1,2,3', 1, NULL, 3, 1);

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE `user` (
  `id` smallint(6) NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `password` varchar(64) NOT NULL,
  `token` smallint(5) UNSIGNED DEFAULT NULL,
  `groups` varchar(1024) DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL,
  `state` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `name`, `password`, `token`, `groups`, `danWei`, `cheJian`, `state`) VALUES
(1, 'oblind', '4e3DWFKQHAFsw', 26440, '[255]', NULL, NULL, NULL),
(2, 'realarzt', '938/kIkECvYAc', 63246, '[255]', NULL, NULL, NULL),
(3, 'NXZXZJ', 'b1jM.wkQmyIM6', NULL, '[3]', 1, 1, NULL),
(7, 'HBGLY', '8fSRUyL.fcSqw', NULL, '[1]', 1, NULL, NULL),
(8, 'NJDGLY', 'eeEwBNf04p1x6', NULL, '[2]', 2, NULL, NULL),
(9, 'NXZXJX', '07kSvYb.tDtV2', NULL, '[4]', 1, 1, NULL),
(10, 'LJLD', '15J62OK8A.g3I', NULL, '[254]', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `xingHao`
--

CREATE TABLE `xingHao` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `peiJian` smallint(5) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `xingHao`
--

INSERT INTO `xingHao` (`id`, `name`, `peiJian`) VALUES
(1, '转K4', 2),
(2, 'C63', 2),
(3, '转8A', 2),
(4, '转8G ', 2),
(5, '转K2 QCZ85-20A-01', 2),
(6, '控制型 QCZ41-20-01 B级钢', 2),
(7, '100T铁水车用', 2),
(8, '转8 B', 2),
(9, '100型', 2),
(10, '转K6 QCZ133-20-01', 2),
(11, '转9', 2),
(12, '转K7', 2),
(13, '65T铁水车用', 2),
(14, '65型', 2),
(15, '转K5 ZCHZ56-20-01A', 3),
(16, '转K6 B+', 3),
(17, '转K5', 3),
(18, '转K1型车专用', 3),
(19, '转K6 QCZ133-20-00', 3),
(20, '转K2', 3),
(21, '转K5', 2),
(22, '控制型 QCZ49-40-01', 4),
(23, 'C63', 4),
(24, '转K2 QCZ85-40-01', 4),
(25, '100型', 4),
(26, '转K4', 4),
(27, '100T铁水车用', 4),
(28, '65型', 4),
(29, '转K6 QCZ133-40-01', 4),
(30, '转K5', 4),
(31, '转8A、转8G', 4),
(33, '转9', 4),
(34, 'C63', 4),
(35, '65T铁水车用', 4),
(36, '转K6', 5),
(37, '转K2', 5),
(38, '转K6 2位', 5),
(39, 'K1型车专用', 5),
(40, '转8AG', 5),
(41, '转K5 2位', 5),
(42, '转K6 1位', 5),
(43, '转K5 1位', 5),
(44, '转K4 1位', 5),
(45, '转K4 2位', 5),
(46, '13B', 6),
(47, '2号', 6),
(48, '16号', 6),
(49, '17型', 6),
(50, '16型 利旧', 6),
(51, '13号 下作用', 6),
(52, '13A 上作用', 6),
(53, '17号', 6),
(54, '13号 小间隙', 6),
(55, '16型', 6),
(56, '13号 小间隙 下作用', 6),
(57, '13A', 6),
(58, '13B QCP818F-00-00 E级钢', 6),
(59, '13号 上作用', 6),
(60, '16号、17号 QCP802-00-02 E级钢', 7),
(61, '13号', 7),
(62, '17号 SP', 7),
(63, '13B', 7),
(64, '16H', 7),
(65, '13号 HT93-02-75 C级钢', 7),
(66, '13A', 7),
(67, '13B QCP818F-00-01 E级钢', 7),
(68, 'HT87-710-02', 7),
(69, '17号 QCP802-00-03 C级40Cr', 8),
(70, '13号 HT93-05-75 合金钢', 8),
(71, '13号 HT93-05-75 C级钢', 8),
(72, '2号 下作用 HT88-01-75', 8),
(73, '17号', 8),
(74, '13号', 8),
(75, '16号、17号 QCP802-00-04 B级钢', 9),
(76, '13号', 9),
(77, '13B', 9),
(78, '13号 HT93-03-75 C级钢', 9),
(79, '13号 B级钢', 9),
(80, '16号、17号', 9),
(81, '13号 通用', 9),
(82, '13号 E级钢', 9),
(83, '13号 HT93-04-75 C级钢', 10),
(84, '13号 GB/7709-04-87', 10),
(85, '13号', 10),
(86, '16号、17号 QCP802-01-01 E级钢', 10),
(87, '13号 QCP818D-00-02', 10),
(88, '16号、17号', 11),
(89, '16号、17号 QCP802-01-00', 11),
(90, '13型', 12),
(91, '13号 HT93-06-75', 13),
(92, '13号 三级防跳 QCP818D-20A-00', 14),
(93, '13型', 15),
(94, '16号', 16),
(95, '17号 QCP803-01-01 B级钢', 17),
(96, '17号', 16),
(97, '17号 QCP803A-00-01 B级钢', 18),
(98, '17#', 18),
(99, '13号', 16),
(100, '13型', 15),
(101, '13号 QCP818C-20-00 B级钢', 19),
(102, '16号', 20),
(103, '17号', 20),
(104, '13B QCP818E-20-00 E级钢', 20),
(105, '8B', 21),
(106, 'K2\\K6', 21),
(107, '控制型 C63 QCZ50A-90-002', 22),
(108, '转K5 ZCHZ56-90-00', 22),
(109, '转8AG 8G QCZ106-90-00', 22),
(110, '转K4 ZCH110-80-07-000', 22),
(111, '转K2 QCZ86A-90A-00', 22),
(112, '转K2', 21),
(113, 'QCZ86A-92B-01 Q235A', 21),
(114, 'K4，K5', 21),
(115, 'L-B型 高摩 右 QCP704A-10-00', 23),
(116, 'L-B型 低摩 左 QCP704A-20-00', 23),
(117, 'L-B型 高摩 左 QCP704A-10-00', 23),
(118, 'L-B型 右 QCP704-10-00', 23),
(119, 'L-B型 右', 24),
(120, 'L-B型 左', 25),
(121, 'L-B型 右', 25),
(122, 'ST2-250型', 26),
(123, 'ST1-600型', 26),
(124, '转K2 QCZ85-71/72-00', 27),
(125, '转8G QCZ105-71A-00', 27),
(126, '转8AG、转8G QCZ105-71C-00', 28),
(127, '转K2 QCZ85A-72-00', 29),
(128, '转K2、转K6 QCZ85A-71-00', 30),
(129, 'C80BF', 31),
(130, '转K2、转K6(加修)', 31),
(131, '转K6', 29),
(132, 'C80E', 31),
(133, '转K2 新', 30),
(134, '转K2 新', 29),
(135, '转K2、转K6 QCZ85A-71A-00', 31),
(136, '转K2及转K6', 31),
(137, 'K5', 32),
(138, 'K4', 32),
(139, 'C80EH THB-1', 32),
(140, '转K5', 32),
(141, '转K4 ZCZ53-80A-00', 32),
(142, '转K4', 32),
(143, '转K5 ZCHZ56-80-00', 32),
(144, 'K5', 33),
(145, '转K4', 33),
(146, '转K5', 34),
(147, '转K4 ZCZ53-20-11', 35),
(148, '小圆弧 K4 新式', 35),
(149, '转K2 左', 36),
(150, '转K2/K6 组合式', 37),
(151, '转K2 QCZ85A-30-01', 37),
(152, 'C76A', 37),
(153, 'C80BF', 37),
(154, 'KF60', 37),
(155, 'K16', 37),
(156, '转K6、转K2 组合式 QCZ133-90-00', 38),
(157, '8G', 37),
(158, '转8B、转8AB QCZ105A-30-01', 37),
(159, '转8A', 37),
(160, '转K4', 37),
(161, 'C76C', 37),
(162, '转K3', 39),
(163, '转8B', 38),
(164, 'k16 新型', 37),
(165, 'K4', 37),
(166, '转K2 右', 36),
(167, 'C76H', 37),
(168, 'C76B', 37),
(169, 'C63', 37),
(170, '转K2', 40),
(171, 'K1型车专用', 37),
(172, '转K5', 37),
(173, '控制型', 37),
(174, 'K2', 41),
(175, '转K4', 42),
(176, 'C80EH ZX-5', 43),
(177, 'ZCH142-09-08-000', 42),
(178, 'C80E', 42),
(179, 'C80EF ZX-3', 38),
(180, 'K5', 42),
(181, '665ZC', 44),
(182, '980', 44),
(183, '850ZC TYBJ04A-00-00', 44),
(184, '585ZC', 44),
(185, '795 TYBJ04A-00-00', 44),
(186, '36×3×870', 44),
(187, '710G', 44),
(188, '715', 44),
(189, 'KZW-A型 TYJLKZWA', 45),
(190, 'KZW-B型', 45),
(191, 'KZW-A 70T', 45),
(192, 'X-A', 45),
(193, 'GK', 45),
(194, '120 10寸 MSP120-10-00', 46),
(195, '120 14寸', 46),
(196, 'TWG-1A型 MSP423-10-00', 47),
(197, 'TWG-1A型 MSP424-10-00', 48),
(198, '120 MSP120-40-00', 49),
(199, 'JC-1', 50),
(200, 'JC', 50),
(201, '转K2 新', 50),
(202, '转8A', 51),
(203, '转K6', 51),
(204, '转K2  ', 51),
(205, '转K2', 52);

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
(1, '临修'),
(2, '段修'),
(3, '辅修'),
(4, '入段厂修'),
(6, '新造');

--
-- 转储表的索引
--

--
-- 表的索引 `cheJian`
--
ALTER TABLE `cheJian`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `cheXing`
--
ALTER TABLE `cheXing`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `daBuWei`
--
ALTER TABLE `daBuWei`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `danWei`
--
ALTER TABLE `danWei`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `dianWen`
--
ALTER TABLE `dianWen`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `group`
--
ALTER TABLE `group`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `guZhang`
--
ALTER TABLE `guZhang`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `jiaoJian`
--
ALTER TABLE `jiaoJian`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `jiaoJianChuLi`
--
ALTER TABLE `jiaoJianChuLi`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `jiaoJianCount`
--
ALTER TABLE `jiaoJianCount`
  ADD PRIMARY KEY (`id`),
  ADD KEY `month` (`month`);

--
-- 表的索引 `option`
--
ALTER TABLE `option`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `peiJian`
--
ALTER TABLE `peiJian`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `ruKuFuJian`
--
ALTER TABLE `ruKuFuJian`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xingHao`
--
ALTER TABLE `xingHao`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xiuCheng`
--
ALTER TABLE `xiuCheng`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `cheJian`
--
ALTER TABLE `cheJian`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `cheXing`
--
ALTER TABLE `cheXing`
  MODIFY `id` smallint(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=367;

--
-- 使用表AUTO_INCREMENT `daBuWei`
--
ALTER TABLE `daBuWei`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `danWei`
--
ALTER TABLE `danWei`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `dianWen`
--
ALTER TABLE `dianWen`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `guZhang`
--
ALTER TABLE `guZhang`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=333;

--
-- 使用表AUTO_INCREMENT `jiaoJian`
--
ALTER TABLE `jiaoJian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- 使用表AUTO_INCREMENT `jiaoJianCount`
--
ALTER TABLE `jiaoJianCount`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- 使用表AUTO_INCREMENT `peiJian`
--
ALTER TABLE `peiJian`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- 使用表AUTO_INCREMENT `ruKuFuJian`
--
ALTER TABLE `ruKuFuJian`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- 使用表AUTO_INCREMENT `user`
--
ALTER TABLE `user`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `xingHao`
--
ALTER TABLE `xingHao`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=206;

--
-- 使用表AUTO_INCREMENT `xiuCheng`
--
ALTER TABLE `xiuCheng`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
