//
//  ContactList.m
//  KitSample
//
//  Created by Gal Oshri on 12/31/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import "ContactList.h"
#import "Contact.h"

@implementation ContactList

- (NSMutableArray *)contacts
{
    if (!_contacts)
    {
        _contacts = [[NSMutableArray alloc] init];
    }
    
    return _contacts;
}

- (void)populateContacts
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSMutableArray *archiveArray = [userData objectForKey:@"ContactList"];
    
    [self.contacts removeAllObjects];
    
    for (NSData *data in archiveArray)
    {
        Contact *contact = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.contacts addObject:contact];
    }
}

- (void)saveContacts
{
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:self.contacts.count];
    for (Contact *contact in self.contacts)
    {
        NSData *contactEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:contact];
        [archiveArray addObject:contactEncodedObject];
    }
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:archiveArray forKey:@"ContactList"];
    [userData synchronize];
}

@end
