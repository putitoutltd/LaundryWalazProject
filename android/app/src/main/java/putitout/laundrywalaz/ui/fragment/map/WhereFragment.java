package putitout.laundrywalaz.ui.fragment.map;

import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.view.InflateException;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

import putitout.laundrywalaz.R;
import putitout.laundrywalaz.ui.fragment.base.BaseFragment;
import putitout.laundrywalaz.ui.fragment.when.WhenFragment;
import putitout.laundrywalaz.utils.LWLog;
import putitout.laundrywalaz.utils.LWPrefs;
import putitout.laundrywalaz.utils.LWUtil;
import putitout.laundrywalaz.widgets.TypefaceEditText;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
@SuppressWarnings("ALL")
public class WhereFragment extends BaseFragment implements GoogleApiClient.ConnectionCallbacks,GoogleApiClient.OnConnectionFailedListener,
        ResultCallback, View.OnClickListener {

    public static final String TAG = WhereFragment.class.getSimpleName();

    static final LatLng LAHORE = new LatLng(31.5546,74.3572);
    static final LatLng LAHORE_CANTT_LAT = new LatLng (31.478726,74.416029);
    static final LatLng CAVALRY_GROUND_LAT = new LatLng(31.500772,74.369010);
    static final LatLng GULBERG_1_LAT = new LatLng(31.525502,74.349248);
    static final LatLng GULBERG_2_LAT = new LatLng(31.523263,74.348483);
    static final LatLng GULBERG_3_LAT = new LatLng(31.505354,74.349949);
    static final LatLng GULBERG_4_LAT = new LatLng(31.526759,74.337485);
    static final LatLng GULBERG_5_LAT = new LatLng(31.537782,74.347750);
    static final LatLng DHA_5_LAT = new LatLng(31.462538,74.408592);
    static final LatLng DHA_6_LAT = new LatLng(31.471504,74.458424);

    private int REQUEST_CHECK_SETTINGS = 100;
    private int RESULT_OK = 1;


    protected GoogleApiClient mGoogleApiClient;
    protected LocationRequest locationRequest;

    private GoogleMap googleMap;

//    private boolean isLocationSelected = false;

    private Button confirmAddressButton;

    private TypefaceEditText getLocationEditText;

    private Spinner shareWithSpinner;
    private String[] spinnerLocationOptions;

    GoogleMap.OnMyLocationChangeListener myLocationChangeListener;
    String address = "";
    private static View rootView;

    String locationArea = "";
    String city  = "";
    String state = "";
    String country = "";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
//        View view = inflater.inflate(R.layout.fragment_where, container, false);
        getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        if (rootView != null) {
            ViewGroup parent = (ViewGroup) rootView.getParent();
            if (parent != null)
                parent.removeView(rootView);
        } try {
            rootView = inflater.inflate(R.layout.fragment_where, container, false);
            initWidget(rootView);
        } catch (InflateException e) {
        /* googleMap is already there, just return view as it is  */
        }
        return rootView;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MapsInitializer.initialize(getActivity());
    }

    //    @Override
//    public void onDestroy() {
//        super.onDestroy();
//        Fragment fragment = (getFragmentManager().findFragmentById(R.id.googleMap));
//        FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
//        ft.remove(fragment);
//        ft.commit();
//    }

    @Override
    public void onDetach() {
        super.onDetach();
//        Fragment fragment = (getFragmentManager().findFragmentById(R.id.map));
//        FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
//        ft.remove(fragment);
//        ft.commit();
    }

    public void initWidget(View view) {
//        LWUtil.generateHashKey(getActivity(), LWUtil.KEY_ENCODING_TYPE);
//        LWLog.info(LWUtil.generateHashKey(getActivity(),LWUtil.KEY_ENCODING_TYPE)));
        googleMap = ((MapFragment) getActivity().getFragmentManager().findFragmentById(R.id.map))
                .getMap();
        System.gc();

        confirmAddressButton = (Button) view.findViewById(R.id.confirmAddressButton);
        confirmAddressButton.setOnClickListener(this);

        getLocationEditText = (TypefaceEditText) view.findViewById(R.id.getLocationEditText);

        shareWithSpinner = (Spinner) view.findViewById(R.id.spinnerShare);
//        shareWithSpinner.setPopupBackgroundResource(R.drawable.spinner_border);
        spinnerLocationOptions = getResources().getStringArray(R.array.areas_array);

        shareWithSpinner.setAdapter(new ShareSpinnerAdapter(getActivity(), R.layout.spinner_share_layout, spinnerLocationOptions));
        shareWithSpinner.post(new Runnable() {
            @Override
            public void run() {

                ((ShareSpinnerAdapter) shareWithSpinner.getAdapter()).notifyDataSetChanged();
            }
        });


        if (googleMap !=null){

            Marker Cantt = googleMap.addMarker(new MarkerOptions()
                    .position(LAHORE_CANTT_LAT)
                    .title("Cantt")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));

            Marker Gulberg = googleMap.addMarker(new MarkerOptions()
                    .position(GULBERG_1_LAT)
                    .title("Gulberg")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));

            Marker GulbergII = googleMap.addMarker(new MarkerOptions()
                    .position(GULBERG_2_LAT)
                    .title("Gulberg II")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));

            Marker GulbergIII = googleMap.addMarker(new MarkerOptions()
                    .position(GULBERG_3_LAT)
                    .title("Gulberg III")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));
            Marker Gulberg4 = googleMap.addMarker(new MarkerOptions()
                    .position(GULBERG_4_LAT)
                    .title("Gulberg IV")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));

            Marker Gulberg5 = googleMap.addMarker(new MarkerOptions()
                    .position(GULBERG_5_LAT)
                    .title("Gulberg V")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));

            Marker Cavalary = googleMap.addMarker(new MarkerOptions()
                    .position(CAVALRY_GROUND_LAT)
                    .title("Cavalary ground")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));

            Marker DHAPhase5 = googleMap.addMarker(new MarkerOptions()
                    .position(DHA_5_LAT)
                    .title("DHA Phase V")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));

            Marker DHAPhase6 = googleMap.addMarker(new MarkerOptions()
                    .position(DHA_6_LAT)
                    .title("DHA Phase VI")
                    .icon(BitmapDescriptorFactory
                            .fromResource(R.drawable.order_location)));
            if (ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_FINE_LOCATION) ==
                    PackageManager.PERMISSION_GRANTED &&
                    ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_COARSE_LOCATION) ==
                            PackageManager.PERMISSION_GRANTED) {
                googleMap.setMyLocationEnabled(true);
//                googleMap.getUiSettings().setMyLocationButtonEnabled(true);
            } else {
//                Toast.makeText(getActivity(),"Secutity Error", Toast.LENGTH_LONG).show();
            }
//            googleMap.setMyLocationEnabled(true);
            System.gc();
        }

        try {
            googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(LAHORE, 15));

// Zoom in, animating the camera.
            googleMap.animateCamera(CameraUpdateFactory.zoomTo(12), 3000, null);
        }catch (Exception e){
            e.printStackTrace();
        }


        if (ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_FINE_LOCATION) ==
                PackageManager.PERMISSION_GRANTED &&
                ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_COARSE_LOCATION) ==
                        PackageManager.PERMISSION_GRANTED) {
            //        googleMap.getUiSettings().setMyLocationButtonEnabled(true);
            googleMap.getUiSettings().setRotateGesturesEnabled(true);
//        googleMap.getUiSettings().setMyLocationButtonEnabled(true);
            googleMap.getUiSettings().setZoomControlsEnabled(true);
            googleMap.getUiSettings().setMapToolbarEnabled(true);
//                googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        } else {
//            Toast.makeText(getActivity(),"Secutity Error", Toast.LENGTH_LONG).show();
        }




//        currentLocation();




//        googleMap.setOnMyLocationChangeListener(myLocationChangeListener);

//        googleMap.setOnMapClickListener(new GoogleMap.OnMapClickListener() {
//            @Override
//            public void onMapClick(LatLng latLng) {
//
//
//                MarkerOptions markerOptions = new MarkerOptions();
//
//                // Setting the position for the marker
//                markerOptions.position(latLng);
//                // Setting the title for the marker.
//                // This will be displayed on taping the marker
//                markerOptions.title(latLng.latitude + " : " + latLng.longitude);
//                markerOptions.title(address);
//
//                markerOptions.icon(BitmapDescriptorFactory.fromResource(R.drawable.order_location));
//
//                // Clears the previously touched position
//                googleMap.clear();
//
//                // Animating to the touched position

//
//                // Placing a marker on the touched position
//                googleMap.addMarker(markerOptions);
//
////                MarkerOptions options = new MarkerOptions().position( latLng );
////                options.title( getAddressFromLatLng( latLng ) );
////
////                options.icon( BitmapDescriptorFactory.defaultMarker() );
////                googleMap.addMarker( options );
//
//            }
//        });

        mGoogleApiClient = new GoogleApiClient.Builder(getActivity())
                .addApi(LocationServices.API)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this).build();
        mGoogleApiClient.connect();

        locationRequest = LocationRequest.create();
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        locationRequest.setInterval(30 * 1000);
        locationRequest.setFastestInterval(5 * 1000);
        System.gc();
    }

    public void currentLocation(){
        myLocationChangeListener = new GoogleMap.OnMyLocationChangeListener() {
            @Override
            public void onMyLocationChange(final Location location) {
                LatLng loc = new LatLng(location.getLatitude(), location.getLongitude());
//                googleMap.clear();
//                googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(loc, 16.0f));
                MarkerOptions markerOptions = new MarkerOptions();

                Geocoder geocoder;
                List<Address> addresses = null;
                geocoder = new Geocoder(getActivity(), Locale.getDefault());

                try {
                    addresses = geocoder.getFromLocation(loc.latitude, loc.longitude, 2);

                    if (addresses != null && addresses.size() > 0) {
//                        isLocationSelected=false;
                        address = addresses.get(0).getAddressLine(0);
                        // If any additional address line present than only, check with max available address lines by getMaxAddressLineIndex()
                        city = addresses.get(0).getLocality();
                        state = addresses.get(0).getAdminArea();
                        country = addresses.get(0).getCountryName();
                        String postalCode = addresses.get(0).getPostalCode();
                        String knownName = addresses.get(0).getFeatureName();
                        markerOptions.title(address + " " + knownName + " " + city + " " + state + " " + country);

                        getLocationEditText.setText(address + " " + " " + city + " " + state + " " + country);
                        LWPrefs.saveString(getActivity(),LWPrefs.KEY_ADDRESS , getLocationEditText.getText().toString());

                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        };
    }

    private String getAddressFromLatLng( LatLng latLng ) {
        Geocoder geocoder = new Geocoder( getActivity());
        address = "";
        try {
            address = geocoder
                    .getFromLocation( latLng.latitude, latLng.longitude,1)
                    .get(0).getAddressLine(0);
        } catch (IOException e) {}
        return address;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.confirmAddressButton:
                if (getLocationEditText.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity(),R.string.enterAddress,Toast.LENGTH_SHORT).show();
                } else if (shareWithSpinner.getSelectedItemPosition()== 0 || spinnerLocationOptions.length < 0) {
                    Toast.makeText(getActivity(),R.string.selectLocation,Toast.LENGTH_SHORT).show();
                } else {
                    replaceFragment(R.id.fragmentContainerLayout, new WhenFragment(), WhenFragment.TAG, true);
                    LWPrefs.saveString(getActivity(),LWPrefs.KEY_ADDRESS,getLocationEditText.getText().toString());
                }
                break;
        }
    }

    @Override
    public void onConnected(@Nullable Bundle bundle) {
        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder().addLocationRequest(locationRequest);
        builder.setAlwaysShow(true);
        PendingResult result = LocationServices.SettingsApi.checkLocationSettings(mGoogleApiClient,builder.build());
        result.setResultCallback(this);
    }

    @Override
    public void onConnectionSuspended(int i) {}

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {}

    @Override
    public void onResult(@NonNull Result result) {
        final Status status = result.getStatus();
        switch (status.getStatusCode()) {
            case LocationSettingsStatusCodes.SUCCESS:
                // NO need to show the dialog;
                break;
            case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
                //  Location settings are not satisfied. Show the user a dialog
                try {
                    // Show the dialog by calling startResolutionForResult(), and check the result
                    // in onActivityResult().
                    status.startResolutionForResult(getActivity(), REQUEST_CHECK_SETTINGS);
                } catch (IntentSender.SendIntentException e) {
                    //failed to show
                }
                break;
            case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
                // Location settings are unavailable so not possible to show any dialog now
                break;
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CHECK_SETTINGS) {
            if (resultCode == RESULT_OK) {
                Toast.makeText(getActivity(),"GPS enabled", Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(getActivity(),"GPS is not enabled", Toast.LENGTH_LONG).show();
            }
        }
    }

    public class ShareSpinnerAdapter extends ArrayAdapter<String> {
        AbsListView.LayoutParams params;
        public ShareSpinnerAdapter(Context context, int textViewResourceId, String[] options) {
            super(context, textViewResourceId, options);
            params = new AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,(int) (LWUtil.getWindowHeight(getActivity()) * 0.066));
        }

        @Override public View getDropDownView(final int position, View convertView, final ViewGroup parent) {
            if (position == spinnerLocationOptions.length-1) {
                return new View(parent.getContext());
            }

            LayoutInflater layoutInflater = (LayoutInflater) parent.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View mySpinner = layoutInflater.inflate(R.layout.spinner_share_item_layout, parent, false);

            TextView selectedOptionTextView = (TextView) mySpinner .findViewById(R.id.selectedOptionTextView);
            ImageView imageView = (ImageView) mySpinner .findViewById(R.id.imageView);
            mySpinner.setLayoutParams(params);
            selectedOptionTextView.setText(spinnerLocationOptions[position]);

            return mySpinner;
        }

        @Override public View getView(int position, View convertView, ViewGroup parent) {
            LayoutInflater layoutInflater = (LayoutInflater) parent.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View mySpinner = layoutInflater.inflate(R.layout.spinner_share_layout, parent, false);

            TextView selectedOptionTextView = (TextView) mySpinner .findViewById(R.id.selectedOptionTextView);
            selectedOptionTextView.setText(spinnerLocationOptions[position]);

            if (selectedOptionTextView.getText().equals("Cantt")) {
                googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(LAHORE_CANTT_LAT, 15));
                googleMap.animateCamera(CameraUpdateFactory.zoomTo(13), 3000, null);
                locationArea = "1";
                LWLog.info(locationArea);
            } else if (selectedOptionTextView.getText().equals("Cavalary ground")) {
                googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(CAVALRY_GROUND_LAT, 15));
                googleMap.animateCamera(CameraUpdateFactory.zoomTo(13), 3000, null);
                locationArea = "2";
                LWLog.info(locationArea);
            } else if (selectedOptionTextView.getText().equals("DHA Phase 5&6")) {
                googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(DHA_5_LAT, 15));
                googleMap.animateCamera(CameraUpdateFactory.zoomTo(13), 3000, null);
                locationArea = "3";
                LWLog.info(locationArea);
            } else if (selectedOptionTextView.getText().equals("Gulberg I-V")) {
                googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(GULBERG_1_LAT, 15));
                googleMap.animateCamera(CameraUpdateFactory.zoomTo(13), 3000, null);
                locationArea = "4";
                LWLog.info(locationArea);
            }

            LWPrefs.saveString(getActivity(),LWPrefs.KEY_LOCATION_AREA,locationArea);

            return mySpinner;
        }
    }



}
