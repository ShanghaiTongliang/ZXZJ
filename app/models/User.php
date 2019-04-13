<?php

class UserModel extends BaseModel {
  protected static $hidden = ['password', 'token'];
  protected static $jsonFields = ['groups'];
  protected static $cacheFields = ['icon'];
  /**@var UserModel */
  static $user;

  function admin(UserModel $u = null) {
    if(!$u)
      return in_array(255, $this->groups);
    $gs = []; $cs = [];
    foreach(GroupModel::get() as $g)
      $gs[$g->id] = $g;
    foreach($this->groups as $id)
      if($g = $gs[$id] ?? null)
        foreach($g->cheJian as $c)
          $cs[] = $c;
    if($u->groups) {  //目标处于用户所能管理组内
      foreach($cs as $c)
        if($c->permission & GroupModel::PERMISSION_MANAGE)
          foreach($u->groups as $id)
            if($g = $gs[$id] ?? null)
              foreach($g->cheJian as $uc)
                if($uc->id == $c->id)
                  return true;
    } else  //目标用户无组，任何有管理权限者都可管理
      foreach($cs as $c)
        if($c->permission & GroupModel::PERMISSION_MANAGE)
          return true;
  }

  static function register(array $data, &$err): ?UserModel {
    if(Validator::valid($data, [
      'name' => 'required|between:3,32',
      'password' => 'required|between:6,16|confirmed'
    ], $err)) {
      if($u = static::where(['name' => $data['name']])->first())
        $err = _('user already exists');
      else {
        $u = new static;
        $u->name = $data['name'];
        $u->password = crypt($data['password'], md5(rand(0x7fff, 0xffff)));
        //$u->token = rand(1, 0xffff);
        $u->groups = [];
        $u->save();
        return $u;
      }
    }
    return null;
  }

  static function login(array $data, &$err): ?UserModel {
    if(Validator::valid($data, [
      'name' => 'required|between:3,32',
      'password' => 'required|between:6,16'
    ], $err)) {
      if($u = static::where(['name' => $data['name']])->first()) {
        if($u->password != crypt($data['password'], $u->password))
          $err = _('password incorrect');
        else {
          //$u->token = rand(1, 0xffff);
          $u->save();
          static::$user = $u;
          return $u;
        }
      } else
        $err = _('user does not exists');
    }
    return null;
  }
}
