<?php

class AuthController extends Yaf\Controller_Abstract {
  function indexAction() {
    echo json_encode(UserModel::$user);
  }

  //登录
  function storeAction() {
    if($u = UserModel::login($_POST['name'], $_POST['password'], $err)) {
      $t = time();
      setcookie('id', $u->id, $t + ($_POST['remember'] ? 86400 * 7 : 1800));
      setcookie('token', $u->token, $t + 86400 * 365, '', '', false, true);
      $this->indexAction();
    } else
      response($err);
  }
}