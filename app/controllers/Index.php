<?php
/**
 * @name IndexController
 * @author oblind-nb\oblind
 * @desc 默认控制器
 * @see http://www.php.net/manual/en/class.yaf-controller-abstract.php
 */
class IndexController extends Yaf\Controller_Abstract {

  public function indexAction($name = "Stranger") {
    //return true;
    //return false;
  }

  function testAction() {
    echo $this->getRequest()->getLanguage();
    return false;
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
    return false;
  }

  function aaaAction() {
    if($this->getRequest())
    echo "aaa\n";
    return false;
    //ssddd
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
    return false;
  }
}
