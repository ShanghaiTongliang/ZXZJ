<?php
namespace Middleware;

use Yaf\Request\Http;
use UserModel;

class Auth extends BaseMiddleware {
  function handle(Http $request) {
    if(isset($_COOKIE['id'], $_COOKIE['token']) && ($u = UserModel::find($_COOKIE['id'])) && $u->token == $_COOKIE['token'])
      UserModel::$user = $u;
    else {
      response(_('no permission'));
      return false;
    }
  }
}
