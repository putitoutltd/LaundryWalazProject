package putitout.laundrywalaz.webservices;

import android.content.Context;

import org.apache.http.NameValuePair;

import java.util.ArrayList;

import putitout.laundrywalaz.interfaces.OnWebServiceResponse;
import putitout.laundrywalaz.network.NetworkMananger;
import putitout.laundrywalaz.utils.LWUtil;


public class APIWebService extends BaseAsyncTask<String,Void, String>{
    private OnWebServiceResponse listnerOnWebServiceResponse;
    private Context context;
    private int requestCode;
    private ArrayList<NameValuePair> params;
    private int requestType;
    private String url;

    public void setOnWebServiceResponseListener (OnWebServiceResponse onwebServiceResponseListener) {
     this.listnerOnWebServiceResponse = onwebServiceResponseListener;
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        listnerOnWebServiceResponse.onStartWebService(requestCode);
    }

    @Override
    protected String doInBackground(String... strings) {
        String response = null;
        try {
            response = NetworkMananger.getApiResponse(url, params, requestType);
            response = response.replace("null", "0");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    @Override
    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        boolean isJsonResponse = LWUtil.isJsonResponse(result);
        listnerOnWebServiceResponse.onCompletedWebService(result, requestCode, isJsonResponse);
    }

    public APIWebService(Context context, int requestCode, ArrayList<NameValuePair> param, int requestType, String url) {
        this.context = context;
        this.requestCode = requestCode;
        this.params = param;
        this.requestType = requestType;
        this.url = url;
    }
}
