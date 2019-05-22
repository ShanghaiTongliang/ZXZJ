<?php

class IndexController extends Yaf\Controller_Abstract {
  function indexAction() {
    $f = strpos($_SERVER['HTTP_USER_AGENT'], 'Trident') ? 'ie.htm' : 'index.htm';
    echo file_get_contents(APP_PATH . "/resources/html/$f");
  }
}
