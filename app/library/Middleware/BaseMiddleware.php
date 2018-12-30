<?php
namespace Middleware;

use Yaf\Request\Http;

abstract class BaseMiddleware {
  abstract function handle(Http $request): void;
}
