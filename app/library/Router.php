<?php
class Router {
  static $module;
  static $method;
  static $router;
  static $rules = [];

  static function init($router, $method) {
    static::$router = $router;
    static::$method = $method;
  }

  static function act($method, $rule, $route, $name = null) {
    if($method == static::$method)
      static::$router->addRoute($name ?: $rule, new Yaf\Route\Rewrite($rule, $route));
    elseif(static::$method == 'Cli') {
      $route['method'] = $method;
      static::$router->addRoute($name ?: $rule, new Route\Restful($rule, $route));
    }
  }

  static function prefix(string $prefix, Closure $callback) {
    if(($l = strlen($prefix)) && $prefix[$l - 1] != '/')
      $prefix .= '/';
    $pr = new class {
      public $r = [];

      function act(string $method, string $rule, array $route, $name = null) {
        $this->r[] = [$method, $rule, $route, $name];
      }

      function get(string $rule, array $route, $name = null) {
        $this->act('GET', $rule, $route, $name);
      }

      function post(string $rule, array $route, $name = null) {
        $this->act('POST', $rule, $route, $name);
      }

      function put(string $rule, array $route, $name = null) {
        $this->act('PUT', $rule, $route, $name);
      }

      function delete(string $rule, array $route, $name = null) {
        $this->act('DELETE', $rule, $route, $name);
      }
    };
    $callback($pr);
    foreach($pr->r as $r)
      static::act($r[0], "$prefix{$r[1]}", $r[2], $r[3]);
  }

  static function get(string $rule, array $route, $name = null) {
    static::act('GET', $rule, $route, $name);
  }

  static function post($rule, $route, $name = null) {
    static::act('POST', $rule, $route, $name);
  }

  static function put($rule, $route, $name = null) {
    static::act('PUT', $rule, $route, $name);
  }

  static function delete($rule, $route, $name = null) {
    static::act('DELETE', $rule, $route, $name);
  }
}
