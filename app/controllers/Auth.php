<?php

class AuthController extends Yaf\Controller_Abstract {
  function indexAction() {
    $us = UserModel::get();
    foreach($us as $u) {
      $f = "/img/user/$u->id.png";
      $u->icon = file_exists(APP_PATH . $f) ? $f : '/img/user16.png';
    }
    echo json_encode([
      'users' => $us,
      'groups' => []
    ], JSON_UNESCAPED_UNICODE);
  }

  //登录
  function storeAction() {
    if($u = UserModel::login($_POST, $err)) {
      $t = time();
      setcookie('id', $u->id, $t + ($_POST['remember'] ?? false ? 86400 * 7 : 1800), PATH);
      setcookie('token', $u->token, $t + 86400 * 365, PATH, '', false, true);
      $this->indexAction();
    } else
      response($err);
  }
}