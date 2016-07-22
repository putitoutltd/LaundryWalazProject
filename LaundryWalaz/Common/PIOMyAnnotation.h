//
//  PIOMyAnnotation.h
//  LaundryWalaz
//
//  Created by pito on 7/22/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface PIOMyAnnotation : NSObject <MKAnnotation>

{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subTitle;
    NSString *time;
}

@property (nonatomic)CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *subTitle;

@property (nonatomic,retain) NSString *time;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c  title:(NSString *) t  subTitle:(NSString *)timed time:(NSString *)tim;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *)tit;

@end
