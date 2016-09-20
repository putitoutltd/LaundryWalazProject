package putitout.laundrywalaz.ui.activity.demo;

import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.DrawerLayout;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.crashlytics.android.Crashlytics;

import io.fabric.sdk.android.Fabric;
import putitout.laundrywalaz.R;
import putitout.laundrywalaz.adapter.ImagePagerAdapter;
import putitout.laundrywalaz.ui.activity.base.BaseActivity;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.ui.activity.login.LoginActivity;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceTextView;

/**
 * Created by Ehsan Aslam on 7/20/2016.
 */
public class DemoActivity extends BaseActivity implements View.OnClickListener {

    private static final int RESULT_CLOSE = 1;


    private ViewPager imageViewPager;

    private ImageView menuImageView;
    private ImageView crossImageView;
    private ImageView backImageView;
    private ImageView menuCallImageView;
    private ImageView menuFaceBookImageView;
    private ImageView menuInstagramImageView;

    private LinearLayout bottomLinearLayout;

    private ImagePagerAdapter imagePagerAdapter;

    HomeActivity homeActivity;

    private Button pickUpButton;
    private Button loginButton;

    private int[] sliderImages;

//    private View centerLine;

    private AlertDialog logoutDialog;

    private DrawerLayout drawerLayout;
    private LinearLayout drawerMenuLinearLayout;

    private TypefaceTextView menuPickupTextView;
    private TypefaceTextView menuMyOrderTextView;
    private TypefaceTextView menuPriceTextView;
    private TypefaceTextView menuHowItWorksTextView;
    private TypefaceTextView menuFeedbackTextView;
    private TypefaceTextView menuLogoutTextView;
    private TypefaceTextView menuFAQTextView;
    private TypefaceTextView menuTermsAndPoliciesTextView;

    //    private String access_Token = LWPrefs.getString(getActivity(), LWPrefs.KEY_TOKEN, "");
    private View myOrderView;
    private boolean isPickUpFromMenu = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_demo);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        initWidget();
    }


    public void initWidget() {

//        LWUtil.isFromMenu = false;


//
//        if (access_Token.isEmpty()) {
//            menuLogoutTextView.setVisibility(View.GONE);
//            menuMyOrderTextView.setVisibility(View.GONE);
//            myOrderView.setVisibility(View.GONE);
//
//        } else {
//            menuLogoutTextView.setVisibility(View.VISIBLE);
//            menuMyOrderTextView.setVisibility(View.VISIBLE);
//            myOrderView.setVisibility(View.VISIBLE);
//        }

        sliderImages = new int[]{R.drawable.first_slide, R.drawable.second_slide,
                R.drawable.third_slide};

        drawerLayout = (DrawerLayout) findViewById(R.id.drawerLayout);
        drawerMenuLinearLayout = (LinearLayout) findViewById(R.id.menuDrawer);

        menuImageView = (ImageView) findViewById(R.id.menuImageView);
        menuImageView.setOnClickListener(this);

        bottomLinearLayout = (LinearLayout) findViewById(R.id.bottomLinearLayout);

        imageViewPager = (ViewPager) findViewById(R.id.imageViewPager);
        imagePagerAdapter = new ImagePagerAdapter(this, sliderImages);
        pickUpButton = (Button) findViewById(R.id.pickUpButton);
        loginButton = (Button) findViewById(R.id.loginButton);
        loginButton.setOnClickListener(this);
        pickUpButton.setOnClickListener(this);

        menuPickupTextView = (TypefaceTextView) findViewById(R.id.menuPickupTextView);
        menuPickupTextView.setOnClickListener(this);
        menuMyOrderTextView = (TypefaceTextView) findViewById(R.id.menuMyOrderTextView);
        menuMyOrderTextView.setOnClickListener(this);
        menuPriceTextView = (TypefaceTextView) findViewById(R.id.menuPriceTextView);
        menuPriceTextView.setOnClickListener(this);
        menuHowItWorksTextView = (TypefaceTextView) findViewById(R.id.menuHowItWorksTextView);
        menuHowItWorksTextView.setOnClickListener(this);
        menuFeedbackTextView = (TypefaceTextView) findViewById(R.id.menuFeedbackTextView);
        menuFeedbackTextView.setOnClickListener(this);
        menuLogoutTextView = (TypefaceTextView) findViewById(R.id.menuLogoutTextView);
        menuLogoutTextView.setOnClickListener(this);
        crossImageView = (ImageView) findViewById(R.id.crossImageView);
        crossImageView.setOnClickListener(this);
        menuFAQTextView = (TypefaceTextView) findViewById(R.id.menuFAQTextView);
        menuFAQTextView.setOnClickListener(this);
        menuTermsAndPoliciesTextView = (TypefaceTextView) findViewById(R.id.menuTermsAndPoliciesTextView);
        menuTermsAndPoliciesTextView.setOnClickListener(this);
        menuCallImageView = (ImageView) findViewById(R.id.menuCallImageView);
        menuCallImageView.setOnClickListener(this);

        menuFaceBookImageView = (ImageView) findViewById(R.id.menuFaceBookImageView);
        menuFaceBookImageView.setOnClickListener(this);

        menuInstagramImageView = (ImageView) findViewById(R.id.menuInstagramImageView);
        menuInstagramImageView.setOnClickListener(this);

//        centerLine = (View) findViewById(R.id.centerLine);
        myOrderView = (View) findViewById(R.id.myOrderView);


        if (LWUtil.isFromMenu == true){
            bottomLinearLayout.setVisibility(View.GONE);
//            loginButton.setVisibility(View.GONE);
//            centerLine.setVisibility(View.GONE);
//            menuImageView.setVisibility(View.GONE);
            LWUtil.isFromMenu = false;
            isPickUpFromMenu = true;
        } else {
            bottomLinearLayout.setVisibility(View.VISIBLE);
//            loginButton.setVisibility(View.VISIBLE);
//            centerLine.setVisibility(View.VISIBLE);
            menuImageView.setVisibility(View.VISIBLE);
        }
        imageViewPager.setAdapter(imagePagerAdapter);
        imagePagerAdapter.notifyDataSetChanged();
        imageViewPager.setCurrentItem(0);


        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(LWUtil.BROADCAST_ACTION_KILL_PREVIOUS_ACTIVIES);
        intentFilter.addAction(LWUtil.BROADCAST_ACTION_DEMO_ACTIVITY);
//        intentFilter.addAction(LWUtil.BROADCAST_ACTION_COMING_FROM_HOME_ACTIVITY);
        registerReceiver(broadcastReceiver, intentFilter);

    }

    private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(LWUtil.BROADCAST_ACTION_KILL_PREVIOUS_ACTIVIES)) {
                DemoActivity.this.finish();
            }  else if (intent.getAction().equals(LWUtil.BROADCAST_ACTION_DEMO_ACTIVITY)) {
                DemoActivity.this.finish();
            }
//            else if (intent.getAction().equals(LWUtil.BROADCAST_ACTION_COMING_FROM_HOME_ACTIVITY)) {
//                DemoActivity.this.finish();
//            }
        }
    };

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(broadcastReceiver);
    }


    @Override
    protected void onResume() {
        super.onResume();
        LWUtil.isFromPriceMenu = false;
        LWUtil.isUserLogin=false;
        LWUtil.access_Token = LWPrefs.getString(getActivity(), LWPrefs.KEY_TOKEN, "");
        if ( LWUtil.access_Token.isEmpty()) {
            menuLogoutTextView.setVisibility(View.GONE);
            menuMyOrderTextView.setVisibility(View.GONE);
            myOrderView.setVisibility(View.GONE);
        } else {
            menuLogoutTextView.setVisibility(View.VISIBLE);
            menuMyOrderTextView.setVisibility(View.VISIBLE);
            myOrderView.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onClick(View v) {
        switch(v.getId()) {
            case R.id.menuImageView:
                toggleMenu();
                break;
            case R.id.pickUpButton:
                startActivity(new Intent(this, HomeActivity.class));
                break;
            case R.id.loginButton:
                startActivity(new Intent(this, LoginActivity.class));
                break;
            case R.id.menuPickupTextView:
                if (isPickUpFromMenu == true) {
                    DemoActivity.this.finish();
                    isPickUpFromMenu = false;
                } else {
//                    if (LWUtil.isFromMenu == false) {
//                        startActivity(new Intent(this, HomeActivity.class));
//                        DemoActivity.this.finish();
//                    } else {
                    isPickUpFromMenu = false;
                    toggleMenu();
                    LWUtil.isFromPickUp = true;
                    startActivity(new Intent(this, HomeActivity.class));
//                        this.finish();
//                    }
                }

                break;
            case R.id.menuMyOrderTextView:
                if (LWUtil.access_Token.isEmpty()) {
                    LWUtil.isFromOrderMenu = true;
                    toggleMenu();
                    startActivity(new Intent(this, HomeActivity.class));
                } else {

                    LWUtil.isFromOrderMenu = true;
                    toggleMenu();
                    startActivity(new Intent(this, HomeActivity.class));
                    DemoActivity.this.finish();
                }
                break;
            case R.id.menuPriceTextView:
                if (LWUtil.access_Token.isEmpty()) {
                    LWUtil.isFromPriceMenu = true;
                    toggleMenu();
                    startActivity(new Intent(this, HomeActivity.class));
                } else {

                LWUtil.isFromPriceMenu = true;
                toggleMenu();
                startActivity(new Intent(this, HomeActivity.class));
                DemoActivity.this.finish();
        }
                break;
            case R.id.menuHowItWorksTextView:
                toggleMenu();
                break;
            case R.id.menuFeedbackTextView:
                if (LWUtil.access_Token.isEmpty()) {
                    LWUtil.isFromFeedbackMenu=true;
                    startActivity(new Intent(this,HomeActivity.class));
                    toggleMenu();
                } else {
                    LWUtil.isFromFeedbackMenu = true;
                    startActivity(new Intent(this, HomeActivity.class));
                    toggleMenu();
                    DemoActivity.this.finish();
                }
                break;
            case R.id.menuLogoutTextView:
                toggleMenu();
                showLogoutAlert();
                break;
            case R.id.crossImageView:
                toggleMenu();
                break;
            case R.id.menuFAQTextView:
                if (LWUtil.access_Token.isEmpty()) {
                    LWUtil.isFromFAQMenu=true;
                    startActivity(new Intent(this,HomeActivity.class));
                    toggleMenu();
                } else {
                    LWUtil.isFromFAQMenu = true;
                    startActivity(new Intent(this, HomeActivity.class));
                    toggleMenu();
                    DemoActivity.this.finish();
                }
                break;
            case R.id.menuTermsAndPoliciesTextView:
                if (LWUtil.access_Token.isEmpty()) {
                    LWUtil.isFromTermsMenu = true;
                    startActivity(new Intent(this, HomeActivity.class));
                    toggleMenu();

                } else {
                    LWUtil.isFromTermsMenu = true;
                    startActivity(new Intent(this, HomeActivity.class));
                    toggleMenu();
                    DemoActivity.this.finish();
                }
                    break;
            case R.id.menuCallImageView:
                LWUtil.isFromCallMenu=true;
                startActivity(new Intent(this,HomeActivity.class));
                toggleMenu();
                break;
            case R.id.menuFaceBookImageView:
                LWUtil.isFromFBMenu=true;
                startActivity(new Intent(this,HomeActivity.class));
                toggleMenu();
                break;
            case R.id.menuInstagramImageView:
                LWUtil.isFromINSTAMenu=true;
                startActivity(new Intent(this,HomeActivity.class));
                toggleMenu();
                break;
        }
    }

    private void toggleMenu() {
        if (drawerLayout.isDrawerOpen(drawerMenuLinearLayout)) {
            drawerLayout.closeDrawer(drawerMenuLinearLayout);
        } else {
            drawerLayout.openDrawer(drawerMenuLinearLayout);
            drawerLayout.requestDisallowInterceptTouchEvent(true);
        }
    }

    public void showLogoutAlert() {
        toggleMenu();
        if(logoutDialog!=null && logoutDialog.isShowing()) return;
        logoutDialog = new AlertDialog.Builder(getActivity()).setMessage(getResources().getString(R.string.logoutAlert))
                .setCancelable(true)
                .setPositiveButton(getResources().getString(R.string.logOut), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        logOut();
                        dialog.dismiss();
                    }
                }).setNegativeButton(getResources().getString(R.string.cancel), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                }).create();
        logoutDialog.show();
    }

    public void logOut() {
        LWPrefs.clearSharedPreferences(this);
        Intent intent = new Intent(this, DemoActivity.class);
        startActivity(intent);
        finish();
        sendBroadcast(new Intent(LWUtil.BROADCAST_ACTION_KILL_HOME_ACTIVITY));
    }
}
