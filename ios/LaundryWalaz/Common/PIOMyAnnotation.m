//
//  PIOMyAnnotation.m
//  LaundryWalaz
//
//  Created by pito on 7/22/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOMyAnnotation.h"

@implementation PIOMyAnnotation

@synthesize coordinate;

@synthesize title;

@synthesize time;

@synthesize subTitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c  title:(NSString *) t  subTitle:(NSString *)timed time:(NSString *)tim
{
    self.coordinate=c;
    self.time=tim;
    self.subTitle=timed;
    self.title=t;
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *)tit
{
    self.coordinate=c;
    self.title=tit;
    return self;
}


@end
