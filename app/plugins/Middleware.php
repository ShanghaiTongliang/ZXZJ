<?php
/**
 * @name SamplePlugin
 * @desc Yaf定义了如下的6个Hook,插件之间的执行顺序是先进先Call
 * @see http://www.php.net/manual/en/class.yaf-plugin-abstract.php
 * @author oblind-nb\oblind
 */
use Yaf\Request_Abstract;
use Yaf\Response_Abstract;
use Yaf\Dispatcher;

class MiddlewarePlugin extends Yaf\Plugin_Abstract {

  /*public function routerStartup(Request_Abstract $request, Response_Abstract $response) {
  }
  */

  public function routerShutdown(Request_Abstract $request, Response_Abstract $response) {
    $r = Dispatcher::getInstance()->getRouter();
    if($ms = $r->getRoute($r->getCurrentRoute())->middleware ?? null)
      foreach($ms as $m)
        $m->handle($request);
    if($request->isPost() && strpos(strtolower(getallheaders()['Content-Type']), 'application/json') !== false)
      $_POST = json_decode(file_get_contents('php://input'), true);
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
