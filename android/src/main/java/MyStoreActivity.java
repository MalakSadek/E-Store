package malaksadek.databaseproject;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
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

public class MyStoreActivity extends AppCompatActivity {
    TextView title, categories;
    ListView productList, orderList;
    Button addProduct, editStore;
    ArrayList<Item> productlist, orderlist;
    ArrayList<String> productnos;
    Item item;
    JSONObject obj;
    YourDialogFragmentDismissHandler h;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mystore);
        h = new YourDialogFragmentDismissHandler();
        title = findViewById(R.id.storename);
        categories = findViewById(R.id.categories);
        productList = findViewById(R.id.products);
        orderList = findViewById(R.id.orders);
        addProduct = findViewById(R.id.addproduct);
        editStore = findViewById(R.id.edit);
        productnos = new ArrayList<>();


        editStore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(getApplicationContext(), SetupStoreActivity.class);
                i.putExtra("EditStore", true);
                startActivity(i);
            }
        });

        final ProductDialogFragment pdf=new ProductDialogFragment(MyStoreActivity.this, 1, h, MyStoreActivity.this, null, null);
        final OrderDialogFragment odf=new OrderDialogFragment(MyStoreActivity.this, 1, h, MyStoreActivity.this, null);

        fillInformation();

        orderList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                odf.idtext.setText(orderlist.get(i).Name);
                odf.idtitle.setText("Total Price:");
                odf.statustext.setText(orderlist.get(i).Price);
                odf.buyertext.setText(orderlist.get(i).Quantity);
                odf.show();

            }
        });

        productList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                pdf.index = i;
                pdf.ae = 0;
                pdf.productname.setText(productlist.get(i).Name);
                pdf.productprice.setText(productlist.get(i).Price);
                pdf.productdesc.setText(productlist.get(i).Description);
                pdf.productstock.setText(productlist.get(i).Quantity);
                pdf.show();

            }
        });

        productList.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, final int i, long l) {

                AsyncHttpClient client = new AsyncHttpClient();
                RequestParams params;
                params = new RequestParams();
                params.put("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
                params.put("product", productnos.get(i));
                client.post("http://malaksadekapps.com/DBRemoveProduct.php",
                        params, new AsyncHttpResponseHandler() {
                            @Override
                            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                Log.i("Status Code:", String.valueOf(statusCode));

                                if (statusCode == 200) {
                                    productlist.remove(i);
                                    CustomAdapter CA = new CustomAdapter(getApplicationContext(), productlist, 2);
                                    productList.setAdapter(CA);
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

        addProduct.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                pdf.productdesc.setText("-");
                pdf.productstock.setText("-");
                pdf.productprice.setText("-");
                pdf.productname.setText("-");
                pdf.ae = 1;
                pdf.show();
            }
        });

    }

    public void doUpdate() {
        fillInformation();
    }

    void fillInformation() {
        com.android.volley.RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());

        JSONArray jsonAr2 = new JSONArray();
        JsonArrayRequest jsonArRequest2 = new JsonArrayRequest(Request.Method.GET, "http://malaksadekapps.com/DBStoreInfo.php?email="+getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"), jsonAr2, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {
                obj = new JSONObject();
                try {
                    obj = response.getJSONObject(0);
                    Log.i("", String.valueOf(response));
                    title.setText(obj.getString("storeName"));
                    categories.setText(obj.getString("Categories"));

                } catch (JSONException e) {
                    e.printStackTrace();
                }


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

                orderlist.clear();
                Toast t = new Toast(getApplicationContext());
                t.makeText(getApplicationContext(), "No Orders Yet!", Toast.LENGTH_LONG).show();

                Log.d("", "onERRORResponse register: " + error.toString());
            }
        });

        requestQueue.add(jsonArRequest2);

        orderlist = new ArrayList<>();

        JSONArray jsonAr = new JSONArray();
        Log.i("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
        JsonArrayRequest jsonArRequest = new JsonArrayRequest(Request.Method.GET, "http://malaksadekapps.com/DBOrderInfo.php?email="+getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"), jsonAr, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                if (!response.toString().contains("None")) {
                    orderlist.clear();
                    for (int i = 0; i < response.length(); i++) {

                        item = new Item();
                        obj = new JSONObject();
                        try {
                            obj = response.getJSONObject(i);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        try {
                            SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
                            SharedPreferences.Editor editor = sp.edit();
                            editor.putString("BuyerEmail", obj.getString("Buyer"));
                            editor.commit();
                            item.Name = obj.getString("OrderID");
                            item.Price = obj.getString("Status");
                            item.Quantity = obj.getString("Buyer");

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        orderlist.add(i, item);
                    }
                    CustomAdapter CA = new CustomAdapter(getApplicationContext(), orderlist, 1);
                    orderList.setAdapter(CA);
                }
                else {

                    orderlist.clear();
                    CustomAdapter CA = new CustomAdapter(getApplicationContext(), orderlist, 1);
                    orderList.setAdapter(CA);

                    Log.i("here", "here");
                    Toast t = new Toast(getApplicationContext());
                    t.makeText(getApplicationContext(), "No Orders Yet!", Toast.LENGTH_LONG).show();
                }

            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

                orderlist.clear();
                Toast t = new Toast(getApplicationContext());
                t.makeText(getApplicationContext(), "No Orders Yet!", Toast.LENGTH_LONG).show();

                Log.d("", "onERRORResponse register: " + error.toString());
            }
        });
        requestQueue.add(jsonArRequest);


        productlist = new ArrayList<>();

        JSONArray jsonAr3 = new JSONArray();
        Log.i("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
        JsonArrayRequest jsonAr3Request = new JsonArrayRequest(Request.Method.GET, "http://malaksadekapps.com/DBProductInfo.php?email="+getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"), jsonAr3, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                if (!response.toString().contains("None")) {
                    productlist.clear();
                    for (int i = 0; i < response.length(); i++) {

                        item = new Item();
                        obj = new JSONObject();
                        try {
                            obj = response.getJSONObject(i);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        try {
                            item.Name = obj.getString("ProductName");
                            productnos.add(i,  obj.getString("ProductNumber"));
                            item.Price = obj.getString("ProductPrice");
                            if(obj.getString("ProductStock") == "0") {
                                item.Quantity = "Out of Stock";
                            }
                            else {
                                item.Quantity = obj.getString("ProductStock");
                            }
                            item.Description = obj.getString("ProductDescription");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        productlist.add(i, item);
                    }
                    CustomAdapter CA = new CustomAdapter(getApplicationContext(), productlist, 2);
                    productList.setAdapter(CA);
                }
                else {

                    productlist.clear();
                    CustomAdapter CA = new CustomAdapter(getApplicationContext(), productlist, 2);
                    productList.setAdapter(CA);

                    Log.i("here", "here");
                    Toast t = new Toast(getApplicationContext());
                    t.makeText(getApplicationContext(), "No Products Yet!", Toast.LENGTH_LONG).show();
                }

            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

                productlist.clear();
                Toast t = new Toast(getApplicationContext());
                t.makeText(getApplicationContext(), "No Products Yet!", Toast.LENGTH_LONG).show();

                Log.d("", "onERRORResponse register: " + error.toString());
            }
        });
        requestQueue.add(jsonAr3Request);
    }

}

class YourDialogFragmentDismissHandler extends Handler {

        public void handleMessage(int msg, MyStoreActivity c, MyOrdersActivity c2, StoreActivity c3) {
            switch(msg) {
                case 0:
                    c.doUpdate();
                    break;
                case 1:
                    c2.doUpdate();
                    break;
                case 2:
                    c3.doUpdate();
            }
        // refresh your textview's here
    }
}

//TODO: Make UI nicer
//TODO: Clean up code and modulate
//TODO: Screenshot backend, take videos and screenshots of application