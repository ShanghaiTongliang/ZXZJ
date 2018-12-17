<?php
class Pipeline {
  protected $pipes = [];
  protected $arg;
  protected $resole;

  function __construct() {

  }

  function pipe(Closure $pipe): Pipeline {
    if(is_array($pipe))
      $this->pipes = array_merge($this->pipes, $pipe);
    else
      $this->pipes[] = $pipe;
    return $this;
  }

  function send($arg): Pipeline {
    $this->arg = $arg;
    return $this;
  }

  function then(Closure $resole) {
    $this->resole = $resole;
    if($this->pipes) {
      $p = array_splice($this->pipes, 0, 1)[0];
      $ps = [];
      $ps[] = array_reduce(array_reverse($this->pipes), function($pipe, $next) use(&$ps) {
        $p = function() use($pipe, $next) {
          return function() use($pipe, $next) {
            return $pipe($this->arg, $next);
          };
        };
        $ps[] = $p;
        return $p;
      }, $p);
      $r = $ps[0]();
      $this->resole($r);
    }
  }
}