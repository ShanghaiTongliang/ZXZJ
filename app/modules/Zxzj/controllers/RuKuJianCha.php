<?php

class RuKuJianChaController extends Yaf\Controller_Abstract {

  function storeAction() {
    $g = Table::open('ruKuJianCha');
    foreach($_POST as $k => $v)
      $g->$k = $v;
    $g->save();
    echo $g->id;
  }

  function updateAction() {
    $p = $this->getRequest()->getParams();
    if($g = Table::open('ruKuJianCha')::find($p['id'])) {
      $a = json_decode(file_get_contents('php://input'));
      foreach($a as $k => $v)
        $g->$k = $v;
      $g->save();
    } else
      response(_('guZhang not found'), RES_NOT_FOUND);
  }

  function destroyAction() {
    $p = $this->getRequest()->getParams();
    if($g = Table::open('ruKuJianCha')::find($p['id'])) {
      $g->delete();
      $g::resetAutoIncrement();
    } else
      response(_('guZhang not found'), RES_NOT_FOUND);
  }
}
