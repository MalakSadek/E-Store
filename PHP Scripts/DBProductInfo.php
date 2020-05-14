<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];

$res = mysqli_query($con, "SELECT SellerNum FROM User WHERE Email = '$email'");

$data = array();

while ($rows = $res->fetch_assoc()) {
  $storeNum = $rows['SellerNum'];
  $res2 = mysqli_query($con, "SELECT * FROM Product WHERE storeNum = '$storeNum'");
  while ($rows2 = $res2->fetch_assoc()) {
    array_push($data, array("ProductNumber"=>$rows2['ProductID'], "ProductName"=>$rows2['ProductName'], "ProductPrice"=>$rows2['Price'], "ProductPrice"=>$rows2['Price'], "ProductDescription"=>$rows2['Description'], "ProductStock"=>$rows2['Stock']));
  }
}

if($data == null)
  echo "None";
else
echo json_encode($data);
mysqli_close($con);

?>
