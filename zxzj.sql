-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2019-03-14 20:58:50
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
-- 表的结构 `banZu`
--

CREATE TABLE `banZu` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `banZu`
--

INSERT INTO `banZu` (`id`, `name`, `cheJian`) VALUES
(1, '杭州质检一班', 3),
(2, '杭州质检二班', 3),
(3, '南翔质检', 1),
(4, '连云港质检', 4);

-- --------------------------------------------------------

--
-- 表的结构 `cheJian`
--

CREATE TABLE `cheJian` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `cheJian`
--

INSERT INTO `cheJian` (`id`, `name`, `danWei`) VALUES
(1, '上海车轮车间', 1),
(2, '芜湖检修车间', 1),
(3, '乔司检修车间', 1),
(4, '连云港', 2),
(5, '徐州', 2),
(6, '蚌埠', 2),
(7, '南京东', 2);

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
-- 表的结构 `config`
--

CREATE TABLE `config` (
  `guZhangTime` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `config`
--

INSERT INTO `config` (`guZhangTime`) VALUES
('2019-02-27 16:00:00');

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
(7, '转向机'),
(8, '其他');

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
-- 表的结构 `dengJi`
--

CREATE TABLE `dengJi` (
  `id` tinyint(4) UNSIGNED NOT NULL,
  `name` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `dengJi`
--

INSERT INTO `dengJi` (`id`, `name`) VALUES
(1, 'A'),
(2, 'B'),
(3, 'C');

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
(1, '上海东车辆段管理员', '[{\"id\":1,\"permission\":255},{\"id\":3,\"permission\":3},{\"id\":2,\"permission\":3}]'),
(2, '上海东车辆段质检员', '[{\"id\":1,\"permission\":1},{\"id\":2,\"permission\":1},{\"id\":3,\"permission\":1}]'),
(3, '上海东车辆段检修员', '[{\"id\":1,\"permission\":2},{\"id\":2,\"permission\":2},{\"id\":3,\"permission\":2}]'),
(4, '上海东车辆段', '[{\"id\":1,\"permission\":0},{\"id\":2,\"permission\":0},{\"id\":3,\"permission\":0}]'),
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
(324, '挡键螺栓丢失', 3, 7),
(325, '挡键漏装', 2, 6),
(326, '挡键开口销折断', 3, 6),
(327, '挡键开口销角度不良', 3, 6),
(328, '挡键间隙不符合要求', 3, 6),
(329, '挡键丢失', 2, 6),
(330, '承载鞍未正位', 3, 6),
(331, '承载鞍裂损', 2, 6),
(332, '临修故障未处理', 1, 8);

-- --------------------------------------------------------

--
-- 表的结构 `jiaoJian`
--

CREATE TABLE `jiaoJian` (
  `id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `cheHao` varchar(16) DEFAULT NULL,
  `xiuCheng` tinyint(4) DEFAULT NULL,
  `cheZhong` smallint(5) UNSIGNED DEFAULT NULL,
  `guZhang` smallint(5) UNSIGNED DEFAULT NULL,
  `danWei` tinyint(3) UNSIGNED DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL,
  `banZu` smallint(5) UNSIGNED DEFAULT NULL,
  `user` smallint(5) UNSIGNED DEFAULT NULL,
  `state` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `jiaoJian`
--

INSERT INTO `jiaoJian` (`id`, `date`, `cheHao`, `xiuCheng`, `cheZhong`, `guZhang`, `danWei`, `cheJian`, `banZu`, `user`, `state`) VALUES
(1, '2018-12-11', '1234c', 1, 5, 7, 1, 1, 3, 3, NULL),
(2, '2018-12-11', '4321', 2, 1, 6, 1, 3, 1, 4, 1),
(4, '2018-12-30', '1111', 1, 1, 1, 1, 3, 2, 3, NULL),
(5, '2018-12-31', '2222', 1, 5, 6, 1, 3, 2, 3, NULL),
(6, '2019-01-02', '3333', 1, 2, 2, 1, 3, 1, 4, 4),
(7, '2019-01-05', '4444', 1, 5, 318, 1, 3, 2, 5, 2),
(8, '2019-03-01', '4332', 1, 1, 1, 1, 3, 1, 4, NULL),
(9, '2019-03-01', 'ssxx', 1, 1, 171, 1, 1, 3, 7, NULL),
(10, '2019-03-01', 'njd', 2, 3, 169, 2, 4, 4, 4, NULL),
(11, '2019-03-01', 'ssxx', 1, 1, 1, 1, 1, 3, 7, NULL),
(12, '2019-03-01', 'ssxx', 1, 1, 4, 1, 1, 3, 7, NULL),
(13, '2019-03-01', 'ssxx', 1, 1, 8, 1, 1, 3, 7, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `jiaoJianChuLi`
--

CREATE TABLE `jiaoJianChuLi` (
  `id` int(10) UNSIGNED NOT NULL,
  `state` tinyint(3) UNSIGNED DEFAULT NULL,
  `cheHao` varchar(16) DEFAULT NULL,
  `xiuCheng` tinyint(3) UNSIGNED DEFAULT NULL,
  `danWei` tinyint(4) UNSIGNED DEFAULT NULL,
  `cheJian` tinyint(4) UNSIGNED DEFAULT NULL,
  `guZhang` smallint(6) UNSIGNED DEFAULT NULL,
  `xiaFaShiJian` timestamp NULL DEFAULT NULL,
  `xiaFaRen` smallint(5) UNSIGNED DEFAULT NULL,
  `chuLiShiJian` timestamp NULL DEFAULT NULL,
  `chuLiRen` smallint(5) UNSIGNED DEFAULT NULL,
  `chuLi` tinyint(3) UNSIGNED DEFAULT NULL,
  `yanZhiYuanYin` varchar(64) DEFAULT NULL,
  `fuJianShiJian` timestamp NULL DEFAULT NULL,
  `fuJianRen` smallint(5) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `jiaoJianChuLi`
--

INSERT INTO `jiaoJianChuLi` (`id`, `state`, `cheHao`, `xiuCheng`, `danWei`, `cheJian`, `guZhang`, `xiaFaShiJian`, `xiaFaRen`, `chuLiShiJian`, `chuLiRen`, `chuLi`, `yanZhiYuanYin`, `fuJianShiJian`, `fuJianRen`) VALUES
(2, 1, '4321', 2, 1, 3, 6, '2019-03-13 08:42:18', 4, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 4, '3333', 1, 1, 3, 2, '2019-03-07 11:30:24', 4, '2019-03-07 13:15:00', 7, 0, NULL, '2019-03-07 13:15:00', 3),
(7, 2, '4444', 1, 1, 3, 318, '2019-03-12 13:13:41', 5, '2019-03-13 08:43:00', 7, 0, NULL, '2019-03-13 08:42:00', 3);

-- --------------------------------------------------------

--
-- 表的结构 `jiaoJianCount`
--

CREATE TABLE `jiaoJianCount` (
  `id` int(10) UNSIGNED NOT NULL,
  `month` varchar(8) DEFAULT NULL,
  `cheJian` tinyint(3) UNSIGNED DEFAULT NULL,
  `count` smallint(5) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `jiaoJianCount`
--

INSERT INTO `jiaoJianCount` (`id`, `month`, `cheJian`, `count`) VALUES
(1, '2018-12', 3, 90),
(2, '2019-03', 3, 101),
(3, '2019-01', 3, 26),
(4, '2018-07', 1, 33),
(5, '2019-03', 4, 11),
(6, '2019-03', 7, 21),
(7, '2019-03', 1, 22),
(8, '2018-12', 1, 45);

-- --------------------------------------------------------

--
-- 表的结构 `peiJian`
--

CREATE TABLE `peiJian` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `xingHao` varchar(64) DEFAULT NULL,
  `leiBie` tinyint(3) UNSIGNED DEFAULT NULL,
  `danWei` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `peiJian`
--

INSERT INTO `peiJian` (`id`, `name`, `xingHao`, `leiBie`, `danWei`) VALUES
(1, '轴承', 'RD2', 2, '对'),
(2, 'ff', 'ss', 1, 'ee');

-- --------------------------------------------------------

--
-- 表的结构 `ruKuFuJian`
--

CREATE TABLE `ruKuFuJian` (
  `id` int(10) UNSIGNED NOT NULL,
  `date` date DEFAULT NULL,
  `peiJian` smallint(5) UNSIGNED DEFAULT NULL,
  `ruKuShuLiang` int(10) UNSIGNED DEFAULT NULL,
  `fuJianShuLiang` tinyint(3) UNSIGNED DEFAULT NULL,
  `bianHao` varchar(255) DEFAULT NULL,
  `jieGuo` tinyint(3) UNSIGNED DEFAULT NULL,
  `user` smallint(5) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `ruKuFuJian`
--

INSERT INTO `ruKuFuJian` (`id`, `date`, `peiJian`, `ruKuShuLiang`, `fuJianShuLiang`, `bianHao`, `jieGuo`, `user`) VALUES
(1, '2019-03-08', 1, 5, 1, '111', 1, 3);

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
  `banZu` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `name`, `password`, `token`, `groups`, `banZu`) VALUES
(1, 'oblind', 'ddHSDUw8lB75s', 26440, '[255]', 3),
(2, 'realarzt', '938/kIkECvYAc', 63246, '[255]', NULL),
(3, 'test', 'ddHSDUw8lB75s', NULL, '[2]', 1),
(4, '关强', 'ddHSDUw8lB75s', 123, '[1]', 4),
(5, '夏云飞', 'ddHSDUw8lB75s', 123, '[1]', 2),
(7, '111', '69s06.iMJqanI', NULL, '[3]', 3);

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

--
-- 转储表的索引
--

--
-- 表的索引 `banZu`
--
ALTER TABLE `banZu`
  ADD PRIMARY KEY (`id`);

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
-- 表的索引 `danWei`
--
ALTER TABLE `danWei`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `dengJi`
--
ALTER TABLE `dengJi`
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
-- 表的索引 `xiuCheng`
--
ALTER TABLE `xiuCheng`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `banZu`
--
ALTER TABLE `banZu`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `cheJian`
--
ALTER TABLE `cheJian`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `danWei`
--
ALTER TABLE `danWei`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `dengJi`
--
ALTER TABLE `dengJi`
  MODIFY `id` tinyint(4) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `guZhang`
--
ALTER TABLE `guZhang`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=333;

--
-- 使用表AUTO_INCREMENT `jiaoJian`
--
ALTER TABLE `jiaoJian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- 使用表AUTO_INCREMENT `jiaoJianCount`
--
ALTER TABLE `jiaoJianCount`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `peiJian`
--
ALTER TABLE `peiJian`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `ruKuFuJian`
--
ALTER TABLE `ruKuFuJian`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `user`
--
ALTER TABLE `user`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `xiuCheng`
--
ALTER TABLE `xiuCheng`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
