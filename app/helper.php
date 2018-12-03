<?php

const RES_BAD_REQUEST = 400;
const RES_NO_PERMISSION = 401;
const RES_FORBIDEN = 403;
const RES_NOT_FOUND = 404;
const RES_NOT_ALLOWED = 405;

function response($msg, $code = RES_BAD_REQUEST) {
  $codes = [
    RES_BAD_REQUEST => 'Bad Request',
    RES_NO_PERMISSION => 'Unauthorized',
    RES_FORBIDEN => 'Forbidden',
    RES_NOT_FOUND => 'Not Found',
    RES_NOT_ALLOWED => 'Not Allowed'
  ];
  header("{$_SERVER['SERVER_PROTOCOL']} $code {$codes[$code]}");
  echo $msg;
}