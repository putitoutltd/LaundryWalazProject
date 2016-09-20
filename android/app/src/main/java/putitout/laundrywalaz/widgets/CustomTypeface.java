package putitout.laundrywalaz.widgets;

import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.widget.TextView;

import java.util.HashMap;
import java.util.Map;

public class CustomTypeface {
    /*
     * Caches typefaces based on their file path and name, so that they don't have to be created
     * every time when they are referenced.
     */
    private static Map<String, Typeface> mTypefaces;
    
    public static void setFont(TextView textView, Context context, AttributeSet attributeSet, int[] classStyleable, int propertyStyleable) {
        // return early for eclipse preview mode
        if (textView.isInEditMode()) return;
        
        if (mTypefaces == null) {
            mTypefaces = new HashMap<String, Typeface>();
        }
        final TypedArray typedArray = context.obtainStyledAttributes(attributeSet,classStyleable);
        if (typedArray != null) {
            final String typefaceAssetPath = typedArray.getString(propertyStyleable);
            if (typefaceAssetPath != null) {
                Typeface typeface = null;
                if (mTypefaces.containsKey(typefaceAssetPath)) {
                    typeface = mTypefaces.get(typefaceAssetPath);
                } else {
                    AssetManager assetManager = context.getAssets();
                    typeface = Typeface.createFromAsset(assetManager, typefaceAssetPath);
                    mTypefaces.put(typefaceAssetPath, typeface);
                }
                textView.setTypeface(typeface);
            }
            typedArray.recycle();
        }
    }
}