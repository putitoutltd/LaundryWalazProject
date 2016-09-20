package putitout.laundrywalaz.model;

/**
 * Created by Ehsan Aslam on 7/29/2016.
 */
public class PriceModel {

    String category;
    String id;
    String name;
    String price_dryclean;
    String price_laundry;
    String service_categories_id;



    public PriceModel(String id, String category, String name, String price_dryclean, String price_laundry, String service_categories_id) {
        this.id = id;
        this.category = category;
        this.name = name;
        this.price_dryclean = price_dryclean;
        this.price_laundry = price_laundry;
        this.service_categories_id = service_categories_id;

    }


    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPrice_dryclean() {
        return price_dryclean;
    }

    public void setPrice_dryclean(String price_dryclean) {
        this.price_dryclean = price_dryclean;
    }

    public String getPrice_laundry() {
        return price_laundry;
    }

    public void setPrice_laundry(String price_laundry) {
        this.price_laundry = price_laundry;
    }

    public String getService_categories_id() {
        return service_categories_id;
    }

    public void setService_categories_id(String service_categories_id) {
        this.service_categories_id = service_categories_id;
    }

    @Override
    public String toString() {
        return "PriceModel{" +
                "category='" + category + '\'' +
                ", id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", price_dryclean='" + price_dryclean + '\'' +
                ", price_laundry='" + price_laundry + '\'' +
                ", service_categories_id='" + service_categories_id + '\'' +
                '}';
    }
}
