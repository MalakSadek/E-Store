<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

$email = $_REQUEST['email'];

$res = mysqli_query($con, "SELECT BuyerNum FROM User WHERE Email = '$email'");

while ($rows = $res->fetch_assoc()) {
  $buyerNum = $rows['BuyerNum'];
    echo $buyerNum;
}

$res2 = mysqli_query($con, "SELECT COUNT(*) 'Count' FROM `Order`");
$currentID = $res2->fetch_assoc()['Count']+1;

$res3 = mysqli_query($con, "INSERT INTO `Order` (OrderID, `Status`, BuyerN) VALUES ('$currentID', 'New', '$buyerNum')");

$res4 = mysqli_query($con, "SELECT StoreNumber, ProductNo, Quantity FROM CartProducts WHERE CartNo = '$buyerNum'");

$data = array();

while ($rows2 = $res4->fetch_assoc()) {
  $store = $rows2['StoreNumber'];
  $product = $rows2['ProductNo'];
  $quantity = $rows2['Quantity'];
  echo $store;
  echo $product;
  echo $quantity;
  $res5 = mysqli_query($con, "INSERT INTO OrderProducts (OrderNo, ProductN, storeNumber, QuantityOrdered) VALUES ('$currentID', '$product', '$store', '$quantity')");
  $res6 = mysqli_query($con, "DELETE FROM CartProducts WHERE CartNo = '$buyerNum' AND StoreNumber = '$store' AND ProductNo = '$product'");
}

echo json_encode($data);
mysqli_close($con);

?>
