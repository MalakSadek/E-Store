package malaksadek.databaseproject;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

import cz.msebera.android.httpclient.Header;

/**
 * Created by malaksadek on 3/1/18.
 */

public class SignUpBuyer2Activity extends AppCompatActivity {
    EditText CardNumber, SecurityCode, ExpiryDate;
    Spinner Types;
    Button done;
    ArrayList<String> types;
    String ChosenType;
    Boolean edit;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signupbuyer2);

        CardNumber = findViewById(R.id.cardnumber);
        SecurityCode = findViewById(R.id.securitycode);
        ExpiryDate = findViewById(R.id.expirydate);
        Types = findViewById(R.id.types);
        done = findViewById(R.id.done);

        types = new ArrayList<String>();
        types.add("MasterCard");
        types.add("Visa");
        types.add("American Express");

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, types);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        Types.setAdapter(adapter);

        Types.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                ChosenType = types.get(i);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
        edit = sp.getBoolean("EditBuyer", false);
        if (!edit) {
            done.setOnClickListener(new View.OnClickListener() {
                @SuppressLint("SimpleDateFormat")
                @Override
                public void onClick(View view) {
                    if ((CardNumber.getText().toString().isEmpty()) || (SecurityCode.getText().toString().isEmpty()) || (ExpiryDate.getText().toString().isEmpty())) {
                        Toast.makeText(getApplicationContext(), "Please fill all fields!", Toast.LENGTH_LONG).show();
                    } else if (SecurityCode.getText().length() > 3) {
                        Toast.makeText(getApplicationContext(), "Invalid security code!", Toast.LENGTH_LONG).show();
                    }

                    else try {
                            if (new SimpleDateFormat("yyyy/MM/DD").parse(ExpiryDate.getText().toString()).before(new Date())) {
                                Toast.makeText(getApplicationContext(), "This card is expired!", Toast.LENGTH_LONG).show();
                            }
                            else {

                                RequestParams params;

                                params = new RequestParams();
                                params.put("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
                                params.put("type", ChosenType);
                                params.put("card", CardNumber.getText().toString());
                                params.put("date", ExpiryDate.getText().toString());
                                params.put("code", SecurityCode.getText().toString());

                                AsyncHttpClient client = new AsyncHttpClient();
                                client.post("http://malaksadekapps.com/DBAddUserBuyer2.php",
                                        params, new AsyncHttpResponseHandler() {
                                            @Override
                                            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {


                                                if (statusCode == 200) {

                                                    Toast.makeText(getApplicationContext(), "Info Uploaded",
                                                            Toast.LENGTH_LONG).show();

                                                    //TODO: Script to add buyer
                                                    SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
                                                    SharedPreferences.Editor editor = sp.edit();
                                                    editor.putString("CardNumber", CardNumber.getText().toString());
                                                    editor.putString("SecurityCode", SecurityCode.getText().toString());
                                                    editor.putString("ExpiryDate", ExpiryDate.getText().toString());
                                                    editor.putString("CardType", ChosenType);
                                                    editor.putBoolean("Buyer", true);
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
                        } catch (ParseException e) {
                            e.printStackTrace();
                        }
                }
            });
        }
        else {
            done.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if ((CardNumber.getText().toString().isEmpty()) || (SecurityCode.getText().toString().isEmpty()) || (ExpiryDate.getText().toString().isEmpty())) {
                        Toast.makeText(getApplicationContext(), "Please fill all fields!", Toast.LENGTH_LONG).show();
                    } else if (SecurityCode.getText().length() > 3) {
                        Toast.makeText(getApplicationContext(), "Invalid security code!", Toast.LENGTH_LONG).show();
                    }
                    try {
                        if (new SimpleDateFormat("yyyy/MM/DD").parse(ExpiryDate.getText().toString()).before(new Date())) {
                            Toast.makeText(getApplicationContext(), "This card is expired!", Toast.LENGTH_LONG).show();
                        }
                        else {

                            RequestParams params;
                            SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
                            final SharedPreferences.Editor editor = sp.edit();

                            params = new RequestParams();
                            params.put("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));

                            if(CardNumber.getText().toString().isEmpty())
                                params.put("card", getSharedPreferences("DatabaseProjectPrefs", 0).getString("CardNumber", "None"));

                            else {
                                params.put("card", CardNumber.getText().toString());
                                editor.putString("CardNumber", CardNumber.getText().toString());
                            }

                            if(ChosenType.isEmpty())
                                params.put("type", getSharedPreferences("DatabaseProjectPrefs", 0).getString("CardType", "None"));

                            else {
                                params.put("type", ChosenType);
                                editor.putString("CardTy[e", ChosenType);
                            }

                            if(ExpiryDate.getText().toString().isEmpty())
                                params.put("date", getSharedPreferences("DatabaseProjectPrefs", 0).getString("ExpiryDate", "None"));

                            else {
                                params.put("date", ExpiryDate.getText().toString());
                                editor.putString("ExpiryDate", ExpiryDate.getText().toString());
                            }

                            if(SecurityCode.getText().toString().isEmpty())
                                params.put("card", getSharedPreferences("DatabaseProjectPrefs", 0).getString("SecurityCode", "None"));

                            else {
                                params.put("code", SecurityCode.getText().toString());
                                editor.putString("SecurityCode", SecurityCode.getText().toString());
                            }


                            AsyncHttpClient client = new AsyncHttpClient();
                            client.post("http://malaksadekapps.com/DBAddUserBuyer2.php",
                                    params, new AsyncHttpResponseHandler() {
                                        @Override
                                        public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {


                                            if (statusCode == 200) {

                                                Toast.makeText(getApplicationContext(), "Info Uploaded",
                                                        Toast.LENGTH_LONG).show();

                                                editor.putBoolean("Buyer", true);
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
                    } catch (ParseException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
        SharedPreferences.Editor editor = sp.edit();
        editor.putBoolean("EditBuyer", false);
        editor.commit();
    }
}
