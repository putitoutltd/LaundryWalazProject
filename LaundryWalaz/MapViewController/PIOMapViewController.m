//
//  PIOMapViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/29/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOMapViewController.h"
#import <MapKit/MapKit.h>
#import "PIOOrderViewController.h"
#import "PIOAppController.h"

#define METERS_MILE 1609.344
#define METERS_FEET 3.28084

@interface PIOMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end

@implementation PIOMapViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = NO;
    
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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)confirmAddressButtonPressed:(id)sender
{
    PIOOrderViewController *orderViewController = [PIOOrderViewController new];
    [self.navigationController pushViewController: orderViewController animated: YES];
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
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
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

@end
