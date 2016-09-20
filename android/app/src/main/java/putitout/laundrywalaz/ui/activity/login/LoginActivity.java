package putitout.laundrywalaz.ui.activity.login;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.interfaces.OnWebServiceResponse;
import putitout.laundrywalaz.model.Parser;
import putitout.laundrywalaz.network.NetworkMananger;
import putitout.laundrywalaz.network.NetworkUtil;
import putitout.laundrywalaz.ui.activity.base.BaseActivity;
import putitout.laundrywalaz.ui.activity.demo.DemoActivity;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceEditText;
import putitout.laundrywalaz.widgets.TypefaceTextView;

/**
 * Created by Ehsan Aslam on 7/20/2016.
 */
public class LoginActivity extends BaseActivity implements View.OnClickListener,OnWebServiceResponse {


    private ImageView backImageView;
    private ImageView checkImageView;

    private TypefaceTextView registerTextView;
    private TypefaceTextView forgotPasswordTextView;

    private static final int LOGIN_USER = 3;

    private TypefaceEditText emailEditText;
    private TypefaceEditText passwordEditText;
    private Button loginButton;

    private DemoActivity demoActivity;


    private boolean isClick = true;

    ProgressDialog progressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

        initWidget();
    }


    @Override
    public void initWidget() {
        backImageView = (ImageView) findViewById(R.id.backImageView);
        backImageView.setOnClickListener(this);
        checkImageView = (ImageView) findViewById(R.id.checkImageView);
        checkImageView.setOnClickListener(this);
        registerTextView = (TypefaceTextView) findViewById(R.id.registerTextView);
        registerTextView.setOnClickListener(this);
        forgotPasswordTextView = (TypefaceTextView) findViewById(R.id.forgotPasswordTextView);
        forgotPasswordTextView.setOnClickListener(this);

        loginButton = (Button) findViewById(R.id.loginButton);
        loginButton.setOnClickListener(this);

        emailEditText = (TypefaceEditText) findViewById(R.id.emailEditText);
        passwordEditText = (TypefaceEditText) findViewById(R.id.passwordEditText);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.backImageView:
                this.finish();
                break;
            case R.id.checkImageView:
                if (isClick){
                    checkImageView.setImageResource(R.drawable.check_box_active);
                    LWPrefs.saveBoolean(this,LWPrefs.KEY_REMEMBER_ME,isClick);
                    isClick=false;
                } else {
                    checkImageView.setImageResource(R.drawable.check_box_inactive);
                    isClick=true;
                }
                break;
            case R.id.registerTextView:
                startActivity(new Intent(this,RegisterActivity.class));
                emailEditText.setText("");
                passwordEditText.setText("");
                break;
            case R.id.forgotPasswordTextView:
                startActivity(new Intent(this,ForgotPasswordActivity.class));
                break;
            case R.id.loginButton:
                validateFields();
                break;
        }
    }

    private void validateFields() {
        if (LWUtil.isEmpty(emailEditText.getText().toString())) {
            emailEditText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.emailAddressErrorMessageEmpty)));
        } else {
            emailEditText.setError(null);
        }
        if (LWUtil.isEmpty(passwordEditText.getText().toString())) {
            passwordEditText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.passwordErrorMessageEmpty)));
        } else {
            passwordEditText.setError(null);
        }
        if (!LWUtil.emailValidator(emailEditText.getText().toString())) {
            emailEditText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.emailAddressInvalidMessage)));
        } else {
            emailEditText.setError(null);
        }
        if (!LWUtil.isEmpty(emailEditText.getText().toString())
                && !LWUtil.isEmpty(passwordEditText.getText().toString())
                && LWUtil.emailValidator(emailEditText.getText().toString())) {
            login(emailEditText.getText().toString(), passwordEditText.getText().toString());
        }
    }

    private void login(String email, String password) {
        if (NetworkUtil.checkIfNetworkAvailable(this)) {
            NetworkMananger.loginUserApi(this, email, password, this, LOGIN_USER);
        } else {
            LWUtil.showNetworkErrorAlertDialog(this);
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
                case LOGIN_USER:
                    parseUserData(parser);
                    LWLog.info(response);
                    break;
            }
        }
    }

    private void parseUserData(Parser parser) {
        if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_FAILURE)) {
            LWUtil.showAlert(getActivity(),parser.getMessage());
//            LWUtil.showAlert(this,(getString(R.string.registrationAlert)));
        } else if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_SUCCESS)) {
            saveUserData(this, parser);
            if(LWUtil.isUserLogin == true) {
                Intent intent = new Intent(LoginActivity.this, HomeActivity.class);
                startActivity(intent);
                finish();
                sendBroadcast(new Intent(LWUtil.BROADCAST_ACTION_DEMO_ACTIVITY));
            } else {
                Intent intent = new Intent(LoginActivity.this, HomeActivity.class);
                startActivity(intent);
                finish();
                Toast.makeText(this,"You have been successfully Login.",Toast.LENGTH_SHORT).show();
                sendBroadcast(new Intent(LWUtil.BROADCAST_ACTION_DEMO_ACTIVITY));
            }
        }
    }

    private void saveUserData(Context context, Parser parseData) {
        String token = parseData.getToken();
        String id = parseData.getId();
        String firstName = parseData.getFirstName();
        String lastName = parseData.getLastName();
        String phone = parseData.getPhone();
//        String getMiddleName = parseData.getMiddleName();

        String gender = parseData.getGender();
        String type = parseData.getType();
        String dateModified = parseData.getDateModified();
        String userStatus = parseData.getOrderStatus();
        String email = parseData.getEmail();
        String image = parseData.getOrder();


        LWPrefs.saveString(context, LWPrefs.KEY_TOKEN, token);
        LWPrefs.saveString(context, LWPrefs.KEY_USER_ID, id);
        LWPrefs.saveString(context, LWPrefs.KEY_FIRST_NAME, firstName);
        LWPrefs.saveString(context, LWPrefs.KEY_LAST_NAME, lastName);
        LWPrefs.saveString(context, LWPrefs.KEY_PHONE, phone);
//        LWPrefs.saveString(context, LWPrefs.KEY_GENDER, gender);
//        LWPrefs.saveString(context, LWPrefs.KEY_TYPE, type);
        LWPrefs.saveString(context, LWPrefs.KEY_USER_STATUS, userStatus);
//        LWPrefs.saveString(context, LWPrefs.KEY_IMAGE, image);
        LWPrefs.saveString(context, LWPrefs.KEY_EMAIL, email);
    }
}
