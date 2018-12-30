<?php
namespace Zxzj;

use Yaf\Application;

class Redis {
  static $redis;

  static function instance(): \Redis {
    if(!static::$redis) {
      $cfg = Application::app()->getConfig();
      static::$redis = new \Redis;
      static::$redis->pconnect($cfg['host'], $cfg['port']);
      static::$redis->select($cfg['select']);
    }
    return static::$redis;
  }
}
