package malaksadek.databaseproject;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
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

public class MyCartActivity extends AppCompatActivity {

    ListView CartList;
    Button checkout;
    ArrayList<Item> cartlist;
    Item item;
    JSONObject obj;
    ArrayList<String> productNos;
    TextView total;
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mycart);
        CartList = findViewById(R.id.cartlist);
        checkout = findViewById(R.id.checkout);
        total = findViewById(R.id.total);
        total.setText("0");
        cartlist = new ArrayList<>();
        com.android.volley.RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());
        JSONArray jsonAr = new JSONArray();
        JsonArrayRequest jsonArRequest = new JsonArrayRequest(Request.Method.GET, "http://malaksadekapps.com/DBFillCart.php?email="+getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"), jsonAr, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                cartlist.clear();
                productNos = new ArrayList<>();
                item = new Item();
                obj = new JSONObject();
                try {
                    obj = response.getJSONObject(0);
                    total.setText(obj.getString("Total"));
                    if (obj.getString("Total").equals("null"))
                        total.setText("0");
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                for (int i = 1; i < response.length(); i++) {

                    item = new Item();
                    obj = new JSONObject();
                    try {
                        obj = response.getJSONObject(i);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    try {
                        item.Name = obj.getString("ProductName");
                        item.Quantity = obj.getString("ProductStock");
                        item.Price = obj.getString("ProductPrice");
                        productNos.add(i-1,  obj.getString("ProductNumber"));

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    cartlist.add(i-1, item);
                }

                CustomAdapter CA = new CustomAdapter(getApplicationContext(), cartlist, 4);
                CartList.setAdapter(CA);

            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

                cartlist.clear();
                Toast t = new Toast(getApplicationContext());
                t.makeText(getApplicationContext(), "No Products Added to Cart Yet!", Toast.LENGTH_LONG).show();

                Log.d("", "onERRORResponse register: " + error.toString());
            }
        });
        requestQueue.add(jsonArRequest);

        checkout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast t = new Toast(getApplicationContext());
                t.makeText(getApplicationContext(), "Are you sure you want to checkout? Press for 2 seconds if so!", Toast.LENGTH_LONG).show();
            }
        });

        checkout.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View view) {

                RequestParams params;
                params = new RequestParams();
                params.put("email", getApplicationContext().getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
                AsyncHttpClient client = new AsyncHttpClient();
                client.post("http://malaksadekapps.com/DBCheckout.php",
                        params, new AsyncHttpResponseHandler() {
                            @Override
                            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                Log.i("Status Code:", String.valueOf(statusCode));

                                if (statusCode == 200) {

                                    cartlist.clear();
                                    CustomAdapter CA = new CustomAdapter(getApplicationContext(), cartlist, 4);
                                    CartList.setAdapter(CA);
                                    total.setText("0");
                                }
                            }

                            @Override
                            public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                                // When Http response code is '404'
                            }
                        });
                return false;
            }
        });

        CartList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Toast.makeText(getApplicationContext(), "This will permanently delete this productitem! Press for 2 seconds if you're sure.", Toast.LENGTH_LONG).show();

            }
        });

        CartList.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, final int i, long l) {

                AsyncHttpClient client = new AsyncHttpClient();
                RequestParams params;
                params = new RequestParams();
                params.put("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
                params.put("product", productNos.get(i));
                client.post("http://malaksadekapps.com/DBRemoveFromCart.php",
                        params, new AsyncHttpResponseHandler() {
                            @Override
                            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                Log.i("Status Code:", String.valueOf(statusCode));

                                if (statusCode == 200) {
                                    cartlist.remove(i);
                                    com.android.volley.RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());
                                    JSONArray jsonAr = new JSONArray();
                                    JsonArrayRequest jsonArRequest = new JsonArrayRequest(Request.Method.GET, "http://malaksadekapps.com/DBFillCart.php?email="+getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"), jsonAr, new Response.Listener<JSONArray>() {
                                        @Override
                                        public void onResponse(JSONArray response) {

                                            cartlist.clear();
                                            productNos = new ArrayList<>();
                                            item = new Item();
                                            obj = new JSONObject();
                                            try {
                                                obj = response.getJSONObject(0);
                                                total.setText(obj.getString("Total"));
                                                if (obj.getString("Total").equals("null"))
                                                    total.setText("0");
                                            } catch (JSONException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                }, new Response.ErrorListener() {
                                    @Override
                                    public void onErrorResponse(VolleyError error) {

                                        cartlist.clear();
                                        Toast t = new Toast(getApplicationContext());
                                        t.makeText(getApplicationContext(), "No Products Added to Cart Yet!", Toast.LENGTH_LONG).show();

                                        Log.d("", "onERRORResponse register: " + error.toString());
                                    }
                                });

                                requestQueue.add(jsonArRequest);
                                    CustomAdapter CA = new CustomAdapter(getApplicationContext(), cartlist, 4);
                                    CartList.setAdapter(CA);
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

                return false;
            }
        });
    }
}
