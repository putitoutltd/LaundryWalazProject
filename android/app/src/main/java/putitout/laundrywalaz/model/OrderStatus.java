package putitout.laundrywalaz.model;

/**
 * Created by Ehsan Aslam 7/28/2016.
 */
public class OrderStatus {


    String locationId;
    String phone;
    String firstName;
    String lastName;
    String address;
    String pickup_time;
    String dropoff_time;
    String id;
    String status;
    String special_instructions;
    String date_created;
    String date_modified;
    String users_id;


    public OrderStatus(String pickup_time, String dropoff_time, String status) {
        this.pickup_time = pickup_time;
        this.dropoff_time = dropoff_time;
        this.status = status;
    }


    public String getLocationId() {
        return locationId;
    }

    public void setLocationId(String locationId) {
        this.locationId = locationId;
    }

    public String getPickup_time() {
        return pickup_time;
    }

    public void setPickup_time(String pickup_time) {
        this.pickup_time = pickup_time;
    }

    public String getDropoff_time() {
        return dropoff_time;
    }

    public void setDropoff_time(String dropoff_time) {
        this.dropoff_time = dropoff_time;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "OrderStatus{" +
                "pickup_time='" + pickup_time + '\'' +
                ", dropoff_time='" + dropoff_time + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
