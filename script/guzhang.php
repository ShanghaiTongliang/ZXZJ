<?php
$a = explode("\n", file_get_contents('guzhang.txt'));
$ps = [];
$ls = ['A' => 1, 'B' => 2, 'C' => 3];
$r = []; $v = [];
foreach($a as $k => $s)
  if($s) {
    $t = explode("\t", $s);
    if(!$v[$t[2]]) {
      $v[$t[2]] = 1;
      if(!$p = $ps[$t[1]] ?? null) {
        $p = count($ps) + 1;
        $ps[$t[1]] = $p;
      }
      $t[3] = trim($t[3]);
      if(!$l = $ls[$t[3]] ?? null) {
        $l = count($ls) + 1;
        $ls[$t[3]] = $l;
      }
      $r[] = "('{$t[2]}', $l, $p)";
    } else
      echo "冗余: $k\n";
  }
$sql = "delete from guZhang; alter table guZhang auto_increment=1;
delete from daBuWei; alter table daBuWei auto_increment=1;
delete from dengJi; alter table dengJi auto_increment=1;
insert into guZhang (name, dengJi, daBuWei) values " . implode(', ', $r) . ";\n";
$sql .= 'insert into daBuWei (name) values ' . implode(', ', array_map(function($p) {
  return "('$p')";
}, array_keys($ps))) . ";\n";
$sql .= 'insert into dengJi (name) values ' . implode(', ', array_map(function($l) {
  return "('$l')";
}, array_keys($ls))) . ";\n";
file_put_contents('guzhang.sql', $sql);
