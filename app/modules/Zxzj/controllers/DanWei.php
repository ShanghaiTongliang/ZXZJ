<?php
declare(strict_types = 1);

class DanWeiController extends Yaf\Controller_Abstract {
  function check(&$p, &$a, &$err, array $fields): bool {
    $a = $_POST ?: json_decode(file_get_contents('php://input'), true);
    if(Validator::valid($a, ['name' => 'required|between:6,64'], $err, $fields)) {
      $p = $this->getRequest()->getParams();
      return true;
    }
    return false;
  }

  function storeAction() {
    if($this->check($p, $a, $err, ['name' => 'danWei'])) {
      if($d = Table::open('danWei')::where(['name' => $a['name']])->first())
        $err = sprintf(_('danWei %s already exists'), $a['name']);
      else {
        $d = Table::open('danWei');
        $d->name = $a['name'];
        $d->save();
        echo json_encode(['id' => $d->id]);
        return;
      }
    }
    response($err);
  }

  function updateAction() {
    if($this->check($p, $a, $err, ['name' => 'danWei'])) {
      if($d = Table::open('danWei')::find($p['did'])) {
        $d->name = $a['name'];
        $d->save();
        return;
      } else
        $err = _('danWei not found');
    }
    response($err);
  }

  function destroy(string $table, string $subTable, string $id) {
    $p = $this->getRequest()->getParams();
    if($d = Table::open($table)::find($p[$id])) {
      $c = $d::query("select count(*) as c from $subTable where $table=$d->id")->fetch();
      if($c->c > 0)
        $err = _('please delete all subitems first');
      else {
        $d->delete();
        $d::resetAutoIncrement();
        return;
      }
    } else
      $err = _("$table not found");
    response($err, RES_NOT_FOUND);
  }

  function destroyAction() {
    $this->destroy('danWei', 'cheJian', 'did');
  }

  function storeCheJianAction() {
    if($this->check($p, $a, $err, ['name' => 'cheJian'])) {
      if(!$d = Table::open('danWei')::find($p['did']))
        $err = _('danWei not found');
      elseif($c = Table::open('cheJian')::where(['name' => $a['name']])->first())
        $err = sprintf(_('cheJian %s already exists'), $a['name']);
      else {
        $c = Table::open('cheJian');
        $c->name = $a['name'];
        $c->danWei = $d->id;
        $c->save();
        echo json_encode(['id' => $c->id]);
        return;
      }
    }
    response($err);
  }

  function updateCheJianAction() {
    if($this->check($p, $a, $err, ['name' => 'cheJian'])) {
      if($c = Table::open('cheJian')::where(['name' => $a['name']])->first())
        $err = sprintf(_('cheJian %s already exists'), $a['name']);
      elseif(!$c = Table::find($p['cid']))
        $err = _('cheJian not found');
      else {
        $c->name = $a['name'];
        $c->save();
        return;
      }
    }
    response($err);
  }

  function destroyCheJianAction() {
    $this->destroy('cheJian', 'banZu', 'cid');
  }

  function storeBanZuAction() {
    if($this->check($p, $a, $err, ['name' => 'banZu'])) {
      if(!$c = Table::open('cheJian')::find($p['cid']))
        $err = _('cheJian not found');
      elseif($b = Table::open('banZu')::where(['name' => $a['name']])->first())
        $err = sprintf(_('banZu %s already exists'), $a['name']);
      else {
        $b = Table::open('banZu');
        $b->name = $a['name'];
        $b->cheJian = $c->id;
        $b->save();
        echo json_encode(['id' => $b->id]);
        return;
      }
    }
    response($err);
  }

  function updateBanZuAction() {
    if($this->check($p, $a, $err, ['name' => 'banZu'])) {
      if($b = Table::open('banZu')::where(['name' => $a['name']])->first())
        $err = sprintf(_('banZu %s already exists'), $a['name']);
      elseif(!$b = Table::find($p['bid']))
        $err = _('banZu not found');
      else {
        $b->name = $a['name'];
        $b->save();
        return;
      }
    }
    response($err);
  }

  function destroyBanZuAction() {
    $this->destroy('banZu', 'user', 'bid');
  }
}
