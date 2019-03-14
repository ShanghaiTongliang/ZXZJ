<?php

class StandardController extends Yaf\Controller_Abstract {
  function getParams() {
    $p = $this->getRequest()->getParams();
    if(in_array($p['type'], ['xiuCheng', 'cheZhong', 'daBuWei', 'xiaoBuWei', 'juTiBuWei', 'guZhang', 'dengJi', 'peiJian']))
      return $p;
    else
      response(_('standard type not found'), RES_NOT_FOUND);
  }

  function storeAction() {
    if($p = $this->getParams()) {
      $s = Table::open($p['type']);
      $a = json_decode(file_get_contents('php://input'));
      foreach($a as $k => $v)
        $s->$k = $v;
      $s->save();
      echo json_encode(['id' => $s->id]);
    }
  }

  function updateAction() {
    if($p = $this->getParams()) {
      if($s = Table::open($p['type'])::find($p['id'])) {
        $a = json_decode(file_get_contents('php://input'));
        foreach($a as $k => $v)
          $s->$k = $v;
        $s->save();
      } else
        response(_('standard not found'), RES_NOT_FOUND);
    }
  }

  function destroyAction() {
    if($p = $this->getParams()) {
      if($s = Table::open($p['type'])::find($p['id'])) {
        $s->delete();
        $s->resetAutoIncrement();
      } else
        response(_('standard not found'), RES_NOT_FOUND);
    }
  }
}
