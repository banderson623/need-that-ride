//
//  BAContact.m
//  ComeGetMe
//
//  Created by Brian Anderson on 7/14/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import "BAContact.h"


// This is where the user is stored
@implementation BAContact

@synthesize name;
@synthesize phoneNumber;
@synthesize phoneNumberLabel;

- (id) initWithName: (NSString* )lname PhoneNumber: (NSString*) number andLabel: (NSString*) label {
    
    [self setName:lname];
    [self setPhoneNumber:number];
    [self setPhoneNumberLabel:label];
    return self;

}



@end


@implementation BAContactCollection

- (id) init {
    m_contacts = [[NSMutableArray alloc] init];
    return self;
}

- (NSUInteger) count {
    return [m_contacts count];
}


- (id)objectAtIndex:(NSUInteger)index {
    return [m_contacts objectAtIndex:index];
}


- (bool)addObject:(id) contact {
    NSLog(@"Adding contact: %@",contact);
    [m_contacts addObject:contact];
    return true;
}


@end