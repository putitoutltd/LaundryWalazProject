package putitout.laundrywalaz.ui.fragment.base;

import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.View;

import java.util.Calendar;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.utils.LWUtil;


/**
 * Created by Ehsan Aslam on 5/27/2016.
 */
public abstract class BaseFragment extends Fragment {

    public Calendar calendar = Calendar.getInstance();
    public DatePickerDialog datePickerDialog, deliveryPickerDialog;
    public int datePickerYear = calendar.get(Calendar.YEAR);
    public int datePickerMonth = calendar.get(Calendar.MONTH);
    public int datePickerDay = calendar.get(Calendar.DAY_OF_MONTH);
    public Calendar deliveryCalendar = Calendar.getInstance();
    public int deliveryDatePickerYear = deliveryCalendar.get(Calendar.YEAR);
    public int deliveryDatePickerMonth = deliveryCalendar.get(Calendar.MONTH);
    public int deliveryDatePickerDay = deliveryCalendar.get(Calendar.DAY_OF_MONTH);

    ProgressDialog progressDialog;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public void showDatePickerDialog(DatePickerDialog.OnDateSetListener datePickerListener) {
        datePickerDialog = new DatePickerDialog(getActivity(),android.R.style.Theme_Holo_Light_Dialog,
                datePickerListener, datePickerYear, datePickerMonth, datePickerDay);
        calendar.add(Calendar.DAY_OF_MONTH,2);
        datePickerDialog.getDatePicker().setMinDate(calendar.getTimeInMillis());
        calendar.add(Calendar.DAY_OF_MONTH,-2);
        LWUtil.isNextDayShown = false;
        datePickerDialog.show();
        datePickerDialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
    }

    public void showDatePickerOtherDayDeliveryDialog(DatePickerDialog.OnDateSetListener datePickerListener) {
        if (LWUtil.isNextDayShown == true) {
            datePickerDialog = new DatePickerDialog(getActivity(),android.R.style.Theme_Holo_Light_Dialog,
                    datePickerListener, datePickerYear, datePickerMonth, datePickerDay+1);
            calendar.add(Calendar.DAY_OF_MONTH,3);
            datePickerDialog.getDatePicker().setMinDate(calendar.getTimeInMillis());
            calendar.add(Calendar.DAY_OF_MONTH,-3);
            LWUtil.isNextDayShown = false;
            datePickerDialog.show();
            datePickerDialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        } else {
            deliveryPickerDialog = new DatePickerDialog(getActivity(),android.R.style.Theme_Holo_Light_Dialog,
                    datePickerListener, deliveryDatePickerYear, deliveryDatePickerMonth, deliveryDatePickerDay);
            deliveryCalendar.add(Calendar.DAY_OF_MONTH,2);
            deliveryPickerDialog.getDatePicker().setMinDate(deliveryCalendar.getTimeInMillis());
            deliveryCalendar.add(Calendar.DAY_OF_MONTH,-2);
            deliveryPickerDialog.show();
            deliveryPickerDialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        }
    }

    public void initWidget(View view) {}

    public void replaceFragment(int contentId, Fragment fragment, String fragmentTag, boolean addToBackStack) {
        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.replace(contentId, fragment, fragmentTag);
        if(addToBackStack) {
            fragmentTransaction.addToBackStack(fragmentTag);
        }
        fragmentTransaction.commit();
    }

    public ProgressDialog getProgressDialog() {
        if (progressDialog == null) {
            progressDialog = new ProgressDialog(getActivity());
            progressDialog.setIndeterminate(false);
            progressDialog.setMessage(getString(R.string.loading));
            progressDialog.setCancelable(true);
            progressDialog.setCanceledOnTouchOutside(false);
        }
        return progressDialog;
    }
}


