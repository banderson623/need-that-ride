//
//  HelloWorldMasterViewController.m
//  ComeGetMe
//
//  Created by Brian Anderson on 7/13/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//
#import "NeedThatRideAppDelegate.h"
#import "PresetContactMasterViewController.h"
#import "PresetContactDetailViewController.h"
#import "BAContact.h"

@interface PresetContactMasterViewController () {
    NSMutableArray* m_objects;
    BAContactCollection* m_contacts;
    
}
@end

@implementation PresetContactMasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    m_contacts = ((NeedThatRideAppDelegate *)[UIApplication sharedApplication].delegate).contacts;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(showPicker:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self buildRowsForContacts];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return false;
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void) buildRowsForContacts
{
    for(int i = 0; i < m_contacts.count; ++i)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_contacts.count;
    //return m_objects.count;
}

// This draws and inserts the row.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BAContact* contact = [m_contacts objectAtIndex:indexPath.row];
    
    // If we have to create a cell, do it here.
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.phoneNumberLabel;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [m_contacts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = [m_objects objectAtIndex:indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setContact:[m_contacts objectAtIndex:indexPath.row]];
    }
}



# pragma mark - User Picker

- (IBAction)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
}


- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController: 
(ABPeoplePickerNavigationController *)peoplePicker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
        
    bool shouldPresentPhoneNumberPicker = true;
    // Check if there is exactly one phone record, if there is no need to present any
    // other option, just add it.
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if(ABMultiValueGetCount(phoneNumbers) == 1){
        // no need to take it to the next view
        shouldPresentPhoneNumberPicker = false;
        // Call the method to add the person's phone number.
        [self addPerson:person
           withProperty:kABPersonPhoneProperty
          andIdentifier:ABMultiValueGetIdentifierAtIndex(phoneNumbers, 0)];

    } else if(ABMultiValueGetCount(phoneNumbers) == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Selected contact has no phone numbers"
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
        shouldPresentPhoneNumberPicker = false;
    }
    
    if(!shouldPresentPhoneNumberPicker){
        // Close contact view
        [self dismissModalViewControllerAnimated:YES];
    }
    
    return shouldPresentPhoneNumberPicker;
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    [self addPerson:person withProperty:property andIdentifier: identifier];
    // Close contact view
    [self dismissModalViewControllerAnimated:YES];

    // Select a property
    return NO;
}


- (void) addPerson: (ABRecordRef)person
      withProperty: (ABPropertyID) property
     andIdentifier:(ABMultiValueIdentifier) identifier {
    
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);

    CFIndex selection = ABMultiValueGetIndexForIdentifier(ABRecordCopyValue(person, kABPersonPhoneProperty), identifier);
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, property);
    CFStringRef phoneLabelRef = ABMultiValueCopyLabelAtIndex(phoneNumbers, selection);
    
    NSString* phoneLabel = (__bridge NSString *)(ABAddressBookCopyLocalizedLabel(phoneLabelRef));
    NSString* phoneNumber = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, selection);
    NSString* name = [[firstName stringByAppendingString:@" " ] stringByAppendingString: lastName];
    
    BAContact* personRecord = [BAContact alloc];
    [personRecord setPhoneNumber:phoneNumber];
    [personRecord setPhoneNumberLabel: phoneLabel];
    [personRecord setName:name];
    
    // If the cotnact was added, redraw row.
    if([m_contacts addObject:personRecord]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([m_contacts count]- 1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    
}


@end
