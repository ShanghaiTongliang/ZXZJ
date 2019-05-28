<?php

class JiaoJianController extends Yaf\Controller_Abstract {
  const DISPATCHED = 1, CHECKEDIN = 2, REVIEWED = 3;

  function storeAction() {
    $g = new JiaoJianModel;
    foreach($_POST as $k => $v)
      $g->$k = $v;
    $g->save();
    echo $g->id;
  }

  function updateAction() {
    $p = $this->getRequest()->getParams();
    if($g = JiaoJianModel::find($p['id'])) {
      $a = json_decode(file_get_contents('php://input'));
      unset($a->id);
      foreach($a as $k => $v)
        $g->$k = $v;
      $g->save();
    } else
      response(_('guZhang not found'), RES_NOT_FOUND);
  }

  function destroyAction() {
    $p = $this->getRequest()->getParams();
    if($g = JiaoJianModel::find($p['id'])) {
      $g->delete();
      $g::resetAutoIncrement();
    } else
      response(_('guZhang not found'), RES_NOT_FOUND);
  }

  function updateCountAction() {
    $a = json_decode(file_get_contents('php://input'));
    if($c = Table::open('cheJian')::find($a->cheJian)) {
      if(!$c = JiaoJianCountModel::where(['month' => $a->month, 'cheJian' => $a->cheJian])->first()) {
        $c = new JiaoJianCountModel;
        $c->cheJian = $a->cheJian;
        $c->month = $a->month;
      }
      $t = 0;
      foreach($a->counts as $n)
        $t += $n;
      $c->count = $t;
      $c->counts = $a->counts;
      $c->save();
      echo json_encode(['id' => $c->id]);
    } else
      response(_('cheJian not found'), RES_NOT_FOUND);
  }

  /**查询 */
  function queryAction() {
    $a = $_POST;
    if(isset($a['from'], $a['to'])) {
      $t = date('t', strtotime($a['to']));
      $sql = "select * from jiaoJian where date >= '{$a['from']}-01' and date <= '{$a['to']}-$t'";
      if(isset($a['danWei']))
        $sql .= " and danWei = {$a['danWei']}";
      if(isset($a['cheJian']))
        $sql .= " and cheJian = {$a['cheJian']}";
      if(isset($a['banZu']))
        $sql .= " and banZu = {$a['banZu']}";
      $s = BaseModel::query($sql);
      $r = $s->fetchAll();
      echo json_encode($r);
    } else
      response(_('format incorrect'));
  }

  /**下发，新建处理 */
  function storeChuLiAction() {
    $p = $this->getRequest()->getParams();
    if($g = JiaoJianModel::find($p['id'])) {
      if(!$c = Table::open('jiaoJianChuLi')::find($p['id'])) {
        $c = Table::open('jiaoJianChuLi');
        $c->id = $p['id'];
      }
      $g->state = static::DISPATCHED;
      $g->save();
      foreach(['state', 'cheHao', 'cheXing', 'xiuCheng', 'danWei', 'cheJian', 'guZhang'] as $k)
        $c->$k = $g->$k;
      $c->xiaFaShiJian = date('Y-m-d H:i:s');
      $c->xiaFaRen = $g->user;
      $c->save();
      echo $c;
    } else
      response(_('guZhang not found'), RES_NOT_FOUND);
  }

  /**签收/复检，更新处理*/
  function updateChuLiAction() {
    $p = $this->getRequest()->getParams();
    if(($g = JiaoJianModel::find($p['id'])) && ($c = Table::open('jiaoJianChuLi')::find($p['id']))) {
      $a = json_decode(file_get_contents('php://input'));
      $g->state = $a->state;
      $g->save();
      foreach($a as $k => $v)
        $c->$k = $v;
      $c->save();
    } else
      response(_('guZhang not found'), RES_NOT_FOUND);
  }
}
