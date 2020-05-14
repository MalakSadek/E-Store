<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

$email = $_REQUEST['email'];

$res = mysqli_query($con, "SELECT BuyerNum FROM User WHERE Email = '$email'");

while ($rows = $res->fetch_assoc()) {
  $cart = $rows['BuyerNum'];
}


$res2 = mysqli_query($con, "SELECT StoreNumber, ProductNo FROM CartProducts WHERE CartNo = '$cart'");

$data = array();

$res5 = mysqli_query($con, "SELECT Total FROM carttotalview WHERE CartNo = '$cart'");
$total = $res5->fetch_assoc()['Total'];
array_push($data, array("Total"=>$total));
while ($rows2 = $res2->fetch_assoc()) {
  $store = $rows2['StoreNumber'];
  $product = $rows2['ProductNo'];
  $res3 = mysqli_query($con, "SELECT * FROM Product WHERE storeNum = '$store' AND ProductID = '$product'");
  while($rows3 = $res3->fetch_assoc()){
    $res4 = mysqli_query($con, "SELECT Quantity FROM CartProducts WHERE CartNo = '$cart' AND StoreNumber = '$store' AND ProductNo = '$product'");
    $rows4 = $res4->fetch_assoc();
    $quantity = $rows4['Quantity'];
    array_push($data, array("ProductNumber"=>$product, "ProductName"=>$rows3['ProductName'], "ProductPrice"=>$rows3['Price'], "ProductDescription"=>$rows3['Description'], "ProductStock"=>$rows4['Quantity']));
  }
}

echo json_encode($data);
mysqli_close($con);

?>
