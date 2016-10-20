package putitout.laundrywalaz.ui.activity.home;

import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

import java.util.List;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.ui.activity.base.BaseActivity;
import putitout.laundrywalaz.ui.activity.demo.DemoActivity;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;
import putitout.laundrywalaz.ui.fragment.contactinfo.AddContactInfoFragment;
import putitout.laundrywalaz.ui.fragment.map.WhereFragment;
import putitout.laundrywalaz.ui.fragment.menu.FeedBackFragment;
import putitout.laundrywalaz.ui.fragment.menu.MyOrderFragment;
import putitout.laundrywalaz.ui.fragment.menu.PriceListFragment;
import putitout.laundrywalaz.ui.fragment.when.WhenFragment;
import putitout.laundrywalaz.ui.fragment.policy.FAQFragment;
import putitout.laundrywalaz.ui.fragment.policy.TermsAndPoliciesFragment;
import putitout.laundrywalaz.ui.fragment.summary.SummaryFragment;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceTextView;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
public class HomeActivity extends BaseActivity implements View.OnClickListener {

    public static final String TAG = HomeActivity.class.getSimpleName();


    private ImageView menuImageView;
    private ImageView crossImageView;
    private ImageView backImageView;
    private ImageView menuCallImageView;
    private ImageView menuFaceBookImageView;
    private ImageView menuInstagramImageView;

    private AlertDialog logoutDialog;
    private View myOrderView;

    private TypefaceTextView headerTextView;

    private TypefaceTextView menuPickupTextView;
    public  TypefaceTextView menuMyOrderTextView;
    private TypefaceTextView menuPriceTextView;
    private TypefaceTextView menuHowItWorksTextView;
    private TypefaceTextView menuFeedbackTextView;
    private TypefaceTextView menuLogoutTextView;
    private TypefaceTextView menuFAQTextView;
    public TypefaceTextView menuTermsAndPoliciesTextView;

    private DrawerLayout drawerLayout;
    private LinearLayout drawerMenuLinearLayout;
    private FrameLayout fragmentContainerLayout;
    private String fragmentName;
    private boolean isBackArrowOnWhereFragment = false;

    private String access_Token;

    public static String FACEBOOK_URL = "https://www.facebook.com/laundrywalaz";
    public static String FACEBOOK_PAGE_ID = "Laundry Walaz";

    boolean isFromOtherMenu = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        initWidget();
    }

    @Override
    public void initWidget() {

        LWUtil.isFromMenu = false;

        LWUtil.access_Token = LWPrefs.getString(getActivity(), LWPrefs.KEY_TOKEN, "");
        drawerLayout = (DrawerLayout) findViewById(R.id.drawerLayout);
        drawerMenuLinearLayout = (LinearLayout) findViewById(R.id.menuDrawer);
        fragmentContainerLayout = (FrameLayout) findViewById(R.id.fragmentContainerLayout);
        myOrderView = findViewById(R.id.myOrderView);

        menuImageView = (ImageView) findViewById(R.id.menuImageView);
        menuImageView.setOnClickListener(this);

        backImageView = (ImageView) findViewById(R.id.backImageView);
        backImageView.setOnClickListener(this);



        headerTextView = (TypefaceTextView) findViewById(R.id.headerTextView);
        headerTextView.setText(R.string.whereText);

        //Menu Layout Views
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

        if (LWUtil.access_Token.isEmpty()) {
            menuLogoutTextView.setVisibility(View.GONE);
            menuMyOrderTextView.setVisibility(View.GONE);
            myOrderView.setVisibility(View.GONE);
        } else {
            menuLogoutTextView.setVisibility(View.VISIBLE);
            menuMyOrderTextView.setVisibility(View.VISIBLE);
            myOrderView.setVisibility(View.VISIBLE);
        }

        if (  LWUtil.isFromPickUp == true){
            getSupportFragmentManager().beginTransaction().
                    replace(R.id.fragmentContainerLayout, new WhereFragment(), WhereFragment.TAG).
                    commit();
//            sendBroadcast(new Intent(LWUtil.BROADCAST_ACTION_COMING_FROM_HOME_ACTIVITY));
            headerTextView.setText(R.string.whereText);
            clearPreviousBackStackTillHomeActivity();
            registerBackStackListener();
            LWUtil.isFromPickUp =false;
        }

        else if(LWUtil.isFromPriceMenu == true) {

            getSupportFragmentManager().beginTransaction().
                    replace(R.id.fragmentContainerLayout, new PriceListFragment(), PriceListFragment.TAG).
                    commit();
            headerTextView.setText(R.string.menuPricing);
            clearPreviousBackStackTillHomeActivity();
            LWUtil.isFromPriceMenu =false;
            fragmentName=PriceListFragment.TAG;
            isFromOtherMenu = true;
        }
        else if (LWUtil.isFromOrderMenu==true){
            if(headerTextView.getText()=="Order Status"){
                toggleMenu();
            } else {
//                toggleMenu();

                getSupportFragmentManager().beginTransaction().
                        replace(R.id.fragmentContainerLayout, new MyOrderFragment(), MyOrderFragment.TAG).
                        commit();
                headerTextView.setText(R.string.orderStatus);
                clearPreviousBackStackTillHomeActivity();
                LWUtil.isFromOrderMenu =false;
                fragmentName=MyOrderFragment.TAG;
                isFromOtherMenu = true;
            }
        }


        else if (LWUtil.isFromFeedbackMenu==true){
            getSupportFragmentManager().beginTransaction().
                    replace(R.id.fragmentContainerLayout, new FeedBackFragment(), FeedBackFragment.TAG).
                    commit();
            headerTextView.setText(R.string.menuFeedBack);
//            clearPreviousBackStackTillHomeActivity();
            LWUtil.isFromFeedbackMenu =false;
            fragmentName=FeedBackFragment.TAG;
            isFromOtherMenu = true;
        }

//        else if (LWUtil.isFromLogoutMenu==true){
//            showLogoutAlert();
//            LWUtil.isFromLogoutMenu =false;
//        }

        else if (LWUtil.isFromFAQMenu==true){
            getSupportFragmentManager().beginTransaction().
                    replace(R.id.fragmentContainerLayout, new FAQFragment(), FAQFragment.TAG).
                    commit();
            headerTextView.setText(R.string.menuFAQ);
//            registerBackStackListener();
//            clearPreviousBackStackTillHomeActivity();

            LWUtil.isFromFAQMenu =false;
            fragmentName=FAQFragment.TAG;
            isFromOtherMenu = true;
        }
        else if (LWUtil.isFromTermsMenu==true){
            getSupportFragmentManager().beginTransaction().
                    replace(R.id.fragmentContainerLayout, new TermsAndPoliciesFragment(), TermsAndPoliciesFragment.TAG).
                    commit();
            headerTextView.setText(R.string.menuTermsAndPolicies);
//            registerBackStackListener();
//            clearPreviousBackStackTillHomeActivity();

            LWUtil.isFromTermsMenu =false;
            fragmentName=TermsAndPoliciesFragment.TAG;
            isFromOtherMenu = true;
        }
        else if (LWUtil.isFromCallMenu==true){
            dialNumber();
            LWUtil.isFromCallMenu =false;
            finish();
        }

        else if (LWUtil.isFromFBMenu==true){
            fbPageLink();
            LWUtil.isFromFBMenu =false;
            finish();
        }
        else if (LWUtil.isFromINSTAMenu==true){
            instagramPageLink();
            LWUtil.isFromINSTAMenu =false;
            finish();
        }
        else if(LWUtil.isUserLogin==true){
            getSupportFragmentManager().beginTransaction().
                    replace(R.id.fragmentContainerLayout, new AddContactInfoFragment(), AddContactInfoFragment.TAG).
                    commit();
            headerTextView.setText(R.string.addInfoText);
            LWUtil.isUserLogin=false;
            backImageView.setVisibility(View.VISIBLE);
            backImageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    getActivity().getSupportFragmentManager().popBackStack();
                }
            });
            fragmentName = AddContactInfoFragment.TAG;
            isFromOtherMenu = true;
            registerBackStackListener();
        }
        else {
            getSupportFragmentManager().beginTransaction().
                    replace(R.id.fragmentContainerLayout, new WhereFragment(), WhereFragment.TAG).
                    commit();
            showTitle();
            registerBackStackListener();
        }


        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(LWUtil.BROADCAST_ACTION_KILL_PREVIOUS_ACTIVIES);
        intentFilter.addAction(LWUtil.BROADCAST_ACTION_KILL_HOME_ACTIVITY);
        registerReceiver(broadcastReceiver, intentFilter);

    }

    @Override
    protected void onResume() {
        super.onResume();
        if(headerTextView.getText().equals(R.string.summaryText)){
            clearPreviousBackStackTillHomeActivity();
        }
        else if (headerTextView.getText().equals(R.string.addInfoText)){
            clearPreviousBackStackTillHomeActivity();
        }
        LWUtil.access_Token = LWPrefs.getString(getActivity(), LWPrefs.KEY_TOKEN, "");
        if (LWUtil.access_Token.isEmpty()) {
            menuLogoutTextView.setVisibility(View.GONE);
            menuMyOrderTextView.setVisibility(View.GONE);
            myOrderView.setVisibility(View.GONE);
        } else {
            menuLogoutTextView.setVisibility(View.VISIBLE);
            menuMyOrderTextView.setVisibility(View.VISIBLE);
            myOrderView.setVisibility(View.VISIBLE);
        }

        showTitle();
    }

    private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(LWUtil.BROADCAST_ACTION_KILL_PREVIOUS_ACTIVIES)) {
                HomeActivity.this.finish();
            }
            else if (intent.getAction().equals(LWUtil.BROADCAST_ACTION_KILL_HOME_ACTIVITY)) {
                HomeActivity.this.finish();
            }
        }
    };

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(broadcastReceiver);
    }
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.menuImageView:
                toggleMenu();
                break;
            case R.id.backImageView:
                if (isBackArrowOnWhereFragment == true) {
                    finish();
                } else {
                    isBackArrowOnWhereFragment = false;
                    getSupportFragmentManager().popBackStack();
                }
                break;
            case R.id.menuPickupTextView:
//                if(headerTextView.getText().equals("Where?")){
//                    if(fragmentName==PriceListFragment.TAG){
//
//                        getSupportFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
//                    }
//                    toggleMenu();
//                    clearPreviousBackStackTillHomeActivity();
//                    replaceFragment(R.id.fragmentContainerLayout, new WhereFragment(), WhereFragment.TAG, true);
//                } else {


                if(headerTextView.getText().equals(SummaryFragment.TAG)){
                    clearPreviousBackStackTillHomeActivity();
                }
                else if (headerTextView.getText().equals(AddContactInfoFragment.TAG)){
                    clearPreviousBackStackTillHomeActivity();
                }

                if (LWUtil.access_Token.isEmpty()){
                    headerTextView.setText(R.string.whereText);
//                    clearPreviousBackStackTillHomeActivity();
                        replaceFragment(R.id.fragmentContainerLayout, new WhereFragment(), WhereFragment.TAG, true);


                    toggleMenu();
                    LWUtil.isFromMenu = false;
//                    getSupportFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);

                } else {
                    if (fragmentName == null) {
                        clearPreviousBackStackTillHomeActivity();
//                        replaceFragment(R.id.fragmentContainerLayout, new WhereFragment(), WhereFragment.TAG, true);
                        headerTextView.setText(R.string.whereText);

                        toggleMenu();
                        LWUtil.isFromMenu = false;
                        isFromOtherMenu = false;

                    }
                    if (isFromOtherMenu == true) {
                        if (fragmentName.equals(PriceListFragment.TAG) || fragmentName.equals(MyOrderFragment.TAG)
                                || fragmentName.equals(FeedBackFragment.TAG) || fragmentName.equals(FAQFragment.TAG)
                                || fragmentName.equals(TermsAndPoliciesFragment.TAG)
                                || fragmentName.equals(SummaryFragment.TAG)
                                || fragmentName.equals(AddContactInfoFragment.TAG)) {
                            toggleMenu();
                            clearPreviousBackStackTillHomeActivity();
//                            getSupportFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                            isFromOtherMenu = false;
                            finish();
                            headerTextView.setText(R.string.whereText);
                        }
                    } else {

                        clearPreviousBackStackTillHomeActivity();
//                        replaceFragment(R.id.fragmentContainerLayout, new WhereFragment(), WhereFragment.TAG, true);
                        headerTextView.setText(R.string.whereText);

                        toggleMenu();
                        LWUtil.isFromMenu = false;
                        isFromOtherMenu = false;
                    }

                }
                break;
            case R.id.menuMyOrderTextView:
//                clearPreviousBackStackTillHomeActivity();
//                if(headerTextView.getText()=="Order Status"){
//                    toggleMenu();
//                } else {
//                    toggleMenu();
                clearPreviousBackStackTillHomeActivity();
                    replaceFragment(R.id.fragmentContainerLayout, new MyOrderFragment(), MyOrderFragment.TAG, true);
                toggleMenu();
                break;
            case R.id.menuPriceTextView:
//                if(headerTextView.getText().equals("Price List")){
//                    toggleMenu();
//                } else {
                clearPreviousBackStackTillHomeActivity();

                    replaceFragment(R.id.fragmentContainerLayout, new PriceListFragment(), PriceListFragment.TAG, true);

                toggleMenu();

                break;
            case R.id.menuHowItWorksTextView:
                clearPreviousBackStackTillHomeActivity();
//                toggleMenu();
//                startActivity(new Intent(this,HowItWorksActivity.class));
//                Toast.makeText(this,"How it works",Toast.LENGTH_LONG).show();
//                HomeActivity.this.finish();

                if(LWUtil.access_Token.isEmpty()){
                    LWUtil.isFromMenu = false;
                    startActivity(new Intent(this, DemoActivity.class));
                    toggleMenu();
                }else {
                    LWUtil.isFromMenu = true;
                    startActivity(new Intent(this, DemoActivity.class));
                    toggleMenu();
                }
                break;
            case R.id.menuFeedbackTextView:

                clearPreviousBackStackTillHomeActivity();

                replaceFragment(R.id.fragmentContainerLayout, new FeedBackFragment(), FeedBackFragment.TAG, true);
                toggleMenu();
                fragmentContainerLayout.requestDisallowInterceptTouchEvent(true);
//                clearPreviousBackStackTillHomeActivity();
                break;
            case R.id.menuLogoutTextView:
                showLogoutAlert();
                break;
            case R.id.crossImageView:
                toggleMenu();
                break;
            case R.id.menuFAQTextView:
//                if(headerTextView.getText().equals("FAQ.")){
//                    toggleMenu();
//                } else {
                clearPreviousBackStackTillHomeActivity();
                    replaceFragment(R.id.fragmentContainerLayout, new FAQFragment(), FAQFragment.TAG, true);
//                    clearPreviousBackStackTillHomeActivity();
                    toggleMenu();
//                }
                break;
            case R.id.menuTermsAndPoliciesTextView:
//                if(headerTextView.getText().equals("Terms and Policies")){
//                    toggleMenu();
//                } else {
                clearPreviousBackStackTillHomeActivity();
                    replaceFragment(R.id.fragmentContainerLayout, new TermsAndPoliciesFragment(), TermsAndPoliciesFragment.TAG, true);
//                    clearPreviousBackStackTillHomeActivity();
                    toggleMenu();

                break;
            case R.id.menuCallImageView:
                dialNumber();
                break;
            case R.id.menuFaceBookImageView:
                fbPageLink();
                break;
            case R.id.menuInstagramImageView:
                instagramPageLink();
                break;
        }
    }

    public void setTitle(String text) {
        headerTextView.setText(text);
    }

    public void showTitle() {
        headerTextView.setVisibility(View.VISIBLE);
        menuImageView.setVisibility(View.VISIBLE);

    }
    public void hideTitle() {
        headerTextView.setVisibility(View.INVISIBLE);
    }
    public void instagramPageLink(){
        Uri uri = Uri.parse("http://instagram.com//laundrywalaz");
        Intent insta = new Intent(Intent.ACTION_VIEW, uri);
        insta.setPackage("com.instagram.android");
        if (isIntentAvailable(this, insta)){
            startActivity(insta);
        } else {
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://instagram.com/laundrywalaz")));
        }
    }

    private boolean isIntentAvailable(Context ctx, Intent intent) {
        final PackageManager packageManager = ctx.getPackageManager();
        List<ResolveInfo> list = packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
        return list.size() > 0;
    }
    //    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        unregisterReceiver(broadcastReceiver);
//    }
//
//    private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            if (intent.getAction().equals(LWUtil.BROADCAST_ACTION_LOGOUT)) {
//                logOut();
//            }
//
//
//        }
//    };


    public void fbPageLink(){

        Intent facebookIntent = new Intent(Intent.ACTION_VIEW);
        String facebookUrl = getFacebookPageURL(this);
        facebookIntent.setData(Uri.parse(facebookUrl));
        startActivity(facebookIntent);
    }
    //method to get the right URL to use in the intent
    public String getFacebookPageURL(Context context) {
        PackageManager packageManager = context.getPackageManager();
        try {
            int versionCode = packageManager.getPackageInfo("com.facebook.katana", 0).versionCode;
            if (versionCode >= 3002850) { //newer versions of fb app
                return "fb://facewebmodal/f?href=" + FACEBOOK_URL;
            } else { //older versions of fb app
                return "fb://page/" + FACEBOOK_PAGE_ID;
            }
        } catch (PackageManager.NameNotFoundException e) {
            return FACEBOOK_URL; //normal web url
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
    public void logOut() {
        try {

//            AlbumListingFragment.clearCache();

        } catch (Exception e) {}
        clearPreviousBackStackTillHomeActivity();
        LWPrefs.clearSharedPreferences(this);
        Intent intent = new Intent(this, DemoActivity.class);
        startActivity(intent);
        finish();
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

    private void clearPreviousBackStackTillHomeActivity() {
        getSupportFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
        LWUtil.doSoftInputHide(this);
    }


    public void dialNumber(){

        Intent intent = new Intent(Intent.ACTION_DIAL);
        intent.setData(Uri.parse("tel:042 36688830-31"));
//                if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
//                    // TODO: Consider calling
//                    //    ActivityCompat#requestPermissions
//                    // here to request the missing permissions, and then overriding
//                    //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
//                    //                                          int[] grantResults)
//                    // to handle the case where the user grants the permission. See the documentation
//                    // for ActivityCompat#requestPermissions for more details.
//                    return;
//                }
        startActivity(intent);
    }

    public void registerBackStackListener() {
        getSupportFragmentManager().addOnBackStackChangedListener(new FragmentManager.OnBackStackChangedListener() {
            @Override
            public void onBackStackChanged() {
                int count = getSupportFragmentManager().getBackStackEntryCount();
                if (count > 0) {
                    FragmentManager.BackStackEntry backStackEntry = getSupportFragmentManager().getBackStackEntryAt(count - 1);

                    //Pop previous fragment if needed
                    if (fragmentName != null && (fragmentName == WhereFragment.TAG ||
                            fragmentName == WhenFragment.TAG || fragmentName == PriceListFragment.TAG ||
                            fragmentName == FeedBackFragment.TAG || fragmentName == MyOrderFragment.TAG
                    || fragmentName == FAQFragment.TAG || fragmentName == TermsAndPoliciesFragment.TAG)) {
                    }
                    fragmentName = backStackEntry.getName();
                    BaseFragment baseFragment = (BaseFragment) getSupportFragmentManager().findFragmentByTag(fragmentName);
                    if(baseFragment != null) {
//                        baseFragment.onVisible();
                    }

                    Log.i("Top Fragment: " , fragmentName);

                    if (fragmentName.equals(WhereFragment.TAG)) {
                        headerTextView.setText(R.string.whereText);
                        backImageView.setVisibility(View.VISIBLE);
                        isBackArrowOnWhereFragment=true;
                    } else if (fragmentName.equals(WhenFragment.TAG)) {
                        headerTextView.setText(R.string.whenText);
                        backImageView.setVisibility(View.VISIBLE);
                    } else if (fragmentName.equals(FeedBackFragment.TAG)) {
                        headerTextView.setText(R.string.menuFeedBack);
                    } else if(fragmentName.equals(MyOrderFragment.TAG)){
                        headerTextView.setText(R.string.orderStatus);
                    } else if(fragmentName.equals(PriceListFragment.TAG)){
                        headerTextView.setText(R.string.menuPricing);
                    } else if (fragmentName.equals(AddContactInfoFragment.TAG)){
                        headerTextView.setText(R.string.addInfoText);
                        backImageView.setVisibility(View.VISIBLE);
                    } else if (fragmentName.equals(FAQFragment.TAG)){
                        headerTextView.setText(R.string.menuFAQ);
                    }else if (fragmentName.equals(TermsAndPoliciesFragment.TAG)){
                        headerTextView.setText(R.string.menuTermsAndPolicies);
                    }else if (fragmentName.equals(SummaryFragment.TAG)){
                        headerTextView.setText(R.string.summaryText);
                    }
                    else {}
                    if(fragmentName.equals(AddContactInfoFragment.TAG)){
                        backImageView.setVisibility(View.VISIBLE);
                        menuImageView.setVisibility(View.VISIBLE);
                    }else {
                        backImageView.setVisibility(View.INVISIBLE);
                        menuImageView.setVisibility(View.VISIBLE);
                    }

//                    if (fragmentName.equals(HelpFragment.TAG) ||
//                            fragmentName.equals(PricingFragment.TAG) ||
//                            fragmentName.equals(PrivacyFragment.TAG) ||
//                            fragmentName.equals(TCFragment.TAG) ||
//                            fragmentName.equals(AddContactInfoFragment.TAG)||
//                            fragmentName.equals(ConfirmationFragment.TAG)) {
//                        pricingImageView.setVisibility(View.INVISIBLE);
//                    } else {
//                        pricingImageView.setVisibility(View.VISIBLE);
//                        menuImageView.setVisibility(View.VISIBLE);
//                        backImageView.setVisibility(View.INVISIBLE);
//                        headerTextView.setText(R.string.newOrder);
//                    }
                } else {

                    menuImageView.setVisibility(View.VISIBLE);
                    backImageView.setVisibility(View.INVISIBLE);
                    headerTextView.setText(R.string.whereText);
                    headerTextView.setVisibility(View.VISIBLE);
                }
//                headerTextView.setText(R.string.whereText);
//                headerTextView.setVisibility(View.VISIBLE);
            }
        });
    }


    public void clearPreviousBackStackTillTimeLine() {
        getSupportFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
        LWUtil.doSoftInputHide(this);
    }

}
