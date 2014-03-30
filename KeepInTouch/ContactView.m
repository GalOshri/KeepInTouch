//
//  ContactView.m
//  KitSample
//
//  Created by Gal Oshri on 1/1/14.
//  Copyright (c) 2014 BT601. All rights reserved.
//

#import "ContactView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface ContactView ()

// Labels
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPriorityLabel;

// Edit Tools
@property (weak, nonatomic) IBOutlet UIStepper *priorityStepper;
@property (weak, nonatomic) IBOutlet UIButton *editPhoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *editEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteContactButton;

// Edit Help Tips
@property (weak, nonatomic) IBOutlet UITextView *priorityHelpText;

@end

@implementation ContactView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // Set up Name and Priority
    self.contactNameLabel.text = [[self.contact.firstName stringByAppendingString:@" "] stringByAppendingString:self.contact.lastName];
    self.contactPriorityLabel.text = [NSString stringWithFormat:@"%d", self.contact.priority];
    self.priorityStepper.value = self.contact.priority;
    
    // Set up Phone Number
    self.contactNumberLabel.text = [self.contact getContactPhoneNumber];
    
    // Set up Email
    self.contactEmailLabel.text = [self.contact getContactEmail];
    
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setEditing:self.editing animated:YES]; // set editing if contact was just created
    
}

#pragma mark - Methods to Edit Contact Details

- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    self.contact.priority = [sender value];
    self.contactPriorityLabel.text = [NSString stringWithFormat:@"%d", self.contact.priority];
}

- (IBAction)editPhoneNumber {
    ABPersonViewController *view = [[ABPersonViewController alloc] init];
    
    view.personViewDelegate = self;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef contactRecord = ABAddressBookGetPersonWithRecordID(addressBook, self.contact.recordID);
    view.displayedPerson = contactRecord; // Assume person is already defined.
    
    view.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    
    view.allowsActions = NO;
    view.allowsEditing = NO;
    
    view.navigationItem.title = @"";
    
    if (self.contact.phoneNumberIdentifier != -1)
        [view setHighlightedItemForProperty:kABPersonPhoneProperty withIdentifier:self.contact.phoneNumberIdentifier];
    
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)editEmail {
    ABPersonViewController *view = [[ABPersonViewController alloc] init];
    
    view.personViewDelegate = self;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef contactRecord = ABAddressBookGetPersonWithRecordID(addressBook, self.contact.recordID);
    view.displayedPerson = contactRecord; // Assume person is already defined.
    
    view.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
    
    view.allowsActions = NO;
    view.allowsEditing = NO;
    
    view.navigationItem.title = @"";
    
    if (self.contact.emailIdentifier != -1)
        [view setHighlightedItemForProperty:kABPersonEmailProperty withIdentifier:self.contact.emailIdentifier];
    
    [self.navigationController pushViewController:view animated:YES];
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property
                  identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonPhoneProperty)
    {
        self.contact.phoneNumberIdentifier = identifier;
        [self.navigationController popViewControllerAnimated:YES];
        
        self.contactNumberLabel.text = [self.contact getContactPhoneNumber];
    }
    else if (property == kABPersonEmailProperty)
    {
        self.contact.emailIdentifier = identifier;
        [self.navigationController popViewControllerAnimated:YES];
        
        self.contactEmailLabel.text = [self.contact getContactEmail];
    }
    return NO;
}

- (IBAction)deleteContact {
    [self.delegate contactDeleted:self.contact];
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - Transition to/from Edit Mode

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing == YES)
    {
        // Change views to edit mode.
        [self.priorityStepper setHidden:NO];
        [self.priorityHelpText setHidden:NO];
        [self.editPhoneNumberButton setHidden:NO];
        [self.editEmailButton setHidden:NO];
        [self.deleteContactButton setHidden:NO];
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.priorityStepper.alpha = 1;
                             self.priorityHelpText.alpha = 1;
                             self.editPhoneNumberButton.alpha = 1;
                             self.editEmailButton.alpha = 1;
                             self.deleteContactButton.alpha = 1;
                         }];    
    }
    
    else
    {
        // Save the changes if needed and change the views to noneditable
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.priorityStepper.alpha = 0;
                             self.priorityHelpText.alpha = 0;
                             self.editPhoneNumberButton.alpha = 0;
                             self.editEmailButton.alpha = 0;
                             self.deleteContactButton.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self.priorityStepper setHidden:YES];
                             [self.priorityHelpText setHidden:YES];
                             [self.editPhoneNumberButton setHidden:YES];
                             [self.editEmailButton setHidden:YES];
                             [self.deleteContactButton setHidden:YES];
                         }];
    }
}

@end
