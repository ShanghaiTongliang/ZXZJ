<?php

class UserController extends Yaf\Controller_Abstract {
  //新建用户
  function storeAction() {
    if($u = UserModel::register($_POST, $err))
      $this->forward('auth', 'store');
    else
      response($err);
  }
}
