//
//  ContactCellDelegate.h
//  KitSample
//
//  Created by Gal Oshri on 12/31/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@protocol ContactCellDelegate <NSObject>

-(void) contactSoftDismissed:(Contact *)contact;

-(void) contactHardDismissed:(Contact *)contact;

-(void) contactRecentTouch:(Contact *)contract;

-(void) contactSendEmail:(Contact *)contact;

-(void) contactSendMessage:(Contact *)contact;

@end
