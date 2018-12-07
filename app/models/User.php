<?php

class UserModel extends BaseModel {
  protected static $hidden = ['password', 'token'];
  protected static $cacheFields = ['icon'];
  static $user;

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
        $u->token = rand(1, 0xffff);
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
          $u->token = rand(1, 0xffff);
          $u->save();
          static::$user = $u;
          return $u;
        }
      } else
        $err = _('user not exists');
    }
    return null;
  }
}
