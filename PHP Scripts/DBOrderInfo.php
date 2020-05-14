<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];

$res = mysqli_query($con, "SELECT * FROM `Order` WHERE OrderID IN (SELECT OrderNo FROM OrderProducts WHERE storeNumber IN (SELECT SellerNum FROM User WHERE Email = '$email'))");

$data = array();

while ($rows = $res->fetch_assoc()) {
  $buyerNum = $rows['BuyerN'];
  $order = $rows['OrderID'];
  $res2 = mysqli_query($con, "SELECT Email FROM User WHERE BuyerNum = '$buyerNum'");
  $rows2 = $res2->fetch_assoc();
  $res3 = mysqli_query($con, "SELECT Total FROM ordertotalview WHERE OrderID = '$order'");
  $total = $res3->fetch_assoc()['Total'];
  array_push($data, array("OrderID"=>$total, "Status"=>$rows['Status'], "Buyer"=>$rows2['Email']));
}

if($data == null)
  echo "None";
else
echo json_encode($data);
mysqli_close($con);

?>
