<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];
$product = $_REQUEST["product"];
$store = $_REQUEST["store"];

$res = mysqli_query($con, "SELECT BuyerNum FROM User WHERE Email = '$email'");
$rows = $res->fetch_assoc();
$cart = $rows['BuyerNum'];

$res2 = mysqli_query($con, "SELECT Quantity FROM CartProducts WHERE CartNo = '$cart' AND StoreNumber = '$store' AND ProductNo = '$product'");

$rows2 = $res2->fetch_assoc();
$quantity = $rows2['Quantity'];

$res4 = mysqli_query($con, "UPDATE Product SET Stock = Stock-1 WHERE ProductID = $product");
echo $quantity;
if($quantity == null) {
  $res3 = mysqli_query($con, "INSERT INTO CartProducts (CartNo, StoreNumber, ProductNo, Quantity) VALUES ('$cart', '$store', '$product', 1)");
} else {
  $quantity=$quantity+1;
  $res3 = mysqli_query($con, "UPDATE CartProducts SET Quantity = '$quantity' WHERE CartNo = '$cart' AND StoreNumber = '$store' AND ProductNo = '$product'");
}

if ( false===$res3 ) {
  printf("error: %s\n", mysqli_error($con));
}

mysqli_close($con);

?>
