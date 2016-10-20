package putitout.laundrywalaz.widgets;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.TextView;

import putitout.laundrywalaz.R;


public class TypefaceTextView extends TextView {

	public TypefaceTextView(Context context) {
		super(context);
	}
	
	public TypefaceTextView(Context context, AttributeSet attributeSet) {
		super(context, attributeSet);
		CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceTextView, R.styleable.TypefaceTextView_customTypefaceTextView);
	}
	
	public TypefaceTextView(Context context, AttributeSet attributeSet, int defStyle) {
		super(context, attributeSet, defStyle);
		CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceTextView, R.styleable.TypefaceTextView_customTypefaceTextView);
	}    
}
