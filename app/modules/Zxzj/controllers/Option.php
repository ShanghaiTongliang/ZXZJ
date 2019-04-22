<?php

class OptionController extends Yaf\Controller_Abstract {
  function updateAction() {
    if(UserModel::$user->admin()) {
      $o = OptionModel::first();
      foreach(json_decode(file_get_contents('php://input')) as $k => $v)
        $o->options->$k = $v;
      $o->options = $o->options;
      $o->save();
    } else
      response(_('no permission'), RES_NO_PERMISSION);
  }
}
