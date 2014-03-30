//
//  ContactCell.h
//  KitSample
//
//  Created by Gal Oshri on 12/31/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ContactCellDelegate.h"

@interface ContactCell : UITableViewCell 

@property (nonatomic) Contact *contact;

@property (nonatomic, assign) id<ContactCellDelegate> delegate;

-(void) toggleMenu;

-(void) showMenu;

-(void) hideMenu;

@end
