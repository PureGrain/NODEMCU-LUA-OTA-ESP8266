<?php 

    // These variables define the connection information for your MySQL database 
    $dsnprefix = "pgsql";//mysql
    $username = "esp_mng"; 
    $password = "12345678"; 
    $host = "localhost"; 
    $dbname = "esp"; 
    
    if( $dsnprefix == "mysql" ) {
      $options = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');
      $dsn = "{$dsnprefix}:host={$host};dbname={$dbname};charset=utf8"; 
    }
    if( $dsnprefix == "pgsql" ) {
      $options = NULL;
      $dsn = "{$dsnprefix}:host={$host};dbname={$dbname};user={$username};password={$password};port=5433"; 
    }
    try { $db = new PDO($dsn, $username, $password, $options); } 
    catch(PDOException $ex){ die("Failed to connect to the database: " . $ex->getMessage());} 
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
    $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC); 
    header('Content-Type: text/html; charset=utf-8'); 
    session_start(); 
?>
