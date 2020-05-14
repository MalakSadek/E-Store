package malaksadek.databaseproject;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import java.util.Arrays;
import java.util.Objects;

import cz.msebera.android.httpclient.Header;

/**
 * Created by malaksadek on 3/1/18.
 */

public class SetupStoreActivity extends AppCompatActivity {
    RadioButton fashion, home, food, accesssories, electronics, sports, stationary;
    Button done;
    EditText storename;
    String categories;
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setupstore);
        fashion = findViewById(R.id.fashion);
        home = findViewById(R.id.home);
        food = findViewById(R.id.food);
        accesssories = findViewById(R.id.accessories);
        electronics = findViewById(R.id.electronics);
        sports = findViewById(R.id.sport);
        stationary = findViewById(R.id.stationary);
        storename = findViewById(R.id.storename);
        done = findViewById(R.id.done);

        done.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                categories = "";
                if(fashion.isChecked())
                    categories+="Fashion, ";
                if(home.isChecked())
                    categories+="Home & Furniture, ";
                if(food.isChecked())
                    categories+="Food & Beverages, ";
                if(accesssories.isChecked())
                    categories+="Accessories, ";
                if(electronics.isChecked())
                    categories+="Electronics, ";
                if(sports.isChecked())
                    categories+="Sports, ";
                if(stationary.isChecked())
                    categories+="Stationary, ";

                if((!fashion.isChecked())&&(!home.isChecked())&&(!food.isChecked())&&(!accesssories.isChecked())&&(!electronics.isChecked())&&(!sports.isChecked())&&(!stationary.isChecked()))
                    Toast.makeText(getApplicationContext(), "Please choose at least one category!", Toast.LENGTH_LONG).show();
                else if (storename.getText().toString().isEmpty()){
                    Toast.makeText(getApplicationContext(), "Please enter a name, even if it is the same one!", Toast.LENGTH_LONG).show();
                } else
                    categories=categories.substring(0, categories.length()-2);

                RequestParams params;

                params = new RequestParams();
                params.put("email", getSharedPreferences("DatabaseProjectPrefs", 0).getString("Email", "None"));
                params.put("categories", categories);
                params.put("storename", storename.getText().toString());
                String url;
                if (getIntent().getBooleanExtra("EditStore", false)) {
                    url = "http://malaksadekapps.com/DBEditStore.php";
                }
                else {
                    url = "http://malaksadekapps.com/DBSetupStore.php";
                }
                    AsyncHttpClient client = new AsyncHttpClient();
                    client.post(url,
                            params, new AsyncHttpResponseHandler() {
                                @Override
                                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {


                                    if (statusCode == 200) {

                                        Toast.makeText(getApplicationContext(), "Info Uploaded",
                                                Toast.LENGTH_LONG).show();

                                        //TODO: Script to add buyer
                                        SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
                                        SharedPreferences.Editor editor = sp.edit();
                                        editor.putBoolean("Store", true);
                                        editor.commit();

                                        Intent i = new Intent(getApplicationContext(), MyStoreActivity.class);
                                        i.putExtra("name", storename.getText().toString());
                                        i.putExtra("categories", categories);
                                        startActivity(i);
                                    } else {
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
        });
    }

}
