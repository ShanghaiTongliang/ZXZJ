<?php
/**
 * @name ErrorController
 * @desc 错误控制器, 在发生未捕获的异常时刻被调用
 * @see http://www.php.net/manual/en/yaf-dispatcher.catchexception.php
 * @author oblind-nb\oblind
 */
class ErrorController extends Yaf\Controller_Abstract {

  public function errorAction($exception) {
    $r = $this->getRequest();
    if($r->isXmlHttpRequest())
      response($exception->getMessage(), $exception->getCode() ?: RES_BAD_REQUEST);
    //elseif(Yaf\Dispatcher::getInstance()->getRouter()->getCurrentRoute() == '_default')
    //  response('', RES_NOT_FOUND);
    else
      $this->redirect('/zxzj');
  }
}
