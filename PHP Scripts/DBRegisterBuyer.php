<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];
$card = 99;
$date = '0000-00-00';
$code = 0;
$type = "None";

$sql = "SELECT COUNT(*) 'Count' FROM User WHERE BuyerNum IS NOT NULL";
$currentID = mysqli_query($con, $sql)->fetch_assoc()['Count']+1;

$sql2 = "INSERT INTO Buyer (BuyerID, Card, ExpiryDate, SecurityCode, CardType) VALUES ('$currentID', '$card', '$date', '$code', '$type')";

$result = mysqli_query($con, $sql2);

$sql3 = "UPDATE User SET BuyerNum = '$currentID' WHERE Email = '$email'";

$result2 = mysqli_query($con, $sql3);

if ( false===$result ) {
  printf("error: %s\n", mysqli_error($con));
}

mysqli_close($con);

?>
