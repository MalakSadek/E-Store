package malaksadek.databaseproject;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;


/**
 * Created by malaksadek on 6/14/17.
 */

public class CustomAdapter extends ArrayAdapter<Item> {

    TextView Name, Price, Quantity, Description, label1, label2, label3, label4;
    Item c;
    int src;

    public CustomAdapter(Context context, ArrayList<Item> c, int source) {
        super(context, 0, c);
        src = source;
    }

    void Setup(View convertView){
        Name = convertView.findViewById(R.id.Name);
        Price = convertView.findViewById(R.id.Price);
        Quantity = convertView.findViewById(R.id.Quantity);
        Description = convertView.findViewById(R.id.Description);
        label1 = convertView.findViewById(R.id.label1);
        label2 = convertView.findViewById(R.id.label2);
        label3 = convertView.findViewById(R.id.label3);
        label4 = convertView.findViewById(R.id.label4);

        switch (src) {
            case 0:
                label1.setText("Product & Quantity:   ");
                label2.setText("Order Status:   ");
                label3.setText("Total Price:   ");
                label4.setText("");
                break;
            case 1:
                label1.setText("Total Price:   ");
                label2.setText("Order Status:   ");
                label3.setText("Buyer Email:   ");
                label4.setText("");
                break;
            case 2:
                label1.setText("Name:   ");
                label2.setText("Price:   ");
                label3.setText("Stock:   ");
                label4.setText("Description:   ");
                break;
            case 3:
                label1.setText("Store Name:   ");
                label2.setText("Store Categories:   ");
                label3.setText("");
                label4.setText("");
                break;
            case 4:
                label1.setText("Name:   ");
                label2.setText("Item Price:   ");
                label3.setText("Quantity Ordered:   ");
                label4.setText("");
                break;
        }
    }

    void fillItem (int position) {
        c = getItem(position);
        Name.setText(c.Name);
        Price.setText(c.Price);
        Quantity.setText(c.Quantity);
        Description.setText(c.Description);


    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.productitem, parent, false);
        }

        Setup(convertView);
        fillItem(position);

        return convertView;
    }
}
