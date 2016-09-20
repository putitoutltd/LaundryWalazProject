package putitout.laundrywalaz.model;

/**
 * Created by Ehsan Aslam on 7/28/2016.
 */
public class OrderModel {

    String emailAddress;
    String locationId;
    String phone;
    String firstName;
    String lastName;
    String address;
    String accessToken;
    String pickup_time;
    String dropoff_time;


    public OrderModel(String emailAddress, String locationId, String phone, String firstName, String lastName, String address, String accessToken, String pickup_time, String dropoff_time) {
        this.emailAddress = emailAddress;
        this.locationId = locationId;
        this.phone = phone;
        this.firstName = firstName;
        this.lastName = lastName;
        this.address = address;
        this.accessToken = accessToken;
        this.pickup_time = pickup_time;
        this.dropoff_time = dropoff_time;
    }


    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getLocationId() {
        return locationId;
    }

    public void setLocationId(String locationId) {
        this.locationId = locationId;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
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

    @Override
    public String toString() {
        return "OrderModel{" +
                "emailAddress='" + emailAddress + '\'' +
                ", locationId='" + locationId + '\'' +
                ", phone='" + phone + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", address='" + address + '\'' +
                ", accessToken='" + accessToken + '\'' +
                ", pickup_time='" + pickup_time + '\'' +
                ", dropoff_time='" + dropoff_time + '\'' +
                '}';
    }
}
