<?php

class UserController extends Yaf\Controller_Abstract {
  //新建用户
  function storeAction() {
    if($u = UserModel::register($_POST, $err)) {
      $t = time();
      setcookie('id', $u->id, $t + 1800, PATH);
      setcookie('token', $u->token, $t + 86400 * 365, PATH, '', false, true);
      $this->forward('auth', 'index');
    } else
      response($err);
  }
}
