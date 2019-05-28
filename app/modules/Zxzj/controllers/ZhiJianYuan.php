<?php

class ZhiJianYuanController extends Yaf\Controller_Abstract {
  function storeDianWenAction() {
    $p = new DianWenModel;
    foreach($_POST as $k => $v)
      $p->$k = $v;
    //$p->save();
    echo json_encode(['id' => $p->id]);
  }

  function updateDianWenAction() {
    $d = $this->getRequest()->getParams();
    if($d = DianWenModel::find($d['id'])) {
      $a = json_decode($_POST['dianWen']);
      $base = 'zhiJianYuan/dianWen/';
      //删除文件
      foreach($d->attachments as $old) {
        $b = false;
        foreach($a->attachments as $new)
          if($old->name == $new->name) {
            $b = true;
            break;
          }
        if(!$b && file_exists($p = "$base$d->id/$old->name"))
          unlink($p);
      }
      $p = "$base$d->id";
      if(count($_FILES)) {
        if(!is_dir($p))
          mkdir($p);
        foreach($_FILES as $f)
          move_uploaded_file($f['tmp_name'], "$base$d->id/{$f['name']}");
      }
      foreach($a as $k => $v)
        $d->$k = $v;
      $d->save();
    } else
      response(_('dianWen not found'));
  }

  function checkinDianWenAction() {
    $d = $this->getRequest()->getParams();
    if($d = DianWenModel::find($d['id'])) {
      $f = false;
      $id = UserModel::$user->id;
      foreach($d->checkin as $u)
        if($u->id == $id) {
          $f = true;
          break;
        }
      if(!$f) {
        $c = (object)['id' => $id, 'date' => date('Y-m-d')];
        $d->checkin[] = $c;
        $d->checkin = $d->checkin;
        echo json_encode($c);
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
      if($n != $f['name'])
        unlink("zhiJianYuan/zhiDaoShu/$n");
      move_uploaded_file($f['tmp_name'], "zhiJianYuan/zhiDaoShu/{$f['name']}");
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
