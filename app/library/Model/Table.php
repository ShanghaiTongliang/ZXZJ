<?php
namespace Model;

abstract class Table extends Base {
  function __construct($name) {
    if(is_string($name)) {
      static::$tableNames[get_called_class()] = $name;
      parent::__construct();
    } else
      parent::__construct($name);
  }
}
