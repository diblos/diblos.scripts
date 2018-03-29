<?php
ini_set('max_execution_time', 40000);
define('LURL', 'http://localhost:8000');
define('PURL', 'http://tpsmonitor.seamcloud.com');
define('DEVICE', '123');
define('TOKEN', 'e6cb86ccb3746962dd724aee762184f7');
$destination = PURL;

require_once 'db.php';
$process_start = microtime(true);

// testGET($destination);
// testPUT($destination);
// testPOST($destination);
// testPOST2($destination);
// testPATCH($destination);

// testDELETE($destination);

// testToker($destination);
// testGetToker($destination);

// DEVICE SECTION
// testPOSTAttendance($destination);
// testPOSTAttendance($destination);

// testLogin($destination);
// testGETAttendance($destination);

// testje();
// populateTable();

// $today = date("Y-m-d H:i:s");
// echo("$yesterday - $today".PHP_EOL);

// iwater();
// iwater(200,'2017-10-11',true);
// iwater(999,'2017-10-11',true);

$localDB = new DbLib();
$remoteDB = new DbLib('alpharevolution','*********','*******','alpharev_nrwmanagement_dev');
transfer_iwater(500,false,'01');
// transfer_iwater(500);

// $offset = round(rand(1, 2) / rand(6, 8),4);
// echo "$offset";

$process_end = microtime(true);
echo 'finished in '.round($process_end-$process_start).' seconds' ;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function transfer_iwater($loggerid,$test=true,$channelid=null){
  global $localDB;
  global $remoteDB;
  $sql = "select
          nrwm_nrwprofiledate,
          nrwm_nrwprofiletime,
          nrwm_nrwprofilevalue,
          nrwm_nrwprofile_idchannel,
          nrwm_nrwprofile_idloggerinfo
          from nrwm_nrwprofile
          where nrwm_nrwprofile_idloggerinfo=$loggerid
          ";
  $sql = $sql . ($channelid ? " and nrwm_nrwprofile_idchannel = '$channelid'" : "");
  $result = $localDB->conn->query($sql);
  if ($result->num_rows > 0) {
      echo "read $result->num_rows records".PHP_EOL;
      // output data of each row
      while($row = $result->fetch_assoc()) {
          if (!$test){

            try {
              $nrwm_nrwprofiledate = $row["nrwm_nrwprofiledate"];
              $nrwm_nrwprofiletime = $row["nrwm_nrwprofiletime"];
              $nrwm_nrwprofilevalue = $row["nrwm_nrwprofilevalue"];
              $nrwm_nrwprofile_idchannel = $row["nrwm_nrwprofile_idchannel"];
              $nrwm_nrwprofile_idloggerinfo = $row["nrwm_nrwprofile_idloggerinfo"];

              $query=mysqli_query($remoteDB->conn,
              "INSERT INTO nrwm_nrwprofile
              (
                nrwm_nrwprofiledate,
                nrwm_nrwprofiletime,
                nrwm_nrwprofilevalue,
                nrwm_nrwprofile_idchannel,
                nrwm_nrwprofile_idloggerinfo
              ) VALUES
              (
                '$nrwm_nrwprofiledate',
                '$nrwm_nrwprofiletime',
                $nrwm_nrwprofilevalue,
                '$nrwm_nrwprofile_idchannel',
                $nrwm_nrwprofile_idloggerinfo
              );");

            } catch (Exception $e) {
              var_dump($e);
            }

          }else{
            echo "date: " . $row["nrwm_nrwprofiledate"]. " time: " . $row["nrwm_nrwprofiletime"]. " - value: " . $row["nrwm_nrwprofilevalue"].PHP_EOL;
          }

      }

  } else {
      echo "0 results".PHP_EOL;
  }

  $localDB->conn->close();
}

function iwater($loggerid = 200,$insert_date = '2017-10-02',$INSERT_MODE = false){
  ini_set('date.timezone', 'Asia/Kuala_Lumpur');
  $servername = 'localhost';
  $username = 'root';
  $password = '';
  $dbname = 'nrwmanagement';

  // Create connection
  $conn = new mysqli($servername, $username, $password, $dbname);
  // Check connection
  if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
  }


  $startdate = '2017-09-10';
  $enddate = '2017-09-03';

  $sql = "select
          nrwm_nrwprofiledate,
          nrwm_nrwprofiletime,
          nrwm_nrwprofilevalue,
          nrwm_nrwprofile_idchannel,
          nrwm_nrwprofile_idloggerinfo
          from nrwm_nrwprofile
          where nrwm_nrwprofile_idloggerinfo=$loggerid
          ";

  $sql = $sql . "and nrwm_nrwprofiledate = '$startdate'";
  // $sql = $sql . "and nrwm_nrwprofiledate >= '$startdate' and nrwm_nrwprofiledate < '$enddate'";

  $result = $conn->query($sql);

  if ($result->num_rows > 0) {
      // output data of each row
      while($row = $result->fetch_assoc()) {
          $offset = round(rand(1, 2) / rand(5, 8),4);
          if ($INSERT_MODE){

            try {
              $nrwm_nrwprofiledate = $insert_date;
              $nrwm_nrwprofiletime = $row["nrwm_nrwprofiletime"];
              $nrwm_nrwprofilevalue_old = $row["nrwm_nrwprofilevalue"];
              $nrwm_nrwprofilevalue_new = $nrwm_nrwprofilevalue_old + $offset;
              $nrwm_nrwprofile_idchannel = $row["nrwm_nrwprofile_idchannel"];
              $nrwm_nrwprofile_idloggerinfo = $row["nrwm_nrwprofile_idloggerinfo"];

              $query=mysqli_query($conn,
              "INSERT INTO nrwm_nrwprofile
              (
                nrwm_nrwprofiledate,
                nrwm_nrwprofiletime,
                nrwm_nrwprofilevalue,
                nrwm_nrwprofile_idchannel,
                nrwm_nrwprofile_idloggerinfo
              ) VALUES
              (
                '$nrwm_nrwprofiledate',
                '$nrwm_nrwprofiletime',
                $nrwm_nrwprofilevalue_new,
                '$nrwm_nrwprofile_idchannel',
                $nrwm_nrwprofile_idloggerinfo
              );");

            } catch (Exception $e) {
              var_dump($e);
            }

          }else{
            echo "date: " . $row["nrwm_nrwprofiledate"]. " time: " . $row["nrwm_nrwprofiletime"]. " - value: " . $row["nrwm_nrwprofilevalue"].PHP_EOL;
            // $old = $row["nrwm_nrwprofilevalue"];
            // $new = $old + $offset;
            // echo "$old >> $new".PHP_EOL;
          }

      }
      echo "$result->num_rows records".PHP_EOL;
  } else {
      echo "0 results".PHP_EOL;
  }

  $conn->close();

}

function add_date($givendate,$day=0,$mth=0,$yr=0) {
      $cd = strtotime($givendate);
      $newdate = date('Y-m-d h:i:s', mktime(date('h',$cd),
    date('i',$cd), date('s',$cd), date('m',$cd)+$mth,
    date('d',$cd)+$day, date('Y',$cd)+$yr));
      return $newdate;
}

function tukar_date($givendate,$jam=0,$minit=0,$saat=0) {
      $cd = strtotime($givendate);
      $newdate = date('Y-m-d h:i:s', mktime(date('h',$cd)+$jam,
    date('i',$cd)+$minit, date('s',$cd)+$saat, date('m',$cd),
    date('d',$cd), date('Y',$cd)));
      return $newdate;
}

function testPATCH($url){
	$ch = curl_init($url.'/patch');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PATCH");
	$result = curl_exec($ch);
	// echo($result);
}

function testGET($url){
	$ch = curl_init($url.'/api/device/'.DEVICE);
	// $ch = curl_init($url.'/api/device/list');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");

	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Authorization: ' . TOKEN
	));

	$result = curl_exec($ch);
	// echo($result);
}

function testPUT($url){
	$data = array("heartbeat_time" => "09:00:00", "heartbeat_duration" => "6666", "reset_heartbeat_every_period" => "Y");
	$data_string = json_encode($data);

	$ch = curl_init($url.'/api/device/'.DEVICE);
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Content-Type: application/json',
	    'Content-Length: ' . strlen($data_string))
	);

	$result = curl_exec($ch);
	// $json =json_decode($result);
	// var_dump($json);
	echo($result);
}

function testPOST($url){
	$data = array("heartbeat_time" => "09:00:00", "heartbeat_duration" => "1454", "reset_heartbeat_every_period" => "Y");
	$data_string = json_encode($data);

	$ch = curl_init($url.'/api/device/'.DEVICE);
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Content-Type: application/json',
	    'Content-Length: ' . strlen($data_string))
	);

	$result = curl_exec($ch);
	// $json =json_decode($result);
	// var_dump($json);
	echo($result);
}

function testPOST2($url){
	$ch = curl_init($url.'/post');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	$result = curl_exec($ch);
	// echo($result);
}

function testDELETE($url){
	$ch = curl_init($url.'/api/device/'.DEVICE);
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
	$result = curl_exec($ch);
	// echo($result);
}

function testPOSTAttendance($url){
	$data = array("tag_id" => "1404", "timestamp" => "2013-08-05T18:19:03+8:00", "previous_heartbeat_start" => "2013-08-05T18:19:03+8:00", "Previous_heartbeat_stop" => "2013-08-05T18:19:03+8:00");
	$data_string = json_encode($data);

	$ch = curl_init($url.'/device/'.DEVICE.'/attendance');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Content-Type: application/json',
	    'Content-Length: ' . strlen($data_string))
	);

	$result = curl_exec($ch);
	// $json =json_decode($result);
	// var_dump($json);
	echo($result);
}

function testPOSTStatus($url){
	$data = array("tag_id" => "1404", "timestamp" => "2013-08-05T18:19:03+8:00", "previous_heartbeat_start" => "2013-08-05T18:19:03+8:00", "Previous_heartbeat_stop" => "2013-08-05T18:19:03+8:00");
	$data_string = json_encode($data);

	$ch = curl_init($url.'/device/'.DEVICE.'/status');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Content-Type: application/json',
	    'Content-Length: ' . strlen($data_string))
	);

	$result = curl_exec($ch);
	// $json =json_decode($result);
	// var_dump($json);
	echo($result);
}

function testToker($url){
	$data = array("user" => "user123", "pass" => "123@qwe");
	$data_string = json_encode($data);

	$ch = curl_init($url.'/api/authentication');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Content-Type: application/json',
	    'Content-Length: ' . strlen($data_string))
	);
	$result = curl_exec($ch);
	echo($result);
}

function testGetToker($url){
	$data = array("client_id" => "testclient");
	$data_string = json_encode($data);

	$ch = curl_init($url.'/token/v1/token.php');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Content-Type: application/json',
	    'Content-Length: ' . strlen($data_string))
	);
	$result = curl_exec($ch);
	echo($result);
}

function testLogin($url){
	//$data = array("uid" => "user", "pwd" => "password");
	$data = array("uid" => "cms", "pwd" => "cmstestingpassword");
	// $data = array("uid" => "test", "pwd" => "123");
	$data_string = json_encode($data);

	$ch = curl_init($url.'/api/user/login');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Content-Type: application/json',
	    'Content-Length: ' . strlen($data_string))
	);
	$result = curl_exec($ch);
	echo($result);
}

function populateTable(){
	ini_set('date.timezone', 'Asia/Kuala_Lumpur');
	// $connection = new mysqli('localhost', 'root', 'tpsmonitor123','tps');
	$connection = new mysqli('localhost', 'mydev', '123@qwe', 'tps');
	$num = 720;

	// $id = '0001010053415931';
	$id = '123';
	$tag_id = '74-83-B7-29';
	$start_time = "2016-10-01";

	for ($i = 0; $i < $num; $i++) {

	 	$timestamp = tukar_date($start_time,$i,rand(0, 5),rand(0, 55));
		$previous_heartbeat_start = tukar_date($timestamp,0,-30,rand(0, 55));
		$previous_heartbeat_stop = tukar_date($timestamp,0,30,rand(0, 55));

	  	$query=mysqli_query($connection,"INSERT INTO time_attend_log (deviceid,cardid,dev_timestamp,prev_hb,next_hb) VALUES ('$id' , '$tag_id', '$timestamp','$previous_heartbeat_start','$previous_heartbeat_stop');");
	}
	echo "DONE!".PHP_EOL;
}

function testGETAttendance($url){
	$dev = "device";
	$id  = "0001010053415931";
	// $id  = "74-83-B7-29";
	$start_time = "2016-10-19T00:00";
	$end_time = "2016-10-31T00:00";
	$start_counter = 50;

	//$token = 'c75b77abdec47e0f78aa139f1b451c30';
	$token = TOKEN;

	$start_time = urlencode($start_time);
	$end_time = urlencode($end_time);
	$ch = curl_init($url.'/api/attendance/'.$dev.'/'.$id.'?start_time='.$start_time.'&end_time='.$end_time.'&start_counter='.$start_counter);
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Authorization: ' . $token)
	);
	$result = curl_exec($ch);
	echo($result);

}

function testje(){

// $ch = curl_init($url.'/api/attendance/tag/74-83-B7-29?start_time=2016-10-19T00%3A00&end_time=2016-10-28T00%3A00&start_counter=0');

	$url   = 'http://tpsmonitor.seamcloud.com';
	$token = '24e5458cc719e247cb6934af7f3eb79e';

	$ch = curl_init($url.'/api/attendance/device/0001010053415931?start_time=2016-10-19T00%3A00&end_time=2016-10-28T00%3A00&start_counter=0');
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	    'Authorization: ' . $token)
	);
	$result = curl_exec($ch);
	echo($result);

}

?>
