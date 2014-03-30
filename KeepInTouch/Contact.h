//
//  Contact.h
//  KitSample
//
//  Created by Gal Oshri on 12/29/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Contact : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (nonatomic) NSInteger priority;
@property (nonatomic) ABRecordID recordID;
@property (nonatomic) ABMultiValueIdentifier phoneNumberIdentifier;
@property (nonatomic) ABMultiValueIdentifier emailIdentifier;

- (id)initWithFirstName:(NSString *)firstName
           WithLastName:(NSString *)lastName
         WithABRecordID:(ABRecordID)recordID;

- (NSString *)getContactPhoneNumber;

- (NSString *)getContactEmail;

@end
