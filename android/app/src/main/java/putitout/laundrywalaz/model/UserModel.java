package putitout.laundrywalaz.model;

public class UserModel {
    String emailAddress;
    String password;
    String locationId;
    String phone;
    String firstName;
    String lastName;
    String address;
    String accessToken;

    public UserModel(String emailAddress, String password, String locationId, String phone, String firstName, String lastName, String address, String accessToken) {
        this.emailAddress = emailAddress;
        this.password = password;
        this.locationId = locationId;
        this.phone = phone;
        this.firstName = firstName;
        this.lastName = lastName;
        this.address = address;
        this.accessToken = accessToken;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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

    @Override
    public String toString() {
        return "UserModel{" +
                "emailAddress='" + emailAddress + '\'' +
                ", password='" + password + '\'' +
                ", locationId='" + locationId + '\'' +
                ", phone='" + phone + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", address='" + address + '\'' +
                ", accessToken='" + accessToken + '\'' +
                '}';
    }
}
