//
//  ContactView.h
//  KitSample
//
//  Created by Gal Oshri on 1/1/14.
//  Copyright (c) 2014 BT601. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ContactViewDelegate.h"

@interface ContactView : UIViewController <ABPersonViewControllerDelegate>

@property (nonatomic, assign) id<ContactViewDelegate> delegate;

@property (strong, nonatomic) Contact *contact;

@end
