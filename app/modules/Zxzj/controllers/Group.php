<?php

class GroupController extends Yaf\Controller_Abstract {
  function storeAction() {
    $a = json_decode(file_get_contents('php://input'));
    if(isset($a->id, $a->name, $a->cheJian)) {
      if(($g = GroupModel::find($a->id)) || ($g = GroupModel::where(['name' => $a->name])->first()))
        response(sprintf(_('group %d: %s already exists'), $a->id, $a->name));
      else {
        $g = new GroupModel;
        $g->id = $a->id;
        $g->name = $a->name;
        $g->cheJian = $a->cheJian;
        $g->save();
      }
    } else
      response(_('format incorrect'));
  }

  function updateAction() {
    $p = $this->getRequest()->getParams();
    if($g = GroupModel::find($p['id'])) {
      $a = json_decode(file_get_contents('php://input'));
      foreach($a as $k => $v)
        $g->$k = $v;
      $g->save();
    } else
      response(_('group not found'), RES_NOT_FOUND);
  }
}
