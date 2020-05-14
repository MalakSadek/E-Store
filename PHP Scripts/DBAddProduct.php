<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["Email"];
$name = $_REQUEST["Name"];
$price = $_REQUEST["Price"];
$desc = $_REQUEST["Description"];
$stock = $_REQUEST["Stock"];

$result = mysqli_query($con, "SELECT SellerNum FROM User WHERE Email = '$email'");

$data = array();

while ($rows = $result->fetch_assoc()) {
  $sellerNum = $rows["SellerNum"];
  $result2 = mysqli_query($con, "SELECT COUNT(*) 'Count' FROM Product WHERE storeNum = '$sellerNum'");
  $currentID = $result2->fetch_assoc()['Count'];
  $res2 = mysqli_query($con, "INSERT INTO Product (storeNum, ProductID, ProductName, Price, Description, Stock) VALUES ('$sellerNum', '$currentID', '$name', '$price', '$desc', '$stock')");
}

if ( false===$result ) {
  printf("error: %s\n", mysqli_error($con));
}

mysqli_close($con);

?>
