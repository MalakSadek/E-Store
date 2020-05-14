package malaksadek.databaseproject;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import java.util.Arrays;

import cz.msebera.android.httpclient.Header;

/**
 * Created by malaksadek on 3/1/18.
 */

public class ProfileActivity extends AppCompatActivity {

    TextView Fname, Lname, Address, Email, Phone, CardType, SecurityCode, CardNumber, ExpiryDate, label1, label2, label3, label4;
    Button SetupStore, RegisterBuyer, RegisterSeller, ViewStore, Logout, EditInfo, EditPayment;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);

        SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);

        Fname = findViewById(R.id.fname);
        Fname.setText(sp.getString("Fname", "None"));
        Lname = findViewById(R.id.lname);
        Lname.setText(sp.getString("Lname", "None"));
        Address = findViewById(R.id.address);
        Address.setText(sp.getString("Address", "None"));
        Email = findViewById(R.id.email);
        Email.setText(sp.getString("Email", "None"));
        Phone = findViewById(R.id.number);
        Phone.setText(sp.getString("Phone", "None"));

        CardType = findViewById(R.id.cardtype);
        SecurityCode = findViewById(R.id.securitycode);
        CardNumber = findViewById(R.id.cardnumber);
        ExpiryDate = findViewById(R.id.expirydate);
        SetupStore = findViewById(R.id.setupstore);
        RegisterBuyer = findViewById(R.id.registerbuyer);
        RegisterSeller = findViewById(R.id.registerseller);
        ViewStore = findViewById(R.id.viewstore);
        Logout = findViewById(R.id.logout);
        EditInfo = findViewById(R.id.editinfo);
        EditPayment = findViewById(R.id.editpayment);

        label1 = findViewById(R.id.label1);
        label2 = findViewById(R.id.label2);
        label3 = findViewById(R.id.label3);
        label4 = findViewById(R.id.label4);

        SetupStore.setVisibility(View.INVISIBLE);
        RegisterSeller.setVisibility(View.INVISIBLE);
        RegisterBuyer.setVisibility(View.INVISIBLE);
        ViewStore.setVisibility(View.INVISIBLE);


        if(sp.getBoolean("Seller", false)) {
            if(sp.getBoolean("Store", false)) {
                ViewStore.setVisibility(View.VISIBLE);
            }
            else {
                SetupStore.setVisibility(View.VISIBLE);
            }
        }
        else {
            RegisterSeller.setVisibility(View.VISIBLE);
        }

        if(sp.getBoolean("Buyer", false)) {
            CardNumber.setText(sp.getString("CardNumber", "None"));
            CardType.setText(sp.getString("CardType", "None"));
            SecurityCode.setText(sp.getString("SecurityCode", "None"));
            ExpiryDate.setText(sp.getString("ExpiryDate", "None"));
        }
        else {
            RegisterBuyer.setVisibility(View.VISIBLE);
            label1.setVisibility(View.INVISIBLE);
            label2.setVisibility(View.INVISIBLE);
            label3.setVisibility(View.INVISIBLE);
            label4.setVisibility(View.INVISIBLE);
            CardType.setVisibility(View.INVISIBLE);
            CardNumber.setVisibility(View.INVISIBLE);
            ExpiryDate.setVisibility(View.INVISIBLE);
            SecurityCode.setVisibility(View.INVISIBLE);
            EditPayment.setVisibility(View.INVISIBLE);
        }

        RegisterBuyer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                RequestParams params;

                params = new RequestParams();
                params.put("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));

                AsyncHttpClient client = new AsyncHttpClient();
                client.post("http://malaksadekapps.com/DBRegisterBuyer.php",
                        params, new AsyncHttpResponseHandler() {
                            @Override
                            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {


                                if (statusCode == 200) {

                                    Toast.makeText(getApplicationContext(), "You are now a registered buyer.",
                                            Toast.LENGTH_LONG).show();

                                    SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
                                    SharedPreferences.Editor editor = sp.edit();
                                    editor.putBoolean("Buyer", true);
                                    editor.commit();
                                    Intent i = new Intent(getApplicationContext(), SignUpBuyer2Activity.class);
                                    startActivity(i);
                                }
                                else {
                                    Toast.makeText(getApplicationContext(),
                                            Arrays.toString(responseBody),
                                            Toast.LENGTH_LONG).show();
                                }
                            }

                            @Override
                            public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                                // When Http response code is '404'
                                if (statusCode == 404) {
                                    Toast.makeText(getApplicationContext(),
                                            "Requested resource not found",
                                            Toast.LENGTH_LONG).show();
                                }
                                // When Http response code is '500'
                                else if (statusCode == 500) {
                                    Toast.makeText(getApplicationContext(),
                                            "Something went wrong at server end",
                                            Toast.LENGTH_LONG).show();
                                }
                                // When Http response code other than 404, 500
                                else {
                                    Toast.makeText(
                                            getApplicationContext(),
                                            "Error Occurred \n Most Common Error: \n1. Device not connected to Internet\n2. Web App is not deployed in App server\n3. App server is not running\n HTTP Status code : "
                                                    + statusCode, Toast.LENGTH_LONG)
                                            .show();
                                }
                            }
                        });

            }
        });

        RegisterSeller.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                RequestParams params;

                params = new RequestParams();
                params.put("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));

                AsyncHttpClient client = new AsyncHttpClient();
                client.post("http://malaksadekapps.com/DBRegisterSeller.php",
                        params, new AsyncHttpResponseHandler() {
                            @Override
                            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {


                                if (statusCode == 200) {

                                    Toast.makeText(getApplicationContext(), "You are now a registered seller.",
                                            Toast.LENGTH_LONG).show();
                                        SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
                                        SharedPreferences.Editor editor = sp.edit();
                                        editor.putBoolean("Seller", true);
                                        editor.commit();
                                    SetupStore.setVisibility(View.VISIBLE);
                                    RegisterSeller.setVisibility(View.INVISIBLE);
                                }
                                else {
                                    Toast.makeText(getApplicationContext(),
                                            Arrays.toString(responseBody),
                                            Toast.LENGTH_LONG).show();
                                }
                            }

                            @Override
                            public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                                // When Http response code is '404'
                                if (statusCode == 404) {
                                    Toast.makeText(getApplicationContext(),
                                            "Requested resource not found",
                                            Toast.LENGTH_LONG).show();
                                }
                                // When Http response code is '500'
                                else if (statusCode == 500) {
                                    Toast.makeText(getApplicationContext(),
                                            "Something went wrong at server end",
                                            Toast.LENGTH_LONG).show();
                                }
                                // When Http response code other than 404, 500
                                else {
                                    Toast.makeText(
                                            getApplicationContext(),
                                            "Error Occurred \n Most Common Error: \n1. Device not connected to Internet\n2. Web App is not deployed in App server\n3. App server is not running\n HTTP Status code : "
                                                    + statusCode, Toast.LENGTH_LONG)
                                            .show();
                                }
                            }
                        });

            }
        });

        Logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LogoutDialogFragment d = new LogoutDialogFragment();
                d.show(getSupportFragmentManager(), "My Dialog");
            }
        });

        SetupStore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(getApplicationContext(), SetupStoreActivity.class);
                i.putExtra("EditStore", false);
                startActivity(i);
            }
        });

        EditInfo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SharedPreferences sp2 = getSharedPreferences("DatabaseProjectPrefs", 0);
                SharedPreferences.Editor editor = sp2.edit();
                editor.putBoolean("EditSeller", true);
                editor.commit();
                Intent i = new Intent(getApplicationContext(), SignUpSellerActivity.class);
                startActivity(i);
            }
        });

        EditPayment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SharedPreferences sp3 = getSharedPreferences("DatabaseProjectPrefs", 0);
                SharedPreferences.Editor editor = sp3.edit();
                editor.putBoolean("EditBuyer", true);
                editor.commit();
                Intent i = new Intent(getApplicationContext(), SignUpBuyer2Activity.class);
                startActivity(i);
            }
        });

        ViewStore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(getApplicationContext(), MyStoreActivity.class);
                startActivity(i);
            }
        });

    }
}
