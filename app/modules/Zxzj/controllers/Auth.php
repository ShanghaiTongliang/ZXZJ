<?php
use Zxzj\Redis;

class AuthController extends Yaf\Controller_Abstract {

  static function scandir(string $p): array {
    $r = [];
    if($fs = scandir($p)) {
      foreach($fs as $f) {
        if($f != '.' && $f != '..') {
          $t = "$p/$f";
          $r[] = [
            'name' => $f,
            'time' => filemtime($t),
            'size' => filesize($t)
          ];
        }
      }
    }
    usort($r, function($a, $b) {
      return $b['time'] - $a['time'];
    });
    return $r;
  }

  function indexAction() {
    $us = UserModel::get();
    $gs = GroupModel::get();
    foreach($us as $u) {
      $f = "img/user/$u->id.png";
      $u->icon = file_exists(APP_PATH . $f) ? $f : 'img/user16.png';
    }
    $ds = Table::open('danWei')::get();
    $cs = CheJianModel::get();
    foreach($ds as $d)
      $d->cheJian = [];
    foreach($cs as $c) {
      $c->user = [];
      foreach($ds as $d) {
        if($c->danWei == $d->id) {
          $d->cheJian[] = $c;
          break;
        }
      }
    }
    foreach($us as $u)
      foreach($cs as $c)
        if($u->cheJian == $c->id) {
          $c->user[] = $u->id;
          break;
        }
    $zcs = JiaoJianCountModel::orderBy('month')->get();
    foreach($cs as $c) {
      $c->jiaoJian = [];
      foreach($zcs as $z)
        if($z->cheJian == $c->id)
          $c->jiaoJian[] = $z;
    }
    foreach($ps = Table::open('peiJian')::get() as $p)
      $p->xingHao = [];
    foreach(Table::open('xingHao')::get() as $x)
      foreach($ps as $p)
        if($x->peiJian == $p->id)
          $p->xingHao[] = $x;

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
    $sql = "date >= '$y0-$m0-01' and date <= '$y-$m-$d'";
    //作业指导书, 学习资料
    $zds = static::scandir('zhiJianYuan/zhiDaoShu');
    $zl = static::scandir('zhiJianYuan/ziLiao');
    $o = OptionModel::first();
    echo json_encode([
      'users' => $us,
      'groups' => $gs,
      'options' => $o->options,
      'state' => $o->state,
      'std' => [
        'danWei' => $ds,
        'xiuCheng' => Table::open('xiuCheng')::get(),
        'peiJian' => $ps,
      ],
      'jiaoJian' => Table::open('jiaoJian')::where($sql)->get(),
      'ruKuFuJian' => Table::open('ruKuFuJian')::where($sql)->get(),
      'jiaoJianChuLi' => Table::open('jiaoJianChuLi')::orderBy('xiaFaShiJian', 'desc')->get(),
      'zhiJianYuan' => [
        'dianWen' => DianWenModel::orderBy('date', true)->get(),
        'zhiDaoShu' => $zds,
        'ziLiao' => $zl
      ]
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
