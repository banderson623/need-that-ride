//
//  HelloWorldDetailViewController.m
//  ComeGetMe
//
//  Created by Brian Anderson on 7/13/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import "PresetContactDetailViewController.h"
#import <AddressBook/AddressBook.h>

@interface PresetContactDetailViewController ()
- (void)configureView;
@end

@implementation PresetContactDetailViewController

@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize mapView = m_mapView;
@synthesize addressLabel = m_addressLabel;
@synthesize currentUserCoordinate = m_currentUserCoordinate;
@synthesize contact = m_contact;
@synthesize messageButton1;

#pragma mark - Managing the detail item

- (void) setContact:(BAContact *)contact {
    m_contact = contact;
    [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    [self enableUI];
    if (m_contact) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"Select message to send to %@'s %@",
                                            m_contact.name, m_contact.phoneNumberLabel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setAddressLabel:nil];
    [self setMessageButton1:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - MapViewDelegate


- (void)viewWillAppear:(BOOL)animated
{
    [self getCurrentLocation];
}

- (void)disableUI
{
    m_isUIEnabled = false;
    NSLog(@"Disable UI until the reverse geocode is complete");
}

- (void)enableUI
{
    m_isUIEnabled = true;
    NSLog(@"enable UI");
}


#pragma mark - Geocode


- (void)getCurrentLocation
{
    [self disableUI];
        
    // if location services are restricted do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        m_addressLabel.text = @"Location Services are disabled...";
        return;
    }
    
    // if locationManager does not currently exist, create it
    if (!m_locationManager)
    {
        m_locationManager = [[CLLocationManager alloc] init];
        [m_locationManager setDelegate: self];
        m_locationManager.distanceFilter = 1.0f; // we don't need to be any more accurate than 10m
        m_locationManager.purpose = @"This may be used to obtain your reverse geocoded address";
    }
    
    [m_locationManager startUpdatingLocation];
    
    m_addressLabel.text = @"Locating...";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30)
    {
        return;
    }
    
    m_currentUserCoordinate = [newLocation coordinate];
    
    
    m_addressLabel.text = [NSString stringWithFormat:@"φ:%.4F, λ:%.4F", m_currentUserCoordinate.latitude, m_currentUserCoordinate.longitude];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(m_currentUserCoordinate,
                                                                   (CLLocationDistance) 10,
                                                                   (CLLocationDistance) 10);
    
    [m_mapView setCenterCoordinate:m_currentUserCoordinate animated:YES];
    [m_mapView setRegion:region animated:NO];
    [m_mapView setShowsUserLocation:YES];

    
    [self reverseGeocode];
    
    // after recieving a location, stop updating
    [self stopUpdatingCurrentLocation];
}

- (void) reverseGeocode
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocationCoordinate2D coord = m_currentUserCoordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        [self handleResults:placemarks];
    }];
}

- (void)stopUpdatingCurrentLocation
{
    [m_locationManager stopUpdatingLocation];
    //[self showCurrentLocationSpinner:NO];
}

- (void) displayError:(NSError*) error
{
     NSLog(@"%@", error);
}

// display the results
- (void)handleResults :(NSArray *)placemarks
{
    dispatch_async(dispatch_get_main_queue(),^ {
        [self enableUI];
        if ([placemarks count] > 0){
            CLPlacemark* pm = [placemarks objectAtIndex:0];
            NSDictionary* address = pm.addressDictionary;

            m_currentUserAddress = [NSString stringWithFormat: @"%@, %@ %@",
                                    [address valueForKey:(__bridge_transfer NSString*)kABPersonAddressStreetKey],
                                    [address valueForKey:(__bridge_transfer NSString*)kABPersonAddressCityKey],
                                    [address valueForKey:(__bridge_transfer NSString*)kABPersonAddressStateKey]
                                    ];
            m_addressLabel.text = m_currentUserAddress;
        }

    });
}


#pragma mark Message buttons pressed

- (IBAction)messageButton1Pressed:(id)sender {
    [self sendMessage:[NSString stringWithFormat:@"Please come get me, I am at %@",m_currentUserAddress]
        recipientList:[NSArray arrayWithObject:m_contact.phoneNumber]];
}

- (void)sendMessage:(NSString *)body recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController* messageController = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        messageController.body = body;
        messageController.recipients = recipients;
        messageController.messageComposeDelegate = self;
        [self presentModalViewController:messageController animated:YES];
    }    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled) {
        NSLog(@"Message cancelled");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
    } else {
        NSLog(@"Message failed");
    }
}

@end
