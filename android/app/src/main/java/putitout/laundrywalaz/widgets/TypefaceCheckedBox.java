package putitout.laundrywalaz.widgets;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.RadioButton;

import putitout.laundrywalaz.R;


public class TypefaceCheckedBox extends RadioButton {

	public TypefaceCheckedBox(Context context) {
		super(context);
	}

	public TypefaceCheckedBox(Context context, AttributeSet attributeSet) {
		super(context, attributeSet);
		CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceCheckedBox, R.styleable.TypefaceCheckedBox_customTypefaceCheckedBox);
	}

	public TypefaceCheckedBox(Context context, AttributeSet attributeSet, int defStyle) {
		super(context, attributeSet, defStyle);
		CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceCheckedBox, R.styleable.TypefaceCheckedBox_customTypefaceCheckedBox);
	}    
}
