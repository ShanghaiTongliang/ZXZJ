<?php
use Zxzj\Redis;

class AuthController extends Yaf\Controller_Abstract {
  function indexAction() {
    $us = UserModel::get();
    foreach($us as $u) {
      $f = "/img/user/$u->id.png";
      $u->icon = file_exists(APP_PATH . $f) ? $f : '/img/user16.png';
    }
    $ds = Table::open('danWei')::get();
    $cs = Table::open('cheJian')::get();
    $bs = Table::open('banZu')::get();
    $us = UserModel::get();
    $zcs = JiaoJianCountModel::orderBy('month')->get();
    foreach($ds as $d)
      $d->cheJian = [];
    foreach($cs as $c) {
      $c->banZu = [];
      foreach($ds as $d) {
        if($c->danWei == $d->id) {
          $d->cheJian[] = $c;
          break;
        }
      }
      $c->jiaoJian = [];
      foreach($zcs as $z)
        if($z->cheJian == $c->id)
          $c->jiaoJian[] = $z;
    }
    foreach($bs as $b) {
      $b->user = [];
      foreach($cs as $c)
        if($b->cheJian == $c->id) {
          $c->banZu[] = $b;
          break;
        }
    }
    foreach($us as $u)
      foreach($bs as $b)
        if($u->banZu == $b->id) {
          $b->user[] = $u->id;
          break;
        }

    $y = date('Y');
    $m = date('m');
    $d = date('t');
    if($m < 12) {
      $y0 = $y - 1;
      $m0 = $m + 1;
    } else {
      $y0 = $y;
      $m0 = 1;
    }
    $t = date("Y-m-d");
    echo json_encode([
      'users' => $us,
      'groups' => GroupModel::get(),
      'config' => Table::open('config')::first(),
      //单位人员信息
      'danWei' => $ds,
      'std' => [
        'xiuCheng' => Table::open('xiuCheng')::get(),
        'cheZhong' => Table::open('cheZhong')::get(),
        'peiJian' => Table::open('peiJian')::get()
      ],
      'jiaoJian' => Table::open('jiaoJian')::where("date >= '$y0-$m0-01' and date <= '$y-$m-$d'")->get(),
      'ruKuFuJian' => Table::open('ruKuFuJian')::where("date = '$t'")->get(),
      'jiaoJianChuLi' => Table::open('jiaoJianChuLi')::orderBy('xiaFaShiJian', 'desc')->get(),
      'pingJia' => PingJiaModel::get()
    ], JSON_UNESCAPED_UNICODE);
  }

  //登录
  function storeAction() {
    if($u = UserModel::login($_POST, $err)) {
      $t = time();
      $token = rand(1, 0xffff);
      $redis = Redis::instance();
      $redis->set("token$u->id", $token, 86400 * 7);
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
