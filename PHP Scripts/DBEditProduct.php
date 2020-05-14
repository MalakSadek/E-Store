<?php
//Creating a connection
    $con= new mysqli("localhost","root","","DatabaseProject");

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$email = $_REQUEST["Email"];
$index = $_REQUEST["Index"];
$name = $_REQUEST["Name"];
$price = $_REQUEST["Price"];
$desc = $_REQUEST["Description"];
$stock = $_REQUEST["Stock"];

$result = mysqli_query($con, "UPDATE Product SET ProductName = '$name', Price = '$price', Description = '$desc', Stock = '$stock' WHERE `Product`.`productID` = '$index' AND `Product`.`storeNum` = (SELECT SellerNum FROM User WHERE Email = '$email')");

if ( false===$result ) {
  printf("error: %s\n", mysqli_error($con));
}

mysqli_close($con);

?>
