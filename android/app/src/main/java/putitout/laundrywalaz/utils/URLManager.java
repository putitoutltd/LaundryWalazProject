package putitout.laundrywalaz.utils;

/**
 * Created by Ehsan Aslam on 7/26/2016.
 */
public class URLManager {

  public static final String SERVER_ULR = "http://backend.laundrywalaz.com"; // For Live API URL
//  public static final String SERVER_ULR = "http://backend-staging.laundrywalaz.com"; // For Stagging API URL
  public static final String REGISTER_USER = SERVER_ULR + "/api/user/register";
  public static final String LOGIN_USER = SERVER_ULR + "/api/user/login";
  public static final String FORGET_PASSWORD = SERVER_ULR + "/api/user/forget-password";
  public static final String CREATE_ORDER = SERVER_ULR + "/api/order/create";
  public static final String ORDER_STATUS = SERVER_ULR + "/api/order/status";
  public static final String FEED_BACK = SERVER_ULR + "/api/user/send_feedback";
  public static final String SERVICE_LIST = SERVER_ULR + "/api/services/list";
}
