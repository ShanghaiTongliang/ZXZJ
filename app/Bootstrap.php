<?php
require '../vendor/autoload.php';

/**
 * @name Bootstrap
 * @author oblind-nb\oblind
 * @desc 所有在Bootstrap类中, 以_init开头的方法, 都会被Yaf调用,
 * @see http://www.php.net/manual/en/class.yaf-bootstrap-abstract.php
 * 这些方法, 都接受一个参数:Yaf_Dispatcher $dispatcher
 * 调用的次序, 和申明的次序相同
 */
use Yaf\Dispatcher;
use Oblind\Language;

class Bootstrap extends Yaf\Bootstrap_Abstract {

  public function _initConfig() {
    define('PATH', '/zxzj');

    //本地化
    Language::addTranslation([
      ":attribute format invalid" => ":attribute 格式错误",
      ":attribute inconsistent" => ":attribute 不相符",
      ":attribute length between %d-%d" => ":attribute 长度范围 %d-%d",
      ":attribute maximal length %d" => ":attribute 最多 %d 字符",
      ":attribute minimal length %d" => ":attribute 至少 %d 字符",
      ":attribute required" => "请输入 :attribute",
      "confirmation" => "确认密码",
      "email" => "电子邮箱",
      "format incorrect" => "格式错误",
      "group %d: %s already exists" => "用户组 %d: %s 已存在",
      "group not found" => "用户组未找到",
      "guZhang not found" => "故障未找到",
      "name" => "用户名",
      "no permission" => "权限不足",
      "password" => "密码",
      "password incorrect" => "密码错误",
      "standard not found" => "标准未找到",
      "standard type not found" => "标准类型未找到",
      "user already exists" => "用户已存在",
      "user does not exists" => "用户不存在",
    ], 'zh-cn');
    Language::set(explode(',', $_SERVER['HTTP_ACCEPT_LANGUAGE'])[0]);

    //辅助函数
    Yaf\Loader::import(APP_PATH.'/app/helper.php');
  }

  public function _initPlugin(Dispatcher $dispatcher) {
    //注册一个插件
    $dispatcher->registerPlugin(new MiddlewarePlugin());
  }

  public function _initRoute(Dispatcher $dispatcher) {
    Router::init($dispatcher->getRouter(), $dispatcher->getRequest()->method);
    Router::prefix('zxzj/api', function($router) {
      $auth = new Middleware\Auth;
      $p = [
        'module' => 'zxzj',
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
        $p['action'] = 'update';
        $router->put('user/:id', $p);
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
        $p['action'] = 'destroy';
        $router->delete('auth', $p);

        //单位
        $p['controller'] = 'danWei';
        $p['action'] = 'store';
        $router->post('danWei', $p);

        //用户组
        $p['controller'] = 'group';
        $p['action'] = 'store';
        $router->post('group', $p);
        $p['action'] = 'update';
        $router->put('group/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('group/:id', $p);

        //故障
        $p['controller'] = 'guzhang';
        $p['action'] = 'index';
        $router->get('guzhang', $p);

        //标准参数
        $p['controller'] = 'standard';
        $p['action'] = 'store';
        $router->post('standard/:type', $p);
        $p['action'] = 'update';
        $router->put('standard/:type/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('standard/:type/:id', $p);

        //整车交检
        $p['controller'] = 'zhengCheJiaoJian';
        $p['action'] = 'store';
        $router->post('zhengCheJiaoJian', $p);
        $p['action'] = 'update';
        $router->put('zhengCheJiaoJian/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('zhengCheJiaoJian/:id', $p);
        //设置数量
        $p['action'] = 'count';
        $router->put('zhengCheJiaoJian/:month/count', $p);

        //入库检查
        $p['controller'] = 'ruKuJianCha';
        $p['action'] = 'store';
        $router->post('ruKuJianCha', $p);
        $p['action'] = 'update';
        $router->put('ruKuJianCha/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('ruKuJianCha/:id', $p);
      });

    });
  }

  public function _initView(Dispatcher $dispatcher) {
    //在这里注册自己的view控制器，例如smarty,firekylin
    $dispatcher->disableView();
  }
}
