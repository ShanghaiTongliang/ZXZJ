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
    define('PATH', '/');

    //本地化
    $lang = str_replace('-', '_', explode(',', $_SERVER['HTTP_ACCEPT_LANGUAGE'])[0]) . '.UTF8';
    putenv("LANG=$lang");
    setlocale(LC_ALL, $lang);
    $domain = 'zxzj';
    bindtextdomain($domain, APP_PATH.'/locale');
    bind_textdomain_codeset($domain, 'UTF-8');
    textdomain($domain);
    Validator::init();

    //辅助函数
    Yaf\Loader::import(APP_PATH.'/app/helper.php');
  }

  public function _initPlugin(Dispatcher $dispatcher) {
    //注册一个插件
    $dispatcher->registerPlugin(new AuthPlugin());
  }

  public function _initRoute(Dispatcher $dispatcher) {
    Router::init($dispatcher->getRouter(), $dispatcher->getRequest()->method);
    Router::prefix('api', function($router) {
      $auth = new Middleware\Auth;
      $p = [
        'controller' => 'index',
        'action' => 'calc'
      ];
      $router->post('calc', $p);
      $p['action'] = 'list';
      $router->get('list', $p);
      $p['action'] = 'cheXing';
      $router->get('cheXing', $p);

      //注册
      $p['controller'] = 'user';
      $p['action'] = 'store';
      $router->post('user', $p);
      $router->middleware($auth, function($router) use($p) {
        //修改
        $p['action'] = 'update';
        $router->put('user/:id', $p);
        //删除
        $p['action'] = 'destroy';
        $router->delete('user/:id', $p);
      });

      $p['controller'] = 'auth';
      //登录
      $p['action'] = 'store';
      $router->post('auth', $p);
      $router->middleware($auth, function($router) use($p) {
        //查看信息
        $p['action'] = 'index';
        $router->get('auth', $p);

        //单位
        $p['controller'] = 'danWei';
        //新建
        $p['action'] = 'store';
        $router->post('danWei', $p);
      });
    });
  }

  public function _initView(Dispatcher $dispatcher) {
    //在这里注册自己的view控制器，例如smarty,firekylin
    $dispatcher->disableView();
  }
}
