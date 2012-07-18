//
//  HelloWorldDetailViewController.h
//  ComeGetMe
//
//  Created by Brian Anderson on 7/13/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "BAContact.h"
                                                                // Says that it is the maps delegate
                                                                // need to implement a couple of methods - protocol == interface
@interface PresetContactDetailViewController : UIViewController <MKMapViewDelegate,MFMessageComposeViewControllerDelegate>
{
    CLLocationManager* m_locationManager; // location manager for current location
    CLLocationCoordinate2D m_currentUserCoordinate; // used to store the users selection
    BAContact* m_contact;
    NSString* m_currentUserAddress;
    bool m_isUIEnabled;
}


@property (readonly) CLLocationCoordinate2D currentUserCoordinate;
@property (strong, nonatomic) IBOutlet UILabel* detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, readonly) BAContact* contact;
@property (weak, nonatomic) IBOutlet UIButton *messageButton1;

- (IBAction)messageButton1Pressed:(id)sender;
- (void) setContact:(BAContact *)contact;

@end
