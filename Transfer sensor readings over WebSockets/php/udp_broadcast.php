<?php

  /*************************************************
   *
   * PHP UDP broadcast example
   *
   * @author Glenn De Backer <glenn@simplicity.be>
   *
   *************************************************/

  $ip = "255.255.255.255";
  $port = 5005;

  // configure sockets
  $sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
  socket_set_option($sock, SOL_SOCKET, SO_BROADCAST, 1);

  // create json string and broadcast it over udp
  $jsonStr = json_encode(array('sensor' => 'php', 'value' => 'hello php'));
  socket_sendto($sock, $jsonStr, strlen($jsonStr), 0, $ip, $port);