<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];

$res = mysqli_query($con, "SELECT OrderNo, productN, QuantityOrdered FROM OrderProducts WHERE storeNumber = (SELECT SellerNum FROM User WHERE Email = '$email')");

$data = array();

while ($rows = $res->fetch_assoc()) {
  $product = $rows['productN'];
  $quantity = $rows['QuantityOrdered'];
  $res2 = mysqli_query($con, "SELECT ProductName, Price, Description FROM Product WHERE ProductID = '$product'");
  $rows2 = $res2->fetch_assoc();
  array_push($data, array("ProductName"=>$rows2['ProductName'], "Price"=>$rows2['Price'], "Description"=>$rows2['Description'], "QuantityOrdered"=>$rows['QuantityOrdered'], "OrderNo"=>$rows['OrderNo']));
}

if($data == null)
  echo "None";
else
echo json_encode($data);
mysqli_close($con);

?>
