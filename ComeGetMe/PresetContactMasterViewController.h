//
//  HelloWorldMasterViewController.h
//  ComeGetMe
//
//  Created by Brian Anderson on 7/13/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PresetContactMasterViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

- (IBAction)showPicker:(id)sender;

@end
