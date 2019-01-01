<?php
use Zxzj\Redis;

class AuthController extends Yaf\Controller_Abstract {
  function indexAction() {
    $us = UserModel::get();
    foreach($us as $u) {
      $f = "/img/user/$u->id.png";
      $u->icon = file_exists(APP_PATH . $f) ? $f : '/img/user16.png';
    }
    $dws = Table::open('danWei')::get();
    foreach($dws as $dw) {
      $dw->cheJian = Table::open('cheJian')::where(['danWei' => $dw->id])->get();
      foreach($dw->cheJian as $c) {
        $c->banZu = Table::open('banZu')::where(['cheJian' => $c->id])->get();
        foreach($c->banZu as $b) {
          $b->user = [];
          foreach($us as $u)
            if($u->banZu == $b->id)
              $b->user[] = $u->id;
        }
      }
    }
    echo json_encode([
      'users' => $us,
      'groups' => GroupModel::get(),
      //单位人员信息
      'danWei' => $dws,
      'std' => [
        'xiuCheng' => Table::open('xiuCheng')::get(),
        'cheZhong' => Table::open('cheZhong')::get(),
        'daBuWei' => Table::open('daBuWei')::get(),
        'xiaoBuWei' => Table::open('xiaoBuWei')::get(),
        'juTiBuWei' => Table::open('juTiBuWei')::get(),
        'guZhang' => Table::open('guZhang')::get(),
        'dengJi' => Table::open('dengJi')::get(),
        'guZhangList' => Table::open('guZhangList')::get(),
      ],
      'guZhang' => [
        'zhengCheJiaoJian' => Table::open('zhengCheJiaoJian')::get()
      ]
    ], JSON_UNESCAPED_UNICODE);
  }

  //登录
  function storeAction() {
    if($u = UserModel::login($_POST, $err)) {
      $t = time();
      $token = rand(1, 0xffff);
      $redis = Redis::instance();
      $redis->set("token$u->id", $token);
      setcookie('id', $u->id, $t + ($_POST['remember'] ?? false ? 86400 * 7 : 1800), PATH);
      //setcookie('token', $u->token, $t + 86400 * 365, PATH, '', false, true);
      setcookie('token', JWT::encode(['id' => $u->id, 'token' => $token], 'tongliang'), $t + 86400 * 365, PATH, '', false, true);
      $this->indexAction();
    } else
      response($err);
  }

  function destroyAction() {
    $t = time();
    setcookie('id', 0, $t - 3600, PATH);
    setcookie('token', 0, $t - 3600, PATH);
  }
}
