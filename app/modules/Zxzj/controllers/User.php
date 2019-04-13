<?php

class UserController extends Yaf\Controller_Abstract {
  //新建用户
  function storeAction() {
    if($u = UserModel::register($_POST, $err)) {
      $t = time();
      setcookie('id', $u->id, $t + 1800, PATH);
      //setcookie('token', $u->token, $t + 86400 * 365, PATH, '', false, true);
      setcookie('token', JWT::encode(['id' => $u->id], 'tongliang'), $t + 86400 * 365, PATH, '', false, true);
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
      if(UserModel::$user->admin($u)) {
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
    if(Validator::valid($a, [
      'previous' => 'required|between:6,16',
      'password' => 'required|between:6,16|confirmed'
    ], $err)) {
      if($u = UserModel::find($a['id'])) {
        if($u->password != crypt($a['previous'], $u->password))
          $err = _('previous password incorrect');
        else {
          $u->password = crypt($a['password'], md5(rand(0x7fff, 0xffff)));
          $u->save();
          return;
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
        $u->state = 1;
        $u->save();
        return;
      }
    } else {
      if($u = UserModel::find($_POST['id'])) {
        //重置密码
        if($_POST['action'] == 'approve')
          $u->password = crypt('123456', md5(rand(0x7fff, 0xffff)));
        $u->state = null;
        $u->save();
        return;
      }
    }
    response(_('user does not exists'));
  }

  function upgradeAction() {
    $bs = [];
    foreach(Table::open('banZu')::get() as $b)
      $bs[$b->id] = $b;
    foreach(UserModel::get() as $u) {
      if($u->banZu) {
        $u->cheJian = $bs[$u->banZu]->cheJian;
        $u->save();
      }
    }
  }
}
