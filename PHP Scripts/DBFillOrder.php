<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];

$res = mysqli_query($con, "SELECT OrderID, Status FROM `Order` WHERE BuyerN = (SELECT BuyerNum FROM User WHERE Email = '$email')");

$data = array();

while ($rows = $res->fetch_assoc()) {
  $order = $rows['OrderID'];
  $res2 = mysqli_query($con, "SELECT Total FROM ordertotalview WHERE OrderID = '$order'");
  $total = $res2->fetch_assoc()['Total'];
  array_push($data, array("OrderID"=>$total, "Status"=>$rows['Status'], "Buyer"=>$order));
}

if($data == null)
  echo "None";
else
echo json_encode($data);
mysqli_close($con);

?>
