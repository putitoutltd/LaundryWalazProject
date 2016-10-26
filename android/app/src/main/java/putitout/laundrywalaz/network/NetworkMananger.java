package putitout.laundrywalaz.network;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Build;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpEntityEnclosingRequestBase;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.ArrayList;

import putitout.laundrywalaz.interfaces.OnWebServiceResponse;
import putitout.laundrywalaz.model.OrderModel;
import putitout.laundrywalaz.model.UserModel;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.utils.URLManager;
import putitout.laundrywalaz.webservices.APIWebService;


@SuppressWarnings("ALL")
public class NetworkMananger {
    public static final int HTTP_GET_REQUEST_TYPE = 0;
    public static final int HTTP_POST_REQUEST_TYPE = 1;
    public static final int HTTP_PUT_REQUEST_TYPE = 2;
    public static final int HTTP_DELETE_REQUEST_TYPE = 3;

    public static String getApiResponse(String url, ArrayList<NameValuePair> parameters,
                                        int requestType) throws Exception {
        BufferedReader bufferReader = null;
        String result = LWUtil.KEY_SERVER_NO_RESPONSE;
        try {
            HttpResponse response = getHttpResponse(url, parameters, requestType);
            bufferReader = new BufferedReader(new InputStreamReader(response
                    .getEntity().getContent()));
            StringBuffer stringBuffer = new StringBuffer("");
            String line = "";
            String lineSeparator = System.getProperty("line.separator");
            while ((line = bufferReader.readLine()) != null) {
                stringBuffer.append(line + lineSeparator);
            }
            bufferReader.close();
            result = stringBuffer.toString();
        } catch (ClientProtocolException e) {
            e.printStackTrace();
            result = LWUtil.KEY_SERVER_NO_RESPONSE;
        } catch (IOException io) {
            if (bufferReader != null) {
                try {
                    bufferReader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            io.printStackTrace();
            result = LWUtil.KEY_SERVER_NO_RESPONSE;
        } catch (Exception e) {
            e.printStackTrace();
            result = LWUtil.KEY_SERVER_NO_RESPONSE;
        }
        return result;
    }



    public static HttpResponse getHttpResponse(String webUrl, ArrayList<NameValuePair> parameters,
                                               int requestCode) throws Exception {
        HttpClient httpClient = new DefaultHttpClient();

        HttpResponse response = null;
        HttpGet httpGet = null;
        HttpEntityEnclosingRequestBase request = null;
        switch (requestCode) {
            case HTTP_GET_REQUEST_TYPE:
                httpGet = new HttpGet();
                break;
            case HTTP_POST_REQUEST_TYPE:
                request = new HttpPost(webUrl);
                break;
            case HTTP_PUT_REQUEST_TYPE:
                request = new HttpPut(webUrl);
                break;
            case HTTP_DELETE_REQUEST_TYPE:
                request = new HttpDeleteWithBody(
                        webUrl);
                break;
        }
        if (requestCode != HTTP_GET_REQUEST_TYPE) {
            request.addHeader("auth-token",
                    LWUtil.AUTH_TOKEN_KEY);
            UrlEncodedFormEntity urlEncodedFormEntitiy = new UrlEncodedFormEntity(parameters,
                    HTTP.UTF_8);
            request.setEntity(urlEncodedFormEntitiy);
            response = httpClient.execute(request);
        } else {
            String parametsString = "?";
            for(NameValuePair nameValuePair : parameters) {
                parametsString += (nameValuePair.getName() +"="+nameValuePair.getValue() + "&");
            }
            parametsString = parametsString.substring(0, parametsString.length()-1);
            URI website = new URI(webUrl + parametsString);
            httpGet.setURI(website);
            response = httpClient.execute(httpGet);
        }
        return response;
    }

    private static void sendApiRequest(Context context, int requestCode, ArrayList<NameValuePair>
            params, OnWebServiceResponse listener, int requestType, String url) {
        APIWebService apiWebService = new APIWebService(
                context, requestCode, params, requestType, url);
        apiWebService.setOnWebServiceResponseListener(listener);
        startAsyncTaskInParallel(apiWebService);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    private static void startAsyncTaskInParallel(APIWebService task) {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            task.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
        }
        else {
            task.execute();
        }
    }

    public static class HttpDeleteWithBody extends HttpEntityEnclosingRequestBase {
        public static final String METHOD_NAME = "DELETE";

        public String getMethod() {
            return METHOD_NAME;
        }

        public HttpDeleteWithBody(final String uri) {
            super();
            setURI(URI.create(uri));
        }

        public HttpDeleteWithBody(final URI uri) {
            super();
            setURI(uri);
        }

        public HttpDeleteWithBody() {
            super();
        }
    }

    public static final void createNewUserApi(Context context, OnWebServiceResponse webserviceResponseListener,
                                              int requestCode, UserModel model) {

        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair(LWUtil.KEY_FIRST_NAME,
                model.getFirstName()));
        params.add(new BasicNameValuePair(LWUtil.KEY_ADDRESS,
                model.getAddress()));
//        params.add(new BasicNameValuePair(LWUtil.KEY_LOCATION_ID,
//                model.getLocationId()));
        params.add(new BasicNameValuePair(LWUtil.KEY_LAST_NAME,
                model.getLastName()));
        params.add(new BasicNameValuePair(LWUtil.KEY_EMAIL,
                model.getEmailAddress()));
        params.add(new BasicNameValuePair(LWUtil.KEY_PHONE,
                model.getPhone()));
        params.add(new BasicNameValuePair(LWUtil.KEY_PASSWORD,
               model.getPassword()));
//        params.add(new BasicNameValuePair(LWUtil.KEY_STATUS,
//                model.getStatus() + ""));
        sendApiRequest(context, requestCode, params, webserviceResponseListener,
                NetworkMananger.HTTP_POST_REQUEST_TYPE, URLManager.REGISTER_USER);
    }

    public static void loginUserApi(Context context, String email, String password, OnWebServiceResponse
            webServiceResponse, int requestCode) {
        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair(LWUtil.KEY_EMAIL, email));
        params.add(new BasicNameValuePair(LWUtil.KEY_PASSWORD, password));
        sendApiRequest(context, requestCode, params, webServiceResponse,
                NetworkMananger.HTTP_POST_REQUEST_TYPE, URLManager.LOGIN_USER);
    }

    public static void forgotPasswordApi(Context context, String email, OnWebServiceResponse
            webServiceResponse, int requestCode) {
        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair(LWUtil.KEY_EMAIL, email));
        sendApiRequest(context, requestCode, params, webServiceResponse,
                NetworkMananger.HTTP_POST_REQUEST_TYPE, URLManager.FORGET_PASSWORD);
    }

    public static void createOrderApi(Context context, OnWebServiceResponse
            webServiceResponse, int requestCode, OrderModel orderModel) {
        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair(LWUtil.KEY_FIRST_NAME,
                orderModel.getFirstName()));
        params.add(new BasicNameValuePair(LWUtil.KEY_ADDRESS,
                orderModel.getAddress()));
        params.add(new BasicNameValuePair(LWUtil.KEY_LOCATION_ID,
                orderModel.getLocationId()));
        params.add(new BasicNameValuePair(LWUtil.KEY_ADDRESS,
                orderModel.getAddress()));
        params.add(new BasicNameValuePair(LWUtil.KEY_ACCESS_TOKEN,
                orderModel.getAccessToken()));
        params.add(new BasicNameValuePair(LWUtil.KEY_LAST_NAME,
                orderModel.getLastName()));
        params.add(new BasicNameValuePair(LWUtil.KEY_EMAIL,
                orderModel.getEmailAddress()));
        params.add(new BasicNameValuePair(LWUtil.KEY_PHONE,
                orderModel.getPhone()));
        params.add(new BasicNameValuePair(LWUtil.KEY_PICK_UP_TIME,
                orderModel.getPickup_time()));
        params.add(new BasicNameValuePair(LWUtil.KEY_DROP_OFF_TIME,
                orderModel.getDropoff_time()));
        sendApiRequest(context, requestCode, params, webServiceResponse,
                NetworkMananger.HTTP_POST_REQUEST_TYPE, URLManager.CREATE_ORDER);
    }

    public static void orderStatusApi(Context context, String access_token, OnWebServiceResponse
            webServiceResponse, int requestCode) {
        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair(LWUtil.KEY_ACCESS_TOKEN, access_token));
        sendApiRequest(context, requestCode, params, webServiceResponse,
                NetworkMananger.HTTP_POST_REQUEST_TYPE, URLManager.ORDER_STATUS);
    }

    public static void feedBackApi(Context context, String about, String feedback, String customerName, String orderID, OnWebServiceResponse onWebServiceResponse, int requestCode){
        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair(LWUtil.KEY_ABOUT, about));
        params.add(new BasicNameValuePair(LWUtil.KEY_FEEDBACK, feedback));
        params.add(new BasicNameValuePair(LWUtil.KEY_CUSTOMER_NAME, customerName));
        params.add(new BasicNameValuePair(LWUtil.KEY_ORDER_ID, orderID));
        sendApiRequest(context, requestCode, params, onWebServiceResponse,
                NetworkMananger.HTTP_GET_REQUEST_TYPE, URLManager.FEED_BACK);
    }

    public static void serviceListApi(Context context, OnWebServiceResponse onWebServiceResponse, int requestCode){
        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        sendApiRequest(context, requestCode, params, onWebServiceResponse,
                NetworkMananger.HTTP_GET_REQUEST_TYPE, URLManager.SERVICE_LIST);
    }
}
