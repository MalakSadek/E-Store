package malaksadek.databaseproject;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceActivity;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import java.util.Arrays;

import cz.msebera.android.httpclient.Header;

/**
 * Created by malaksadek on 3/1/18.
 */

public class SignUpSellerActivity extends AppCompatActivity {

    EditText Fname, Lname, Phone, Address, Password, Vpassword, Email;
    Button done;
    Boolean edit;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signupseller);

        Fname = findViewById(R.id.fname);
        Lname = findViewById(R.id.lname);
        Phone = findViewById(R.id.number);
        Password = findViewById(R.id.password);
        Address = findViewById(R.id.address);
        Vpassword = findViewById(R.id.vpassword);
        Email = findViewById(R.id.email);
        done = findViewById(R.id.done);

        SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
        edit = sp.getBoolean("EditSeller", false);

        if (!edit) {
            done.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if ((Fname.getText().toString().isEmpty()) || (Lname.getText().toString().isEmpty()) || (Phone.getText().toString().isEmpty()) || (Password.getText().toString().isEmpty()) || (Vpassword.getText().toString().isEmpty()) || (Address.getText().toString().isEmpty()) || (Email.getText().toString().isEmpty())) {
                        Toast.makeText(getApplicationContext(), "Please fill all fields!", Toast.LENGTH_LONG).show();
                    } else if (!Password.getText().toString().equals(Vpassword.getText().toString())) {
                        Toast.makeText(getApplicationContext(), "Passwords do not match!", Toast.LENGTH_LONG).show();
                    } else if (!Email.getText().toString().contains("@")) {
                        Toast.makeText(getApplicationContext(), "Invalid Email!", Toast.LENGTH_LONG).show();
                    } else {



                        RequestParams params;

                        params = new RequestParams();
                        params.put("fname", Fname.getText().toString());
                        params.put("lname", Lname.getText().toString());
                        params.put("number", Phone.getText().toString());
                        params.put("email", Email.getText().toString());
                        params.put("password", Password.getText().toString());
                        params.put("address", Address.getText().toString());

                        AsyncHttpClient client = new AsyncHttpClient();
                        client.post("http://malaksadekapps.com/DBAddUserSeller.php",
                                params, new AsyncHttpResponseHandler() {
                                    @Override
                                    public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {


                                        if (statusCode == 200) {

                                                Toast.makeText(getApplicationContext(), "Info Uploaded",
                                                        Toast.LENGTH_LONG).show();

                                                SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
                                                SharedPreferences.Editor editor = sp.edit();
                                                editor.putString("Fname", Fname.getText().toString());
                                                editor.putString("Lname", Lname.getText().toString());
                                                editor.putString("Phone", Phone.getText().toString());
                                                editor.putString("Password", Password.getText().toString());
                                                editor.putString("Address", Address.getText().toString());
                                                editor.putString("Email", Email.getText().toString());
                                                editor.putBoolean("First", false);
                                                editor.putBoolean("Seller", true);
                                                editor.putBoolean("Store", false);
                                                editor.commit();
                                                Intent i = new Intent(getApplicationContext(), MenuActivity.class);
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
                }
            });
        }
        else {

            Email.setVisibility(View.INVISIBLE);
            SharedPreferences sp2 = getSharedPreferences("DatabaseProjectPrefs", 0);
            final SharedPreferences.Editor editor = sp2.edit();

            done.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                if (!Password.getText().toString().equals(Vpassword.getText().toString())) {
                        Toast.makeText(getApplicationContext(), "Passwords do not match!", Toast.LENGTH_LONG).show();
                    } else {

                    RequestParams params;

                    params = new RequestParams();

                    if (!Fname.getText().toString().isEmpty()) {
                        params.put("fname", Fname.getText().toString());
                        editor.putString("Fname", Fname.getText().toString());
                    } else
                        params.put("fname", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Fname", "None"));

                    if (!Lname.getText().toString().isEmpty()) {
                        params.put("lname", Lname.getText().toString());
                        editor.putString("Lname", Lname.getText().toString());
                    }
                        else
                            params.put("lname", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Lname", "None"));

                        if(!Phone.getText().toString().isEmpty()) {
                            params.put("number", Phone.getText().toString());
                            editor.putString("Phone", Phone.getText().toString());
                        }
                        else
                            params.put("number", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Phone", "None"));

                        if(!Password.getText().toString().isEmpty()) {
                            params.put("password", Password.getText().toString());
                            editor.putString("Password", Password.getText().toString());
                        }
                        else
                            params.put("password", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Password", "None"));

                        if(!Address.getText().toString().isEmpty()) {
                            params.put("address", Address.getText().toString());
                            editor.putString("Address", Address.getText().toString());
                        }
                        else
                            params.put("address", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Address", "None"));

                        params.put("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));

                        AsyncHttpClient client = new AsyncHttpClient();
                        client.post("http://malaksadekapps.com/DBEditUserSeller.php",
                                params, new AsyncHttpResponseHandler() {
                                    @Override
                                    public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                        Log.i("Status Code:", String.valueOf(statusCode));

                                        if (statusCode == 200) {
                                            Toast.makeText(getApplicationContext(), "Info Uploaded",
                                                    Toast.LENGTH_LONG).show();
                                            editor.putBoolean("Seller", true);
                                            editor.commit();
                                            Intent i = new Intent(getApplicationContext(), ProfileActivity.class);
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
                }
            });
        }
        SharedPreferences.Editor editor = sp.edit();
        editor.putBoolean("EditSeller", false);
        editor.commit();
    }
}
