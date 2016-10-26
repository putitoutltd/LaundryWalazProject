package putitout.laundrywalaz.ui.fragment.policy;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.webkit.WebSettings;
import android.webkit.WebView;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;

/**
 * Created by Ehsan Aslam on 7/26/2016.
 */
public class TermsAndPoliciesFragment extends BaseFragment implements View.OnClickListener {

    public static final String TAG = TermsAndPoliciesFragment.class.getSimpleName();
    private WebView termsAndPoliciesWebView;
    private HomeActivity homeActivity;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_terms_and_policies,container,false);
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
        homeActivity.setTitle(getString(R.string.menuTermsAndPolicies));
        termsAndPoliciesWebView = (WebView) view.findViewById(R.id.termsAndPoliciesWebView);
        WebSettings webSettings = termsAndPoliciesWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        termsAndPoliciesWebView.loadUrl("file:///android_asset/terms.html");
    }

    @Override
    public void onClick(View v) {
    }
}
