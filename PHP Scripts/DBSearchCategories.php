<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }
$category = $_REQUEST["Category"];
$res = mysqli_query($con, "SELECT storeName FROM User WHERE SellerNum = (SELECT storeNo FROM StoreCat WHERE Category LIKE '%$category%')");

$data = array();

while ($rows = $res->fetch_assoc()) {
  array_push($data, array("storeName"=>$rows['storeName']));
}

if($data == null)
  echo "None";
else
echo json_encode($data);
mysqli_close($con);

?>