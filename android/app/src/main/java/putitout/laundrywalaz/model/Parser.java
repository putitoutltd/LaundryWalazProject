package putitout.laundrywalaz.model;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import putitout.laundrywalaz.utils.LWUtil;

public class Parser {

    private String response = "";
    private String status = "";
    private String message = "";
    private String data = "";
    private String token = "";
    private String firstName = "";
    private String lastName = "";
    private String locationId = "";
    private String phone = "";
    private String dateModified = "";
    private String type = "";
    private String gender = "";
    private String address = "";
    private String order;
    private String emailAddress;
    private String pickup_time;
    private String dropoff_time;
    private String orderStatus = "";
    private String category;
    private String id;
    private String name;
    private String price_dryclean;
    private String price_laundry;
    private String service_categories_id;
    int responseType;

    private ArrayList<PriceModel> menList = new ArrayList<PriceModel>();

    private ArrayList<PriceModel> womenList = new ArrayList<PriceModel>();

    private ArrayList<PriceModel> bedList = new ArrayList<PriceModel>();

    private ArrayList<PriceModel> otherItemList = new ArrayList<PriceModel>();


    public Parser(String response) {
        this.responseType = 0;
        parseResponseData(response);
    }

    public Parser(String response, int responseType) {
        this.responseType = responseType;
        parseResponseData(response);
    }

    private void parseResponseData(String response) {
        try {
            JSONObject parseJsonObject = new JSONObject(response);
            if (parseJsonObject.has(LWUtil.KEY_SERVER_RESPONSE_STATUS)) {
                status = parseJsonObject
                        .getString(LWUtil.KEY_SERVER_RESPONSE_STATUS);
            }
            if (parseJsonObject.has(LWUtil.KEY_SERVER_RESPONSE_MESSAGE)) {
                message = parseJsonObject.getString(LWUtil.KEY_SERVER_RESPONSE_MESSAGE);
            }
            if (parseJsonObject.has(LWUtil.KEY_SERVER_RESPONSE_DATA) &&
                    !parseJsonObject.getString(LWUtil.KEY_SERVER_RESPONSE_DATA).equals("")) {

                JSONObject jsonData = new JSONObject(parseJsonObject.
                        getString(LWUtil.KEY_SERVER_RESPONSE_DATA));
                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_TOKEN)) {
                    token = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_TOKEN);
                }

                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_PHONE)) {
                    phone = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_PHONE);
                }

                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_DETAILS)) {
                    JSONObject userInfo = new JSONObject(jsonData.getString
                            (LWUtil.KEY_SERVER_RESPONSE_DETAILS));
                    parseUserInfo(userInfo);
                }
                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_DETAILS)) {
                    JSONObject orderInfo = new JSONObject(jsonData.getString
                            (LWUtil.KEY_SERVER_RESPONSE_DETAILS));
                    parseOrderInfo(orderInfo);
                }

                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_ORDER_ID)) {
                    JSONObject orderInfo = new JSONObject(jsonData.getString
                            (LWUtil.KEY_SERVER_RESPONSE_ORDER_ID));
                    parseOrderStatus(orderInfo);
                }

                if(jsonData.has(LWUtil.KEY_SERVER_RESPONSE_FIRST_NAME)) {
                    firstName = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_FIRST_NAME);
                }

                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_LAST_NAME)) {
                    lastName = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_LAST_NAME);
                }

                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_LOCATION_ID)) {
                    locationId = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_LOCATION_ID);
                }

                if(jsonData.has(LWUtil.KEY_SERVER_RESPONSE_PICK_UP_TIME)) {
                    pickup_time = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_PICK_UP_TIME);
                }

                if(jsonData.has(LWUtil.KEY_SERVER_RESPONSE_DROP_OFF_TIME)) {
                    dropoff_time = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_DROP_OFF_TIME);
                }

                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_ORDER_STATUS)) {
                    orderStatus = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_ORDER_STATUS);
                }

                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_ADDRESS)) {
                    address = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_ADDRESS);
                }

                if (jsonData.has(LWUtil.KEY_SERVER_RESPONSE_ORDER)){
                    order = jsonData.getString(LWUtil.KEY_SERVER_RESPONSE_ORDER);
                }
                parsePriceList(jsonData);
            }

        } catch (JSONException je) {
            je.printStackTrace();
        }
    }

    public void parseUserInfo(JSONObject userInfo) {
        try {
            if(userInfo.has(LWUtil.KEY_SERVER_RESPONSE_EMAIL)) {
                emailAddress = userInfo.getString(LWUtil.KEY_SERVER_RESPONSE_EMAIL);
            }
            if (userInfo.has(LWUtil.KEY_SERVER_RESPONSE_FIRST_NAME)) {
                firstName = userInfo.getString(LWUtil.KEY_SERVER_RESPONSE_FIRST_NAME);
            }
            if (userInfo.has(LWUtil.KEY_SERVER_RESPONSE_LAST_NAME)) {
                lastName = userInfo.getString(LWUtil.KEY_SERVER_RESPONSE_LAST_NAME);
            }
            if (userInfo.has(LWUtil.KEY_SERVER_RESPONSE_LOCATION_ID)) {
                locationId = userInfo.getString(LWUtil.KEY_SERVER_RESPONSE_LOCATION_ID);
            }
            if (userInfo.has(LWUtil.KEY_SERVER_RESPONSE_ADDRESS)) {
                address = userInfo.getString(LWUtil.KEY_SERVER_RESPONSE_ADDRESS);
            }
            if (userInfo.has(LWUtil.KEY_SERVER_RESPONSE_PHONE)) {
                phone = userInfo.getString(LWUtil.KEY_SERVER_RESPONSE_PHONE);
            }
        } catch (JSONException je) {
            je.printStackTrace();
        }
    }

    public void parseOrderInfo(JSONObject orderInfo) {
        try {
            if(orderInfo.has(LWUtil.KEY_SERVER_RESPONSE_ORDER)) {
                order = orderInfo.getString(LWUtil.KEY_SERVER_RESPONSE_ORDER);
            }
        } catch (JSONException je) {
            je.printStackTrace();
        }
    }

    public void parseOrderStatus(JSONObject orderStatusInfo) {
        try {
            if(orderStatusInfo.has(LWUtil.KEY_SERVER_RESPONSE_ORDER_STATUS)) {
                orderStatus = orderStatusInfo.getString(LWUtil.KEY_SERVER_RESPONSE_ORDER_STATUS);
            }
            if(orderStatusInfo.has(LWUtil.KEY_SERVER_RESPONSE_PICK_UP_TIME)) {
                 pickup_time = orderStatusInfo.getString(LWUtil.KEY_SERVER_RESPONSE_PICK_UP_TIME);
            }
            if(orderStatusInfo.has(LWUtil.KEY_SERVER_RESPONSE_DROP_OFF_TIME)) {
                dropoff_time = orderStatusInfo.getString(LWUtil.KEY_SERVER_RESPONSE_DROP_OFF_TIME);
            }
        } catch (JSONException je) {
            je.printStackTrace();
        }
    }

    public void parsePriceList(JSONObject priceList) {
        try {
            JSONArray menApparel = priceList.getJSONArray("Men's Apparel");

            for(int i = 0; i < menApparel.length(); i++) {
                JSONObject men_Apparel = menApparel.getJSONObject(i);
                category = men_Apparel.getString(LWUtil.KEY_SERVER_RESPONSE_CATEGORY);
                id = men_Apparel.getString(LWUtil.KEY_SERVER_RESPONSE_ID);
                name = men_Apparel.getString(LWUtil.KEY_SERVER_RESPONSE_NAME);
                price_dryclean = men_Apparel.getString(LWUtil.KEY_SERVER_RESPONSE_PRICE_DRY_CLEAN);
                price_laundry = men_Apparel.getString(LWUtil.KEY_SERVER_RESPONSE_PRICE_LAUNDRY);
                service_categories_id = men_Apparel.getString(LWUtil.KEY_SERVER_RESPONSE_SERVICE_CATEGORIES_ID);

                PriceModel priceModel = new PriceModel(category,id,name,price_dryclean,price_laundry,service_categories_id);
                menList.add(priceModel);
            }

            JSONArray womenApparel = priceList.getJSONArray("Women's Apparel");

            for(int i = 0; i < womenApparel.length(); i++) {
                JSONObject other_Items = womenApparel.getJSONObject(i);
                category = other_Items.getString(LWUtil.KEY_SERVER_RESPONSE_CATEGORY);
                id = other_Items.getString(LWUtil.KEY_SERVER_RESPONSE_ID);
                name = other_Items.getString(LWUtil.KEY_SERVER_RESPONSE_NAME);
                price_dryclean = other_Items.getString(LWUtil.KEY_SERVER_RESPONSE_PRICE_DRY_CLEAN);
                price_laundry = other_Items.getString(LWUtil.KEY_SERVER_RESPONSE_PRICE_LAUNDRY);
                service_categories_id = other_Items.getString(LWUtil.KEY_SERVER_RESPONSE_SERVICE_CATEGORIES_ID);
                PriceModel priceModel = new PriceModel(category,id,name,price_dryclean,price_laundry,service_categories_id);
                womenList.add(priceModel);
            }

            JSONArray jsonObject = priceList.getJSONArray("Bed Linen");
            for(int i = 0; i < jsonObject.length(); i++) {
                JSONObject bad_Linen = jsonObject.getJSONObject(i);
                category = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_CATEGORY);
                id = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_ID);
                name = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_NAME);
                price_dryclean = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_PRICE_DRY_CLEAN);
                price_laundry = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_PRICE_LAUNDRY);
                service_categories_id = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_SERVICE_CATEGORIES_ID);

                PriceModel priceModel = new PriceModel(category,id,name,price_dryclean,price_laundry,service_categories_id);
                bedList.add(priceModel);
            }

            JSONArray itemsJsonObject = priceList.getJSONArray("Other Items");
            for(int i = 0; i < itemsJsonObject.length(); i++) {
                JSONObject bad_Linen = itemsJsonObject.getJSONObject(i);
                category = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_CATEGORY);
                id = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_ID);
                name = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_NAME);
                price_dryclean = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_PRICE_DRY_CLEAN);
                price_laundry = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_PRICE_LAUNDRY);
                service_categories_id = bad_Linen.getString(LWUtil.KEY_SERVER_RESPONSE_SERVICE_CATEGORIES_ID);

                PriceModel priceModel = new PriceModel(category,id,name,price_dryclean,price_laundry,service_categories_id);
                otherItemList.add(priceModel);
            }

        } catch (JSONException je) {
            je.printStackTrace();
        }
    }
    public String getStatus() {
        return status;
    }

    public String getMessage() {
        return message;
    }

    public String getToken() {
        return token;
    }

    public String getData() {
        return data;
    }

    public String getId() {
        return id;
    }

    public String getResponse() {
        return response;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getLocationId() {
        return locationId;
    }

    public String getDateModified() {
        return dateModified;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public String getPickup_time() {
        return pickup_time;
    }

    public String getDropoff_time() {
        return dropoff_time;
    }

    public String getType() {
        return type;
    }

    public String getGender() {
        return gender;
    }

    public String getPhone() {
        return phone;
    }
    public String getAddress() {
        return address;
    }

    public String getEmail() {
        return emailAddress;
    }

    public String getOrder() {
        return order;
    }

    public ArrayList<PriceModel>  getMenPricingList() {
        return menList;
    }

    public ArrayList<PriceModel>  getWomenPricingList() {
        return womenList;
    }

    public ArrayList<PriceModel>  getBedPricingList() {
        return bedList;
    }

    public ArrayList<PriceModel>  getOtherItemsPricingList() {
        return otherItemList;
    }

}
