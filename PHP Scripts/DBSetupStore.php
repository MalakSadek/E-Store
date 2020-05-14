<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$categories = $_REQUEST["categories"];
$storename = $_REQUEST["storename"];
$email = $_REQUEST["email"];

$res = mysqli_query($con, "SELECT * FROM User WHERE Email = '$email'");

$data = array();

$SellerNum = $res->fetch_assoc()['SellerNum'];

  if($SellerNum != null) {
    $res2 = mysqli_query($con, "UPDATE User SET StoreName = '$storename' WHERE Email = '$email'");
}

$res3 = mysqli_query($con, "INSERT INTO StoreCat (storeNo, Category) VALUES ('$SellerNum', '$categories')");

mysqli_close($con);

?>
