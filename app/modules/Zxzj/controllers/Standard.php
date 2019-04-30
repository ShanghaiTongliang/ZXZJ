<?php

class StandardController extends Yaf\Controller_Abstract {
  function getParams() {
    $p = $this->getRequest()->getParams();
    if(in_array($p['type'], ['xiuCheng', 'cheZhong', 'daBuWei', 'guZhang', 'peiJian', 'xingHao']))
      return $p;
    else
      response(_('standard type not found'), RES_NOT_FOUND);
  }

  function checkStandard(string $t) {
    if(in_array($t, ['daBuWei', 'guZhang', 'cheZhong'])) {
      $o = OptionModel::first();
      $t = $t == 'cheZhong' ? 'cheZhongTime' : 'guZhangTime';
      $o->state->$t = date('Y-m-d H:i:s');
      $o->state = $o->state;
      $o->save();
    }
  }

  function indexDaBuWeiAction() {
    $ds = Table::open('daBuWei')::get();
    foreach($ds as $d)
      $d->guZhang = [];
    foreach(GuZhangModel::get() as $g)
      foreach($ds as $d)
        if($g->daBuWei == $d->id) {
          $d->guZhang[] = $g;
          break;
        }
    echo json_encode($ds, JSON_UNESCAPED_UNICODE);
  }

  function indexCheZhongAction() {
    echo json_encode(Table::open('cheZhong')::get(), JSON_UNESCAPED_UNICODE);
  }

  function storeAction() {
    if($p = $this->getParams()) {
      $s = Table::open($p['type']);
      $a = json_decode(file_get_contents('php://input'));
      foreach($a as $k => $v)
        $s->$k = $v;
      $s->save();
      $this->checkStandard($p['type']);
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
        $this->checkStandard($p['type']);
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
