# E-Store
An online marketplace mobile application (2018)

🛍🛒 EStore started as a project for my Database course. It's an online marketplace where you can register as a buyer or seller (or both). As a buyer you can search for stores by their name, the products they offer, or their category. You can view your cart and place an order. As a seller, you can set up your store and add products (you can edit both your store and the products you add later) and you can also keep track of the orders placed by buyers. As a buyer, you can register as a seller and setup a store at any time and vice versa. The application is not currently for use by the public, and cannot handle actual financial transactions, however it's live and all features are working.

The **iOS** version is created in **Swift** and the **Android** version in **Java**. A **MySQL database** was created to host the back end and was initially hosted locally using **PHPMyAdmin** (which is why a custom IP address was needed to access it through **ngork**). This database was later migrated to **RemoteMySQL** and the PHP API files hosted on **000webhost**. The application communicates with the database through custom made APIs written in **PHP** and containing **complex SQL queries**. The database itself makes use of SQL Views, Foreign Keys, and One-to-One, One-to-Many, and Many-to-Many data relationship models. It is a model and a proof of concept, not yet intended for commercial use, it cannot handle financial transaction and real credit card information should NOT be stored on the application.

Screenshots and videos of the application can be found here: https://malaksadek.wordpress.com/2019/08/09/estore-the-online-marketplace/

# Download the App:

The app is available to download on:
* The iOS App Store: https://apps.apple.com/us/app/estore-the-online-marketplace/id1476976040?ls=1
* The Android Play Store: https://play.google.com/store/apps/details?id=malaksadek.databaseproject

# Contact

* email: mfzs1@st-andrews.ac.uk
* LinkedIn: www.linkedin.com/in/malak-sadek-17aa65164/
* website: https://malaksadek.wordpress.com/

