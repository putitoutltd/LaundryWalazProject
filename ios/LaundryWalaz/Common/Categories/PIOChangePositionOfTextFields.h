//
//  PIOChangePositionOfTextFields.h
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIOChangePositionOfTextFields : UITextField

- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds ;
 
@end
