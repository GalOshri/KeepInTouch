//
//  ContactList.h
//  KitSample
//
//  Created by Gal Oshri on 12/29/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactList.h"
#import "ContactViewDelegate.h"

@interface ContactListView : UITableViewController <ABPeoplePickerNavigationControllerDelegate, ContactViewDelegate>

@property (nonatomic, strong) ContactList *contactList;

@end
