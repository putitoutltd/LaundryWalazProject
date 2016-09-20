package putitout.laundrywalaz.ui.activity.login;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
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
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceEditText;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
public class ForgotPasswordActivity extends BaseActivity implements View.OnClickListener,OnWebServiceResponse {

    private ImageView backImageView;
    private Button sendLoginButton;
    private TypefaceEditText emailAddressEditText;
    private static final int FORGET_USER = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_forgot_password);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        initWidget();
    }

    @Override
    public void initWidget() {
        backImageView = (ImageView) findViewById(R.id.backImageView);
        backImageView.setOnClickListener(this);
        sendLoginButton = (Button) findViewById(R.id.sendLoginButton);
        sendLoginButton.setOnClickListener(this);
        emailAddressEditText = (TypefaceEditText) findViewById(R.id.emailAddressEditText);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.backImageView:
                finish();
                break;
            case R.id.sendLoginButton:
                onSendPassword();
                break;
        }
    }

    private void onSendPassword() {
        if (LWUtil.isEmpty(emailAddressEditText.getText().toString())) {
            emailAddressEditText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.errorMessagePleaseFillInAllFields)));
        } else if (!LWUtil.emailValidator(emailAddressEditText.getText().toString())) {
            emailAddressEditText.setError(LWUtil.getErrorHtmlFromString(getString(R.string.errorMessageEmailAddressIsNotValid)));
        } else {
            emailAddressEditText.setError(null);
            forgotPassword(emailAddressEditText.getText().toString());
        }
    }

    private void forgotPassword(String email) {
        if (NetworkUtil.checkIfNetworkAvailable(this)) {
            NetworkMananger.forgotPasswordApi(this, email, this, FORGET_USER);
        } else {
            LWUtil.showNetworkErrorAlertDialog(this);
        }
    }

    private void parseForgetPasswordData(Parser parser) {
        if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_FAILURE)) {
            LWUtil.showAlert(this, parser.getMessage());
        } else if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_SUCCESS)) {
            Toast.makeText(this, getString(R.string.passwordSent), Toast.LENGTH_SHORT).show();
            finish();
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
            Log.e("response: ", response);
            switch (requestCode) {
                case FORGET_USER:
                    parseForgetPasswordData(parser);
                    break;
            }
        }
    }

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }

}