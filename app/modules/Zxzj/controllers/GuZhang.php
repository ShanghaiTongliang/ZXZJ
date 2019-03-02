<?php

class GuZhangController extends Yaf\Controller_Abstract {
  function indexAction() {
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
}
