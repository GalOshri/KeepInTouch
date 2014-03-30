//
//  ContactViewDelegate.h
//  KitSample
//
//  Created by Gal Oshri on 1/12/14.
//  Copyright (c) 2014 BT601. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@protocol ContactViewDelegate <NSObject>

- (void) contactDeleted:(Contact *)contact;

@end
