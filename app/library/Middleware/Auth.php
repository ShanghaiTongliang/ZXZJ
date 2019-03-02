<?php
namespace Middleware;

use JWT;
use Yaf\Request\Http;
use Zxzj\Redis;
use UserModel;

class Auth extends BaseMiddleware {
  function handle(Http $request, $next): void {
    /*if(isset($_COOKIE['id'], $_COOKIE['token']) && ($u = UserModel::find($_COOKIE['id'])) && $u->token == $_COOKIE['token'])
      UserModel::$user = $u;
    else
      throw new \Exception(_('no permission'));
    */
    if(isset($_COOKIE['token']) && ($o = JWT::decode($_COOKIE['token'], 'tongliang'))) {
      $redis = Redis::instance();
      if($redis->get("token$o->id") == $o->token) {
        UserModel::$user = $o;
        $next($request);
        return;
      }
    }
    throw new \Exception(_('no permission'));
  }
}
