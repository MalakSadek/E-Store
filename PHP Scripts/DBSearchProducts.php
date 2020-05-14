<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }
$Product = $_REQUEST["Product"];
$res = mysqli_query($con, "SELECT StoreName FROM User WHERE SellerNum = (SELECT storeNum FROM Product WHERE ProductName LIKE '%$Product%')");

$data = array();

while ($rows = $res->fetch_assoc()) {
  array_push($data, array("storeName"=>$rows['StoreName']));
}

if($data == null)
  echo "None";
else
echo json_encode($data);
mysqli_close($con);

?>
