package putitout.laundrywalaz.adapter;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import putitout.laundrywalaz.R;

/**
 * Created by Ehsan Aslam on 7/21/2016.
 */
public class ImagePagerAdapter extends PagerAdapter {

    private LayoutInflater inflater;
    private Context context;
    private int[] sliderImages;

    public ImagePagerAdapter(Context context, int[] imagesFlag) {
        this.context = context;
        this.sliderImages = imagesFlag;
    }

    @Override
    public int getCount() {
        return sliderImages.length;
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((LinearLayout) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        // Declare Variables
        ImageView sliderImageView;

        inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View itemView = inflater.inflate(R.layout.image_pager_layout, container, false);
        // Locate the ImageView in viewpager_item.xml
        sliderImageView = (ImageView) itemView.findViewById(R.id.sliderImageView);
        // Capture position and set to the ImageView
        sliderImageView.setImageResource(sliderImages[position]);
        // Add viewpager_item.xml to ViewPager
        ((ViewPager) container).addView(itemView);
        return itemView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        // Remove viewpager_item.xml from ViewPager
        ((ViewPager) container).removeView((LinearLayout) object);
    }
}