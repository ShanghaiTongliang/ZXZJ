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

class AuthPlugin extends Yaf\Plugin_Abstract {

  /*public function routerStartup(Request_Abstract $request, Response_Abstract $response) {
  }
  */

  /*function call(array $ps, int $l) {
    if($l)
      $r = $this->call($ps, $l - 1);
    else
      return
  }*/

  public function routerShutdown(Request_Abstract $request, Response_Abstract $response) {
    $r = Dispatcher::getInstance()->getRouter();
    if($ms = $r->getRoute($r->getCurrentRoute())->middleware ?? null) {
      foreach($ms as $m)
        if($m->handle($request) === false)
          throw new Exception('no');

      /*$ps = [];
      array_reduce(array_reverse($ms), function($m, $next) use($request, $ps) {
        return function($request, $next) {

        };
      });
      $call($ps, count($ps) - 1);*/
    }
    /*if(!in_array($request->controller . $request->action, ['Indexindex', 'Userstore', 'Authstore'])) {
      if(isset($_COOKIE['id'], $_COOKIE['token']) && ($u = UserModel::find($_COOKIE['id'])) && $u->token == $_COOKIE['token'])
        UserModel::$user = $u;
      else
        throw new Exception('权限不足');
    }*/
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
