<?php
/**
 * This is free and unencumbered software released into the public domain.
 * For more information, please refer to <http://unlicense.org/>
 * 
 * This script relies on OAuth extension to PHP.
 * For more information, please refer to <http://docs.php.net/oauth>
 */

// CHANGE THESE variables
$consumer_token  = 'consumer_token';
$consumer_secret = 'consumer_secret';
$access_token    = 'access_token';
$access_secret   = 'access_secret';
$graph_iri       = 'http://example.com/graph';


$oauth = new OAuth($consumer_token, $consumer_secret, OAUTH_SIG_METHOD_HMACSHA1, OAUTH_AUTH_TYPE_AUTHORIZATION);
$oauth->setToken($access_token, $access_secret);

$oauth->fetch('https://api.grids.by/v1/list.json?'.http_build_query(['graph' => $graph_iri]););
$data = json_decode($oauth->getLastResponse());

print_r($data);
