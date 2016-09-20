package putitout.laundrywalaz.widgets;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.RadioButton;

import putitout.laundrywalaz.R;


public class TypefaceRadioButton extends RadioButton {

	public TypefaceRadioButton(Context context) {
		super(context);
	}

	public TypefaceRadioButton(Context context, AttributeSet attributeSet) {
		super(context, attributeSet);
		CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceRadioButton, R.styleable.TypefaceRadioButton_customTypefaceRadioButton);
	}

	public TypefaceRadioButton(Context context, AttributeSet attributeSet, int defStyle) {
		super(context, attributeSet, defStyle);
		CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceRadioButton, R.styleable.TypefaceRadioButton_customTypefaceRadioButton);
	}    
}
