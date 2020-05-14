package malaksadek.databaseproject;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.method.LinkMovementMethod;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
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

import java.util.ArrayList;

/**
 * Created by malaksadek on 3/1/18.
 */

public class SearchActivity extends AppCompatActivity {

    EditText input;
    CheckBox product, store, category;
    ListView results;
    ArrayList<Item> Results;
    Button search;
    Item item;
    JSONObject obj;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);

        input = findViewById(R.id.input);
        product = findViewById(R.id.product);
        store = findViewById(R.id.store);
        category = findViewById(R.id.category);
        results = findViewById(R.id.results);
        search = findViewById(R.id.search);

        search("http://malaksadekapps.com/DBFillStores.php");

        search.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(input.getText().toString().isEmpty()) {
                    Toast.makeText(getApplicationContext(), "Please enter something to search!", Toast.LENGTH_LONG).show();
                }
                else {
                    if((product.isChecked())&&(!category.isChecked())&&(!store.isChecked())) {

                        search("http://malaksadekapps.com/DBSearchProducts.php?Product="+input.getText().toString());
                    }
                    else
                    if((!product.isChecked())&&(category.isChecked())&&(!store.isChecked())) {

                        search("http://malaksadekapps.com/DBSearchCategories.php?Category="+input.getText().toString());
                    }
                    else
                    if((!product.isChecked())&&(!category.isChecked())&&(store.isChecked())) {

                        search("http://malaksadekapps.com/DBSearchStores.php?Store="+input.getText().toString());
                    }
                    else {
                        Toast.makeText(getApplicationContext(), "Please select only one search category!", Toast.LENGTH_LONG).show();
                    }


                }
            }
        });

        results.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Intent intent = new Intent(getApplicationContext(), StoreActivity.class);
                intent.putExtra("Store", Results.get(i).Name);
                startActivity(intent);
            }
        });
    }

    void search(String URL) {
        Results = new ArrayList<Item>();

        com.android.volley.RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());

        JSONArray jsonAr = new JSONArray();
        JsonArrayRequest jsonArRequest = new JsonArrayRequest(Request.Method.GET, URL, jsonAr, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {
                if(!response.toString().contains("None")) {
                    Results.clear();
                    int count = 0;
                    for (int i = 0; i < response.length(); i++) {

                        item = new Item();
                        obj = new JSONObject();
                        try {
                            obj = response.getJSONObject(i);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        try {
                            item.Name = obj.getString("storeName");
                            item.Price = obj.getString("storeCat");

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        if (!item.Name.equals("null")) {
                            Results.add(count, item);
                            count++;
                        }
                    }
                }
                else {
                    Toast.makeText(getApplicationContext(), "No matching results.", Toast.LENGTH_LONG).show();
                }
                CustomAdapter CA = new CustomAdapter(getApplicationContext(), Results, 3);
                results.setAdapter(CA);

            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

                Results.clear();
                CustomAdapter CA = new CustomAdapter(getApplicationContext(), Results, 3);
                results.setAdapter(CA);
                Toast t = new Toast(getApplicationContext());
                t.makeText(getApplicationContext(), "No matching results!", Toast.LENGTH_LONG).show();

                Log.d("", "onERRORResponse register: " + error.toString());
            }
        });
        requestQueue.add(jsonArRequest);
    }
}
