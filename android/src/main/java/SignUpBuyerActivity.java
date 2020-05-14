package malaksadek.databaseproject;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;

import cz.msebera.android.httpclient.Header;

/**
 * Created by malaksadek on 3/1/18.
 */

public class SignUpBuyerActivity extends AppCompatActivity {

    EditText Fname, Lname, Phone, Address, Password, Vpassword, Email;
    Button done;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signupbuyer);

        Fname = findViewById(R.id.fname);
        Lname = findViewById(R.id.lname);
        Phone = findViewById(R.id.number);
        Password = findViewById(R.id.password);
        Address = findViewById(R.id.address);
        Vpassword = findViewById(R.id.vpassword);
        Email = findViewById(R.id.email);
        done = findViewById(R.id.done);

        done.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if((Fname.getText().toString().isEmpty())||(Lname.getText().toString().isEmpty())||(Phone.getText().toString().isEmpty())||(Password.getText().toString().isEmpty())||(Vpassword.getText().toString().isEmpty())||(Address.getText().toString().isEmpty())||(Email.getText().toString().isEmpty())) {
                    Toast.makeText(getApplicationContext(), "Please fill all fields!", Toast.LENGTH_LONG).show();
                }
                else if (!Password.getText().toString().equals(Vpassword.getText().toString())) {
                    Toast.makeText(getApplicationContext(), "Passwords do not match!", Toast.LENGTH_LONG).show();
                }
                else if (!Email.getText().toString().contains("@")) {
                    Toast.makeText(getApplicationContext(), "Invalid Email!", Toast.LENGTH_LONG).show();
                }
                else {
                    RequestParams params;

                    params = new RequestParams();
                    params.put("fname", Fname.getText().toString());
                    params.put("lname", Lname.getText().toString());
                    params.put("number", Phone.getText().toString());
                    params.put("email", Email.getText().toString());
                    params.put("password", Password.getText().toString());
                    params.put("address", Address.getText().toString());

                    AsyncHttpClient client = new AsyncHttpClient();
                    client.post("http://malaksadekapps.com/DBAddUserBuyer.php",
                            params, new AsyncHttpResponseHandler() {
                                @Override
                                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                    if (statusCode == 200) {
                                        Log.i("response", responseBody.toString());

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
            }
        });
    }
}
