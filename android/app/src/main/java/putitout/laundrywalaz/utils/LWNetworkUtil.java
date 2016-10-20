package putitout.laundrywalaz.utils;

import android.app.Application;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.webkit.URLUtil;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Ehsan Aslam
 *
 * A collection of network related utilities and constants.
 *
 */
public class LWNetworkUtil {

	//Connection Properties
	public static final String PROPERTY_USER_AGENT = "User-Agent";
	public static final String PROPERTY_CONTENT_TYPE = "Content-Type";
	public static final String PROPERTY_SOAP_ACTION = "SOAPAction";
	public static final String PROPERTY_AUTHORIZATION = "Authorization";

	/**
	 * Checks if a network connection is available.
	 * 
	 * @param context
	 * @return true if connect is available
	 */
	public static boolean isNetworkAvailable(final Context context) {
		final ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		final NetworkInfo networkInfo = cm.getActiveNetworkInfo();
		return (networkInfo != null && networkInfo.isConnected());
	}

	/**
	 * Disables HTTP connection reuse in FROYO and below, as it was buggy From:
	 * http://android-developers.blogspot.com/2011/09/androids-http-clients.html
	 */
	public static void disableConnectionReuseIfNecessary() {
		// HTTP connection reuse which was buggy pre-froyo
		if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.FROYO) {
			System.setProperty("http.keepAlive", "false");
		}
	}

	/**
	 * Enables built-in http cache beginning in ICS From:
	 * http://android-developers.blogspot.com/2011/09/androids-http-clients.html
	 * 
	 * @param application
	 */
	public static void enableHttpResponseCache(final Application application) {
		try {
			final long httpCacheSize = 10 * 1024 * 1024; // 10 MiB
			final File httpCacheDir = new File(application.getCacheDir(), "http");
			Class.forName("android.net.http.HttpResponseCache").getMethod("install", File.class, long.class).invoke(null, httpCacheDir, httpCacheSize);
		} catch (final Exception httpResponseCacheNotAvailable) {}
	}

	/** converts hashmap to QueryString */
	public static String generateQueryString(HashMap<String, String> hashmap) {
		List<String> parameterNames = new ArrayList<String>(hashmap.keySet());
		Collections.sort(parameterNames);
		boolean first = true;
		String queryString = "";
		for(String name: parameterNames) {
			if (!first) queryString += "&";
			queryString = queryString + name + "=" + hashmap.get(name);
			first = false;
		}
		return queryString;
	}

	/**
	 * 
	 * @return
	 */
	public static String getSoapContentType() {
        return "application/soap-xml; charset=utf-8";
	}

	/**
	 * 
	 * @param url
	 * @return
	 */
	public static boolean isValidUrl(String url) {
		boolean isValidUrl = URLUtil.isValidUrl(url);
		boolean isValidUrlSyntax;
		try {
			URL u = new URL(url);
			u.toURI();
			isValidUrlSyntax = true;
		} catch (URISyntaxException e) {
			isValidUrlSyntax = false;
		} catch (MalformedURLException e) {
			isValidUrlSyntax = false;
		}
		return isValidUrl && isValidUrlSyntax;		
	}

	public static String getDomainName(String url) {
		try {
			URI uri = new URI(url);
			return uri.getHost();
		} catch (URISyntaxException e) {
			e.printStackTrace();
			return url;
		}	    
	}

	/** returns true if Wifi is connected */
	public static boolean isWiFiConnected(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo info = cm.getActiveNetworkInfo();
		if (info == null) return false;
		if (info.getType() == ConnectivityManager.TYPE_WIFI) return info.isConnected();
		return false;
	}

	/** returns true if the SIM card supports 3G */
	public static boolean is3GAvailable(Context context) {
		TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
		if (tm.getSimState() != TelephonyManager.SIM_STATE_READY) {
			return false;
		}

		int type = tm.getNetworkType();
		if (type == TelephonyManager.NETWORK_TYPE_HSDPA
				|| type == TelephonyManager.NETWORK_TYPE_HSPA
				|| type == TelephonyManager.NETWORK_TYPE_HSUPA
				|| type == TelephonyManager.NETWORK_TYPE_UMTS
				|| type == TelephonyManager.NETWORK_TYPE_EVDO_0
				|| type == TelephonyManager.NETWORK_TYPE_EVDO_A) {
			return true;
		}
		return false;
	}

	/** returns true if device is currently connected to 3G */
	public static boolean is3GConnected(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo info = cm.getActiveNetworkInfo();
		if (info == null) return false;
		if (isConnectivityTypeMobile(info.getType())) return info.isConnected();
		return false;
	}

	public static boolean isConnectivityTypeMobile(int type) {
		if (type == ConnectivityManager.TYPE_MOBILE) return true;
		if (type == ConnectivityManager.TYPE_MOBILE_DUN) return true;
		if (type == ConnectivityManager.TYPE_MOBILE_HIPRI) return true;
		if (type == ConnectivityManager.TYPE_MOBILE_MMS) return true;
		if (type == ConnectivityManager.TYPE_MOBILE_SUPL) return true;
		return false;
	}

	/** Returns true if device is connected to Internet */
	public static boolean isConnected(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo info = cm.getActiveNetworkInfo();
		if (info == null) return false;
		return info.isConnected();
	}


}