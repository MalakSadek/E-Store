package malaksadek.databaseproject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.view.Window;
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
 * Created by malaksadek on 3/3/18.
 */

public class OrderDialogFragment extends Dialog implements android.view.View.OnClickListener{

    public Activity c;
    public Dialog d;
    public Button donebutton, editorderstatus;
    public EditText statusupdate;
    public TextView idtext, buyertext, statustext, idtitle;
    public ListView products;
    public ArrayList<Item> Products;
    public Item item;
    public JSONObject obj;
    MyStoreActivity context;
    MyOrdersActivity context2;
    ProductDialogFragment pdf;
    int mode;
    YourDialogFragmentDismissHandler handler;

    public OrderDialogFragment(Activity a, int mode, YourDialogFragmentDismissHandler handler, MyStoreActivity context, MyOrdersActivity context2) {
        super(a);
        this.c = a;
        this.handler = handler;
        this.context = context;
        this.context2 = context2;
        this.mode = mode;

        requestWindowFeature(Window.FEATURE_ACTIVITY_TRANSITIONS);
        setContentView(R.layout.dialog_order);
        donebutton = findViewById(R.id.done);
        editorderstatus = findViewById(R.id.status);
        statusupdate = findViewById(R.id.statusinput);
        idtext = findViewById(R.id.orderid);
        buyertext = findViewById(R.id.buyer);
        statustext = findViewById(R.id.statustext);
        products = findViewById(R.id.products);
        idtitle = findViewById(R.id.idtitle);
        if(mode == 0) {
            editorderstatus.setVisibility(View.INVISIBLE);
            statusupdate.setVisibility(View.INVISIBLE);
            pdf = new ProductDialogFragment(c, 0, handler, context, context2, null);
            pdf.stocklabel.setText("Stock:");
        }
        if (mode == 1) {
            pdf = new ProductDialogFragment(c, 0, handler, context, context2, null);
            pdf.stocklabel.setText("Amount Ordered:");
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        donebutton.setOnClickListener(this);
        editorderstatus.setOnClickListener(this);
        statusupdate.getText().clear();
        Products = new ArrayList<>();

        products.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                pdf.productname.setText(Products.get(i).Name);
                pdf.productprice.setText(Products.get(i).Price);
                pdf.productstock.setText(Products.get(i).Quantity);
                pdf.productdesc.setText(Products.get(i).Description);
                pdf.show();
            }
        });
        com.android.volley.RequestQueue requestQueue = Volley.newRequestQueue(getContext());

        JSONArray jsonAr = new JSONArray();
        JsonArrayRequest jsonArRequest = new JsonArrayRequest(Request.Method.GET, "http://malaksadekapps.com/DBOrderProducts.php?email="+getContext().getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"), jsonAr, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                    Products.clear();
                    int j = 0;
                    for (int i = 0; i < response.length(); i++) {
                        try {
                                item = new Item();
                                obj = new JSONObject();
                                try {
                                    obj = response.getJSONObject(i);
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            if (obj.getString("OrderNo").equals(idtext.getText().toString())) {
                                try {
                                    item.Name = obj.getString("ProductName");
                                    item.Price = obj.getString("Price");
                                    item.Quantity = obj.getString("QuantityOrdered");
                                    pdf.ae = 1;
                                    pdf.minus = 1;
                                    item.Description = obj.getString("Description");


                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }

                                Products.add(j, item);
                                j++;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                        CustomAdapter CA = new CustomAdapter(getContext(), Products, 2);
                        products.setAdapter(CA);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

                Products.clear();
                Toast t = new Toast(getContext());
                t.makeText(getContext(), "No Orders Yet!", Toast.LENGTH_LONG).show();

                Log.d("", "onERRORResponse register: " + error.toString());
            }
        });
        requestQueue.add(jsonArRequest);

    }

    @Override
    public void onClick(View view) {
        switch(view.getId()) {
            case R.id.done:
                SharedPreferences sp = getContext().getSharedPreferences("DatabaseProjectPrefs", 0);
                SharedPreferences.Editor editor = sp.edit();
                editor.putBoolean("Refresh", true);
                editor.commit();
                if(mode == 0) {
                    handler.handleMessage(1, null, context2, null);
                }
                if (mode == 1) {
                    handler.handleMessage(0, context, null, null);
                }

                dismiss();
                break;
            case R.id.status:

                RequestParams params;

                params = new RequestParams();
                    Log.i("email", getContext().getSharedPreferences("DatabaseProjectPrefs", 0).getString("BuyerEmail", "None"));
                    params.put("Email", getContext().getSharedPreferences("DatabaseProjectPrefs", 0).getString("BuyerEmail", "None"));
                    if(statusupdate.getText().toString().isEmpty()) {
                        Toast.makeText(getContext(), "Please enter a status.", Toast.LENGTH_LONG).show();
                    } else {
                        params.put("Status", statusupdate.getText().toString());
                        AsyncHttpClient client = new AsyncHttpClient();
                        client.post("http://malaksadekapps.com/DBEditOrder.php",
                                params, new AsyncHttpResponseHandler() {
                                    @Override
                                    public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                        Log.i("Status Code:", String.valueOf(statusCode));

                                        if (statusCode == 200) {
                                            Toast.makeText(getContext(), "Info Uploaded",
                                                    Toast.LENGTH_LONG).show();


                                        }
                                        else {
                                            Toast.makeText(getContext(),
                                                    Arrays.toString(responseBody),
                                                    Toast.LENGTH_LONG).show();
                                        }
                                    }

                                    @Override
                                    public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                                        // When Http response code is '404'
                                        if (statusCode == 404) {
                                            Toast.makeText(getContext(),
                                                    "Requested resource not found",
                                                    Toast.LENGTH_LONG).show();
                                        }
                                        // When Http response code is '500'
                                        else if (statusCode == 500) {
                                            Toast.makeText(getContext(),
                                                    "Something went wrong at server end",
                                                    Toast.LENGTH_LONG).show();
                                        }
                                        // When Http response code other than 404, 500
                                        else {
                                            Toast.makeText(
                                                    getContext(),
                                                    "Error Occurred \n Most Common Error: \n1. Device not connected to Internet\n2. Web App is not deployed in App server\n3. App server is not running\n HTTP Status code : "
                                                            + statusCode, Toast.LENGTH_LONG)
                                                    .show();
                                        }
                                    }
                                });
                    }

                break;
        }
    }
}
