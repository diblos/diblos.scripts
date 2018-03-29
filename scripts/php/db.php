<?php
  class DbLib {
          public $conn = "";
          public function __construct($DBHost = 'localhost',$DBUser = 'root',$DBPass = '',$DBName = 'nrwmanagement',$DBPort = 3306) {
              $this->conn = new mysqli($DBHost, $DBUser, $DBPass, $DBName, $DBPort);
              if ($this->conn->connect_errno) {
                  printf("Database connection failed: %s\n", $this->conn->connect_error);
                  exit();
              }
          }
      }
?>
