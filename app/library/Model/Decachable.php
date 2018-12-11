<?php
namespace Model;

abstract class Decachable {
  protected $_data;
  protected $_parent;
  protected $_parentKey;
  protected $_decaching;
  protected $_save = [];

  abstract function decache();

  function __construct(&$data, Decachable $parent = null, string $parentKey = null) {
    $this->_data = $data;
    $this->_parent = $parent;
    $this->_parentKey = $parentKey;
  }

  function onChange(string $k) {
    if(!($this->_decaching || in_array($k, $this->_save))) {
      $this->_save[] = $k;
      if($this->_parent)
        $this->_parent->onChange($this->_parentKey);
    }
  }

  function save() {
    foreach($this->_save as $f)
      $this->_data->$f->save();
  }
}
