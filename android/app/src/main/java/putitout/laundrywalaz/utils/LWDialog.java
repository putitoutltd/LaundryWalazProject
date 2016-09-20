package putitout.laundrywalaz.utils;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;

import putitout.laundrywalaz.interfaces.OnDialogButtonClickListener;
import putitout.laundrywalaz.ui.activity.base.BaseActivity;

/**
 * Created by Ehsan Aslam on 7/26/2016.
 */
public class LWDialog {

    private static AlertDialog alert;

    public static void showAlert(Context context, String message,
                                 String buttonNegativeText) {
        if(alert!=null && alert.isShowing()) {
            return;
        } else {
            alert = new AlertDialog.Builder(context)
                    .setMessage(message)
                    .setCancelable(true)
                    .setNegativeButton(buttonNegativeText, new OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    }).create();
            alert.show();
        }
    }

    public static void showAlert(int messageId,
                                 int buttonNegativeTextId) {
        if(alert!=null && alert.isShowing()) {
            return;
        } else {
            alert = new AlertDialog.Builder(BaseActivity.getActivity()).setMessage(BaseActivity.getActivity().getString(messageId))
                    .setCancelable(true)
                    .setNegativeButton(BaseActivity.getActivity().getString(buttonNegativeTextId), new OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    }).create();
            alert.show();
        }
    }

    public static void showAlert(Context context, String message,
                                 String buttonPositiveText, String buttonNegativeText,
                                 final OnDialogButtonClickListener dialogListener,
                                 final int requestCode) {
        if(alert!=null && alert.isShowing()) {
            return;
        } else {
            alert = new AlertDialog.Builder(context).setMessage(message)
                    .setCancelable(true)
                    .setPositiveButton(buttonPositiveText, new OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialogListener.onDialogPositiveButtonClick(requestCode);
                            dialog.dismiss();
                        }
                    }).setNegativeButton(buttonNegativeText, new OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialogListener.onDialogNegativeButtonClick(requestCode);
                            dialog.dismiss();
                        }
                    }).create();
            alert.show();
        }
    }

    public static void showAlert(Context context, String message,
                                 String buttonPositiveText,
                                 final OnDialogButtonClickListener dialogListener,
                                 final int requestCode) {
        if(alert!=null && alert.isShowing()) {
            return;
        } else {
            alert = new AlertDialog.Builder(context).setMessage(message)
                    .setCancelable(true)
                    .setPositiveButton(buttonPositiveText, new OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialogListener.onDialogPositiveButtonClick(requestCode);
                            dialog.dismiss();
                        }
                    }).create();
            alert.show();
        }
    }
}
