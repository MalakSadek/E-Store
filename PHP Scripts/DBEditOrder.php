<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["Email"];
$status = $_REQUEST["Status"];

$result = mysqli_query($con, "UPDATE `Order` SET Status = '$status' WHERE BuyerN = (SELECT BuyerNum FROM User WHERE Email = '$email')");

if ( false===$result ) {
  printf("error: %s\n", mysqli_error($con));
}

mysqli_close($con);

?>
