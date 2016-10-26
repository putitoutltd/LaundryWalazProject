package putitout.laundrywalaz.ui.activity.splash;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.WindowManager;

import com.crashlytics.android.Crashlytics;
import io.fabric.sdk.android.Fabric;
import putitout.laundrywalaz.R;
import putitout.laundrywalaz.ui.activity.demo.DemoActivity;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.utils.LWPrefs;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
public class SplashActivity  extends Activity {

    private static final long SPLASH_MILLIS = 5000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_splash);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        initWidget();
    }

    public void initWidget() {
        checkFlowAndProceed();
    }

    private void checkFlowAndProceed() {
        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if (LWPrefs.getString(SplashActivity.this, LWPrefs.KEY_TOKEN, "").equals("")) {
                    startActivity(new Intent(SplashActivity.this, DemoActivity.class));
                } else {
                    startActivity(new Intent(SplashActivity.this, HomeActivity.class));
                }
                finish();
            }
        }, SPLASH_MILLIS);
    }
}