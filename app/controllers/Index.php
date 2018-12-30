<?php

/**
 * @name IndexController
 * @author oblind-nb\oblind
 * @desc 默认控制器
 * @see http://www.php.net/manual/en/class.yaf-controller-abstract.php
 */
class IndexController extends Yaf\Controller_Abstract {

  public function indexAction() {
    $this->getView()->display('index.phtml');
  }

  function testAction() {
    //echo $this->getRequest()->getLanguage();
    echo json_encode(JWT::decode(JWT::encode(['id' => 1], 'tongliang'), 'tongliang'));
  }

  function calcAction() {
    switch($_POST['op']) {
    case '+':
      $r = $_POST['a'] + $_POST['b'];
      break;
    case '-':
      $r = $_POST['a'] - $_POST['b'];
    }
    echo json_encode(['result' => $r]);
  }

  function aaaAction() {
    if($this->getRequest())
    echo "aaa\n";
  }

  function listAction() {
    echo json_encode([[
      'name' => '1月',
      'error' => [
        'a' => '故障1'
      ]
    ], [
      'name' => '2月',
      'error' => [
        'a' => '故障2'
      ]
    ]]);
  }

  function cheXingAction() {
    $t = new Table('cheXing');
    echo json_encode($t::get());
  }
}
