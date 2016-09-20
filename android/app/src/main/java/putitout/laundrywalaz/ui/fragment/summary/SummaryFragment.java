package putitout.laundrywalaz.ui.fragment.summary;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;

import java.text.SimpleDateFormat;
import java.util.Date;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;
import putitout.laundrywalaz.ui.fragment.menu.MyOrderFragment;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceTextView;

/**
 * Created by Ehsan Aslam on 7/26/2016.
 */
public class SummaryFragment extends BaseFragment implements View.OnClickListener {

    public static final String TAG = SummaryFragment.class.getSimpleName();

    private Button cancelOrderButton;
    private Button orderStatusButton;

    private TypefaceTextView summaryAddressTextView;
    private TypefaceTextView summaryPickUpDateTextView;
    private TypefaceTextView summaryDeliveryDateTextView;
    private TypefaceTextView orderIdTextView;

    String order_id;
    String address;
    String pickUpTime;
    String dropOffTime;
    String pick_up_Time;

    private SimpleDateFormat formatSimpleDateFormat,formatDate;

    private AlertDialog cancelOrderDialog;

    private HomeActivity homeActivity;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_summary,container,false);
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


    public void initWidget(View view) {

        homeActivity = (HomeActivity) getActivity();
        homeActivity.showTitle();
        homeActivity.setTitle(getString(R.string.summaryText));

        formatSimpleDateFormat = new SimpleDateFormat("EEEE, dd MMMM");
        formatDate = new SimpleDateFormat("EEEE, dd MMMM HH:mm aaa");

        cancelOrderButton = (Button) view.findViewById(R.id.cancelOrderButton);
        cancelOrderButton.setOnClickListener(this);
        orderStatusButton = (Button) view.findViewById(R.id.orderStatusButton);
        orderStatusButton.setOnClickListener(this);


        summaryPickUpDateTextView = (TypefaceTextView) view.findViewById(R.id.summaryPickUpDateTextView);
        summaryDeliveryDateTextView = (TypefaceTextView) view.findViewById(R.id.summaryDeliveryDateTextView);
        summaryAddressTextView = (TypefaceTextView) view.findViewById(R.id.summaryAddressTextView);
        orderIdTextView = (TypefaceTextView) view.findViewById(R.id.orderIdTextView);


        order_id = LWPrefs.getString(getActivity(),LWPrefs.KEY_ORDER_ID,"");
        pickUpTime = LWPrefs.getString(getActivity(),LWPrefs.KEY_PICK_UP_TIME,"");
        address = LWPrefs.getString(getActivity(),LWPrefs.KEY_ADDRESS,"");
        dropOffTime = LWPrefs.getString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME,"");

        pick_up_Time = LWPrefs.getString(getActivity(),LWPrefs.KEY_PICKUP_TIME,"");

        orderIdTextView.setText(order_id);
        LWLog.info(TAG + " " + "pickUpTime: " + pickUpTime);
        summaryPickUpDateTextView.setText(getFormattedDate(pickUpTime)+ " "+ pick_up_Time);
        summaryAddressTextView.setText(address);
        summaryDeliveryDateTextView.setText(getFormattedDate(dropOffTime)+" "+"6:00 pm to 9:00 pm");

        LWLog.info(TAG + " " + "order_id: " + order_id);

        LWLog.info(TAG + " " + "address: " + address);

        LWLog.info(TAG + " " + "pickUpTime: " + pickUpTime);

        LWLog.info(TAG + " " + "dropOffTime: " + dropOffTime);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.cancelOrderButton:
                showCancelOrderAlert();
                break;
            case R.id.orderStatusButton:
//                homeActivity.menuMyOrderTextView.setOnClickListener(this);
                replaceFragment(R.id.fragmentContainerLayout,new MyOrderFragment(), MyOrderFragment.TAG,true);
//                homeActivity.clearPreviousBackStackTillTimeLine();
                break;
        }
    }


    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        LWUtil.access_Token = LWPrefs.getString(getActivity(),LWPrefs.KEY_TOKEN,"");
    }


    public void showCancelOrderAlert() {
        if (cancelOrderDialog !=null && cancelOrderDialog.isShowing()) return;
        cancelOrderDialog = new AlertDialog.Builder(getActivity()).setMessage(getResources().getString(R.string.cancelOrder))
                .setCancelable(true)
                .setPositiveButton(getResources().getString(R.string.yes), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
//                        replaceFragment(R.id.fragmentContainerLayout,new WhereFragment(),WhereFragment.TAG,true);
                        dialog.dismiss();
                    }
                }).setNegativeButton(getResources().getString(R.string.no), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                }).create();
        cancelOrderDialog.show();
    }

    private String getFormattedDate(String birthday) {
        String formattedDate = "";
        try {
            Date date = LWUtil.PARSE_SIMPLE_DATE_FORMAT.parse(birthday);
            formattedDate = formatSimpleDateFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formattedDate;
    }

    private String getFormatDate(String birthday) {
        String formattedDate = "";
        try {
            Date date = LWUtil.PARSE_SIMPLE_DATE_FORMAT.parse(birthday);
            formattedDate = formatDate.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formattedDate;
    }

}
