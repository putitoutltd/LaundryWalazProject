package putitout.laundrywalaz.ui.fragment.menu;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.interfaces.OnWebServiceResponse;
import putitout.laundrywalaz.model.Parser;
import putitout.laundrywalaz.network.NetworkMananger;
import putitout.laundrywalaz.network.NetworkUtil;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceEditText;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
public class FeedBackFragment extends BaseFragment implements View.OnClickListener ,OnWebServiceResponse {

    public static final String TAG = FeedBackFragment.class.getSimpleName();
    private RelativeLayout selectLocationRelativeLayout;

    private TypefaceEditText feedbackDetailEditText,customerNameEditText,orderIDEditText;
    private String about = "";
    private String feed_back = "";

    private Spinner shareWithSpinner;
    String[] spinnerOptions;

    private static final int FEED_BACK = 1;

    private ImageView orderStatusImageView;

    ProgressDialog progressDialog;

    private Button sendFeedBackButton;

    private HomeActivity homeActivity;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_feed_back,container,false);
        view.setClickable(true); // your solution!
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
        homeActivity.setTitle(getString(R.string.menuFeedBack));

        selectLocationRelativeLayout = (RelativeLayout) view.findViewById(R.id.selectLocationRelativeLayout);
        selectLocationRelativeLayout.setOnClickListener(this);
        shareWithSpinner = (Spinner) view.findViewById(R.id.spinnerShareWith);
//        shareWithSpinner.setPopupBackgroundResource(R.drawable.spinner_border);
        spinnerOptions = getResources().getStringArray(R.array.feed_back_array);

        sendFeedBackButton = (Button) view.findViewById(R.id.sendFeedBackButton);
        sendFeedBackButton.setOnClickListener(this);

        feedbackDetailEditText = (TypefaceEditText) view.findViewById(R.id.feedbackDetailEditText);

        customerNameEditText = (TypefaceEditText) view.findViewById(R.id.customerNameEditText);
        orderIDEditText = (TypefaceEditText) view.findViewById(R.id.orderIDEditText);

        feed_back = feedbackDetailEditText.getText().toString();

    }
    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        shareWithSpinner.setAdapter(new ShareSpinnerAdapter(getActivity(), R.layout.spinner_share_layout, spinnerOptions));
        shareWithSpinner.post(new Runnable() {
            @Override
            public void run() {
//                shareWithSpinner.setSelection(0, false);

//                shareWithSpinner.setSelection(3);
                ((ShareSpinnerAdapter) shareWithSpinner.getAdapter()).notifyDataSetChanged();
            }
        });

    }

    private void sendFeedBack() {
        if (NetworkUtil.checkIfNetworkAvailable(getActivity())) {
            NetworkMananger.feedBackApi(getActivity(),about,feedbackDetailEditText.getText().toString(),
                    customerNameEditText.getText().toString()
                    ,orderIDEditText.getText().toString(),this, FEED_BACK);
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
                case FEED_BACK:
                    parseFeedBack(parser);
                    LWLog.info(response);
                    break;
            }
        }
    }

    private void parseFeedBack(Parser parser) {

        if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_FAILURE)) {
            LWUtil.showAlert(getActivity(), parser.getMessage());
        } else if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_SUCCESS)) {
            Toast.makeText(getActivity(),"Feedback has been sent.",Toast.LENGTH_SHORT).show();
            customerNameEditText.setText("");
            orderIDEditText.setText("");
            feedbackDetailEditText.setText("");
            shareWithSpinner.setSelection(0);
        }
    }

    public class ShareSpinnerAdapter extends ArrayAdapter<String> {
        AbsListView.LayoutParams params;
        public ShareSpinnerAdapter(Context context, int textViewResourceId, String[] options) {
            super(context, textViewResourceId, options);
            params = new AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,(int) (LWUtil.getWindowHeight(getActivity()) * 0.066));
        }

        @Override public View getDropDownView(final int position, View convertView, final ViewGroup parent) {
            if(position == spinnerOptions.length-1) {
                return new View(parent.getContext());
            }

            LayoutInflater layoutInflater = (LayoutInflater) parent.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View mySpinner = layoutInflater.inflate(R.layout.spinner_share_item_layout, parent, false);

            TextView selectedOptionTextView = (TextView) mySpinner .findViewById(R.id.selectedOptionTextView);
            ImageView imageView = (ImageView) mySpinner .findViewById(R.id.imageView);
//            ImageView radioButtonImageView = (ImageView) mySpinner .findViewById(R.id.radioButtonImageView);
            mySpinner.setLayoutParams(params);

            selectedOptionTextView.setText(spinnerOptions[position]);
//            if (spinnerCheckedOptions[position]) {
//                radioButtonImageView.setImageBitmap(BitmapFactory.decodeResource(getResources(), R.drawable.radio_button_checked));
//            }
//            imageView.setImageBitmap(spinnerOptionsBitmaps[position]);

            mySpinner.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
//                    for (int i = 0; i < spinnerCheckedOptions.length; i++) {
//                        spinnerCheckedOptions[i] = false;
//                    }
//                    spinnerCheckedOptions[position] = true;
                    shareWithSpinner.setSelection(position);
                    View root = parent.getRootView();
                    root.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_BACK));
                    root.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_BACK));
                }
            });
            return mySpinner;
        }

        @Override public View getView(int position, View convertView, ViewGroup parent) {
            LayoutInflater layoutInflater = (LayoutInflater) parent.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View mySpinner = layoutInflater.inflate(R.layout.spinner_share_layout, parent, false);
            TextView selectedOptionTextView = (TextView) mySpinner .findViewById(R.id.selectedOptionTextView);
            selectedOptionTextView.setText(spinnerOptions[position]);

            LWLog.info(about);
            if(selectedOptionTextView.getText().equals("Location")){
//                                googleMap.animateCamera(CameraUpdateFactory.newLatLng(latLng));
//                googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, 17.0f));
//                googleMap.setMyLocationEnabled(true);
//                isLocationSelected=true;
//                currentLocation();
//                locationArea = "Location";
//                LWLog.info(locationArea);
            }

            else if(selectedOptionTextView.getText().equals("Quality")){
                about = "Quality";
                LWLog.info(about);
            }
            else if(selectedOptionTextView.getText().equals("Staff")){
                about = "Staff";
                LWLog.info(about);
            }else if(selectedOptionTextView.getText().equals("Service")){

                about = "Service";
                LWLog.info(about);
            }
            return mySpinner;
        }
    }


    @Override
    public void onClick(View v) {

        switch (v.getId()){
            case R.id.selectLocationRelativeLayout:
                break;
            case R.id.sendFeedBackButton:

                if(customerNameEditText.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(),"Please enter customer name.",Toast.LENGTH_SHORT).show();
                }
                else if (orderIDEditText.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(),"Please enter your Order ID.",Toast.LENGTH_SHORT).show();
                }
                else if(shareWithSpinner.getSelectedItemPosition()==0 || spinnerOptions.length < 0){
                    Toast.makeText(getActivity(),"Please select what feed back is about?",Toast.LENGTH_SHORT).show();
                }
                else if(feedbackDetailEditText.getText().toString().isEmpty()){
                    Toast.makeText(getActivity(),"Please write any comments first.",Toast.LENGTH_SHORT).show();
                } else {
                    sendFeedBack();
                }
                break;
        }

    }
}
