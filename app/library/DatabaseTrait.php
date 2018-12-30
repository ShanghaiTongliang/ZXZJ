<?php

trait DatabaseTrait {
  static $instance;

  static function getDatabase(): PDO {
    if(static::$instance)
      return static::$instance;
    else {
      $cfg = \Yaf\Application::app()->getConfig()->db;
      static::$instance = new PDO(
        "$cfg->type:host=$cfg->host;dbname=$cfg->database", $cfg->user, $cfg->password, [
          //持久连接
          PDO::ATTR_PERSISTENT => true,
          //返回对象, FETCH_ASSOC: 返回数组
          PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ,
          //不对数字转化字符串
          PDO::ATTR_EMULATE_PREPARES => false,
          //抛出异常
          PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
        ]
      );
      return static::$instance;
    }
  }

  static function putDatabase(PDO $db) {
  }
}
