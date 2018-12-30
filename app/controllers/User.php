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

      } else
        $err = _('no permission');
    } else
      $err = _('user not exists');
    response($err);
  }
}
