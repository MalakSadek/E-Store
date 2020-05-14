package malaksadek.databaseproject;

import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

/**
 * Created by malaksadek on 3/1/18.
 */

public class MenuActivity extends AppCompatActivity {

    Button profile, myorders, mycart, search, mystore;


    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu);



        profile = findViewById(R.id.profile);
        myorders = findViewById(R.id.myorders);
        mycart = findViewById(R.id.mycart);
        search = findViewById(R.id.search);
        mystore = findViewById(R.id.mystore);
        final SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
        mystore.setClickable(false);
        mycart.setClickable(false);
        myorders.setClickable(false);
        search.setClickable(false);
        mystore.setTextColor(Color.RED);
        mycart.setTextColor(Color.RED);
        myorders.setTextColor(Color.RED);
        search.setTextColor(Color.RED);


       if (sp.getBoolean("Buyer", false)) {
           myorders.setClickable(true);
           mycart.setClickable(true);
           search.setClickable(true);
           mycart.setTextColor(Color.WHITE);
           myorders.setTextColor(Color.WHITE);
           search.setTextColor(Color.WHITE);

           mycart.setOnClickListener(new View.OnClickListener() {
               @Override
               public void onClick(View view) {
                   Intent i = new Intent(getApplicationContext(), MyCartActivity.class);
                   startActivity(i);
               }
           });

           myorders.setOnClickListener(new View.OnClickListener() {
               @Override
               public void onClick(View view) {
                   Intent i = new Intent(getApplicationContext(), MyOrdersActivity.class);
                   startActivity(i);
               }
           });

           search.setOnClickListener(new View.OnClickListener() {
               @Override
               public void onClick(View view) {
                   Intent i = new Intent(getApplicationContext(), SearchActivity.class);
                   startActivity(i);
               }
           });
       }

       if(sp.getBoolean("Seller", false)) {
           mystore.setClickable(true);
           mystore.setTextColor(Color.WHITE);

           mystore.setOnClickListener(new View.OnClickListener() {
               @Override
               public void onClick(View view) {
                   Log.i("","I work!");
                   if(sp.getBoolean("Store", false)) {
                       Intent i = new Intent(getApplicationContext(), MyStoreActivity.class);
                       startActivity(i);
                   } else {
                       Intent i = new Intent(getApplicationContext(), SetupStoreActivity.class);
                       i.putExtra("EditStore", false);
                       startActivity(i);
                   }
               }
           });
       }

        profile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(getApplicationContext(), ProfileActivity.class);
                startActivity(i);
            }
        });

    }



}
