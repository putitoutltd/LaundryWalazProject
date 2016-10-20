package putitout.laundrywalaz.ui.fragment.contactinfo;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Date;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.interfaces.OnWebServiceResponse;
import putitout.laundrywalaz.model.OrderModel;
import putitout.laundrywalaz.model.Parser;
import putitout.laundrywalaz.network.NetworkMananger;
import putitout.laundrywalaz.network.NetworkUtil;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;
import putitout.laundrywalaz.ui.fragment.summary.SummaryFragment;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceEditText;

/**
 * Created by Ehsan Aslam on 7/22/2016.
 */
public class AddContactInfoFragment extends BaseFragment implements View.OnClickListener ,OnWebServiceResponse {

    public static final String TAG = AddContactInfoFragment.class.getSimpleName();

    private static final int CREATE_ORDER = 3;

    private Button sendButton,dummyButton;

    private TypefaceEditText firstNameEditText;
    private TypefaceEditText lastNameEditText;
    private TypefaceEditText emailEditText;
    private TypefaceEditText phoneEditText;
    ProgressDialog progressDialog;

    private SimpleDateFormat formatSimpleDateFormat;

    String address;
    String locationId;
    String pickUpTime;
    String dropOffTime;
    String first_name;
    String last_name;
    String email;
    String phone;
    private HomeActivity homeActivity;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_add_contact_info,container,false);
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
        homeActivity.setTitle(getString(R.string.addInfoText));

        sendButton = (Button) view.findViewById(R.id.sendButton);
        sendButton.setOnClickListener(this);

        dummyButton = (Button) view.findViewById(R.id.dummyButton);
        dummyButton.setOnClickListener(this);

        phoneEditText = (TypefaceEditText) view.findViewById(R.id.phoneEditText);
        phoneEditText.setEnabled(false);
        firstNameEditText = (TypefaceEditText) view.findViewById(R.id.firstNameEditText);
        firstNameEditText.setEnabled(false);
        lastNameEditText = (TypefaceEditText) view.findViewById(R.id.lastNameEditText);
        lastNameEditText.setEnabled(false);
        emailEditText = (TypefaceEditText) view.findViewById(R.id.emailEditText);
        emailEditText.setEnabled(false);

        formatSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        first_name = LWPrefs.getString(getActivity(),LWPrefs.KEY_FIRST_NAME,"");
        last_name = LWPrefs.getString(getActivity(),LWPrefs.KEY_LAST_NAME,"");
        email = LWPrefs.getString(getActivity(),LWPrefs.KEY_EMAIL,"");
        phone = LWPrefs.getString(getActivity(),LWPrefs.KEY_PHONE,"");

        LWUtil.access_Token = LWPrefs.getString(getActivity(),LWPrefs.KEY_TOKEN,"");

        address = LWPrefs.getString(getActivity(),LWPrefs.KEY_ADDRESS,"");

        locationId = LWPrefs.getString(getActivity(),LWPrefs.KEY_LOCATION_AREA,"");

        pickUpTime = LWPrefs.getString(getActivity(),LWPrefs.KEY_PICK_UP_TIME,"");

        dropOffTime = LWPrefs.getString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME,"");

        phoneEditText.setText(phone);
        firstNameEditText.setText(first_name);
        lastNameEditText.setText(last_name);
        emailEditText.setText(email);

        pickUpTime = getFormattedDate(pickUpTime);
        dropOffTime = getFormattedDate(dropOffTime);

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.sendButton:
                goToSummaryScreen();
                break;
            case R.id.dummyButton:
                replaceFragment(R.id.fragmentContainerLayout, new SummaryFragment(),SummaryFragment.TAG,true);
                break;
        }
    }

    private void CreateOrder(OrderModel model) {
        if (NetworkUtil.checkIfNetworkAvailable(getActivity())) {
            NetworkMananger.createOrderApi(getActivity(), this, CREATE_ORDER,model);
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
                case CREATE_ORDER:
                    parseUserOrder(parser);
                    LWLog.info(response);
                    break;
            }
        }
    }

    private void goToSummaryScreen() {
        if (email.equals("")) {
            Toast.makeText(getActivity(),"Your email is not correct.",Toast.LENGTH_SHORT).show();
        } else if(locationId.equals("")) {
            Toast.makeText(getActivity(),"Kindly select your correct location.",Toast.LENGTH_SHORT).show();
        } else if(phone.equals("")) {
            Toast.makeText(getActivity(),"Your phone number is not correct.",Toast.LENGTH_SHORT).show();
        } else if(first_name.equals("")) {
            Toast.makeText(getActivity(),"Kindly enter your name.",Toast.LENGTH_SHORT).show();
        } else if(last_name.equals("")) {
            Toast.makeText(getActivity(),"Kindly enter your last name.",Toast.LENGTH_SHORT).show();
        } else if(address.equals("")) {
            Toast.makeText(getActivity(),"Kindly enter your address.",Toast.LENGTH_SHORT).show();
        } else if(LWUtil.access_Token.equals("")) {
            Toast.makeText(getActivity(),"Invalid access token.",Toast.LENGTH_SHORT).show();
        } else if (pickUpTime.equals("")) {
            Toast.makeText(getActivity(),"Kindly enter your pickup time.",Toast.LENGTH_SHORT).show();
        }else if(dropOffTime.equals("")){
            Toast.makeText(getActivity(),"Kindly enter your dropOff time.",Toast.LENGTH_SHORT).show();
        }else{

            OrderModel orderModel = new OrderModel(email,locationId,phone,
                    first_name,last_name,address,LWUtil.access_Token,pickUpTime,dropOffTime);
            CreateOrder(orderModel);
        }
    }

    private void parseUserOrder(Parser parser) {
        if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_FAILURE)) {
            if (parser.getMessage().equals(getString(R.string.invalidAccessToken))) {
                LWUtil.showInvalidAccessTokenAlert(getActivity());
            } else {

                LWUtil.showAlert(getActivity(), parser.getMessage());
            }

        } else if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_SUCCESS)) {

            String order_id =  parser.getOrder();
            LWPrefs.saveString(getActivity(), LWPrefs.KEY_ORDER_ID, order_id);
            replaceFragment(R.id.fragmentContainerLayout, new SummaryFragment(),SummaryFragment.TAG,true);
            Toast.makeText(getActivity(),"Order placed successfully.",Toast.LENGTH_SHORT).show();
        }
    }

    private String getFormattedDate(String time) {
        String formattedDate = "";
        try {
            Date date = LWUtil.PARSE_SIMPLE_DATE_FORMAT.parse(time);
            formattedDate = formatSimpleDateFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formattedDate;
    }
}
