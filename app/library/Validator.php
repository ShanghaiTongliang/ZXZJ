<?php

class Validator {
  protected static $validators = [];
  protected static $fields = [];

  static function __callStatic($name, $a) {
    return isset(static::$validators[$name]) && static::$validators[$name](...$a);
  }

  static function register($name, $validator) {
    static::$validators[$name] = $validator;
  }

  static function setFields($fields) {
    static::$fields = array_merge(static::$fields, $fields);
  }

  static function min($value, ?array $arg, &$err): bool {
    $r = strlen($value) >= ($a = intval($arg[0]));
    if(!$r)
      $err = sprintf(_(":attribute minimal length %d"), $a);
    return $r;
  }

  static function max($value, ?array $arg, &$err): bool {
    $r = strlen($value) <= ($a = intval($arg[0]));
    if(!$r)
      $err = sprintf(_(":attribute maximal length %d"), $a);
    return $r;
  }

  static function between($value, ?array $arg, &$err): bool {
    $a = intval($arg[0]);
    $b = intval($arg[1]);
    if($a > $b)
      [$a, $b] = [$b, $a];
    $r = ($l = strlen($value)) >= $a && $l <= $b;
    if(!$r)
      $err = sprintf(_(":attribute length between %d-%d"), $a, $b);
    return $r;
  }

  static function email($value, ?array $arg, &$err): bool {
    $r = preg_match('/^\w+@\w+\.\w+/', $value) > 0;
    if(!$r)
      $err = _(':attribute format invalid');
    return $r;
  }

  static function confirmed($value, ?array $arg, &$err, $values, $field): bool {
    $r = $value == ($values[$field.'_confirmation'] ?? null);
    if(!$r)
      $err = _(':attribute inconsistent');
    return $r;
  }

  protected static function val(array $values, string $field, string $rule, &$err): bool {
    if($l = strpos($rule, ':')) {
      $a = [];
      $q = $l + 1;
      while(($p = strpos($rule, ',', $q)) != false) {
        $a[] = substr($rule, $q, $p - $q);
        $q = $p + 1;
      }
      $a[] = substr($rule, $q);
      $rule = substr($rule, 0, $l);
    } else
      $a = null;
    if($rule == 'required') {
      $r = isset($values[$field]);
      if(!$r)
        $err = str_replace(':attribute', static::$fields[$field] ?? $field, _(':attribute required'));
      return $r;
    }
    elseif(isset($values[$field]) && !static::$rule($values[$field], $a, $err, $values, $field)) {
      $err = str_replace(':attribute', static::$fields[$field] ?? $field, $err);
      return false;
    }
    return true;
  }

  static function valid(array $values, array $rules, &$err): bool {
    foreach($rules as $field => $r) {
      $n = 0;
      while(($m = strpos($r, '|', $n)) != false) {
        if(!static::val($values, $field, substr($r, $n, $m - $n), $err))
          return false;
        $n = $m + 1;
      }
      if(!static::val($values, $field, substr($r, $n), $err))
        return false;
    }
    return true;
  }
}
