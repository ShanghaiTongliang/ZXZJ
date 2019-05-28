<?php
use Zxzj\Redis;

class UserController extends Yaf\Controller_Abstract {
  //新建用户
  function storeAction() {
    if($u = UserModel::register($_POST, $err)) {
      $t = time();
      $token = rand(1, 0xffff);
      $redis = Redis::instance();
      $redis->set("token$u->id", $token, 86400 * 7);
      setcookie('id', $u->id, $t + 1800, PATH);
      //setcookie('token', $u->token, $t + 86400 * 365, PATH, '', false, true);
      setcookie('token', JWT::encode(['id' => $u->id, 'token' => $token], 'tongliang'), $t + 86400 * 365, PATH, '', false, true);
      $this->forward('auth', 'index');
    } else
      response($err);
  }

  //修改用户
  function updateAction() {
    if($u = UserModel::find($id = $this->getRequest()->getParams()['id'])) {
      $p = json_decode(file_get_contents('php://input'));
      foreach($p as $k => $v)
        $u->$k = $v;
      $u->save();
    }
  }

  //删除用户
  function destroyAction() {
    if($u = UserModel::find($id = $this->getRequest()->getParams()['id'])) {
      if(UserModel::$user->admin()) {
        //清理关联表
        foreach(DianWenModel::get() as $d) {
          $cs = $d->checkin;
          $i = 0; $c = count($cs);
          while($i < $c)
            if($cs[$i]->id == $id) {
              array_splice($cs, $i, 1);
              $d->checkin = $cs;
              $d->save();
              break;
            } else
              $i++;
        }
        $u->delete();
        $u::resetAutoIncrement();
        return;
      } else
        $err = _('no permission');
    } else
      $err = _('user does not exists');
    response($err);
  }

  //修改密码
  function updatePasswordAction() {
    $a = json_decode(file_get_contents('php://input'), true);
    if($reset = $a['reset'] ?? null)
      $a['previous'] = '111111';
    if(Validator::valid($a, ['password' => 'required|between:6,16|confirmed'], $err)) {
      if($u = UserModel::find($a['id'])) {
        if($u->state != UserModel::USER_STATE_APPROVED_RESET_PASSWORD) {
          if(Validator::valid($a, ['previous' => 'required|between:6,16'], $err)) {
            if($u->password != crypt($a['previous'], $u->password))
              $err = _('previous password incorrect');
          }
        } elseif(Validator::valid($a, ['previous' => 'required|between:6,16'], $err)) {
          if($u->password != crypt($a['previous'], $u->password))
            $err = _('previous password incorrect');
          else {
            $u->password = crypt($a['password'], md5(rand(0x7fff, 0xffff)));
            if($reset)
              $u->state = null;
            $u->save();
            return;
          }
        }
      } else
        $err = _('user does not exists');
    }
    response($err);
  }

  //重置密码
  function resetPasswordAction() {
    //todo 权限
    if($_POST['action'] == 'apply') {
      if($u = UserModel::where(['name' => $_POST['name']])->first()) {
        $u->state = UserModel::USER_STATE_APPLY_RESET_PASSWORD;
        $u->save();
        return;
      }
    } else {
      if($u = UserModel::find($_POST['id'])) {
        //重置密码
        if($_POST['action'] == 'approve') {
          $u->password = crypt('111111', md5(rand(0x7fff, 0xffff)));
          $u->state = UserModel::USER_STATE_APPROVED_RESET_PASSWORD;
        } else
          $u->state = null;
        $u->save();
        return;
      }
    }
    response(_('user does not exists'));
  }

  /*function upgradeAction() {
    $cs = [];
    foreach(Table::open('cheJian')::get() as $c)
      $cs[$c->id] = $c;
    foreach(UserModel::get() as $u) {
      if($u->cheJian) {
        $u->danWei = $cs[$u->cheJian]->danWei;
        $u->save();
      }
    }
  }*/
}
