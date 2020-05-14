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

public class MyOrdersActivity extends AppCompatActivity {

    ListView OrderList;
    ArrayList<Item> orderlist;
    Item item;
    JSONObject obj;
    YourDialogFragmentDismissHandler h;
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_myorders);
        h = new YourDialogFragmentDismissHandler();
        OrderList = findViewById(R.id.orderlist);
        orderlist = new ArrayList<>();

        final OrderDialogFragment odf=new OrderDialogFragment(MyOrdersActivity.this, 0, h, null, MyOrdersActivity.this);

        fillOrder();

        OrderList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                odf.idtext.setText(orderlist.get(i).Name);
                odf.statustext.setText(orderlist.get(i).Price);
                odf.buyertext.setText("You!");
                odf.show();
            }
        });
    }

    public void doUpdate() {
        fillOrder();
    }

    void fillOrder() {
        com.android.volley.RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());

        JSONArray jsonAr = new JSONArray();
        JsonArrayRequest jsonArRequest = new JsonArrayRequest(Request.Method.GET, "http://malaksadekapps.com/DBFillOrder.php?email="+getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"), jsonAr, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

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
                        item.Name = obj.getString("Product") + " x " + obj.getString("Quantity");
                        item.Price = obj.getString("Status");
                        item.Quantity = obj.getString("OrderID");

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    orderlist.add(i, item);
                }
                CustomAdapter CA = new CustomAdapter(getApplicationContext(), orderlist, 0);
                OrderList.setAdapter(CA);

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
    }

}
