<?php
class DanWeiController extends Yaf\Controller_Abstract {
  function storeAction() {
    if(Validator::valid($_POST, ['name' => 'required|between:6,64'], $err)) {
      if($d = Table::open('danWei')::where(['name' => $_POST['name']])->first())
        $err = '单位已经存在';
      else {
        $d = Table::open('danWei');
        $d->name = $_POST['name'];
        $d->save();
        echo $d;
        return;
      }
    }
    response($err);
  }
}
