<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];

$res = mysqli_query($con, "SELECT SellerNum, StoreName FROM User WHERE Email = '$email'");

$data = array();

while ($rows = $res->fetch_assoc()) {
  $storeNum = $rows['SellerNum'];
  $res2 = mysqli_query($con, "SELECT Category FROM StoreCat WHERE storeNo = '$storeNum'");
  $rows2 = $res2->fetch_assoc();
  array_push($data, array("storeName"=>$rows['StoreName'], "Categories"=>$rows2['Category']));
}

if($data == null)
  echo "None";
else
echo json_encode($data);
mysqli_close($con);

?>
