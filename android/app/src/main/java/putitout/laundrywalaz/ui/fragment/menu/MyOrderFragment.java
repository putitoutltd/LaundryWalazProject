package putitout.laundrywalaz.ui.fragment.menu;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Date;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.interfaces.OnWebServiceResponse;
import putitout.laundrywalaz.model.Parser;
import putitout.laundrywalaz.network.NetworkMananger;
import putitout.laundrywalaz.network.NetworkUtil;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceTextView;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
public class MyOrderFragment extends BaseFragment implements OnWebServiceResponse {

    public static final String TAG = MyOrderFragment.class.getSimpleName();
    private static final int ORDER_STATUS = 1;
    public static final SimpleDateFormat PARSE_SIMPLE_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd KK:mm");
    private ImageView orderStatusImageView;
    private TypefaceTextView orderTimeTextView,orderDateTextView,orderStatusTextView,cancelOrderStatusTextView;
    private ProgressDialog progressDialog;
    private SimpleDateFormat formatSimpleDateFormat,formatSimpleDateDropOffFormat;
    private HomeActivity homeActivity;

    @Override
    public View onCreateView(LayoutInflater inflater,ViewGroup container,Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_my_order,container,false);
        getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        initWidget(view);
        return view;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        homeActivity.hideTitle();
    }


    public void initWidget(View view){
        homeActivity = (HomeActivity) getActivity();
        homeActivity.showTitle();
        homeActivity.setTitle(getString(R.string.orderStatus));
        LWUtil.access_Token = LWPrefs.getString(getActivity(),LWPrefs.KEY_TOKEN,"");
        orderStatusImageView = (ImageView) view.findViewById(R.id.orderStatusImageView);
        orderTimeTextView = (TypefaceTextView) view.findViewById(R.id.orderTimeTextView);
        orderDateTextView = (TypefaceTextView) view.findViewById(R.id.orderDateTextView);
        orderStatusTextView = (TypefaceTextView) view.findViewById(R.id.orderStatusTextView);
        cancelOrderStatusTextView = (TypefaceTextView) view.findViewById(R.id.cancelOrderStatusTextView);
        formatSimpleDateFormat = new SimpleDateFormat("hh:mm aa");
        formatSimpleDateDropOffFormat = new SimpleDateFormat("EEEE MMMM, dd");
        orderStatus();
    }

    private void orderStatus() {
        if (NetworkUtil.checkIfNetworkAvailable(getActivity())) {
            NetworkMananger.orderStatusApi(getActivity(),LWUtil.access_Token, this, ORDER_STATUS);
        } else {
            LWUtil.showNetworkErrorAlertDialog(getActivity());
        }
    }

    @Override
    public void onStartWebService(int requestCode) {
        progressDialog = getProgressDialog();
        if (!progressDialog.isShowing()) {
            progressDialog.show();
        }
    }

    @Override
    public void onCompletedWebService(String response, int requestCode, boolean isValidResponse) {
        if (progressDialog.isShowing()) {
            progressDialog.dismiss();
        }
        if (isValidResponse) {
            Parser parser = new Parser(response);
            switch (requestCode) {
                case ORDER_STATUS:
                    parseOrderStatus(parser);
                    LWLog.info(response);
                    break;
            }
        }
    }

    private void parseOrderStatus(Parser parser) {
        if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_FAILURE)) {
            if (parser.getMessage().equals(getString(R.string.invalidAccessToken))) {
                LWUtil.showInvalidAccessTokenAlert(getActivity());
            } else {
                LWUtil.showAlert(getActivity(), parser.getMessage());
                orderDateTextView.setVisibility(View.INVISIBLE);
            }
        } else if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_SUCCESS)) {

            String orderStatus =  parser.getOrderStatus();
            String pickUpTime = parser.getPickup_time();
            String dropOffTime = parser.getDropoff_time();

            orderTimeTextView.setText(getFormattedDropOffDate(dropOffTime)+" "+"09:00 pm");
            orderTimeTextView.setLineSpacing(0,1.5f);
            if(orderStatus.equalsIgnoreCase("0")){
                orderStatusImageView.setImageResource(R.drawable.status_01);
                orderStatusTextView.setText("Pick-Up at");
                orderTimeTextView.setText(getFormattedDate(pickUpTime));
                orderDateTextView.setText(getFormattedDropOffDate(pickUpTime));
                cancelOrderStatusTextView.setVisibility(View.GONE);
            } else if (orderStatus.equalsIgnoreCase("1")){
                orderStatusImageView.setImageResource(R.drawable.status_02);
                orderStatusTextView.setText("Delivery at");
                orderTimeTextView.setText("09:00 PM");
                orderDateTextView.setText(getFormattedDropOffDate(dropOffTime));
                cancelOrderStatusTextView.setVisibility(View.GONE);
            } else if (orderStatus.equalsIgnoreCase("2")){
                orderStatusImageView.setImageResource(R.drawable.status_03);
                orderStatusTextView.setText("Delivery at");
                orderTimeTextView.setText("09:00 PM");
                orderDateTextView.setText(getFormattedDropOffDate(dropOffTime));
                cancelOrderStatusTextView.setVisibility(View.GONE);
            } else if (orderStatus.equalsIgnoreCase("3")){
                orderStatusImageView.setImageResource(R.drawable.status_044);
                orderStatusTextView.setText("Delivery at");
                orderTimeTextView.setText("09:00 PM");
                orderDateTextView.setText(getFormattedDropOffDate(dropOffTime));
                cancelOrderStatusTextView.setVisibility(View.GONE);
            } else if (orderStatus.equalsIgnoreCase("4")){
                orderStatusImageView.setImageResource(R.drawable.delivered_status);
                orderStatusTextView.setText("Delivery at");
                orderTimeTextView.setText("09:00 PM");
                orderDateTextView.setText(getFormattedDropOffDate(dropOffTime));
                cancelOrderStatusTextView.setVisibility(View.GONE);
            } else if(orderStatus.equalsIgnoreCase("5")){
                orderDateTextView.setVisibility(View.GONE);
                orderTimeTextView.setVisibility(View.GONE);
                orderStatusTextView.setVisibility(View.GONE);
                cancelOrderStatusTextView.setVisibility(View.VISIBLE);
                cancelOrderStatusTextView.setText(R.string.cancelOrderStatus);
                Toast.makeText(getActivity(),"Your order has been cancelled.", Toast.LENGTH_SHORT).show();
            }
            LWPrefs.saveString(getActivity(), LWPrefs.KEY_ORDER_STATUS, orderStatus);
        }
    }

    private String getFormattedDate(String time) {
        String formattedDate = "";
        try {
            Date date = PARSE_SIMPLE_DATE_FORMAT.parse(time);
            formattedDate = formatSimpleDateFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formattedDate;
    }
    private String getFormattedDropOffDate(String time) {
        String formattedDate = "";
        try {
            Date date = PARSE_SIMPLE_DATE_FORMAT.parse(time);
            formattedDate = formatSimpleDateDropOffFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formattedDate;
    }
}
