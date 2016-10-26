package putitout.laundrywalaz.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

/**
 * Created by Ehsan Aslam on 7/26/2016.
 */
public class LWPrefs {
	public static final String KEY_ORDER_STATUS = "KEY_ORDER_STATUS";
	public static final String KEY_USER_ID = "KEY_USER_ID";
	public static final String KEY_ORDER_ID = "KEY_ORDER_ID";
	public static final String KEY_TOKEN = "KEY_TOKEN";
	public static final String KEY_FIRST_NAME = "KEY_FIRST_NAME";
	public static final String KEY_LAST_NAME = "KEY_LAST_NAME";
	public static final String KEY_PHONE = "KEY_PHONE";
	public static final String KEY_ADDRESS = "KEY_ADDRESS";
	public static final String KEY_LOCATION_AREA = "KEY_LOCATION_AREA";
	public static final String KEY_USER_STATUS = "KEY_USER_STATUS";
	public static final String KEY_PICK_UP_TIME = "KEY_PICK_UP_TIME";
	public static final String KEY_DROP_OFF_TIME = "KEY_DROP_OFF_TIME";
	public static final String KEY_PICKUP_TIME = "KEY_PICKUP_TIME";
	public static final String KEY_REMEMBER_ME = "KEY_REMEMBER_ME";
	public static final String KEY_EMAIL = "KEY_EMAIL";
	public static final  String KEY_PICKUP_DATE = "KEY_PICKUP_DATE";

	public static SharedPreferences sharePreference = null;

	public static SharedPreferences getSharedPreference(Context context) {
		if(sharePreference == null) {
			sharePreference = PreferenceManager.getDefaultSharedPreferences(context);
		}
		return sharePreference;
	}

	public static void clearSharedPreferences(Context context) {
		getSharedPreference(context).edit().clear().commit();
	}

	public static void saveBoolean(Context context, String key,boolean value) {
		getSharedPreference(context).edit().putBoolean(key, value).commit();
	}
	
	public static Boolean getBoolean(Context context, String key,Boolean defaultValue) {
		return getSharedPreference(context).getBoolean(key, defaultValue);
	}
	
	public static void saveString(Context context, String key,String value) {
		getSharedPreference(context).edit().putString(key, value).commit();
	}
	
	public static String getString(Context context, String key,String defaultValue) {
		return getSharedPreference(context).getString(key, defaultValue);
	}
}
