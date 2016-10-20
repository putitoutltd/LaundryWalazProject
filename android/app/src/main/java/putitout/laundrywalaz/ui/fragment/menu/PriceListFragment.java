package putitout.laundrywalaz.ui.fragment.menu;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ListView;

import java.util.ArrayList;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.adapter.PriceListAdapter;
import putitout.laundrywalaz.interfaces.OnWebServiceResponse;
import putitout.laundrywalaz.model.Parser;
import putitout.laundrywalaz.model.PriceModel;
import putitout.laundrywalaz.network.NetworkMananger;
import putitout.laundrywalaz.network.NetworkUtil;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceTextView;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
public class PriceListFragment extends BaseFragment implements OnWebServiceResponse {

    public static final String TAG = PriceListFragment.class.getSimpleName();

    private static final int SERVICE_LIST = 1;

    private ListView menListView;
    private ListView womenListView;
    private ListView bedListView;
    private ListView otherItemListView;

    private TypefaceTextView priceStaticTextView;

    private ArrayList<PriceModel> menList = new ArrayList<PriceModel>();
    private ArrayList<PriceModel> womenList = new ArrayList<PriceModel>();
    private ArrayList<PriceModel> bedList = new ArrayList<PriceModel>();
    private ArrayList<PriceModel> otherItemsList = new ArrayList<PriceModel>();

    private PriceListAdapter priceListAdapter;

    ProgressDialog progressDialog;

    private HomeActivity homeActivity;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_pricing_list,container,false);
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
        homeActivity.setTitle(getString(R.string.menuPricing));

        priceStaticTextView = (TypefaceTextView) view.findViewById(R.id.priceStaticTextView);


        menListView = (ListView) view.findViewById(R.id.menListView);
        menListView.setScrollContainer(false);
        menListView.setClickable(false);
        menListView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                int action = event.getAction();
                switch (action) {
                    case MotionEvent.ACTION_DOWN:
                        // Disallow ScrollView to intercept touch events.
                        menListView.requestDisallowInterceptTouchEvent(false);
                        break;

                    case MotionEvent.ACTION_UP:
                        // Allow ScrollView to intercept touch events.
                        v.getParent().requestDisallowInterceptTouchEvent(false);
                        break;
                }

                // Handle ListView touch events.
                v.onTouchEvent(event);
                return true;
            }
        });

        womenListView = (ListView) view.findViewById(R.id.womenListView);
        womenListView.setScrollContainer(false);
        womenListView.setClickable(false);

        womenListView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                int action = event.getAction();
                switch (action) {
                    case MotionEvent.ACTION_DOWN:
                        // Disallow ScrollView to intercept touch events.
                        womenListView.requestDisallowInterceptTouchEvent(false);
                        break;

                    case MotionEvent.ACTION_UP:
                        // Allow ScrollView to intercept touch events.
                        v.getParent().requestDisallowInterceptTouchEvent(false);
                        break;
                }
                // Handle ListView touch events.
                v.onTouchEvent(event);
                return true;
            }
        });
        bedListView = (ListView) view.findViewById(R.id.bedListView);
        otherItemListView = (ListView) view.findViewById(R.id.otherItemListView);
        showPriceList();
    }

    private void showPriceList() {
        if (NetworkUtil.checkIfNetworkAvailable(getActivity())) {
            menListView.setVisibility(View.VISIBLE);
            womenListView.setVisibility(View.VISIBLE);
            bedListView.setVisibility(View.VISIBLE);
            otherItemListView.setVisibility(View.VISIBLE);
            priceStaticTextView.setVisibility(View.VISIBLE);
            NetworkMananger.serviceListApi(getActivity(), this, SERVICE_LIST);
        } else {
            LWUtil.showNetworkErrorAlertDialog(getActivity());
            menListView.setVisibility(View.GONE);
            womenListView.setVisibility(View.GONE);
            bedListView.setVisibility(View.GONE);
            otherItemListView.setVisibility(View.GONE);
        }
    }

    private void parseServiceList(Parser parser) {
        if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_FAILURE)) {
            menListView.setVisibility(View.GONE);
            womenListView.setVisibility(View.GONE);
            bedListView.setVisibility(View.GONE);
            otherItemListView.setVisibility(View.GONE);
            priceStaticTextView.setVisibility(View.GONE);
            if (parser.getMessage().equals(getString(R.string.invalidAccessToken))) {
                LWUtil.showInvalidAccessTokenAlert(getActivity());
            }else if(parser.getMessage().equals("Server is not responding")){
                menListView.setVisibility(View.GONE);
                womenListView.setVisibility(View.GONE);
                bedListView.setVisibility(View.GONE);
                otherItemListView.setVisibility(View.GONE);
                priceStaticTextView.setVisibility(View.GONE);
            } else {
                LWUtil.showAlert(getActivity(), parser.getMessage());
            }
        } else if (parser.getStatus().equals(LWUtil.KEY_SERVER_RESPONSE_SUCCESS)) {
            menListView.setVisibility(View.VISIBLE);
            womenListView.setVisibility(View.VISIBLE);
            bedListView.setVisibility(View.VISIBLE);
            otherItemListView.setVisibility(View.VISIBLE);
            priceStaticTextView.setVisibility(View.VISIBLE);

            menList = new ArrayList<PriceModel>();
            menList = parser.getMenPricingList();

            priceListAdapter = new PriceListAdapter(getActivity(), menList);
            menListView.setAdapter(priceListAdapter);

            womenList = new ArrayList<PriceModel>();
            womenList = parser.getWomenPricingList();

            if (womenList != null) {
                priceListAdapter = new PriceListAdapter(getActivity(),womenList);
                womenListView.setAdapter(priceListAdapter);
            }

            bedList = new ArrayList<PriceModel>();
            bedList = parser.getBedPricingList();

            if (bedList != null) {
                priceListAdapter = new PriceListAdapter(getActivity(), bedList);
                bedListView.setAdapter(priceListAdapter);
            }

            otherItemsList = new ArrayList<PriceModel>();
            otherItemsList = parser.getOtherItemsPricingList();

            if (otherItemListView != null) {
                priceListAdapter = new PriceListAdapter(getActivity(),otherItemsList);
                otherItemListView.setAdapter(priceListAdapter);
            }
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
                case SERVICE_LIST:
                    parseServiceList(parser);
                    break;
            }
        }
    }
}
