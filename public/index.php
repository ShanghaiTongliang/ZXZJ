<?php

define('APP_PATH', realpath(__DIR__ . '/..'));

$application = new Yaf\Application(APP_PATH . "/conf/app.ini");
$application->bootstrap()->run();
