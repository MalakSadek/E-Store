package malaksadek.databaseproject;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ToggleButton;

/**
 * Created by malaksadek on 3/1/18.
 */

public class FirstActivity extends AppCompatActivity {

    ToggleButton t;
    Button b, s;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_first);
        SharedPreferences sp = getSharedPreferences("DatabaseProjectPrefs", 0);
        Boolean first = sp.getBoolean("First", true);
        b = findViewById(R.id.button);
        t = findViewById(R.id.toggleButton);
        s = findViewById(R.id.signin);

        t.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (t.isChecked()) {
                    t.setBackgroundColor(getResources().getColor(R.color.colorPrimary));
                } else {
                    t.setBackgroundColor(getResources().getColor(R.color.colorAccent));
                }
            }
        });

        if (first) {

            String source = sp.getString("source", "");
            b.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (t.isChecked()) {
                        //seller
                        Intent i = new Intent(getApplicationContext(), SignUpSellerActivity.class);
                        startActivity(i);
                    } else {
                        //buyer
                        Intent i = new Intent(getApplicationContext(), SignUpBuyerActivity.class);
                        startActivity(i);
                    }
                }
            });

            s.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent i = new Intent(getApplicationContext(), LoginActivity.class);
                    startActivity(i);
                }
            });

        } else {
            Intent i = new Intent(getApplicationContext(), MenuActivity.class);
            startActivity(i);
        }
    }
}
