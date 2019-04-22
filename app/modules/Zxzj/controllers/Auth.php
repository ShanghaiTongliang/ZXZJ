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
    return $r;
  }

  function indexAction() {
    $us = UserModel::get();
    $gs = GroupModel::get();
    foreach($us as $u) {
      $f = "img/user/$u->id.png";
      $u->icon = file_exists(APP_PATH . $f) ? $f : 'img/user16.png';
    }
    if(UserModel::$user->admin()) {
      $ds = Table::open('danWei')::get();
      $cs = CheJianModel::get();
      $us = UserModel::get();
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
    } else {
      $gx = [];
      $dx = [];
      $ds = [];
      $cx = [];
      $cs = [];
      foreach(GroupModel::get() as $g)
        $gx[$g->id] = $g;
      foreach(UserModel::$user->groups as $g) {
        $g = $gx[$g];
        foreach($g->cheJian as $c0)
          if(!$c = $cx[$c0->id] ?? null) {
            $c = CheJianModel::find($c0->id);
            $c->user = [];
            $cx[$c->id] = $c;
          }
      }
      $m = Table::open('danWei');
      foreach($cx as $c) {
        $cs[] = $c;
        if(!$d = $dx[$c->danWei] ?? null) {
          $d = $m::find($c->danWei);
          $d->cheJian = [];
          $dx[$d->id] = $d;
        }
        $d->cheJian[] = $c;
      }
      foreach($dx as $d)
        $ds[] = $d;
    }
    $zcs = JiaoJianCountModel::orderBy('month')->get();
    foreach($cs as $c) {
      $c->jiaoJian = [];
      foreach($zcs as $z)
        if($z->cheJian == $c->id)
          $c->jiaoJian[] = $z;
    }
    foreach($us as $u)
      foreach($cs as $c)
        if($u->cheJian == $c->id) {
          $c->user[] = $u->id;
          break;
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
    echo json_encode([
      'users' => $us,
      'groups' => $gs,
      'config' => Table::open('config')::first(),
      //单位人员信息
      'danWei' => $ds,
      'std' => [
        'xiuCheng' => Table::open('xiuCheng')::get(),
        'cheZhong' => Table::open('cheZhong')::get(),
        'peiJian' => $ps,
      ],
      'jiaoJian' => Table::open('jiaoJian')::where($sql)->get(),
      'ruKuFuJian' => Table::open('ruKuFuJian')::where($sql)->get(),
      'jiaoJianChuLi' => Table::open('jiaoJianChuLi')::orderBy('xiaFaShiJian', 'desc')->get(),
      'zhiJianYuan' => [
        'dianWen' => DianWenModel::get(),
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
