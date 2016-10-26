package putitout.laundrywalaz.ui.activity.login;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.interfaces.OnDialogButtonClickListener;
import putitout.laundrywalaz.interfaces.OnWebServiceResponse;
import putitout.laundrywalaz.model.Parser;
import putitout.laundrywalaz.model.UserModel;
import putitout.laundrywalaz.network.NetworkMananger;
import putitout.laundrywalaz.network.NetworkUtil;
import putitout.laundrywalaz.ui.activity.base.BaseActivity;
import putitout.laundrywalaz.ui.activity.demo.DemoActivity;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceEditText;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
public class RegisterActivity extends BaseActivity implements View.OnClickListener,OnWebServiceResponse {

    private static final int REGISTER_A_USER = 4;
    private ImageView backImageView;
    private Button registerButton;
    private TypefaceEditText firstNameEditText;
    private TypefaceEditText lastNameEditText;
    private TypefaceEditText phoneEditText;
    private TypefaceEditText emailAddressEditText;
    private TypefaceEditText passwordEditText;
    private ProgressDialog progressDialog;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        initWidget();
    }

    @Override
    public void initWidget() {
        backImageView = (ImageView) findViewById(R.id.backImageView);
        backImageView.setOnClickListener(this);
        firstNameEditText = (TypefaceEditText) findViewById(R.id.firstNameEditText);
        lastNameEditText = (TypefaceEditText) findViewById(R.id.lastNameEditText);
        phoneEditText = (TypefaceEditText) findViewById(R.id.phoneEditText);
        emailAddressEditText = (TypefaceEditText) findViewById(R.id.emailAddressEditText);
        passwordEditText = (TypefaceEditText) findViewById(R.id.passwordEditText);
        registerButton = (Button) findViewById(R.id.registerButton);
        registerButton.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.backImageView:
                finish();
                break;
            case R.id.registerButton:
                registerUser();
                break;
        }
    }

    private void validateFieldWithErrors(EditText editText) {
        if (LWUtil.isEmpty(editText.getText().toString())) {
            editText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.errorMessagePleaseFillInAllFields)));
        } else {
            editText.setError(null);
        }
    }

    private void validateEmailFieldWithErrors(EditText editText) {
        if (LWUtil.isEmpty(editText.getText().toString())) {
            editText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.errorMessagePleaseFillInAllFields)));
        } else if (!LWUtil.emailValidator(editText.getText().toString())) {
            editText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.errorMessageEmailAddressIsNotValid)));
        } else {
            editText.setError(null);
        }
    }

    private void validatePasswordFieldWithErrors(EditText passwordEditText) {
        if (LWUtil.isEmpty(passwordEditText.getText().toString())) {
            passwordEditText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.errorMessagePleaseFillInAllFields)));
        } else if (!LWUtil.isValidPasswordCharacters(passwordEditText.getText().toString())) {
            passwordEditText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.errorMessagePasswordValidCharaters)));
        } else if (!LWUtil.isValidPasswordLength(passwordEditText.getText().toString())) {
            passwordEditText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.errorMessagePasswordLength)));
        } else {
            passwordEditText.setError(null);
        }
    }

    private void registerUser() {

        validateFieldWithErrors(firstNameEditText);
        validateFieldWithErrors(lastNameEditText);
        validateEmailFieldWithErrors(emailAddressEditText);
        validatePasswordFieldWithErrors(passwordEditText);

        if (!LWUtil.isEmpty(firstNameEditText.getText().toString())
                && !LWUtil.isEmpty(lastNameEditText.getText().toString())
                && !LWUtil.isEmpty(emailAddressEditText.getText().toString())
                && LWUtil.emailValidator(emailAddressEditText.getText().toString())

                && !LWUtil.isEmpty(passwordEditText.getText().toString())
                && LWUtil.isValidPasswordCharacters(passwordEditText.getText().toString())
                && LWUtil.isValidPasswordLength(passwordEditText.getText().toString())) {

            UserModel model = new UserModel(emailAddressEditText.getText().toString(),passwordEditText.getText().toString(),"",
                    phoneEditText.getText().toString(),firstNameEditText.getText().toString(),
                    lastNameEditText.getText().toString(),"","");

            registerAUser(model);
        }
    }


    private void registerAUser(UserModel model) {
        if (NetworkUtil.checkIfNetworkAvailable(this)) {
            NetworkMananger.createNewUserApi(this, this, REGISTER_A_USER, model);
        } else {
            LWUtil.showNetworkErrorAlertDialog(this);
        }
    }

    @Override
    public void onStartWebService(int requestCode) {
        progressDialog = getProgressDialog();
        if(!progressDialog.isShowing()) {
            progressDialog.show();
        }
    }

    @Override
    public void onCompletedWebService(String response, int requestCode, boolean isValidResponse) {

        if (!(requestCode == REGISTER_A_USER)) {
            if (progressDialog.isShowing()) {
                progressDialog.dismiss();
            }
        }
        if (isValidResponse) {
            Parser parser = new Parser(response);
            switch (requestCode) {
                case REGISTER_A_USER:
                    parseRegistrationData(parser);
                    LWLog.info(response);
                    break;
            }
        }
    }

    private void parseRegistrationData(Parser parser) {
        if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_FAILURE)) {
            if (parser.getMessage().equals(getString(R.string.invalidAccessToken))) {
                LWUtil.showActionAlertDialog(this, getString(R.string.invalidAccessTokenAlert), getString(R.string.ok), new OnDialogButtonClickListener() {
                    @Override
                    public void onDialogPositiveButtonClick(int requestCode) {
                        Intent intent = new Intent(RegisterActivity.this, DemoActivity.class);
                        startActivity(intent);
                    }
                    @Override
                    public void onDialogNegativeButtonClick(int requestCode) {
                    }
                }, 0);
            } else {
                progressDialog.dismiss();
                LWUtil.showAlert(this, parser.getMessage());
            }
        } else if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_SUCCESS)) {
            String token =  parser.getToken();
            String id = parser.getId();

            LWPrefs.saveString(this, LWPrefs.KEY_USER_ID, id);
            LWPrefs.saveString(this, LWPrefs.KEY_TOKEN, token);
            LWPrefs.saveString(this, LWPrefs.KEY_FIRST_NAME, firstNameEditText.getText().toString());
            LWPrefs.saveString(this, LWPrefs.KEY_LAST_NAME, lastNameEditText.getText().toString());
            LWPrefs.saveString(this, LWPrefs.KEY_PHONE, phoneEditText.getText().toString());
            LWPrefs.saveString(this, LWPrefs.KEY_USER_STATUS, "1");
            LWPrefs.saveString(this, LWPrefs.KEY_EMAIL, emailAddressEditText.getText().toString());
            Toast.makeText(this,R.string.registrationAlert,Toast.LENGTH_LONG).show();
            finish();
        }
    }
}