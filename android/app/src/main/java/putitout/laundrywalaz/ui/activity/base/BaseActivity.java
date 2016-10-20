package putitout.laundrywalaz.ui.activity.base;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;

import putitout.laundrywalaz.R;


/**
 * Created by Ehsan Aslam on 5/27/2016.
 */
public abstract class BaseActivity extends FragmentActivity {

    public ProgressDialog progressDialog;
    private static FragmentActivity activity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        overridePendingTransition(0, 0);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        overridePendingTransition(0, 0);
    }

    @Override
    protected void onStart() {
        super.onStart();
        activity = this;
    }

    public abstract void initWidget();

    public void replaceFragment(int contentId, Fragment fragment, String fragmentTag, boolean addToBackStack) {
        FragmentManager fragmentManager = getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.replace(contentId, fragment, fragmentTag);
        if(addToBackStack) {
            fragmentTransaction.addToBackStack(fragmentTag);
        }
        fragmentTransaction.commit();
    }

    public ProgressDialog getProgressDialog() {
        if (progressDialog == null) {
            progressDialog = new ProgressDialog(this);
            progressDialog.setMessage(getString(R.string.loading));
            progressDialog.setCancelable(true);
        }
        return progressDialog;
    }

    public static FragmentActivity getActivity() {
        return activity;
    }

}
