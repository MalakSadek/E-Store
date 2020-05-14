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
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by malaksadek on 3/1/18.
 */

public class StoreActivity extends AppCompatActivity {

    TextView storeName, categories;
    ListView productList;
    ArrayList<Item> productlist;
    ArrayList<String> productNos;
    Item item;
    JSONObject obj;
    YourDialogFragmentDismissHandler h;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_store);

        storeName = findViewById(R.id.storeName);
        categories = findViewById(R.id.category);
        productList = findViewById(R.id.productList);
        storeName.setText(getIntent().getStringExtra("Store"));
        h = new YourDialogFragmentDismissHandler();
        final ProductDialogFragment pdf=new ProductDialogFragment(StoreActivity.this, 0, h, null, null, StoreActivity.this);

        fillInformation();

        productList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                pdf.productname.setText(productlist.get(i).Name);
                pdf.productdesc.setText(productlist.get(i).Description);
                pdf.productprice.setText(productlist.get(i).Price);
                pdf.productstock.setText(productlist.get(i).Quantity);
                pdf.productnumber = productNos.get(i);
                pdf.storenumber = getIntent().getStringExtra("Store");
                pdf.show();

            }
        });
    }

    public void doUpdate() {
        fillInformation();
    }

    void fillInformation() {
        productlist = new ArrayList<Item>();
        com.android.volley.RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());

        productNos = new ArrayList<>();

        JSONArray jsonAr = new JSONArray();
        JsonArrayRequest jsonArRequest = new JsonArrayRequest(Request.Method.GET, "http://malaksadekapps.com/DBStoreFill.php?name="+getIntent().getStringExtra("Store"), jsonAr, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {
                if(!response.toString().contains("None")) {
                    productlist.clear();
                    item = new Item();
                    obj = new JSONObject();
                    try {
                        obj = response.getJSONObject(0);
                        categories.setText(obj.getString("Categories"));
                        obj = response.getJSONObject(1);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    for (int i = 2; i < response.length(); i++) {

                        item = new Item();
                        obj = new JSONObject();
                        try {
                            obj = response.getJSONObject(i);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        try {
                            item.Name = obj.getString("ProductName");
                            item.Price = obj.getString("ProductPrice");
                            item.Quantity = obj.getString("ProductStock");
                            if (Integer.valueOf(obj.getString("ProductStock")) < 0) {
                                item.Quantity = "0";
                            }
                            item.Description = obj.getString("ProductDescription");
                            productNos.add(i-2, obj.getString("ProductNumber"));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        productlist.add(i-2, item);
                    }
                }
                else {
                    Toast.makeText(getApplicationContext(), "No matching results.", Toast.LENGTH_LONG).show();
                }
                CustomAdapter CA = new CustomAdapter(getApplicationContext(), productlist, 2);
                productList.setAdapter(CA);

            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

                productlist.clear();
                CustomAdapter CA = new CustomAdapter(getApplicationContext(), productlist, 2);
                productList.setAdapter(CA);
                Toast t = new Toast(getApplicationContext());
                t.makeText(getApplicationContext(), "No matching results!", Toast.LENGTH_LONG).show();

                Log.d("", "onERRORResponse register: " + error.toString());
            }
        });
        requestQueue.add(jsonArRequest);
        CustomAdapter CA = new CustomAdapter(getApplicationContext(), productlist,2);
        productList.setAdapter(CA);
    }
}
