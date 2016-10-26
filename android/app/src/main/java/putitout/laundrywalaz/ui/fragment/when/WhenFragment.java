package putitout.laundrywalaz.ui.fragment.when;

import android.app.DatePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.format.DateFormat;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.ui.activity.home.HomeActivity;
import putitout.laundrywalaz.ui.activity.login.LoginActivity;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;
import putitout.laundrywalaz.ui.fragment.contactinfo.AddContactInfoFragment;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceTextView;

/**
 * Created by Ehsan Aslam on 7/22/2016.
 */
public class WhenFragment extends BaseFragment implements View.OnClickListener {

    public static final String TAG = WhenFragment.class.getSimpleName();
    private boolean isOpenCalender = false;
    private boolean isTodaySpinnerShown = true;
    private boolean isTomorrowSpinnerShown = false;
    private boolean isOtherDaySpinnerShown = false;
    private boolean isTimeBetween8to6 = false;
    private Button continueButton;
    private Spinner spinnerTomorrow,spinnerToday,spinnerOtherDay;
    String[] spinnerOptions;
    String[] spinnerOptionsToday;
    private int currentHour;
    private ImageView spinnerTodayImageView;
    private TypefaceTextView pickUpTodayTextView;
    private TypefaceTextView pickUpTomorrowTextView;
    private TypefaceTextView openCalendarTextView;
    private TypefaceTextView pickUpTextView;
    private TypefaceTextView otherDayDateDeliveryTextView;
    private TypefaceTextView todayDateDeliveryTextView;
    private TypefaceTextView tomorrowDeliveryDateTextView;
    private RelativeLayout regularRelativeLayout;
    private RelativeLayout expressRelativeLayout;
    private RelativeLayout pickUpTodayRelativeLayout;
    private RelativeLayout pickUpTomorrowRelativeLayout;
    private RelativeLayout openCalendarRelativeLayout;
    private RelativeLayout spinnerTodayRelativeLayout;
    private RelativeLayout spinnerTomorrowRelativeLayout;
    private RelativeLayout spinnerOtherDayRelativeLayout;
    private RelativeLayout deliveryOpenCalenderRelativeLayout;
    private RelativeLayout tomorrowDeliveryRelativeLayout;
    private LinearLayout pickUpLinearLayout;
    private HomeActivity homeActivity;
    private String packageSelection = "REGULAR";
    SimpleDateFormat curFormater,curFormate;
    public static final SimpleDateFormat PARSE_SIMPLE_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    private SimpleDateFormat formatSimpleDateFormat = new SimpleDateFormat("dd MMMM yyyy");

    GregorianCalendar gregorianCalendar;
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
    Calendar calendarObject = Calendar.getInstance();
    String pickUpDate = "";
    String dropOffDate = "";
    String pickup_time = "";



    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_order_where,container,false);
        getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        initWidget(view);
        return view;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        homeActivity.hideTitle();
    }


    public void initWidget(View view){
        homeActivity = (HomeActivity) getActivity();
        homeActivity.showTitle();
        homeActivity.setTitle(getString(R.string.whenText));
        LWUtil.access_Token = LWPrefs.getString(getActivity(),LWPrefs.KEY_TOKEN,"");
        continueButton = (Button) view.findViewById(R.id.continueButton);
        continueButton.setOnClickListener(this);
        pickUpTodayTextView = (TypefaceTextView) view.findViewById(R.id.pickUpTodayTextView);
        pickUpTomorrowTextView = (TypefaceTextView) view.findViewById(R.id.pickUpTomorrowTextView);
        openCalendarTextView = (TypefaceTextView) view.findViewById(R.id.openCalendarTextView);
        pickUpTextView = (TypefaceTextView) view.findViewById(R.id.pickUpTextView);
        otherDayDateDeliveryTextView = (TypefaceTextView) view.findViewById(R.id.otherDayDateDeliveryTextView);
        todayDateDeliveryTextView = (TypefaceTextView) view.findViewById(R.id.todayDateDeliveryTextView);
        tomorrowDeliveryDateTextView = (TypefaceTextView) view.findViewById(R.id.tomorrowDeliveryDateTextView);
        spinnerTodayImageView = (ImageView) view.findViewById(R.id.spinnerTodayImageView);
        pickUpLinearLayout = (LinearLayout) view.findViewById(R.id.pickUpLinearLayout);
        regularRelativeLayout = (RelativeLayout) view.findViewById(R.id.regularRelativeLayout);
        regularRelativeLayout.setOnClickListener(this);
        expressRelativeLayout = (RelativeLayout) view.findViewById(R.id.expressRelativeLayout);
        expressRelativeLayout.setOnClickListener(this);
        pickUpTodayRelativeLayout = (RelativeLayout) view.findViewById(R.id.pickUpTodayRelativeLayout);
        pickUpTodayRelativeLayout.setOnClickListener(this);
        pickUpTomorrowRelativeLayout = (RelativeLayout) view.findViewById(R.id.pickUpTomorrowRelativeLayout);
        pickUpTomorrowRelativeLayout.setOnClickListener(this);
        openCalendarRelativeLayout = (RelativeLayout) view.findViewById(R.id.openCalendarRelativeLayout);
        openCalendarRelativeLayout.setOnClickListener(this);
        spinnerTodayRelativeLayout = (RelativeLayout) view.findViewById(R.id.spinnerTodayRelativeLayout);
        spinnerTomorrowRelativeLayout = (RelativeLayout) view.findViewById(R.id.spinnerTomorrowRelativeLayout);
        spinnerOtherDayRelativeLayout = (RelativeLayout) view.findViewById(R.id.spinnerOtherDayRelativeLayout);
        deliveryOpenCalenderRelativeLayout = (RelativeLayout) view.findViewById(R.id.deliveryOpenCalenderRelativeLayout);
        deliveryOpenCalenderRelativeLayout.setOnClickListener(this);
        tomorrowDeliveryRelativeLayout = (RelativeLayout) view.findViewById(R.id.tomorrowDeliveryRelativeLayout);
        tomorrowDeliveryRelativeLayout.setOnClickListener(this);
        spinnerTomorrow = (Spinner) view.findViewById(R.id.spinnerTomorrow);
        spinnerToday = (Spinner) view.findViewById(R.id.spinnerToday);
        spinnerOtherDay = (Spinner) view.findViewById(R.id.spinnerOtherDay);
        spinnerToday.setBackgroundResource(R.drawable.spinner_border);
        spinnerTomorrow.setBackgroundResource(R.drawable.spinner_border);
        spinnerOtherDay.setBackgroundResource(R.drawable.spinner_border);
        spinnerOptions = getResources().getStringArray(R.array.time_array);

        curFormater = new SimpleDateFormat("hh:mm aa", Locale.US);
        curFormate = new SimpleDateFormat("hh:mm",Locale.US);

        Date mDate = new Date();
        CharSequence s  = DateFormat.format("dd MMMM yyyy", mDate.getTime());
        pickUpTodayTextView.setText(s);
        todayDateDeliveryTextView.setText(s);
        LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICKUP_DATE, pickUpDate);

        SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
        Calendar c = Calendar.getInstance();
        c.add(Calendar.DATE, 1);  // number of days to add
        String tomorrowDate = sdf.format(c.getTime());
        pickUpTomorrowTextView.setText(tomorrowDate);
        tomorrowDeliveryDateTextView.setText(tomorrowDate);

        calendarObject = Calendar.getInstance();//Create Calendar-Object
        calendarObject.setTime(new Date());//Set the Calendar to now
        currentHour = calendarObject.get(Calendar.HOUR_OF_DAY);
        LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICK_UP_TIME,"");
        LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICKUP_TIME,"");
        LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME,"");

        if (currentHour >= 18 && currentHour <= 24) {// Check if currentHour is between{6 pm to 12 pm}
            isTimeBetween8to6 = false;
            pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
            pickUpTodayRelativeLayout.setClickable(false);
            spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
            spinnerOptionsToday = new String[1];
            spinnerToday.setVisibility(View.INVISIBLE);
            spinnerTodayImageView.setVisibility(View.INVISIBLE);
        }
        if (currentHour >=0000 && currentHour <= 9) {// Check if currentHour is between{12 am to 8 am}
            isTimeBetween8to6 = false;
            pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
            pickUpTodayRelativeLayout.setClickable(true);
            spinnerOptionsToday = getResources().getStringArray(R.array.time_array);
        }
        if (currentHour >=9 && currentHour <=18) {// Check if currentHour is between{8 am to 6 pm}
            isTimeBetween8to6 = true;
            pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
            pickUpTodayRelativeLayout.setClickable(true);
            generateTimeSlots();
        }
    }

    public void generateTimeSlots(){
        if (currentHour == 9) {// Check if currentHour is between{9 am}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[10];
            for (int day = 0; day < 9; day++) {
                spinnerOptionsToday[day] = curFormate.format(gregorianCalendar.getTime());
                if(spinnerOptionsToday[day].contains("12")|| spinnerOptionsToday[day].contains("01")
                        || spinnerOptionsToday[day].contains("02")|| spinnerOptionsToday[day].contains("03")||
                        spinnerOptionsToday[day].contains("04")|| spinnerOptionsToday[day].contains("05")||
                        spinnerOptionsToday[day].contains("06")
                        || spinnerOptionsToday[day].contains("07")){
                    spinnerOptionsToday[day]=curFormate.format(gregorianCalendar.getTime())+" "+"pm";
                }else if(spinnerOptionsToday[day].contains("11")) {
                    spinnerOptionsToday[0]=curFormate.format(gregorianCalendar.getTime())+" "+"am";
                }
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[9]="08:00 pm";
        } else if (currentHour == 10) {// Check if currentHour is between{10 am}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[9];
            for (int day = 0; day < 8; day++) {
                spinnerOptionsToday[day] = curFormater.format(gregorianCalendar.getTime());
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[8]="08:00 pm";
        } else if (currentHour == 11) {  // Check if currentHour is between{11 am}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[8];
            for (int day = 0; day < 7; day++) {
                spinnerOptionsToday[day] = curFormater.format(gregorianCalendar.getTime());
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[7]="08:00 pm";
        } else if (currentHour == 12) { // Check if currentHour is between{12 am}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[7];
            for (int day = 0; day < 6; day++) {
                spinnerOptionsToday[day] = curFormater.format(gregorianCalendar.getTime());
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[6]="08:00 pm";
            spinnerToday.post(new Runnable() {
                @Override
                public void run() {
                    ((ShareSpinnerAdapter) spinnerToday.getAdapter()).notifyDataSetChanged();
                }
            });
        } else if (currentHour == 13) {// Check if currentHour is between{1 pm}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[6];
            for (int day = 0; day < 5; day++) {
                spinnerOptionsToday[day] = curFormater.format(gregorianCalendar.getTime());
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[5]="08:00 pm";
        } else if (currentHour == 14) {// Check if currentHour is between{2 pm}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[5];
            for (int day = 0; day < 4; day++) {
                spinnerOptionsToday[day] = curFormater.format(gregorianCalendar.getTime());
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[4]="08:00 pm";
        } else if (currentHour == 15) {// Check if currentHour is between{3 pm}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[4];
            for (int day = 0; day < 3; day++) {
                spinnerOptionsToday[day] = curFormater.format(gregorianCalendar.getTime());
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[3]="08:00 pm";
        } else if (currentHour == 16) {// Check if currentHour is between{4 pm}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[3];
            for (int day = 0; day < 2; day++) {
                spinnerOptionsToday[day] = curFormater.format(gregorianCalendar.getTime());
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[2]="08:00 pm";

        } else if (currentHour == 17) {// Check if currentHour is between{5 pm}
            gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.add(Calendar.HOUR,2);
            System.out.println(gregorianCalendar.getTime());
            spinnerOptionsToday = new String[2];
            for (int day = 0; day < 1; day++) {
                spinnerOptionsToday[day] = curFormater.format(gregorianCalendar.getTime());
                gregorianCalendar.roll(Calendar.HOUR, true);
            }
            spinnerOptionsToday[1]="08:00 pm";
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.continueButton:
                if (packageSelection.equalsIgnoreCase("REGULAR")) {
                    if (LWUtil.access_Token.isEmpty()) {
                        LWUtil.isUserLogin = true;
                        if (pickUpDate.isEmpty()) {
                            Toast.makeText(getActivity(), "Please select Pick-Up Day", Toast.LENGTH_SHORT).show();
                        } else if (dropOffDate.isEmpty()) {
                            Toast.makeText(getActivity(), "Please select Drop-Off Day.", Toast.LENGTH_SHORT).show();
                        }
                        else {
                            startActivity(new Intent(getActivity(), LoginActivity.class));
                        }
                    } else {
                        if (pickUpDate.isEmpty()) {
                            Toast.makeText(getActivity(), "Please select Pick-Up Day", Toast.LENGTH_SHORT).show();
                        } else if (dropOffDate.isEmpty()) {
                            Toast.makeText(getActivity(), "Please select Drop-Off Day.", Toast.LENGTH_SHORT).show();
                        } else {
                            replaceFragment(R.id.fragmentContainerLayout, new AddContactInfoFragment(), AddContactInfoFragment.TAG, true);
                        }
                    }
                }
                else if (packageSelection.equalsIgnoreCase("EXPRESS")) {
                    if (LWUtil.access_Token.isEmpty()) {
                        LWUtil.isUserLogin=true;
                        if (pickUpDate.isEmpty()) {
                            Toast.makeText(getActivity(), "Please select Pick-Up Day", Toast.LENGTH_SHORT).show();
                        } else {
                            startActivity(new Intent(getActivity(), LoginActivity.class));
                        }
                    } else {
                        if (pickUpDate.isEmpty()) {
                            Toast.makeText(getActivity(), "Please select Pick-Up Day", Toast.LENGTH_SHORT).show();
                        } else {
                            replaceFragment(R.id.fragmentContainerLayout, new AddContactInfoFragment(), AddContactInfoFragment.TAG, true);
                        }
                    }
                }
                break;
            case R.id.regularRelativeLayout:
                calendarObject = Calendar.getInstance();//Create Calendar-Object
                calendarObject.setTime(new Date());//Set the Calendar to current time.
                currentHour = calendarObject.get(Calendar.HOUR_OF_DAY);
                LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICK_UP_TIME,"");
                LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICKUP_TIME,"");
                LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME,"");
                if (currentHour >=9 && currentHour <=18) {// Check if currentHour is between{8 am to 6 pm}
                    isTimeBetween8to6 = true;
                    pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    pickUpTodayRelativeLayout.setClickable(true);
                    generateTimeSlots();
                }
                regularRelativeLayout.setBackgroundResource(R.drawable.active_tab);
                expressRelativeLayout.setBackgroundResource(R.drawable.inactive_tab);
                pickUpLinearLayout.setVisibility(View.VISIBLE);
                pickUpTextView.setVisibility(View.GONE);
                pickUpTomorrowRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                openCalendarRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                deliveryOpenCalenderRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                deliveryOpenCalenderRelativeLayout.setClickable(true);
                tomorrowDeliveryRelativeLayout.setClickable(true);
                pickUpTomorrowRelativeLayout.setClickable(true);
                openCalendarRelativeLayout.setClickable(true);
                tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                openCalendarTextView.setText(R.string.openCalendar);
                otherDayDateDeliveryTextView.setText(R.string.openCalendar);
                spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                packageSelection = "REGULAR";
                pickUpDate = "";
                dropOffDate = "";
                pickup_time = "";
                if ((currentHour >=0000 && currentHour <= 8) ||(currentHour >=8 && currentHour <=18)) {
                    pickUpTodayRelativeLayout.setClickable(true);
                } else {
                    pickUpTodayRelativeLayout.setClickable(false);
                }
                LWUtil.isNextDayShown = false;
                break;
            case R.id.expressRelativeLayout:
                spinnerTomorrow.setSelection(0);
                spinnerOtherDay.setSelection(0);
                spinnerToday.setSelection(0);
                isTodaySpinnerShown = false;
                isOtherDaySpinnerShown = false;
                isTomorrowSpinnerShown = false;
                packageSelection = "EXPRESS";
                regularRelativeLayout.setBackgroundResource(R.drawable.inactive_tab);
                expressRelativeLayout.setBackgroundResource(R.drawable.active_tab);
                spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                spinnerToday.setVisibility(View.INVISIBLE);
                spinnerTodayImageView.setVisibility(View.INVISIBLE);
                spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                if (currentHour >=0000 && currentHour < 11) {
                    packageSelection = "EXPRESS";
                    pickUpLinearLayout.setVisibility(View.GONE);
                    pickUpTextView.setVisibility(View.VISIBLE);
                    pickUpTodayRelativeLayout.setClickable(true);
                    pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    pickUpTomorrowRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    openCalendarRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    deliveryOpenCalenderRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    deliveryOpenCalenderRelativeLayout.setClickable(false);
                    tomorrowDeliveryRelativeLayout.setClickable(false);
                    tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    tomorrowDeliveryRelativeLayout.setClickable(false);
                    tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    openCalendarTextView.setText(R.string.openCalendar);
                    otherDayDateDeliveryTextView.setText(R.string.openCalendar);
                    spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                    pickUpDate = "";
                    dropOffDate = "";
                    pickup_time = "";
                    LWUtil.isNextDayShown = false;
                } else {
                    pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    pickUpTomorrowRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    openCalendarRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    deliveryOpenCalenderRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    pickUpTodayRelativeLayout.setClickable(false);
                    pickUpTomorrowRelativeLayout.setClickable(true);
                    openCalendarRelativeLayout.setClickable(true);
                    deliveryOpenCalenderRelativeLayout.setClickable(false);
                    pickUpTodayRelativeLayout.setClickable(false);
                    tomorrowDeliveryRelativeLayout.setClickable(false);
                    tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                    pickUpTextView.setVisibility(View.VISIBLE);
                }
                break;
            case R.id.pickUpTodayRelativeLayout:
                spinnerToday.setAdapter(new ShareSpinnerAdapter(getActivity(), R.layout.spinner_share_layout, spinnerOptionsToday));
                spinnerToday.post(new Runnable(){
                    @Override
                    public void run() {
                        ((ShareSpinnerAdapter) spinnerToday.getAdapter()).notifyDataSetChanged();
                        spinnerToday.setSelection(0,true);
                    }
                });
                calendarObject = Calendar.getInstance();//Create Calendar-Object
                calendarObject.setTime(new Date());
                currentHour = calendarObject.get(Calendar.HOUR_OF_DAY);
                isTodaySpinnerShown = true;
                isOtherDaySpinnerShown = false;
                isTomorrowSpinnerShown = false;
                if (currentHour >= 18 && currentHour <= 24) {// Check if currentHour is between{6 pm to 12 pm}
                    isTimeBetween8to6 = false;
                    pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    pickUpTodayRelativeLayout.setClickable(false);
                    spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerOptionsToday = new String[1];
                    spinnerToday.setVisibility(View.INVISIBLE);
                    spinnerTodayImageView.setVisibility(View.INVISIBLE);
                } else {
                    pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.send_btn);
                    pickUpTomorrowRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    openCalendarRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    spinnerTodayRelativeLayout.setVisibility(View.VISIBLE);
                    spinnerToday.setVisibility(View.VISIBLE);
                    spinnerTodayImageView.setVisibility(View.VISIBLE);
                    spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                    tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    tomorrowDeliveryRelativeLayout.setClickable(true);
                    openCalendarTextView.setText(R.string.openCalendar);
                    pickup_time = "";
                    pickUpDate = pickUpTodayTextView.getText().toString();
                    LWLog.info(TAG + "pickUpDate :" + pickUpDate);
                    LWUtil.isNextDayShown = false;
                    calendarObject = Calendar.getInstance();//Create Calendar-Object
                    calendarObject.setTime(new Date());//Set the Calendar to now
                    currentHour = calendarObject.get(Calendar.HOUR_OF_DAY);
                }
                if(packageSelection.equalsIgnoreCase("EXPRESS")) {
                    tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                    tomorrowDeliveryRelativeLayout.setClickable(false);
                    spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                    LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICK_UP_TIME, pickUpDate + " " + "1:00 PM");
                    pickup_time = "1:00 PM";
                    LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICKUP_TIME, pickup_time);
                    LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME, pickUpDate + " " + "9:00 PM");
                }
                isTodaySpinnerShown=true;
                isOtherDaySpinnerShown = false;
                isTomorrowSpinnerShown=false;
                break;
            case R.id.pickUpTomorrowRelativeLayout:
                spinnerTomorrow.setAdapter(new ShareSpinnerAdapter(getActivity(), R.layout.spinner_share_layout, spinnerOptions));
                spinnerTomorrow.post(new Runnable() {
                    @Override
                    public void run() {
                        ((ShareSpinnerAdapter) spinnerTomorrow.getAdapter()).notifyDataSetChanged();
                        spinnerTomorrow.setSelection(0,true);
                    }
                });
                pickUpTomorrowRelativeLayout.setBackgroundResource(R.drawable.send_btn);
                pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                openCalendarRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                spinnerTomorrowRelativeLayout.setVisibility(View.VISIBLE);
                spinnerTomorrow.setVisibility(View.VISIBLE);
                spinnerOptions = getResources().getStringArray(R.array.time_array);
                spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                tomorrowDeliveryRelativeLayout.setClickable(false);
                openCalendarTextView.setText(R.string.openCalendar);
                isTodaySpinnerShown=false;
                isTomorrowSpinnerShown = true;
                isOtherDaySpinnerShown = false;
                pickUpDate = pickUpTomorrowTextView.getText().toString();
                LWUtil.isNextDayShown = false;
                pickup_time = "";
                if (packageSelection.equalsIgnoreCase("EXPRESS")) {
                    spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                    LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICK_UP_TIME, pickUpDate + " " + "1:00 PM");
                    pickup_time = "1:00 PM";
                    LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICKUP_TIME, pickup_time);
                    LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME, pickUpDate + " " + "9:00 PM");
                }
                break;
            case R.id.openCalendarRelativeLayout:
                spinnerOtherDay.setAdapter(new ShareSpinnerAdapter(getActivity(), R.layout.spinner_share_layout, spinnerOptions));
                spinnerOtherDay.post(new Runnable(){
                    @Override
                    public void run() {
                        ((ShareSpinnerAdapter) spinnerOtherDay.getAdapter()).notifyDataSetChanged();
                        spinnerOtherDay.setSelection(0,true);
                    }
                });

                isTodaySpinnerShown=false;
                isTomorrowSpinnerShown = false;
                LWUtil.isNextDay = false;
                isOpenCalender = false;
                openCalendarRelativeLayout.setBackgroundResource(R.drawable.send_btn);
                pickUpTodayRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                pickUpTomorrowRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                spinnerOtherDayRelativeLayout.setVisibility(View.VISIBLE);
                tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                tomorrowDeliveryRelativeLayout.setClickable(false);
                showDatePickerDialog(datePickerListener);
                isOtherDaySpinnerShown = true;
                LWUtil.isNextDayShown = true;
                pickup_time = "";
                if (packageSelection.equalsIgnoreCase("EXPRESS")) {
                    spinnerTodayRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerTomorrowRelativeLayout.setVisibility(View.INVISIBLE);
                    spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                }
                break;
            case R.id.deliveryOpenCalenderRelativeLayout:
                LWUtil.isNextDay = true;
                isOpenCalender = true;
                showDatePickerOtherDayDeliveryDialog(deliveryDatePickerListener);
                deliveryOpenCalenderRelativeLayout.setBackgroundResource(R.drawable.send_btn);
                tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                break;
            case R.id.tomorrowDeliveryRelativeLayout:
                tomorrowDeliveryRelativeLayout.setBackgroundResource(R.drawable.send_btn);
                openCalendarTextView.setText(R.string.openCalendar);
                dropOffDate = tomorrowDeliveryDateTextView.getText().toString();
                LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME, dropOffDate + " " + "9:00 PM");
                deliveryOpenCalenderRelativeLayout.setBackgroundResource(R.drawable.login_bg);
                break;
        }
    }

    private DatePickerDialog.OnDateSetListener datePickerListener = new DatePickerDialog.OnDateSetListener() {
        public void onDateSet(DatePicker view, int selectedYear,
                              int selectedMonth, int selectedDay) {
            datePickerYear = selectedYear;
            datePickerMonth = selectedMonth;
            datePickerDay = selectedDay;
            NumberFormat numberFormat = new DecimalFormat("00");

            StringBuilder ss = new StringBuilder().append(datePickerYear)
                    .append("-").append(numberFormat.format(datePickerMonth + 1)).
                            append("-").append(numberFormat.format(datePickerDay));
            openCalendarTextView.setText(getFormattedDate(ss.toString()));
            pickup_time = "11:00 AM";

            pickUpDate = openCalendarTextView.getText().toString();
            pickUpDateEqualsToDropOffDate();
            LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICK_UP_TIME, pickUpDate + " " + pickup_time);
            if(packageSelection.equalsIgnoreCase("EXPRESS")){
                spinnerOtherDayRelativeLayout.setVisibility(View.INVISIBLE);
                LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICK_UP_TIME, pickUpDate + " " + "1:00 PM");
                pickup_time = "1:00 PM";
                LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICKUP_TIME, pickup_time);
                LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME, pickUpDate + " " + "9:00 PM");
            }
        }

    };

    private DatePickerDialog.OnDateSetListener deliveryDatePickerListener = new DatePickerDialog.OnDateSetListener() {
        public void onDateSet(DatePicker view, int selectedYear,
                              int selectedMonth, int selectedDay) {
            deliveryDatePickerYear = selectedYear;
            deliveryDatePickerMonth = selectedMonth;
            deliveryDatePickerDay = selectedDay;

            NumberFormat numberFormat = new DecimalFormat("00");
            StringBuilder s = new StringBuilder().append(deliveryDatePickerYear)
                    .append("-").append(numberFormat.format(deliveryDatePickerMonth + 1)).
                            append("-").append(numberFormat.format(deliveryDatePickerDay));
            otherDayDateDeliveryTextView.setText(getFormattedDate(s.toString()));
            dropOffDate = otherDayDateDeliveryTextView.getText().toString();
            LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME, dropOffDate + " " + "9:00 PM");
            LWUtil.isNextDayShown = false;
            if(dropOffDate.equalsIgnoreCase(pickUpDate)){
                dropOffEqualsToPickUpDate();
            }
        }
    };

    public void dropOffEqualsToPickUpDate(){
        if (dropOffDate.trim().equals(pickUpDate)&&(pickUpDate.equals(dropOffDate.trim()))) {
            try {
                calendarObject.setTime(sdf.parse(dropOffDate));
            } catch (ParseException e) {
                e.printStackTrace();
            }
            calendarObject.add(Calendar.DATE, 1); // number of days to add
            dropOffDate = sdf.format(calendarObject.getTime());
            otherDayDateDeliveryTextView.setText(dropOffDate);
            dropOffDate = otherDayDateDeliveryTextView.getText().toString();
            LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME, dropOffDate + " " + "9:00 PM");
        }
    }

    public void pickUpDateEqualsToDropOffDate(){
        if (pickUpDate.trim().equals(dropOffDate)&&(dropOffDate.equals(pickUpDate.trim()))) {
            try {
                calendarObject.setTime(sdf.parse(dropOffDate));
            } catch (ParseException e) {
                e.printStackTrace();
            }
            calendarObject.add(Calendar.DATE, 1);// number of days to add
            dropOffDate = sdf.format(calendarObject.getTime());
            otherDayDateDeliveryTextView.setText(dropOffDate);
            dropOffDate = otherDayDateDeliveryTextView.getText().toString();
            LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME, dropOffDate + " " + "9:00 PM");
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        pickup_time = "";
    }

    @Override
    public void onStart() {
        super.onStart();
        pickup_time = "";
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        packageSelection = "REGULAR";
        LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICK_UP_TIME,"");
        LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICKUP_TIME,"");
        LWPrefs.saveString(getActivity(),LWPrefs.KEY_DROP_OFF_TIME,"");
        LWUtil.isUserLogin=false;
        calendarObject = Calendar.getInstance();//Create Calendar-Object
        calendarObject.setTime(new Date());//Set the Calendar to now
        currentHour = calendarObject.get(Calendar.HOUR_OF_DAY);
        pickUpDate = "";
        dropOffDate = "";
        pickup_time = "";
        spinnerTomorrow.setAdapter(new ShareSpinnerAdapter(getActivity(), R.layout.spinner_share_layout, spinnerOptions));
        spinnerTomorrow.post(new Runnable() {
            @Override
            public void run() {
                ((ShareSpinnerAdapter) spinnerTomorrow.getAdapter()).notifyDataSetChanged();
                spinnerTomorrow.setSelection(0,true);
            }
        });
        spinnerToday.setAdapter(new ShareSpinnerAdapter(getActivity(), R.layout.spinner_share_layout, spinnerOptionsToday));
        spinnerToday.post(new Runnable() {
            @Override
            public void run() {
                ((ShareSpinnerAdapter) spinnerToday.getAdapter()).notifyDataSetChanged();
                spinnerToday.setSelection(0,true);
            }
        });
        spinnerOtherDay.setAdapter(new ShareSpinnerAdapter(getActivity(), R.layout.spinner_share_layout, spinnerOptions));
        spinnerOtherDay.post(new Runnable() {
            @Override
            public void run() {
                ((ShareSpinnerAdapter) spinnerOtherDay.getAdapter()).notifyDataSetChanged();
                spinnerOtherDay.setSelection(0,true);
            }
        });
    }

    public class ShareSpinnerAdapter extends ArrayAdapter<String> {
        AbsListView.LayoutParams params;
        public ShareSpinnerAdapter(Context context, int textViewResourceId, String[] options) {
            super(context, textViewResourceId, options);
        }

        @Override public View getDropDownView(final int position, View convertView, final ViewGroup parent) {
            if (isTodaySpinnerShown == true) {
                if (position == spinnerOptionsToday.length) {
                    return new View(parent.getContext());
                }
            } else if (isOtherDaySpinnerShown == true) {

                if(position == spinnerOptions.length) {
                    return new View(parent.getContext());
                }
            } else if( isTomorrowSpinnerShown == true) {
                if(position == spinnerOptions.length) {
                    return new View(parent.getContext());
                }
            }
            LayoutInflater layoutInflater = (LayoutInflater) parent.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View mySpinner = layoutInflater.inflate(R.layout.spinner_when_layout, parent, false);
            TextView selectedOptionTodayTextView ,selectedOptionTomorrowTextView ,selectedOtherDayOptionTextView;
            selectedOptionTodayTextView = (TextView) mySpinner .findViewById(R.id.selectedOptionTodayTextView);
            selectedOptionTomorrowTextView = (TextView) mySpinner .findViewById(R.id.selectedOptionTomorrowTextView);
            selectedOtherDayOptionTextView = (TextView) mySpinner .findViewById(R.id.selectedOtherDayOptionTextView);
            if (isTodaySpinnerShown == true) {
                selectedOptionTodayTextView.setText(spinnerOptionsToday[position]);
                selectedOptionTodayTextView.setVisibility(View.VISIBLE);
                selectedOptionTomorrowTextView.setVisibility(View.INVISIBLE);
                selectedOtherDayOptionTextView.setVisibility(View.INVISIBLE);
            } else if (isOtherDaySpinnerShown == true) {
                selectedOptionTomorrowTextView.setText(spinnerOptions[position]);
                selectedOptionTodayTextView.setVisibility(View.INVISIBLE);
                selectedOptionTomorrowTextView.setVisibility(View.VISIBLE);
                selectedOtherDayOptionTextView.setVisibility(View.INVISIBLE);
            } else if (isTomorrowSpinnerShown == true) {
                selectedOtherDayOptionTextView.setText(spinnerOptions[position]);
                selectedOptionTodayTextView.setVisibility(View.INVISIBLE);
                selectedOptionTomorrowTextView.setVisibility(View.INVISIBLE);
                selectedOtherDayOptionTextView.setVisibility(View.VISIBLE);
            }
            mySpinner.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (isTodaySpinnerShown == true) {
                        spinnerToday.setSelection(position);
                        View root = parent.getRootView();
                        root.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_BACK));
                        root.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_BACK));
                    } else if (isOtherDaySpinnerShown == true) {
                        spinnerOtherDay.setSelection(position);
                        View root = parent.getRootView();
                        root.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_BACK));
                        root.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_BACK));
                    } else if (isTomorrowSpinnerShown == true) {
                        spinnerTomorrow.setSelection(position);
                        View root = parent.getRootView();
                        root.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_BACK));
                        root.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_BACK));
                    }
                }
            });
            return mySpinner;
        }

        @Override public View getView(int position, View convertView, ViewGroup parent) {
            LayoutInflater layoutInflater = (LayoutInflater) parent.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View mySpinner = layoutInflater.inflate(R.layout.spinner_when_layout, parent, false);
            TextView selectedOptionTodayTextView ,selectedOptionTomorrowTextView ,selectedOtherDayOptionTextView;
            selectedOptionTodayTextView = (TextView) mySpinner .findViewById(R.id.selectedOptionTodayTextView);
            selectedOptionTomorrowTextView = (TextView) mySpinner .findViewById(R.id.selectedOptionTomorrowTextView);
            selectedOtherDayOptionTextView = (TextView) mySpinner .findViewById(R.id.selectedOtherDayOptionTextView);
            if (isTodaySpinnerShown == true) {
                selectedOptionTodayTextView.setText(spinnerOptionsToday[position]);
                selectedOptionTodayTextView.setVisibility(View.VISIBLE);
                selectedOptionTomorrowTextView.setVisibility(View.INVISIBLE);
                selectedOtherDayOptionTextView.setVisibility(View.INVISIBLE);
                pickup_time = selectedOptionTodayTextView.getText().toString();
            } else if (isOtherDaySpinnerShown == true) {
                selectedOtherDayOptionTextView.setText(spinnerOptions[position]);
                selectedOptionTodayTextView.setVisibility(View.INVISIBLE);
                selectedOptionTomorrowTextView.setVisibility(View.INVISIBLE);
                selectedOtherDayOptionTextView.setVisibility(View.VISIBLE);
                pickup_time = selectedOtherDayOptionTextView.getText().toString();
            } else if (isTomorrowSpinnerShown == true) {
                selectedOptionTomorrowTextView.setText(spinnerOptions[position]);
                selectedOptionTodayTextView.setVisibility(View.INVISIBLE);
                selectedOptionTomorrowTextView.setVisibility(View.VISIBLE);
                selectedOtherDayOptionTextView.setVisibility(View.INVISIBLE);
                pickup_time = selectedOptionTomorrowTextView.getText().toString();
            }
            LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICKUP_TIME, pickup_time);
            LWPrefs.saveString(getActivity(),LWPrefs.KEY_PICK_UP_TIME, pickUpDate + " " + pickup_time);
            return mySpinner;
        }
    }

    private String getFormattedDate(String time) {
        String formattedDate = "";
        try {
            Date date = PARSE_SIMPLE_DATE_FORMAT.parse(time);
            formattedDate = formatSimpleDateFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formattedDate;
    }
}