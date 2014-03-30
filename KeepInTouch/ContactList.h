//
//  ContactList.h
//  KitSample
//
//  Created by Gal Oshri on 12/31/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactList : NSObject

@property (nonatomic, strong) NSMutableArray *contacts;

- (void)populateContacts;

- (void)saveContacts;

@end
