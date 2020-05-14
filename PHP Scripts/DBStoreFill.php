<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$name = $_REQUEST["name"];

$res = mysqli_query($con, "SELECT SellerNum FROM User WHERE StoreName = '$name'");

$data = array();

  $rows = $res->fetch_assoc();
  $storeNum = $rows['SellerNum'];
  $res2 = mysqli_query($con, "SELECT Category FROM StoreCat WHERE storeNo = '$storeNum'");
  $rows2 = $res2->fetch_assoc();
  array_push($data, array("Categories"=>$rows2['Category']));
  array_push($data, array("StoreNumber"=>$storeNum));
  $res3 = mysqli_query($con, "SELECT * FROM Product WHERE storeNum = '$storeNum'");
  while($rows3 = $res3->fetch_assoc()) {
    array_push($data, array("ProductNumber"=>$rows3['ProductID'], "ProductName"=>$rows3['ProductName'], "ProductPrice"=>$rows3['Price'], "ProductDescription"=>$rows3['Description'], "ProductStock"=>$rows3['Stock']));
  }


if($data == null)
  echo "None";
else
echo json_encode($data);
mysqli_close($con);

?>
