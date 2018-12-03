<?php
namespace Route;

class Rewrite implements \Yaf\Route_Interface {
  static $delegates = [];
  public $route;
  protected $delegate;

  function __construct(string $match, array $route) {
    if(!($this->delegate = static::$delegates[$match] ?? null))
      $this->delegate = static::$delegates[$match] = new \Yaf\Route\Rewrite($match, $route);
    $this->route = $route;
  }

  function route($request) {
    if($this->route['method'] == $request->method && $this->delegate->route($request)) {
      if($request->action != $this->route['action'])
        $request->action = $this->route['action'];
      return true;
    }
  }

  function assemble(array $info, array $query = null) {
    return $info['module'];
  }
}
