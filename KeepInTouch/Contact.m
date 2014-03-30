//
//  Contact.m
//  KitSample
//
//  Created by Gal Oshri on 12/29/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import "Contact.h"
#import <AddressBook/AddressBook.h>

@implementation Contact

- (id)initWithFirstName:(NSString *)firstName
           WithLastName:(NSString *)lastName
         WithABRecordID:(ABRecordID)recordID
{
    self = [super init];
    if (self) {
        if (firstName)
            self.firstName = [NSString stringWithString:firstName];
        else
            self.firstName = @"NO FIRST NAME OI VEI";
        if (lastName)
            self.lastName = [NSString stringWithString:lastName];
        else
            self.lastName = @"NO LAST NAME OI VEI";
        self.recordID = recordID;
        self.priority = 1;
        self.phoneNumberIdentifier = -1;
        self.emailIdentifier = -1;
    }
    return self;
}

- (NSString *)getContactPhoneNumber
{
    return [self getProperty:kABPersonPhoneProperty WithIdentifier:self.phoneNumberIdentifier];
}

- (NSString *)getContactEmail
{
    return [self getProperty:kABPersonEmailProperty WithIdentifier:self.emailIdentifier];
}

- (NSString *)getProperty:(ABPropertyID)property WithIdentifier:(ABMultiValueIdentifier)identifier
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef contactRecord = ABAddressBookGetPersonWithRecordID(addressBook, self.recordID);
    
    if (identifier == -1)
    {
        return @"Not chosen";
    }
    else
    {
        ABMultiValueRef listOfValues = ABRecordCopyValue(contactRecord, property);
        
        CFIndex indexForValue = ABMultiValueGetIndexForIdentifier(listOfValues, identifier);
        NSString *value = [NSString stringWithString:((__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(listOfValues, indexForValue))];
        
        CFRelease(listOfValues);
        return value;
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeInt32:self.recordID forKey:@"recordID"];
    [encoder encodeInteger:self.priority forKey:@"priority"];
    [encoder encodeInt32:self.phoneNumberIdentifier forKey:@"phoneNumberIdentifier"];
    [encoder encodeInt32:self.emailIdentifier forKey:@"emailIdentifier"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.recordID = [decoder decodeInt32ForKey:@"recordID"];
        self.priority = [decoder decodeIntegerForKey:@"priority"];
        self.phoneNumberIdentifier = [decoder decodeInt32ForKey:@"phoneNumberIdentifier"];
        self.emailIdentifier = [decoder decodeInt32ForKey:@"emailIdentifier"];
    }
    return self;
}

@end
