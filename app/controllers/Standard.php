<?php
class StandardController extends Yaf\Controller_Abstract {
  function storeAction() {
    $t = $this->getRequest()->getParams()['type'];
    if(in_array($t, ['cheZhong', 'daBuWei', 'xiaoBuWei', 'juTiBuWei', 'guZhang'])) {
      $o = Table::open($t);
      $o->name = file_get_contents('php://input');
      $o->save();
      echo $o;
    } else
      response(_('standard type not found'), RES_NOT_FOUND);
  }
}
