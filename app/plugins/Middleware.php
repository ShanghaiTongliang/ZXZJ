<?php

use Yaf\Request_Abstract;
use Yaf\Response_Abstract;
use Yaf\Dispatcher;

class MiddlewarePlugin extends Yaf\Plugin_Abstract {

  /*public function routerStartup(Request_Abstract $request, Response_Abstract $response) {
  }
  */

  public function routerShutdown(Request_Abstract $request, Response_Abstract $response) {
    $resole = function($request) {
      if($request->isPost() && strpos(getallheaders()['Content-Type'] ?? null, 'application/json') !== false)
        $_POST = json_decode(file_get_contents('php://input'), true);
    };
    $r = Dispatcher::getInstance()->getRouter();
    if($ms = $r->getRoute($r->getCurrentRoute())->middleware ?? null) {
      $p = new Pipeline;
      $p->send($request);
      foreach($ms as $m)
        $p->pipe([$m, 'handle']);
      $p->then($resole);
    } else
      $resole($request);
  }

  /*public function dispatchLoopStartup(Request_Abstract $request, Response_Abstract $response) {
  }

  public function preDispatch(Request_Abstract $request, Response_Abstract $response) {
  }

  public function postDispatch(Request_Abstract $request, Response_Abstract $response) {
  }

  public function dispatchLoopShutdown(Request_Abstract $request, Response_Abstract $response) {
  }
  */
}
