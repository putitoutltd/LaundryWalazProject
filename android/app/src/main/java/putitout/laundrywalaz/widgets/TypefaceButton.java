package putitout.laundrywalaz.widgets;


import android.content.Context;
import android.util.AttributeSet;
import android.widget.Button;

import putitout.laundrywalaz.R;

public class TypefaceButton extends Button {

    public TypefaceButton(Context context) {
        super(context);
    }

    public TypefaceButton(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceButton, R.styleable.TypefaceButton_customTypefaceButton);
    }

    public TypefaceButton(Context context, AttributeSet attributeSet, int defStyle) {
        super(context, attributeSet, defStyle);
        CustomTypeface.setFont(this, context, attributeSet, R.styleable.TypefaceButton, R.styleable.TypefaceButton_customTypefaceButton);
    }
}

