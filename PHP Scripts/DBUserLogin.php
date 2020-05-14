<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["email"];

$res = mysqli_query($con, "SELECT * FROM User WHERE Email = '$email'");

$data = array();

while ($rows = $res->fetch_assoc()) {
  array_push($data, array("FName"=>$rows['FName'], "LName"=>$rows['LName'], "Phone"=>$rows['Phone'], "Address"=>$rows['Address'], "BuyerNum"=>$rows['BuyerNum'], "SellerNum"=>$rows['SellerNum'], "Password"=>base64_decode($rows['Password'])));
  $SellerNum = $rows['SellerNum'];
  $BuyerNum = $rows['BuyerNum'];
  array_push($data, array("StoreName"=>$rows['StoreName']));

  if($BuyerNum != null) {
    $res3 = mysqli_query($con, "SELECT * FROM Buyer WHERE BuyerID = '$BuyerNum'");
    $rows3 = $res3->fetch_assoc();
    array_push($data, array("Card"=>base64_decode($rows3['Card']), "ExpiryDate"=>$rows3['ExpiryDate'], "SecurityCode"=>base64_decode($rows3['SecurityCode']), "cardType"=>$rows3['cardType']));
  }
}

if($data == null)
  echo "No Users";
else
echo json_encode($data);
mysqli_close($con);

?>
