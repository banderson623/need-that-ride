//
//  HelloWorldMasterViewController.m
//  ComeGetMe
//
//  Created by Brian Anderson on 7/13/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import "HelloWorldMasterViewController.h"
#import "HelloWorldDetailViewController.h"
#import "BAContact.h"

@interface HelloWorldMasterViewController () {
    NSMutableArray* m_objects;
    BAContactCollection* m_contacts;

//    NSMutableArray* m_contacts;
}
@end

@implementation HelloWorldMasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(showPicker:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
//    [self insertNewRowWithTextLabel:@"Craig Fraser"];
//    [self insertNewRowWithTextLabel:@"Brian Anderson"];
//    [self insertNewRowWithTextLabel:@"Brett Lessing"];
    BAContact* contact = [[BAContact alloc] init];
    contact.name = @"Craig Fraser";
    contact.phoneNumber= @"408-873-1001";
    contact.phoneNumberLabel = @"Mobile";
    
    BAContact* contact2 = [[BAContact alloc] initWithName:@"Brian Anderson" PhoneNumber:@"515-708-4355" andLabel:@"iPhone"];

    if (m_contacts == nil) {
        m_contacts = [[BAContactCollection alloc] init];
    }
    //m_contacts = [[NSMutableArray alloc] init];
    
    [m_contacts addObject: contact];
    [m_contacts addObject: contact2];

    [self buildRowsForContacts];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



- (void)insertNewObject:(id)sender
{
    [self insertNewRowWithTextLabel: @"Hello World"];
}


- (void) buildRowsForContacts
{
    for(int i = 0; i < m_contacts.count; ++i)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
    }
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                          withRowAnimation:UITableViewRowAnimationLeft];

}

- (void) insertNewRowWithTextLabel:(NSString*) label
{
    if (!m_objects) {
        m_objects = [[NSMutableArray alloc] init];
    }
    
    [m_objects insertObject: label atIndex:[m_objects count]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                          withRowAnimation:UITableViewRowAnimationLeft];
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
        [m_objects removeObjectAtIndex:indexPath.row];
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
        NSDate *object = [m_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
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
        
    return YES;
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    [self addPerson:person withProperty:property andIdentifier: identifier];
    [self dismissModalViewControllerAnimated:YES];

    // Select a property
    return YES;
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
    
    [m_contacts addObject:personRecord];
}


@end
