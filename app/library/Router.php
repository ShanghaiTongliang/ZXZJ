<?php
use Middleware\BaseMiddleware;

class Router {
  static $module;
  static $method;
  static $router;
  static $rules = [];

  static function init(Yaf\Router $router, string $method) {
    static::$router = $router;
    static::$method = $method;
  }

  static function act(string $method, string $rule, array $route, string $name = null, $middleware = null) {
    if($method == static::$method) {
      $r = new Yaf\Route\Rewrite($rule, $route);
      if($middleware)
        $r->middleware = is_array($middleware) ? $middleware : [$middleware];
      static::$router->addRoute($name ?: $rule, $r);
    } elseif(static::$method == 'Cli') {
      $route['method'] = $method;
      static::$router->addRoute($name ?: $rule, new Route\Rewrite($rule, $route));
    }
  }

  static function middleware(BaseMiddleware $middleware, Closure $callback) {
    $ir = new InnerRouter;
    $callback($ir);
    foreach($ir->routes as $r)
      static::act($r[0], $r[1], $r[2], $r[3], $r[4]);
  }

  static function prefix(string $prefix, Closure $callback) {
    if(($l = strlen($prefix)) && $prefix[$l - 1] != '/')
      $prefix .= '/';
    $ir = new InnerRouter;
    $callback($ir);
    foreach($ir->routes as $r)
      static::act($r[0], "$prefix{$r[1]}", $r[2], $r[3], $r[4]);
  }

  static function get(string $rule, array $route, string $name = null, $router = null) {
    static::act('GET', $rule, $route, $name, $router);
  }

  static function post(string $rule, array $route, string $name = null, $router = null) {
    static::act('POST', $rule, $route, $name, $router);
  }

  static function put(string $rule, array $route, string $name = null, $router = null) {
    static::act('PUT', $rule, $route, $name, $router);
  }

  static function delete(string $rule, array $route, string $name = null, $router = null) {
    static::act('DELETE', $rule, $route, $name, $router);
  }
}
