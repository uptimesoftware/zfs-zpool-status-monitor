<?php

// Remote Custom Script
// This script just opens a TCP socket to the agent and writes and reads some text output to/from the agent
// Written in PHP to get around any Netcat antivirus false-positive issues

// Options:
// -h hostname
// -p port
// -s security password
// -c command/remote scripts
// -a arguments to send to script


try {

$options = getopt("h:p:s:c:a:");
//var_dump($options);
if (isset($options['h'])) {
	$host = $options['h'];
}
else {
	$host = 'localhost';
}
if (isset($options['p'])) {
	$port = $options['p'];
}
else {
	$port = '9998';
}
if (isset($options['s'])) {
	$pass = $options['s'];
}
else {
	$pass = '';
}
if (isset($options['a'])) {
	$args = $options['a'];
}
else {
	$args = '';
}
if (isset($options['c'])) {
	$cmd = "rexec {$pass} {$options['c']} {$args}";
}
else {
	$cmd = '"sysinfo"';
}

$errorno = '';
$errorstr = '';
$timeout = 30;	// timeout value in seconds

$resource = fsockopen($host, $port, $errorno, $errorstr, $timeout);
//Attempt to establish a connection to agent on port 9998. On error, place the error number into $errorno, and a string response to $errorstr. Timeout after 10 seconds.
if (!$resource) {
	//fsockopen failed
	echo "No connection established. Error: " . $errorstr . "[" . $errorno . "]\n";
} else {
	// successfully opened a socket
	fwrite($resource, $cmd);
	//while there is data to read from $resource…
	while (!feof($resource)) {
		//read the data, 2048 bytes at a time and echo it out to stdout
		print fgets($resource, 2048);
	}
	//no more data to read, close the resource
	fclose($resource);
}

} catch (Exception $e) {
	var_dump($e->getMessage());
}
?>
