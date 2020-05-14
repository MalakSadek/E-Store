<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$fname = $_REQUEST["fname"];
$lname = $_REQUEST["lname"];
$number = $_REQUEST["number"];
$email = $_REQUEST["email"];
$password = $_REQUEST["password"];
$address = $_REQUEST["address"];
$storeNum = "None";

$sql = "SELECT COUNT(*) 'Count' FROM User WHERE SellerNum IS NOT NULL";

$currentID = mysqli_query($con, $sql)->fetch_assoc()['Count']+1;
$encodedpassword = base64_encode($password);
$sql2 = "INSERT INTO User (FName, LName, Phone, Password, Email, Address, SellerNum) VALUES ( '$fname', '$lname', '$number', '$encodedpassword', '$email', '$address', '$currentID')";

$result = mysqli_query($con, $sql2);

if ( false===$result ) {
  printf("error: %s\n", mysqli_error($con));
}

mysqli_close($con);

?>
