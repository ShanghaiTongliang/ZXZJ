<?php

class UserModel extends BaseModel {
  protected static $hidden = ['password', 'token'];
  static $user;

  static function register($values, &$err): ?UserModel {
    if(Validator::valid($values, [
      'name' => 'required|between:3,32',
      'password' => 'required|between:6,16|confirmed'
    ], $err)) {
      if($u = static::where(['name' => $values['name']])->first())
        $err = _('user already exists');
      else {
        $u = new static;
        $u->name = $values[$name];
        $u->password = crypt($values['password'], md5(rand(0x7fff, 0xffff)));
        $u->token = rand(1, 0xffff);
        $u->save();
        return $u;
      }
    }
    return null;
  }

  static function login(?string $name, ?string $password, &$err): ?UserModel {
    if($u = static::where(['name' => $name])->first()) {
      if($u->password != crypt($password, $u->password))
        $err = '密码错误';
      else {
        static::$user = $u;
        return $u;
      }
    } else
      $err = '用户不存在';
    return null;
  }
}
