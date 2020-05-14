<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

$email = $_REQUEST['email'];
$product = $_REQUEST['product'];

$res = mysqli_query($con, "SELECT BuyerNum FROM User WHERE Email = '$email'");

while ($rows = $res->fetch_assoc()) {
    $store = $rows['SellerNum'];
}


$res1 = mysqli_query($con, "DELETE FROM Product WHERE ProductNo = '$product' AND storeNum = '$store'");
mysqli_close($con);

?>
