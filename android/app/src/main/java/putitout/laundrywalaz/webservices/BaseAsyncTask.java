package putitout.laundrywalaz.webservices;

import android.os.AsyncTask;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWDialog;
import putitout.laundrywalaz.utils.LWUtil;


/**
 * Created by Junaid Shabbir on 12/28/15.
 */
abstract class BaseAsyncTask<Params, Progress, Result> extends AsyncTask<Params, Progress, Result> {
    @Override
    protected void onPostExecute(Result result) {
        super.onPostExecute(result);
        try {
            if (!LWUtil.isJsonResponse(result.toString())) {
                LWLog.info("WebService Result " + result.toString());
                LWDialog.showAlert(R.string.serverError, R.string.ok);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
