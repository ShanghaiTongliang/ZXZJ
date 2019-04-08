<?php

class PingJiaController extends Yaf\Controller_Abstract {
  function storeAction() {
    $p = new PingJiaModel;
    foreach($_POST as $k => $v)
      $p->$k = $v;
    $p->save();
    echo json_encode(['id' => $p->id]);
  }

  function updateAction() {
    $p = $this->getRequest()->getParams();
    if($p = PingJiaModel::find($p['id'])) {
      $a = json_decode(file_get_contents('php://input'));
      unset($a->id);
      foreach($a as $k => $v)
        $p->$k = $v;
      $p->save();
    } else
      response(_('pingJia not found'));
  }

  function destroyAction() {
    $p = $this->getRequest()->getParams();
    if($p = PingJiaModel::find($p['id'])) {
      $p->delete();
      $p::resetAutoIncrement();
    } else
      response(_('pingJia not found'));    
  }
}
