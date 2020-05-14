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
$card = 2;
$date = '0000-00-00';
$code = 0;
$type = "None";

$sql = "SELECT COUNT(*) 'Count' FROM Buyer WHERE BuyerID IS NOT NULL";
$BuyerID = mysqli_query($con, $sql)->fetch_assoc()['Count']+1;
echo $BuyerID;
$sql2 = "INSERT INTO Buyer (BuyerID, Card, ExpiryDate, SecurityCode, CardType) VALUES ('$BuyerID', '$card', '$date', '$code', '$type')";

$result = mysqli_query($con, $sql2);

$encodedpassword = base64_encode($password);
$sql3 = "INSERT INTO User (FName, LName, Phone, Password, Email, Address, BuyerNum) VALUES ( '$fname', '$lname', '$number', '$encodedpassword', '$email', '$address', '$BuyerID')";

$result2 = mysqli_query($con, $sql3);

if ( false===$result2 ) {
  json_encode("Duplicate Entry!");
}

mysqli_close($con);

?>
