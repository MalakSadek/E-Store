<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

$email = $_REQUEST['email'];
$product = $_REQUEST['product'];

$res = mysqli_query($con, "SELECT BuyerNum FROM User WHERE Email = '$email'");

while ($rows = $res->fetch_assoc()) {
  $cart = $rows['BuyerNum'];
}


$res1 = mysqli_query($con, "DELETE FROM CartProducts WHERE ProductNo = '$product' AND CartNo = '$cart'");
mysqli_close($con);

?>
