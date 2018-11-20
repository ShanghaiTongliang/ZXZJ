<?php
/**
 * @name Bootstrap
 * @author oblind-nb\oblind
 * @desc 所有在Bootstrap类中, 以_init开头的方法, 都会被Yaf调用,
 * @see http://www.php.net/manual/en/class.yaf-bootstrap-abstract.php
 * 这些方法, 都接受一个参数:Yaf_Dispatcher $dispatcher
 * 调用的次序, 和申明的次序相同
 */
use Yaf\Dispatcher;
use Yaf\Route;

class Bootstrap extends Yaf\Bootstrap_Abstract {

  public function _initConfig() {
    //把配置保存起来
    $arrConfig = Yaf\Application::app()->getConfig();
    Yaf\Registry::set('config', $arrConfig);
  }

  public function _initPlugin(Dispatcher $dispatcher) {
    //注册一个插件
    $objSamplePlugin = new SamplePlugin();
    $dispatcher->registerPlugin($objSamplePlugin);
  }

  public function _initRoute(Dispatcher $dispatcher) {
    //在这里注册自己的路由协议,默认使用简单路由
    $r = $dispatcher->getRouter();
    $req = $dispatcher->getRequest();
    if($req->method == 'POST')
      $r->addRoute('calc', new Route\Rewrite('calc', ['controller' => 'index', 'action' => 'calc']));
    $r->addRoute('aaa', new Route\Rewrite('aaa', ['controller' => 'index', 'action' => 'aaa']));
    $r->addRoute('list', new Route\Rewrite('api/list', ['controller' => 'index', 'action' => 'list']));
  }

  public function _initView(Dispatcher $dispatcher) {
    //在这里注册自己的view控制器，例如smarty,firekylin
  }
}
