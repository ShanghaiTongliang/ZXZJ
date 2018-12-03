<?php
/**
 * @name SamplePlugin
 * @desc Yaf定义了如下的6个Hook,插件之间的执行顺序是先进先Call
 * @see http://www.php.net/manual/en/class.yaf-plugin-abstract.php
 * @author oblind-nb\oblind
 */
use Yaf\Request_Abstract;
use Yaf\Response_Abstract;

class AuthPlugin extends Yaf\Plugin_Abstract {

  /*public function routerStartup(Request_Abstract $request, Response_Abstract $response) {
  }
  */

  public function routerShutdown(Request_Abstract $request, Response_Abstract $response) {
    //if(in_array(Yaf\Dispatcher::getRouter()->getCurrentRoute(), [])
    if(!in_array($request->controller . $request->action, ['Indexindex', 'Userstore', 'Authstore'])) {
      if(isset($_COOKIE['id']) && ($u = UserModel::find($_COOKIE['id'])) && $u->token == $_COOKIE['token'])
        UserModel::$user = $u;
      else
        throw new Exception('权限不足');
    }
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
