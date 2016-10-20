package putitout.laundrywalaz.utils;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.text.Html;
import android.text.Spanned;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.regex.Pattern;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.interfaces.OnDialogButtonClickListener;
import putitout.laundrywalaz.ui.activity.demo.DemoActivity;
/**
 * Created by Ehsan Aslam
 */
public class LWUtil {

    /**
     * Constants.
     */
    public static final String AUTH_TOKEN_KEY = "{sPjadfadf@4hyBASYdfsLdWJFz2juAdAOI(MkjAnRhsTVC>Wih))J9WT(kr";

    public static final SimpleDateFormat PARSE_SIMPLE_DATE_FORMAT = new SimpleDateFormat("dd MMMM yyyy h:mm a");

    /**
     * BroadCast
     */
    public static final String BROADCAST_ACTION_DEMO_ACTIVITY = "BROADCAST_ACTION_DEMO_ACTIVITY";
    public static final String BROADCAST_ACTION_KILL_PREVIOUS_ACTIVIES = "BROADCAST_ACTION_KILL_PREVIOUS_ACTIVIES";
    public static final String BROADCAST_ACTION_KILL_HOME_ACTIVITY = "BROADCAST_ACTION_KILL_HOME_ACTIVITY";

    /**
     * Application identity.
     */
    public static final String APP_ID = "LaundaryWalaz";
    public static final String KEY_TAG = "LaundaryWalaz";
    public static final String KEY_APPLICATION_PACKAGE_NAME = "putitout.LaundaryWalaz";
    public static final String KEY_SERVER_NO_RESPONSE = "null";


    // Keys for User Model
    public static final String KEY_FIRST_NAME = "first_name";
    public static final String KEY_ADDRESS = "address";
    public static final String KEY_LAST_NAME = "last_name";
    public static final String KEY_LOCATION_ID = "location_id";
    public static final String KEY_EMAIL = "email";
    public static final String KEY_GENDER = "gender";
    public static final String KEY_PHONE = "phone";
    public static final String KEY_PASSWORD = "password";
    public static final String KEY_PICK_UP_TIME = "pickup_time";
    public static final String KEY_DROP_OFF_TIME = "dropoff_time";
    public static final String KEY_ABOUT = "about";
    public static final String KEY_FEEDBACK = "feedback";
    public static final String KEY_CUSTOMER_NAME = "customerName";
    public static final String KEY_ORDER_ID = "orderId";
    public static final String KEY_ACCESS_TOKEN = "access_token";

    //Api Service Keys
    public static final String KEY_SERVER_RESPONSE_ORDER_STATUS = "status";
    public static final String KEY_SERVER_RESPONSE_ORDER_ID = "order";
    public static final String KEY_SERVER_RESPONSE_PICK_UP_TIME = "pickup_time";
    public static final String KEY_SERVER_RESPONSE_DROP_OFF_TIME = "dropoff_time";
    public static final String KEY_SERVER_RESPONSE_ORDER = "order_id";
    public static final String KEY_SERVER_RESPONSE_STATUS = "status";
    public static final String KEY_SERVER_RESPONSE_MESSAGE = "message";
    public static final String KEY_SERVER_RESPONSE_DATA = "data";
    public static final String KEY_SERVER_RESPONSE_MEN = "Men's Apparel";
    public static final String KEY_SERVER_RESPONSE_FAILURE = "failure";
    public static final String KEY_SERVER_RESPONSE_SUCCESS = "success";
    public static final String KEY_SERVER_RESPONSE_TOKEN = "access_token";
    public static final String KEY_SERVER_RESPONSE_USER_ID = "user_id";
    public static final String KEY_SERVER_RESPONSE_DETAILS = "details";
    public static final String KEY_SERVER_RESPONSE_FIRST_NAME = "first_name";
    public static final String KEY_SERVER_RESPONSE_LOCATION_ID = "location_id";
    public static final String KEY_SERVER_RESPONSE_ADDRESS = "address";
    public static final String KEY_SERVER_RESPONSE_LAST_NAME = "last_name";
    public static final String KEY_SERVER_RESPONSE_NAME = "name";
    public static final String KEY_SERVER_RESPONSE_EMAIL = "email";
    public static final String KEY_SERVER_RESPONSE_ID = "id";

    //    Price List
    public static final String KEY_SERVER_RESPONSE_CATEGORY = "category";
    public static final String KEY_SERVER_RESPONSE_PRICE_DRY_CLEAN = "price_dryclean";
    public static final String KEY_SERVER_RESPONSE_PRICE_LAUNDRY = "price_laundry";
    public static final String KEY_SERVER_RESPONSE_SERVICE_CATEGORIES_ID = "service_categories_id";
    public static final String KEY_SERVER_RESPONSE_PHONE = "phone";

    public static boolean isUserLogin = false;
    public static boolean isNextDay = false;
    public static boolean isNextDayShown = false;
    public static boolean isFromPickUp = false;
    public static boolean isFromMenu = false;
    public static boolean isFromPriceMenu = false;
    public static boolean isFromFeedbackMenu = false;
    public static boolean isFromOrderMenu = false;
    public static boolean isFromLogoutMenu = false;
    public static boolean isFromFAQMenu = false;
    public static boolean isFromTermsMenu = false;
    public static boolean isFromCallMenu = false;
    public static boolean isFromFBMenu = false;
    public static boolean isFromINSTAMenu = false;

    public static String access_Token = "";

    public static void showInvalidAccessTokenAlert(final Activity activity) {
        LWUtil.showActionAlertDialog(activity, activity.getString(R.string.invalidAccessTokenAlert), activity.getString(R.string.ok), new OnDialogButtonClickListener() {
            @Override
            public void onDialogPositiveButtonClick(int requestCode) {
//                if (isFromMenu) {
//                    ((DemoActivity) activity).logOut();
//                } else {
//                    activity.sendBroadcast(new Intent(LWUtil.BROADCAST_ACTION_KILL_PREVIOUS_ACTIVIES));
//                }
                LWPrefs.clearSharedPreferences(activity);
                Intent intent = new Intent(activity, DemoActivity.class);
                activity.startActivity(intent);
                DemoActivity demoActivity = null;
//                demoActivity.logOut();
                activity.sendBroadcast(new Intent(LWUtil.BROADCAST_ACTION_KILL_PREVIOUS_ACTIVIES));
            }

            @Override
            public void onDialogNegativeButtonClick(int requestCode) {
            }
        }, 0);
    }

    public static void doSoftInputHide(Activity activity) {
        View view = activity.findViewById(android.R.id.content);
        InputMethodManager inputManager = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        inputManager.hideSoftInputFromWindow(view.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
    }
    public static boolean emailValidator(String email) {
        Pattern EMAIL_ADDRESS_PATTERN = Pattern
                .compile("[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" + "\\@"
                        + "[a-zA-Z0-9][a-zA-Z0-9\\-\\_]{0,64}" + "(" + "\\."
                        + "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" + ")+");
        return EMAIL_ADDRESS_PATTERN.matcher(email).matches();
//        Pattern pattern;
//        Matcher matcher;
//        final String EMAIL_PATTERN =
//        //"^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
//        if (email != null) email = email.trim();
//        pattern = Pattern.compile(EMAIL_PATTERN);
//        matcher = pattern.matcher(email);
//        return matcher.matches();
    }

    public static boolean isEmpty(String string) {
        return (string.length() > 0 ? false : true);
    }

    public static boolean isValidPasswordLength(String password) {
        return (password.length() >= 6 ? true : false);
    }

    public static boolean isValidPasswordCharacters(String password) {
        String PASSWORD_PATTERN = "^(?=.*\\d)(?=.*[a-zA-Z]).{1,}$";
        return (password.matches(PASSWORD_PATTERN) ? true : false);
    }

    public static int getWindowHeight(Context context) {
        if (context == null) {
            return 0;
        }
        DisplayMetrics display = ((Activity) context).getResources()
                .getDisplayMetrics();
        return display.heightPixels;
    }

    public static void generateHashKey(Context context, String encodingType) {
        try {
            PackageInfo info = context.getPackageManager().getPackageInfo(
                    KEY_APPLICATION_PACKAGE_NAME, PackageManager.GET_SIGNATURES);
            for (Signature signature : info.signatures) {
                MessageDigest md = MessageDigest.getInstance(encodingType);
                md.update(signature.toByteArray());
                Log.d(LWUtil.KEY_TAG,
                        Base64.encodeToString(md.digest(), Base64.DEFAULT));
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    public static Spanned getErrorHtmlFromString(String message) {
        return Html.fromHtml("<font color='red'>" + message + "</font>");
    }

    public static boolean isJsonResponse(String response) {
        try {
            JSONObject parseJsonResponse = new JSONObject(response);
            return true;
        } catch (JSONException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String convertStringToSHA256(String base) {
        try{
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(base.getBytes("UTF-8"));
            StringBuffer hexString = new StringBuffer();

            for (int i = 0; i < hash.length; i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if(hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch(Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    public static void showAlert(Context context, String message) {
        new android.app.AlertDialog.Builder(context).setMessage(message).setCancelable(false)
                .setNegativeButton(context.getString(R.string.ok), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                }).show();
    }

    public static void showActionAlertDialog(Context context, String message, String positiveLable, OnDialogButtonClickListener dialogListener, int requestCode) {
        LWDialog.showAlert(context,
                message,
                positiveLable, dialogListener, requestCode);
    }

    public static void showNetworkErrorAlertDialog(Context context) {
        try {
            LWDialog.showAlert(context,
                    context.getString(R.string.noInternet),
                    context.getString(R.string.ok));
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
