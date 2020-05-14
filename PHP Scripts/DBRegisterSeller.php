<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];

$sql = "SELECT COUNT(*) 'Count' FROM User WHERE SellerNum IS NOT NULL";
$currentID = mysqli_query($con, $sql)->fetch_assoc()['Count']+1;

$sql2 = "UPDATE User SET SellerNum = '$currentID' WHERE Email = '$email'";

$result = mysqli_query($con, $sql2);

if ( false===$result ) {
  printf("error: %s\n", mysqli_error($con));
}

mysqli_close($con);

?>
