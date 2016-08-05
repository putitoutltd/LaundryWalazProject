//
//  PIOMapViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/29/16.
//  Copyright © 2016 pito. All rights reserved.
//
#import  "QuartzCore/QuartzCore.h"

#import "PIOMapViewController.h"
#import <MapKit/MapKit.h>
#import "PIOOrderViewController.h"
#import "PIOAppController.h"
#import "PIOMyAnnotation.h"
#import "PIOOrder.h"

#define MINIMUM_ZOOM_ARC 0.059 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

#define METERS_MILE 1609.344
#define METERS_FEET 3.28084

const double LAHORE_CANTT_LAT = 31.478726;
const double LAHORE_CANTT_LONG = 74.416029;

const double CAVALRY_GROUND_LAT = 31.500772;
const double CAVALRY_GROUND_LONG = 74.369010;

const double GULBERG_1_LAT = 31.525502;
const double GULBERG_1_LONG = 74.349248;

const double GULBERG_2_LAT = 31.523263;
const double GULBERG_2_LONG = 74.348483;

const double GULBERG_3_LAT = 31.505354;
const double GULBERG_3_LONG = 74.349949;

const double GULBERG_4_LAT = 31.526759;
const double GULBERG_4_LONG = 74.337485;

const double GULBERG_5_LAT = 31.537782;
const double GULBERG_5_LONG = 74.347750;

const double DHA_5_LAT = 31.462538;
const double DHA_5_LONG = 74.408592;

const double DHA_6_LAT = 31.471504;
const double DHA_6_LONG = 74.458424;

NSString *const PIOPlace_Cantt = @"Cantt";
NSString *const PIOPlace_Cavalary = @"Cavalary ground";
NSString *const PIOPlace_DHA_Phase_5 = @"DHA Phase V";
NSString *const PIOPlace_DHA_Phase_6 = @"DHA Phase VI";
NSString *const PIOPlace_Gulberg_1 = @"Gulberg";
NSString *const PIOPlace_Gulberg_2 = @"Gulberg II";
NSString *const PIOPlace_Gulberg_3 = @"Gulberg III";
NSString *const PIOPlace_Gulberg_4 = @"Gulberg IV";
NSString *const PIOPlace_Gulberg_5 = @"Gulberg V";

#define lat  [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble: LAHORE_CANTT_LAT], [NSNumber numberWithDouble: CAVALRY_GROUND_LAT], [NSNumber numberWithDouble: GULBERG_1_LAT], [NSNumber numberWithDouble: GULBERG_2_LAT], GULBERG_3_LAT, [NSNumber numberWithDouble: GULBERG_4_LAT],[NSNumber numberWithDouble: GULBERG_5_LAT], [NSNumber numberWithDouble: DHA_5_LAT], [NSNumber numberWithDouble: DHA_6_LAT],  nil]

@interface PIOMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) NSMutableArray *GULBERG_Annotations;
@property (nonatomic, strong) NSMutableArray *DHA_Annotations;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *longitudes;
@property (nonatomic, strong)  NSMutableArray *latitudes;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, weak) IBOutlet UIButton *confirmAddressButton;
@property (nonatomic, weak) IBOutlet UIButton *dropdownButton;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, weak) IBOutlet UITextField *locationTextField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITextField *addressTextField;

@end

@implementation PIOMapViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.menuButtonNeedToHide = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    
    
    [self.addressTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.0]];
    [self.locationTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.0]];
    [self.confirmAddressButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.75]];
    [self addAllPlacesOnMap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if ([PIOAppController sharedInstance].accessToken != nil) {
        // Hide Back button
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem=nil;
        self.backButtonHide = YES;
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)dropdownButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    CGRect frame = CGRectMake(self.locationTextField.frame.origin.x, self.locationTextField.frame.size.height+self.locationTextField.frame.origin.y, self.locationTextField.frame.size.width,0);
    NSInteger animation = UIViewAnimationOptionCurveEaseIn;
    
    if (!button.isSelected) {
        [self hideTableview];
        frame =  CGRectMake(self.locationTextField.frame.origin.x, self.locationTextField.frame.size.height+self.locationTextField.frame.origin.y, self.locationTextField.frame.size.width,120);
        animation = UIViewAnimationOptionCurveEaseOut;
        [button setSelected: YES];
        self.tableView.hidden = NO;
        
    }
    else
    {
        [self hideTableview];
        
    }
    
    [UIView animateWithDuration:.1 delay:0.0 options:animation animations:^{
        self.tableView.frame  = frame;
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)hideTableview
{
    self.tableView.hidden = YES;
    [self.dropdownButton setSelected: NO];
    self.tableView.frame =  CGRectMake(self.locationTextField.frame.origin.x, self.locationTextField.frame.size.height+self.locationTextField.frame.origin.y, self.locationTextField.frame.size.width,0);
}


- (IBAction)confirmAddressButtonPressed:(id)sender
{
    if (self.locationTextField.text.length == 0) {
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please select Location from given list." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
    }
    else if (self.addressTextField.text.length == 0) {
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please enter correct address for order pickup." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
    }
    else {
        
        [PIOAppController sharedInstance].order = [[PIOOrder alloc]initWithInitialParameters: self.addressTextField.text location: self.locationID];
        if ([PIOAppController sharedInstance].LoggedinUser  != nil) {
            [PIOAppController sharedInstance].order.customer = [PIOAppController sharedInstance].LoggedinUser;
        }
        
        
        PIOOrderViewController *orderViewController = [PIOOrderViewController new];
        [self.navigationController pushViewController: orderViewController animated: YES];
    }
    
    
}

#pragma  mark - Private Methods

- (void)addAllPlacesOnMap
{
    
    // Add Locations for dropdown list
    self.locations = [NSMutableArray arrayWithObjects: @"Cantt", @"Cavalary ground", @"DHA Phase 5&6", @"Gulberg I-V", nil];
    
    self.mapView.delegate = self;
    [[self mapView] setShowsUserLocation:YES];
    self.locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [[self locationManager] setDelegate:self];
    
    // we have to setup the location maanager with permission in later iOS versions
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Where?" onViewController:self];
    [self hideTableview];
    
    // Set Tableview Border
    self.tableView.layer.borderWidth = .8;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.annotations = [[NSMutableArray alloc]init];
    self.DHA_Annotations = [[NSMutableArray alloc]init];
    self.GULBERG_Annotations = [[NSMutableArray alloc]init];
    
    self.latitudes = [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble: LAHORE_CANTT_LAT],
                 [NSNumber numberWithDouble: CAVALRY_GROUND_LAT],
                 [NSNumber numberWithDouble: DHA_5_LAT],
                 [NSNumber numberWithDouble: DHA_6_LAT],
                 [NSNumber numberWithDouble: GULBERG_1_LAT],
                 [NSNumber numberWithDouble: GULBERG_2_LAT],
                 [NSNumber numberWithDouble: GULBERG_3_LAT],
                 [NSNumber numberWithDouble: GULBERG_4_LAT],
                 [NSNumber numberWithDouble: GULBERG_5_LAT],  nil];
    
    self.longitudes = [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble: LAHORE_CANTT_LONG],
                  [NSNumber numberWithDouble: CAVALRY_GROUND_LONG],
                  [NSNumber numberWithDouble: DHA_5_LONG],
                  [NSNumber numberWithDouble: DHA_6_LONG],
                  [NSNumber numberWithDouble: GULBERG_1_LONG],
                  [NSNumber numberWithDouble: GULBERG_2_LONG],
                  [NSNumber numberWithDouble: GULBERG_3_LONG],
                  [NSNumber numberWithDouble: GULBERG_4_LONG],
                  [NSNumber numberWithDouble: GULBERG_5_LONG], nil];
    
    NSMutableArray *places = [NSMutableArray arrayWithObjects: PIOPlace_Cantt,
                              PIOPlace_Cavalary,
                              PIOPlace_DHA_Phase_5,
                              PIOPlace_DHA_Phase_6,
                              PIOPlace_Gulberg_1,
                              PIOPlace_Gulberg_2,
                              PIOPlace_Gulberg_3,
                              PIOPlace_Gulberg_4,
                              PIOPlace_Gulberg_5, nil];
    
    
    
    for ( int i=0; i<[self.latitudes count]; i++)
    {
        CLLocationCoordinate2D coord;
        
        coord.latitude=[[NSString stringWithFormat:@"%@",[self.latitudes objectAtIndex:i]] floatValue];
        coord.longitude=[[NSString stringWithFormat:@"%@",
                          [self.longitudes objectAtIndex:i]] floatValue];
        //        MKCoordinateRegion region1;
        //        region1.center=coord;
        //        region1.span.longitudeDelta=20 ;
        //        region1.span.latitudeDelta=20;
        //        [self.mapView setRegion:region1 animated:YES];
        
        NSString *titleStr =[places objectAtIndex:i] ;
        // NSLog(@"title is:%@",titleStr);
        
        PIOMyAnnotation*  annotObj =[[PIOMyAnnotation alloc]initWithCoordinate:coord title:titleStr];
        [self.annotations addObject: annotObj];
        if (i>= 2 && i <= 3) {
            [self.DHA_Annotations addObject: annotObj];
        }
        else if (i>= 4) {
            [self.GULBERG_Annotations addObject: annotObj];
        }
        [self.mapView addAnnotation: annotObj];
    }
    
    // [self.mapView addAnnotations: annotations];
    [self performSelector: @selector( zoomMapAfterDelay) withObject:nil afterDelay:.5];
}
- (void)zoomMapAfterDelay
{
    [self zoomMapViewToFitAnnotations: self.mapView animated: YES withAnnotations: self.annotations];
    
}

//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated withAnnotations:(NSArray *)annotaionArray
{
    
    NSInteger count = [annotaionArray count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotaionArray objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 2*METERS_MILE, 2*METERS_MILE);
//    [[self mapView] setRegion:viewRegion animated:YES];
//    [[self locationManager] stopUpdatingLocation];
//
////    if (currentLocation != nil) {
////        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
////        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
////    }
//}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = locations.lastObject;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 2*METERS_MILE, 2*METERS_MILE);
    [[self mapView] setRegion:viewRegion animated:YES];
    
    
    
//    // Reverse Geocoding
//    //    NSLog(@"Resolving the Address");
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        //        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
//        if (error == nil && [placemarks count] > 0) {
//            placemark = [placemarks lastObject];
//           
//            self.address =[NSString stringWithFormat:@"%@ %@\n%@\n%@",
//                      placemark.thoroughfare,
//                      placemark.locality,
//                      placemark.administrativeArea,
//                      placemark.country];
//
//        } else {
//            NSLog(@"%@", error.debugDescription);
//        }
//    } ];
    [[self locationManager] stopUpdatingLocation];
    
}


#pragma mark- MKMapViewDelegate

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation:(id<MKAnnotation>) annotation
{
        if (annotation == mapView.userLocation)
        {
            return nil;
        }
        
    MKAnnotationView *pin = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"VoteSpotPin"];
    if (pin == nil)
    {
        pin = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"TestPin"] ;
    }
    else
    {
        pin.annotation = annotation;
    }
    
    [pin setImage:[UIImage imageNamed:@"order-location"]];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
    //    }
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.detailTextLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.0]];
    [cell.detailTextLabel setText: [self.locations objectAtIndex: indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.frame  = CGRectMake(self.locationTextField.frame.origin.x, self.locationTextField.frame.size.height+self.locationTextField.frame.origin.y, self.locationTextField.frame.size.width,0);
    } completion:^(BOOL finished) {
        [self.locationTextField setText: [self.locations objectAtIndex: indexPath.row]];
        [self hideTableview];
        
        self.locationID = [NSString stringWithFormat: @"%li", (long)indexPath.row+1];
        NSArray *array = [NSArray arrayWithObject: [self.annotations objectAtIndex: indexPath.row]];
        if (indexPath.row == 2) {
            array = self.DHA_Annotations;
        }
        else if (indexPath.row == 3) {
            array = self.GULBERG_Annotations;
        }
        [self zoomMapViewToFitAnnotations: self.mapView animated: YES withAnnotations: array];
        [self performSelector: @selector(fillAddressField) withObject:nil afterDelay:1.0];
    }];
    
}


- (void)fillAddressField
{
    MKMapPoint userPoint = MKMapPointForCoordinate(self.mapView.userLocation.location.coordinate);
    MKMapRect mapRect = self.mapView.visibleMapRect;
    BOOL inside = MKMapRectContainsPoint(mapRect, userPoint);
    if (!inside) {
        self.addressTextField.text = nil;
    }
    else {
        [self.addressTextField setText: self.address];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}



@end
