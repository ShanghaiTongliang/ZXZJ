<?php
use Middleware\BaseMiddleware;

class InnerRouter {
  public $routes = [];

  function middleware(BaseMiddleware $middleware, Closure $callback) {
    $ir = new static;
    $callback($ir);
    foreach($ir->routes as &$r) {
      if(is_array($middleware))
        $r[4] = array_merge($r[4], $middleware);
      else
        $r[4][] = $middleware;
      $this->routes[] = $r;
    }
  }

  function act(string $method, string $rule, array $route, string $name = null, $middleware = null) {
    $this->routes[] = [$method, $rule, $route, $name, is_array($middleware) ? $middleware : ($middleware ? [$middleware] : [])];
  }

  function get(string $rule, array $route, string $name = null, $middleware = null) {
    $this->act('GET', $rule, $route, $name, $middleware);
  }

  function post(string $rule, array $route, string $name = null, $middleware = null) {
    $this->act('POST', $rule, $route, $name, $middleware);
  }

  function put(string $rule, array $route, string $name = null, $middleware = null) {
    $this->act('PUT', $rule, $route, $name, $middleware);
  }

  function delete(string $rule, array $route, string $name = null, $middleware = null) {
    $this->act('DELETE', $rule, $route, $name, $middleware);
  }
}
