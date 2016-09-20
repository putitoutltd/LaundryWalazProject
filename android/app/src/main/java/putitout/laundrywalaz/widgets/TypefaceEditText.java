package putitout.laundrywalaz.widgets;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.EditText;

import putitout.laundrywalaz.R;

public class TypefaceEditText extends EditText {

	public TypefaceEditText(Context context) {
		super(context);
	}

	public TypefaceEditText(Context context, AttributeSet attributeSet) {
		super(context, attributeSet);
		CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceEditText, R.styleable.TypefaceEditText_customTypefaceEditText);
	}

	public TypefaceEditText(Context context, AttributeSet attributeSet, int defStyle) {
		super(context, attributeSet, defStyle);
		CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceEditText, R.styleable.TypefaceEditText_customTypefaceEditText);
	}    
}
