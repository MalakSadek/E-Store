package malaksadek.databaseproject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import java.util.Arrays;
import java.util.Objects;

import cz.msebera.android.httpclient.Header;

/**
 * Created by malaksadek on 3/3/18.
 */

public class ProductDialogFragment extends Dialog implements android.view.View.OnClickListener{

    public Activity c;
    public Dialog d;
    public Button addproduct, addtocart, done;
    public EditText newname, newdesc, newstock, newprice;
    public TextView productname, productdesc, productprice, productstock, stocklabel;
    int mode, ae, index, minus;
    String productnumber, storenumber;
    MyStoreActivity context;
    MyOrdersActivity context2;
    StoreActivity context3;
    YourDialogFragmentDismissHandler handler;

    public ProductDialogFragment(Activity a, int mode, YourDialogFragmentDismissHandler handler, MyStoreActivity context, MyOrdersActivity context2, StoreActivity context3) {
        super(a);
        this.c = a;
        this.mode = mode;
        this.context = context;
        this.context2 = context2;
        this.context3 = context3;
        this.handler = handler;

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_product);
        addproduct = findViewById(R.id.addproduct);
        newname = findViewById(R.id.newname);
        newdesc = findViewById(R.id.newdescription);
        newprice = findViewById(R.id.newprice);
        newstock = findViewById(R.id.newstock);
        productname = findViewById(R.id.productname);
        productdesc = findViewById(R.id.description);
        productprice = findViewById(R.id.price);
        productstock = findViewById(R.id.stock);
        addtocart = findViewById(R.id.addtocart);
        stocklabel = findViewById(R.id.stocklabel);
        done = findViewById(R.id.done);
        minus = 0;

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if(mode == 0) {
            addproduct.setVisibility(View.INVISIBLE);
            newname.setVisibility(View.INVISIBLE);
            newstock.setVisibility(View.INVISIBLE);
            newdesc.setVisibility(View.INVISIBLE);
            newprice.setVisibility(View.INVISIBLE);
            newname.getText().clear();
            newstock.getText().clear();
            newdesc.getText().clear();
            newprice.getText().clear();

        } else {
            addtocart.setVisibility(View.INVISIBLE);
        }

        addproduct.setOnClickListener(this);
        addtocart.setOnClickListener(this);
        done.setOnClickListener(this);

    }

    @Override
    public void onClick(View view) {
        switch(view.getId()) {
            case R.id.addproduct:
                RequestParams params;

                params = new RequestParams();

                if (newname.getText().toString().isEmpty()||(newprice.getText().toString().isEmpty())||(newdesc.getText().toString().isEmpty())||(newstock.getText().toString().isEmpty())) {
                   Toast.makeText(getContext(), "Please enter all needed information.", Toast.LENGTH_LONG).show();
                } else {
                    params.put("Email", getContext().getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
                    params.put("Name", newname.getText().toString());
                    params.put("Price", newprice.getText().toString());
                    params.put("Description", newdesc.getText().toString());
                    params.put("Stock", newstock.getText().toString());

                    if(ae == 1) {
                        AsyncHttpClient client = new AsyncHttpClient();
                        client.post("http://malaksadekapps.com/DBAddProduct.php",
                                params, new AsyncHttpResponseHandler() {
                                    @Override
                                    public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                        Log.i("Status Code:", String.valueOf(statusCode));

                                        if (statusCode == 200) {
                                            Toast.makeText(getContext(), "Info Uploaded",
                                                    Toast.LENGTH_LONG).show();
                                            productdesc.setText(newdesc.getText().toString());
                                            productname.setText(newname.getText().toString());
                                            productprice.setText(newprice.getText().toString());
                                            productstock.setText(newstock.getText().toString());
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
                    else {

                        params.put("Index", index);

                        AsyncHttpClient client = new AsyncHttpClient();
                        client.post("http://malaksadekapps.com/DBEditProduct.php",
                                params, new AsyncHttpResponseHandler() {
                                    @Override
                                    public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                        Log.i("Status Code:", String.valueOf(statusCode));

                                        if (statusCode == 200) {
                                            Toast.makeText(getContext(), "Info Uploaded",
                                                    Toast.LENGTH_LONG).show();
                                            productdesc.setText(newdesc.getText().toString());
                                            productname.setText(newname.getText().toString());
                                            productprice.setText(newprice.getText().toString());
                                            productstock.setText(newstock.getText().toString());
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

                }
                break;
            case R.id.addtocart:
                if(Objects.equals(productstock.getText().toString(), "0")) {
                    Toast.makeText(getContext(), "Cannot add to cart, product is out of stock!", Toast.LENGTH_LONG).show();
                } else {
                    if(minus == 1)
                        productstock.setText(String.valueOf(Integer.valueOf(productstock.getText().toString())-1));
                    AsyncHttpClient client = new AsyncHttpClient();
                    RequestParams params2;
                    params2 = new RequestParams();
                    params2.put("email", getContext().getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
                    params2.put("product", productnumber);
                    params2.put("store", storenumber);
                    Log.i("IP", storenumber);
                    client.post("http://malaksadekapps.com/DBAddToCart.php",
                            params2, new AsyncHttpResponseHandler() {
                                @Override
                                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                                    Log.i("Status Code:", String.valueOf(statusCode));

                                    if (statusCode == 200) {
                                        Toast.makeText(getContext(), "Added to Cart",
                                                Toast.LENGTH_LONG).show();
                                        if(mode == 0) {
                                            handler.handleMessage(2, null, null, context3);
                                        }
                                        if (mode == 1) {
                                            handler.handleMessage(0, context, null, null);
                                        }
                                        dismiss();
                                    } else {
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
            case R.id.done:
                SharedPreferences sp = getContext().getSharedPreferences("DatabaseProjectPrefs", 0);
                SharedPreferences.Editor editor = sp.edit();
                editor.putBoolean("Refresh", true);
                editor.commit();
                if(mode == 0) {
                    handler.handleMessage(2, null, null, context3);
                }
                if (mode == 1) {
                    handler.handleMessage(0, context, null, null);
                }
                dismiss();
                break;
        }
    }
}
