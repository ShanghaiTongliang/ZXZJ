<?php

class ZhiJianYuanController extends Yaf\Controller_Abstract {
  function storeDianWenAction() {
    $p = new DianWenModel;
    foreach($_POST as $k => $v)
      $p->$k = $v;
    $p->save();
    echo json_encode(['id' => $p->id]);
  }

  function updateDianWenAction() {
    $d = $this->getRequest()->getParams();
    if($d = DianWenModel::find($d['id'])) {
      $a = json_decode(file_get_contents('php://input'));
      unset($a->id);
      foreach($a as $k => $v)
        $d->$k = $v;
      $d->save();
    } else
      response(_('dianWen not found'));
  }

  function checkinDianWenAction() {
    $d = $this->getRequest()->getParams();
    if($d = DianWenModel::find($d['id'])) {
      if(!in_array($id = UserModel::$user->id, $d->checkin)) {
        $d->checkin[] = $id;
        $d->checkin = $d->checkin;
      }
      $d->save();
    } else
      response(_('dianWen not found'));
  }

  function destroyDianWenAction() {
    $p = $this->getRequest()->getParams();
    if($p = DianWenModel::find($p['id'])) {
      $p->delete();
      $p::resetAutoIncrement();
    } else
      response(_('dianWen not found'));
  }

  //作业指导书
  function storeZhiDaoShuAction() {
    if($f = $_FILES['file'] ?? null) {
      $n = $_POST['name'] ?? $f['name'];
      move_uploaded_file($f['tmp_name'], "zhiJianYuan/zhiDaoShu/$n");
    } else
      response(_('format incorrect'));
  }

  /*function updateZhiDaoShuAction() {
    if($f = $_FILES['file'] ?? null) {
      if(file_exists($n = $f['name']))
        move_uploaded_file($f['tmp_file'], "zhiJianYuan/zhiDaoShu/$n");
      else
        response(_('zhiDaoShu not found'));
    } else
      response(_('format incorrect'));
  }*/

  function destroyZhiDaoShuAction() {
    if(($p = json_decode(file_get_contents('php://input'))) && isset($p->name)) {
      $n = "zhiJianYuan/zhiDaoShu/$p->name";
      if(file_exists($n))
        unlink($n);
      else
        response(_('zhiDaoShu not found'));
    } else
      response(_('format incorrect'));
  }

  //资料
  function storeZiLiaoAction() {
    if($f = $_FILES['file'] ?? null) {
      $n = $_POST['name'] ?? $f['name'];
      move_uploaded_file($f['tmp_name'], "zhiJianYuan/ziLiao/$n");
    } else
      response(_('format incorrect'));
  }

  /*function updateZiLiaoAction() {
    if($f = $_FILES['file'] ?? null) {
      if(file_exists($n = $f['name']))
        move_uploaded_file($f['tmp_file'], "zhiJianYuan/ziLiao/$n");
      else
        response(_('ziLiao not found'));
    } else
      response(_('format incorrect'));
}*/

  function destroyZiLiaoAction() {
    if(($p = json_decode(file_get_contents('php://input'))) && isset($p->name)) {
      $n = "zhiJianYuan/ziLiao/$p->name";
      if(file_exists($n))
        unlink($n);
      else
        response(_('ziLiao not found'));
    } else
      response(_('format incorrect'));
  }
}
