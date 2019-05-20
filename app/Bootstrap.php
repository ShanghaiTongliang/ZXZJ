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
      'danWei' => '单位',
      'cheJian' => '作业场',
      'banZu' => '班组',
      'previous' => '原密码',
      'format incorrect' => '格式错误',
      'group %d: %s already exists' => '用户组 %d: %s 已存在',
      'group not found' => '用户组未找到',
      'guZhang not found' => '故障未找到',
      'no permission' => '权限不足',
      'password incorrect' => '密码错误',
      'previous password incorrect' => '原密码错误',
      'standard not found' => '标准未找到',
      'standard type not found' => '标准类型未找到',
      'danWei not found' => '单位未找到',
      'danWei %s already already exists' => '单位 %s 已经存在',
      'cheJian not found' => '作业场未找到',
      'cheJian %s already already exists' => '作业场 %s 已经存在',
      'banZu not found' => '班组未找到',
      'banZu %s already already exists' => '班组 %s 已经存在',
      'please delete all subitems first' => '请先删除所有子项目',
      'user already exists' => '用户已存在',
      'user does not exists' => '用户不存在',
      'dianWen not found' => '电文未找到',
      'zhiDaoShu not found' => '指导书未找到',
      'ziLiao not found' => '资料未找到',
    ], 'zh-cn');
    Language::set($_SERVER['HTTP_ACCEPT_LANGUAGE']);

    //辅助函数
    Yaf\Loader::import(APP_PATH.'/app/helper.php');
  }

  public function _initPlugin(Dispatcher $dispatcher) {
    //注册一个插件
    $dispatcher->registerPlugin(new MiddlewarePlugin());
  }

  public function _initRoute(Dispatcher $dispatcher) {
    Router::init($dispatcher->getRouter(), $dispatcher->getRequest()->method);
    Router::prefix('api', function($router) {
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

      $p['action'] = 'upgrade';
      $router->get('user', $p);

      //重置密码
      $p['action'] = 'resetPassword';
      $router->post('user/password', $p);
      $router->middleware($auth, function($router) use($p) {
        $p['action'] = 'update';
        $router->put('user/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('user/:id', $p);
        //修改密码
        $p['action'] = 'updatePassword';
        $router->put('user/:id/password', $p);
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
        $p['action'] = 'update';
        $router->put('danWei/:did', $p);
        $p['action'] = 'destroy';
        $router->delete('danWei/:did', $p);
        //作业场
        $p['action'] = 'storeCheJian';
        $router->post('danWei/:did/cheJian', $p);
        $p['action'] = 'updateCheJian';
        $router->put('danWei/:did/cheJian/:cid', $p);
        $p['action'] = 'destroyCheJian';
        $router->delete('danWei/:did/cheJian/:cid', $p);
        //班组
        $p['action'] = 'storeBanZu';
        $router->post('danWei/:did/cheJian/:cid/banZu', $p);
        $p['action'] = 'updateBanZu';
        $router->put('danWei/:did/cheJian/:cid/banZu/:bid', $p);
        $p['action'] = 'destroyBanZu';
        $router->delete('danWei/:did/cheJian/:cid/banZu/:bid', $p);

        //用户组
        $p['controller'] = 'group';
        $p['action'] = 'store';
        $router->post('group', $p);
        $p['action'] = 'update';
        $router->put('group/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('group/:id', $p);

        //标准参数
        $p['controller'] = 'standard';
        $p['action'] = 'indexDaBuWei';
        $router->get('standard/daBuWei', $p);
        $p['action'] = 'indexCheZhong';
        $router->get('standard/cheZhong', $p);
        $p['action'] = 'store';
        $router->post('standard/:type', $p);
        $p['action'] = 'update';
        $router->put('standard/:type/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('standard/:type/:id', $p);

        //整车交检
        //增删改
        $p['controller'] = 'jiaoJian';
        $p['action'] = 'store';
        $router->post('jiaoJian', $p);
        $p['action'] = 'update';
        $router->put('jiaoJian/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('jiaoJian/:id', $p);
        //设置数量
        $p['action'] = 'updateCount';
        $router->put('jiaoJian/count', $p);
        //查询
        $p['action'] = 'query';
        $router->post('jiaoJian/query', $p);
        //下发，新建处理
        $p['action'] = 'storeChuLi';
        $router->post('jiaoJian/:id/chuLi', $p);
        //签收/复检，更新处理
        $p['action'] = 'updateChuLi';
        $router->put('jiaoJian/:id/chuLi', $p);

        //入库复检
        $p['controller'] = 'ruKuFuJian';
        $p['action'] = 'store';
        $router->post('ruKuFuJian', $p);
        $p['action'] = 'update';
        $router->put('ruKuFuJian/:id', $p);
        $p['action'] = 'destroy';
        $router->delete('ruKuFuJian/:id', $p);
        //查询
        $p['action'] = 'query';
        $router->post('ruKuFuJian/query', $p);

        //质检员
        //电文下发
        $p['controller'] = 'zhiJianYuan';
        $p['action'] = 'storeDianWen';
        $router->post('zhiJianYuan/dianWen', $p);
        $p['action'] = 'updateDianWen';
        $router->put('zhiJianYuan/dianWen/:id', $p);
        $p['action'] = 'destoyDianWen';
        $router->delete('zhiJianYuan/dianWen/:id', $p);
        //签收
        $p['action'] = 'checkinDianWen';
        $router->put('zhiJianYuan/dianWen/:id/checkin', $p);
        $p['action'] = 'destroyDianWen';
        $router->delete('zhiJianYuan/dianWen/:id', $p);
        //作业指导书
        $p['action'] = 'storeZhiDaoShu';
        $router->post('zhiJianYuan/zhiDaoShu', $p);
        //PUT没有 $_FILES变量
        //$p['action'] = 'updateZhiDaoShu';
        //$router->put('zhiJianYuan/zhiDaoShu', $p);
        $p['action'] = 'destroyZhiDaoShu';
        $router->delete('zhiJianYuan/zhiDaoShu', $p);
        //资料
        $p['action'] = 'storeZiLiao';
        $router->post('zhiJianYuan/ziLiao', $p);
        //$p['action'] = 'updateZiLiao';
        //$router->put('zhiJianYuan/ziLiao', $p);
        $p['action'] = 'destroyZiLiao';
        $router->delete('zhiJianYuan/ziLiao', $p);

        //系统参数
        $p['controller'] = 'option';
        $p['action'] = 'update';
        $router->put('option', $p);
      });
    });
  }

  public function _initView(Dispatcher $dispatcher) {
    //在这里注册自己的view控制器，例如smarty,firekylin
    $dispatcher->disableView();
  }
}
