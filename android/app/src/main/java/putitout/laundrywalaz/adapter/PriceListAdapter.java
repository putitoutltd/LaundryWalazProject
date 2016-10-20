package putitout.laundrywalaz.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import java.util.ArrayList;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.model.PriceModel;
import putitout.laundrywalaz.widgets.TypefaceTextView;

/**
 * Created by Ehsan Aslam on 7/29/2016.
 */
public class PriceListAdapter extends BaseAdapter {

    private Context context;
    private ArrayList<PriceModel> priceList = new ArrayList<PriceModel>();

    public PriceListAdapter (Context context , ArrayList<PriceModel> priceList){

        this.context = context;
        this.priceList = priceList;
    }

    @Override
    public int getCount() {
        return priceList.size();
    }

    @Override
    public Object getItem(int position) {
        return position;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        View row = convertView;
        final ViewHolder viewHolder;

        if(row==null){
            LayoutInflater layoutInflater = (LayoutInflater) parent.getContext().
                    getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            row = layoutInflater.inflate(R.layout.list_view_price_list_layout, parent, false);
            viewHolder = new ViewHolder();

            viewHolder.dryCleanTextView = (TypefaceTextView) row.findViewById(R.id.dryCleanTextView);
            viewHolder.itemTextView = (TypefaceTextView) row.findViewById(R.id.itemTextView);
            viewHolder.laundryTextView = (TypefaceTextView) row.findViewById(R.id.laundryTextView);
            viewHolder.headerRelativeLayout = (RelativeLayout) row.findViewById(R.id.headerRelativeLayout);
            viewHolder.headerSectionTextView = (TypefaceTextView) row.findViewById(R.id.headerSectionTextView);
            viewHolder.staticMensWearing = (ImageView) row.findViewById(R.id.staticMensWearing);
            viewHolder.titleLinearLayout = (LinearLayout) row.findViewById(R.id.titleLinearLayout);
            viewHolder.view = row.findViewById(R.id.view);

            row.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) row.getTag();
        }


//        if(position==0){
//            viewHolder.staticMensWearing.setImageResource(R.drawable.menz_wears);
//            viewHolder.headerSectionTextView.setText("MEN'S WEAR CLOTHING");
//            viewHolder.headerRelativeLayout.setVisibility(View.VISIBLE);
//            viewHolder.titleLinearLayout.setVisibility(View.VISIBLE);
//            viewHolder.view.setVisibility(View.VISIBLE);
//        }
//
//        else if(position==22){
//            viewHolder.headerRelativeLayout.setVisibility(View.VISIBLE);
//            viewHolder.staticMensWearing.setImageResource(R.drawable.womenz_wears);
//            viewHolder.headerSectionTextView.setText("WOMEN WEAR CLOTHING");
//            viewHolder.titleLinearLayout.setVisibility(View.VISIBLE);
//        }
//        else if(position==51){
//            viewHolder.headerRelativeLayout.setVisibility(View.VISIBLE);
//            viewHolder.staticMensWearing.setImageResource(R.drawable.bed_linen);
//            viewHolder.headerSectionTextView.setText("BED LINEN");
////            viewHolder.titleLinearLayout.setVisibility(View.VISIBLE);
//        }
//        else{
//            viewHolder.headerRelativeLayout.setVisibility(View.GONE);
//            viewHolder.titleLinearLayout.setVisibility(View.GONE);
//            viewHolder.view.setVisibility(View.GONE);
//        }

        viewHolder.itemTextView.setText(priceList.get(position).getName());
        viewHolder.dryCleanTextView.setText(priceList.get(position).getPrice_dryclean());
        viewHolder.laundryTextView.setText(priceList.get(position).getPrice_laundry());
        return row;
    }


    private class ViewHolder {
        LinearLayout titleLinearLayout;
        RelativeLayout headerRelativeLayout;
        ImageView staticMensWearing ;
        TypefaceTextView headerSectionTextView;

        View view;
        TypefaceTextView itemTextView;
        TypefaceTextView dryCleanTextView;
        TypefaceTextView laundryTextView;

    }


}
