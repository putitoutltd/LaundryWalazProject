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

#define METERS_MILE 1609.344
#define METERS_FEET 3.28084

@interface PIOMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSMutableArray *latitudes;
    NSMutableArray *longitudes;
}
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

    // Hide Back button
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.backButtonHide = YES;
    
    self.menuButtonNeedToHide = NO;
    self.navigationController.navigationBar.hidden = NO;
    
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
    
    [self.addressTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.0]];
    [self.locationTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.0]];
    [self.confirmAddressButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.75]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
   latitudes = [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble: 31.500898], [NSNumber numberWithDouble: 31.505354], nil];
    
    longitudes = [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble: 74.366417], [NSNumber numberWithDouble: 74.349949], nil];
    NSMutableArray *places = [NSMutableArray arrayWithObjects: @"Cavalry Ground Park", @"Gulberg III", nil];
    
    NSMutableArray *annotations = [[NSMutableArray alloc]init];
    for ( int i=0; i<[latitudes count]; i++)
    {
        CLLocationCoordinate2D coord;
        
        coord.latitude=[[NSString stringWithFormat:@"%@",[latitudes objectAtIndex:i]] floatValue];
        coord.longitude=[[NSString stringWithFormat:@"%@",
                          [longitudes objectAtIndex:i]] floatValue];
//        MKCoordinateRegion region1;
//        region1.center=coord;
//        region1.span.longitudeDelta=20 ;
//        region1.span.latitudeDelta=20;
//        [self.mapView setRegion:region1 animated:YES];
        
        NSString *titleStr =[places objectAtIndex:i] ;
        // NSLog(@"title is:%@",titleStr);
        
        PIOMyAnnotation*  annotObj =[[PIOMyAnnotation alloc]initWithCoordinate:coord title:titleStr];
        [self.mapView addAnnotation:annotObj];
        
    }
    
    
    [self zoomMapViewToFitAnnotations: self.mapView animated: YES];
}


#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    NSInteger count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
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
        PIOOrderViewController *orderViewController = [PIOOrderViewController new];
        [self.navigationController pushViewController: orderViewController animated: YES];
    }
    
    
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
    
    
    
    // Reverse Geocoding
//    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.addressTextField.text = [NSString stringWithFormat:@"%@ %@\n%@\n%@",
                                          placemark.thoroughfare,
                                          placemark.locality,
                                          placemark.administrativeArea,
                                          placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    [[self locationManager] stopUpdatingLocation];
    
}


#pragma mark- MKMapViewDelegate

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation:(id<MKAnnotation>) annotation
{
    //    if (annotation == mapView.userLocation)
    //    {
    //        return nil;
    //    }
    //    else
    //    {
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
        
//        CLLocationCoordinate2D coord;
//        
//        coord.latitude=[[NSString stringWithFormat:@"%@",[latitudes objectAtIndex:indexPath.row]] floatValue];
//        coord.longitude=[[NSString stringWithFormat:@"%@",
//                          [longitudes objectAtIndex:indexPath.row]] floatValue];
//        PIOMyAnnotation *ann = [[PIOMyAnnotation alloc]initWithCoordinate:coord title:@""];
//        CLLocation *oldLocation = [[CLLocation alloc]initWithLatitude: ann.coordinate.latitude longitude:ann.coordinate.longitude] ;
//        
//        
//               int distance = [self.mapView.userLocation.location distanceFromLocation:oldLocation];
//        if(distance >50 && distance <100)
//        {
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Distance"
//                                                            message:[NSString stringWithFormat:@"%i meters",distance]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            
//        }
//    
     
        
        
    }];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}



@end
