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
 * Created by Ehsan Aslam on 7/22/2016.
 */
public class FAQFragment extends BaseFragment implements View.OnClickListener {

    public static final String TAG = FAQFragment.class.getSimpleName();
    private WebView faqsWebView;
    private HomeActivity homeActivity;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_faqs,container,false);
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
        homeActivity.setTitle(getString(R.string.menuFAQ));
        faqsWebView = (WebView) view.findViewById(R.id.faqsWebView);
        WebSettings webSettings = faqsWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        faqsWebView.loadUrl("file:///android_asset/faqs.html");
    }

    @Override
    public void onClick(View v) {

    }
}
