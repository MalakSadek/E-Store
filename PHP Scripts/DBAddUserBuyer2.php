<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];
$type = $_REQUEST["type"];
$card = $_REQUEST["card"];
$date = $_REQUEST["date"];
$code = $_REQUEST["code"];

$res = mysqli_query($con, "SELECT * FROM User WHERE Email = '$email'");
$rows = $res->fetch_assoc();
$user = $rows['BuyerNum'];
echo $user;
$encodedcard = base64_encode($card);
$encodedcode = base64_encode($code);
$sql2 = "UPDATE Buyer SET Card = '$encodedcard', ExpiryDate = '$date', SecurityCode = '$encodedcode', CardType = '$type' WHERE BuyerID = '$user'";

$result2 = mysqli_query($con, $sql2);

mysqli_close($con);

?>
