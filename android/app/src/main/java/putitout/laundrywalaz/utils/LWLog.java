package putitout.laundrywalaz.utils;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONObject;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import putitout.laundrywalaz.BuildConfig;


/**
 * Created by Ehsan Aslam on 7/26/2016.
 */
public class LWLog {

	/** logging allowed? When Run As Android Application it returns true.
	 * When Export Android Application with release key, it returns false */
//	public static boolean loggingEnabled() {
//		return BuildConfig.DEBUG;
////	}

	public static boolean loggingEnabled() {
		return BuildConfig.DEBUG;
	}

    public static void debug(String tag, String message) {
		if (loggingEnabled()) {
			Log.d(tag, message);
		}
	}

	public static void info(String tag, String message) {
		if (loggingEnabled()) {
			Log.i(tag, message);
		}
	}

    public static void info(String message) {
        if (loggingEnabled()) {
            Log.v(LWUtil.APP_ID, "**** LaundaryWalaz ****: "+message);
        }
    }

	public static void error(String tag, String message) {
		if (loggingEnabled()) {
			Log.e(tag, message);
		}
	}
	public static void error(String tag, String message,Throwable throwable) {
		if(loggingEnabled()) {
			Log.e(tag,message,throwable);
		}
	}

	public static void verbose(String tag, String message) {
		if (loggingEnabled()) {
			Log.v(tag, message);
		}
	}

	public static void warning(String tag, String message) {
		if (loggingEnabled()) {
			Log.w(tag, message);
		}
	}

	public static void toast(Context context, String resp) {
		if (loggingEnabled()) {
			Toast.makeText(context, resp, Toast.LENGTH_LONG).show();
		}
	}
	public static void showToast(Context context, String msg) {

		Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();

	}
	public static void intent(String tag, Intent intent) {
		if (loggingEnabled()) {
			Bundle bundle = intent.getExtras();
			if (bundle==null || bundle.keySet()==null) return;
			for (String key: bundle.keySet()) {
				if (bundle.get(key)!=null && bundle.get(key).toString()!=null) {
					Log.v(tag, key + ": " + bundle.get(key).toString());
				} else {
					Log.v(tag, key + " IS NULL");
				}
			}
		}
	}

    public static void file(String tag, String message) {
        if (!loggingEnabled()) return;
        try {
            File logFile = new File(Environment.getExternalStorageDirectory().getPath() + "/" + LWUtil.APP_ID + "_log.txt");
            if (!logFile.exists()) logFile.createNewFile();
            BufferedWriter buf = new BufferedWriter(new FileWriter(logFile, true));
            String time = new SimpleDateFormat("MMM dd HH:mm:ss.SSSS", Locale.getDefault()).format(new Date());
            buf.append("{\"time\":\"" + time + "\",\"tag\":" + JSONObject.quote(tag) + ",\n\"message\":{" + message + "}},\n\n");
            buf.flush();
            buf.close();
            error("Util.APPENDED " + tag, message);
        } catch (IOException e) {
            error("Util.APPEND_FAIL " + tag, message);
        }
    }

	public static void file(String tag, Exception e) {
        StackTraceElement[] stack = e.getStackTrace();
        StackTraceElement element;
        String message = "";
        if (e.getLocalizedMessage()!=null) message += "\"localmessage\":\"" + e.getLocalizedMessage() + "\",";
        message += "\"stacktrace\":[";
        for (int i=0;i<stack.length;i++) {
            element = stack[i];
            message += "{\"class\":\"" + element.getClassName() + "." + element.getMethodName() + "(" + element.getFileName() + ":" + element.getLineNumber() + ")\"},";
        }
        message = message.substring(0, message.length()-1) + "]";
        file(tag, message);
    }

}
