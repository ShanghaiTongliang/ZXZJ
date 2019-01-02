<?php

class GuZhangController extends Yaf\Controller_Abstract {
  function getParams() {
    $p = $this->getRequest()->getParams();
    if(in_array($p['type'], ['zhengCheJiaoJian', 'lingBuJianJiaoJian', 'lingBuJianChouYang', 'lingBuJianFuJian', 'guZhangList']))
      return $p;
    else
      response(_('guZhang type not found'), RES_NOT_FOUND);
  }

  function storeAction() {
    if($p = $this->getParams()) {
      $g = Table::open($p['type']);
      foreach($_POST as $k => $v)
        $g->$k = $v;
      $g->save();
      echo $g->id;
    }
  }

  function updateAction() {
    if($p = $this->getParams()) {
      if($g = Table::open($p['type'])::find($p['id'])) {
        $a = json_decode(file_get_contents('php://input'));
        foreach($a as $k => $v)
          $g->$k = $v;
        $g->save();
      } else
        response(_('guZhang not found'), RES_NOT_FOUND);
    }
  }

  function destroyAction() {
    if($p = $this->getParams()) {
      if($g = Table::open($p['type'])::find($p['id'])) {
        $g->delete();
        $g::resetAutoIncrement();
      } else
        response(_('guZhang not found'), RES_NOT_FOUND);
    }
  }
}
