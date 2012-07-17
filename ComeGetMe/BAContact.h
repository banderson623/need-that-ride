//
//  BAContact.h
//  ComeGetMe
//
//  Created by Brian Anderson on 7/14/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/ABRecord.h>


@interface BAContact : NSObject {
    NSString* name;
    NSString* phoneNumberLabel;
    NSString* phoneNumber;
}

- (id) initWithDictionary:(NSDictionary*) dict;
- (id) initWithName: (NSString* )name PhoneNumber: (NSString*) number andLabel: (NSString*) label;
- (NSDictionary*)dictionary;


@property (retain) NSString* name;
@property (retain) NSString* phoneNumber;
@property (retain) NSString* phoneNumberLabel;
@property ABRecordID* recordId;

@end


@interface BAContactCollection : NSObject {
    NSMutableArray* m_contacts;
}

+ (NSString*)filePath;

- (id) init;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (bool)addObject:(id) contact;
- (void)removeObjectAtIndex:(NSUInteger)index;

//- (id) initWithDictionary:(NSDictionary*) dict;
- (id) initFromFile;
//- (NSDictionary*)dictionary;
//- (id) plist;
- (bool) save;



@end