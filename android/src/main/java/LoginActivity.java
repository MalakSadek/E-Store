package malaksadek.databaseproject;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by malaksadek on 3/1/18.
 */

public class LoginActivity extends AppCompatActivity {

    Button done;
    EditText Email, Password;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        done = findViewById(R.id.done);
        Email = findViewById(R.id.email);
        Password = findViewById(R.id.password);

        done.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if((Email.getText().toString().isEmpty())||(Password.getText().toString().isEmpty())) {
                    Toast.makeText(getApplicationContext(), "Please enter all the required information!", Toast.LENGTH_LONG).show();
                }
                else if (!Email.getText().toString().contains("@")){
                    Toast.makeText(getApplicationContext(), "Invalid Email!", Toast.LENGTH_LONG).show();
                }

                String url = "http://malaksadekapps/DBUserLogin.php?email="+Email.getText().toString();

                com.android.volley.RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());

                JSONArray jsonAr = new JSONArray();

                JsonArrayRequest jsonArRequest = new JsonArrayRequest(Request.Method.GET, url, jsonAr, new Response.Listener<JSONArray>() {
                    @Override
                    public void onResponse(JSONArray response) {
                        Log.i("hi", response.toString());
                        if (!response.toString().contains("No Users")) {
                            JSONObject obj = new JSONObject();
                            try {
                                obj = response.getJSONObject(0);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
                            SharedPreferences.Editor editor = sp.edit();
                            try {
                                if(Password.getText().toString().equals(obj.getString("Password"))) {
                                    try {

                                        editor.putString("Fname", obj.getString("FName"));
                                        editor.putString("Email", Email.getText().toString());
                                        editor.putString("Lname", obj.getString("LName"));
                                        editor.putString("Phone", obj.getString("Phone"));
                                        editor.putString("Password", obj.getString("Password"));
                                        editor.putString("Address", obj.getString("Address"));
                                        editor.putBoolean("First", false);

                                        if (obj.getString("SellerNum").equals("null")) {
                                            editor.putBoolean("Seller", false);
                                        }
                                        else {
                                            editor.putBoolean("Seller", true);
                                            obj = response.getJSONObject(1);
                                            Log.i("Response: ", obj.toString());
                                            Log.i("I am a seller","");
                                            if (obj.getString("StoreName").isEmpty()) {
                                                editor.putBoolean("Store", false);
                                            }
                                            else {
                                                editor.putBoolean("Store", true);
                                            }
                                        }

                                        obj = response.getJSONObject(0);
                                        if (obj.getString("BuyerNum").equals("null")) {
                                            editor.putBoolean("Buyer", false);
                                        }
                                        else {
                                            editor.putBoolean("Buyer", true);
                                            obj = response.getJSONObject(2);
                                            editor.putString("CardNumber", obj.getString("Card"));
                                            editor.putString("SecurityCode", obj.getString("SecurityCode"));
                                            editor.putString("ExpiryDate", obj.getString("ExpiryDate"));
                                            editor.putString("CardType", obj.getString("cardType"));
                                        }

                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                    editor.commit();

                                    Intent i = new Intent(getApplicationContext(), MenuActivity.class);
                                    startActivity(i);
                                }
                                else {
                                    Toast.makeText(getApplicationContext(), "Incorrect password!", Toast.LENGTH_LONG).show();
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        } else {
                            Toast.makeText(getApplicationContext(), "Email not found!", Toast.LENGTH_LONG).show();
                        }
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.d("", "onERRORResponse register: " + error.toString());
                    }
                });
                requestQueue.add(jsonArRequest);
            }
        });
    }
}
