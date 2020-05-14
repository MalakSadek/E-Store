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
$encodedpassword = base64_encode($password);
$sql = "UPDATE User SET FName = '$fname', LName = '$lname', Phone = '$number', Password = '$encodedpassword', Address = '$address' WHERE Email = '$email'";

$result = mysqli_query($con, $sql);

if ( false===$result ) {
  printf("error: %s\n", mysqli_error($con));
}

mysqli_close($con);

?>
