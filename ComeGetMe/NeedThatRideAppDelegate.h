//
//  HelloWorldAppDelegate.h
//  ComeGetMe
//
//  Created by Brian Anderson on 7/13/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAContact.h"

@interface NeedThatRideAppDelegate : UIResponder <UIApplicationDelegate> {
    BAContactCollection* m_contacts;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong) BAContactCollection* contacts;


@end
