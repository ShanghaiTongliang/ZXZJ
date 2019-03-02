<?php

class ZhengCheJiaoJianController extends Yaf\Controller_Abstract {

  function storeAction() {
    $g = Table::open('zhengCheJiaoJian');
    foreach($_POST as $k => $v)
      $g->$k = $v;
    $g->save();
    echo $g->id;
  }

  function updateAction() {
    $p = $this->getRequest()->getParams();
    if($g = Table::open('zhengCheJiaoJian')::find($p['id'])) {
      $a = json_decode(file_get_contents('php://input'));
      foreach($a as $k => $v)
        $g->$k = $v;
      $g->save();
    } else
      response(_('guZhang not found'), RES_NOT_FOUND);
  }

  function destroyAction() {
    $p = $this->getRequest()->getParams();
    if($g = Table::open('zhengCheJiaoJian')::find($p['id'])) {
      $g->delete();
      $g::resetAutoIncrement();
    } else
      response(_('guZhang not found'), RES_NOT_FOUND);
  }

  function countAction() {
    $p = $this->getRequest()->getParams();
    $a = json_decode(file_get_contents('php://input'));
    if($c = Table::open('cheJian')::find($a->cheJian)) {
      if(!$c = Table::open('zhengCheJiaoJianCount')::where(['month' => $p['month'], 'cheJian' => $a->cheJian])->first()) {
        $c = new Table('zhengCheJiaoJianCount');
        $c->cheJian = $a->cheJian;
        $c->month = $p['month'];
      }
      $c->count = $a->count;
      $c->save();
      echo json_encode(['id' => $c->id]);
    } else
      response(_('cheJian not found'), RES_NOT_FOUND);
  }
}
