<?php
class Pipeline {
  protected $pipes = [];
  protected $arg;

  function pipe($pipe): Pipeline {
    $this->pipes[] = $pipe;
    return $this;
  }

  function send($arg): Pipeline {
    $this->arg = $arg;
    return $this;
  }

  function then(callable $resole) {
    if($this->pipes) {
      array_reduce(array_reverse($this->pipes), function(callable $next, callable $cur) {
        return function($arg) use($next, $cur) {
          call_user_func($cur, $arg, $next);
        };
      }, $resole)($this->arg);
    }
  }
}