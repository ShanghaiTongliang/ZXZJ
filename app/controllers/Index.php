<?php

class IndexController extends Yaf\Controller_Abstract {
  function indexAction() {
    echo file_get_contents(APP_PATH . '/resources/html/index.htm');
  }
}
