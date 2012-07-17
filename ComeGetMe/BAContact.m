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
    if(self = [super init]){
        [self setName:lname];
        [self setPhoneNumber:number];
        [self setPhoneNumberLabel:label];
    }
    return self;

}

#pragma mark Serialization support

- (id) initWithDictionary: (NSDictionary*) dict {
    if(self = [self init]){
        NSLog(@"Should use dictionary to build object");
        name = [dict valueForKey:@"name"];
        phoneNumber = [dict valueForKey:@"phoneNumber"];
        phoneNumberLabel = [dict valueForKey:@"phoneNumberLabel"];
    }
    return self;
}

- (NSDictionary*)dictionary {
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: name, phoneNumber, phoneNumberLabel, nil]
                                                     forKeys:[NSArray arrayWithObjects:@"name", @"phoneNumber", @"phoneNumberLabel", nil]];
    return dict;
}



@end


@implementation BAContactCollection

+ (NSString*) filePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"presetContacts.plist"];
    return path;
}

- (id) init {
    if(self = [super init]) {
        m_contacts = [[NSMutableArray alloc] init];
    }
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

- (void)removeObjectAtIndex:(NSUInteger)index {
    [m_contacts removeObjectAtIndex:index];
}


#pragma mark Serialization

// Uses the class method filePath
- (id) initFromFile {
    if(self = [self init]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:[BAContactCollection filePath]]){
            NSArray* data = [[NSArray alloc] initWithContentsOfFile:[BAContactCollection filePath]];
            bool canContinue = true;
            for(int i = 0; i < [data count] && canContinue; ++i){
                [self addObject: [[BAContact alloc] initWithDictionary:[data objectAtIndex:i]]];
            }
        }
    }
    return self;
}


- (bool) save {
    
    NSMutableArray* contacts = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self count]; ++i){
        [contacts addObject: [[m_contacts objectAtIndex: i] dictionary]];
    }

    return [contacts writeToFile: [BAContactCollection filePath]
                               atomically:true];
}


@end