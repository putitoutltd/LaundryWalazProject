package putitout.laundrywalaz.network;

import android.content.Context;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

public class NetworkUtil {

	public static boolean checkIfNetworkAvailable(Context context) {
		if(context !=null && context.getResources()!=null) {
			ConnectivityManager cm = (ConnectivityManager) context
					.getSystemService(Context.CONNECTIVITY_SERVICE);
			NetworkInfo wifiNetwork = cm
					.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
			if (wifiNetwork != null && wifiNetwork.isConnected()) {
				return true;
			}
			NetworkInfo mobileNetwork = cm
					.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
			if (mobileNetwork != null && mobileNetwork.isConnected()) {
				return true;
			}
			NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
			if (activeNetwork != null && activeNetwork.isConnected()) {
				return true;
			}
		}
		return false;
	}

	public static boolean isGPSEnabled(Context context) {
		boolean GPSenabled = false;
		LocationManager GPSLocation = (LocationManager) context
				.getSystemService(Context.LOCATION_SERVICE);
		if (GPSLocation.isProviderEnabled(LocationManager.GPS_PROVIDER))
			GPSenabled = true;
		return GPSenabled;
	}
}