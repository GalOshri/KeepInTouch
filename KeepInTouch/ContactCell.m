//
//  ContactCell.m
//  KitSample
//
//  Created by Gal Oshri on 12/31/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import "ContactCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ContactCell ()
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic) CGPoint originalCenter;

@property (nonatomic) BOOL softDismissOnDragRelease;
@property (nonatomic) BOOL hardDismissOnDragRelease;
@property (nonatomic) BOOL recentTouchOnDragRelease;

@property (nonatomic, strong) UILabel *tickLabel;
@property (nonatomic, strong) UILabel *crossLabel;

@property (nonatomic, strong) UIButton *contactCallButton;
@property (nonatomic, strong) UIButton *contactMessageButton;
@property (nonatomic, strong) UIButton *contactEmailButton;

@property (nonatomic) BOOL isMenuShown;

@end

@implementation ContactCell


- (CAGradientLayer *) gradientLayer
{
    if (!_gradientLayer)
        _gradientLayer = [[CAGradientLayer alloc] init];
    return _gradientLayer;
}


#pragma mark - Our Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // cue labels
        self.tickLabel = [self createCueLabel];
        self.tickLabel.text = @"\u2713";
        self.tickLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.tickLabel];
        self.crossLabel = [self createCueLabel];
        self.crossLabel.text = @"\u2717";
        self.crossLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.crossLabel];
        
        // menu buttons
        [self createMenuButtons];
        
        self.isMenuShown = NO;
        
        [self.contentView.superview setClipsToBounds:NO];
        [self setClipsToBounds:NO];
        
        
        // gradient layer
        self.gradientLayer = [CAGradientLayer layer];
        self.frame = self.bounds;
        self.gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                      (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                      (id)[[UIColor clearColor] CGColor],
                                      (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        self.gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        [self.layer insertSublayer:self.gradientLayer atIndex:1];
        
        // gesture
        UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;

- (UILabel *) createCueLabel
{
    UILabel * label= [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void) createMenuButtons
{
    // Call button
    self.contactCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contactCallButton addTarget:self action:@selector(myCustomFunction:) forControlEvents:UIControlEventTouchUpInside];
    //[myButton setBackgroundImage:[UIImage imageNamed:@"yourImageName.png"] forState:UIControlStateNormal];
    self.contactCallButton.frame = CGRectNull;
    self.contactCallButton.backgroundColor = [UIColor greenColor];
    [self.contactCallButton setHidden:YES];
    
    [self addSubview:self.contactCallButton];
    
    // Message button
    self.contactMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contactMessageButton addTarget:self action:@selector(myCustomFunction:) forControlEvents:UIControlEventTouchUpInside];
    //[myButton setBackgroundImage:[UIImage imageNamed:@"yourImageName.png"] forState:UIControlStateNormal];
    self.contactMessageButton.frame = CGRectNull;
    self.contactMessageButton.backgroundColor = [UIColor blueColor];
    [self.contactMessageButton setHidden:YES];
    
    [self addSubview:self.contactMessageButton];
    
    // Email button
    self.contactEmailButton = [[UIButton alloc] initWithFrame:CGRectNull];
    self.contactEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contactEmailButton addTarget:self action:@selector(myCustomFunction:) forControlEvents:UIControlEventTouchUpInside];
    //[myButton setBackgroundImage:[UIImage imageNamed:@"yourImageName.png"] forState:UIControlStateNormal];
    self.contactEmailButton.backgroundColor = [UIColor cyanColor];
    [self.contactEmailButton setHidden:YES];
    
    [self addSubview:self.contactEmailButton];
    
    self.contactCallButton.frame = CGRectMake(240, 0, UI_CUES_WIDTH, self.bounds.size.height);
    self.contactMessageButton.frame = CGRectMake(170, 0, UI_CUES_WIDTH, self.bounds.size.height);
    self.contactEmailButton.frame = CGRectMake(100, 0, UI_CUES_WIDTH, self.bounds.size.height);
}

- (void)myCustomFunction:(id)sender
{
    if (sender == self.contactCallButton)
    {
        NSLog(@"You clicked on Call");
    }
    if (sender == self.contactMessageButton)
    {
        NSLog(@"You clicked on Message");
    }
    if (sender == self.contactEmailButton)
    {
        NSLog(@"You clicked on Email");
    }
    return;
}

const float LABEL_LEFT_MARGIN = 15.0f;

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
    
    self.tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
    self.crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
    

}
/*
- (void)setTodoItem:(GARToDoItem *)todoItem
{
    _todoItem = todoItem;
    self.itemCompleteLayer.hidden = !todoItem.completed;
}*/

- (void)toggleMenu
{
    if (self.isMenuShown)
        [self hideMenu];
    else
        [self showMenu];
}

- (void)showMenu
{
    if (self.isMenuShown)
        return;
    else
    {
        
        [self.contactCallButton setHidden:NO];
        [self.contactMessageButton setHidden:NO];
        [self.contactEmailButton setHidden:NO];
        [UIView animateWithDuration:0.2 animations:^
         {
             self.contactCallButton.alpha = 1.0;
             self.contactMessageButton.alpha = 1.0;
             self.contactEmailButton.alpha = 1.0;
         }];
         
        self.isMenuShown = YES;
    }
}

- (void)hideMenu
{
    if (!self.isMenuShown)
        return;
    else
    {
        [UIView animateWithDuration:0.2 animations:^
        {
            self.contactCallButton.alpha = 0.0;
            self.contactMessageButton.alpha = 0.0;
            self.contactEmailButton.alpha = 0.0;
        }
                         completion:^(BOOL finished)
        {
            [self.contactCallButton setHidden:YES];
            [self.contactMessageButton setHidden:YES];
            [self.contactEmailButton setHidden:YES];
        }];
        self.isMenuShown = NO;
    }
}

#pragma mark - Horizontal Pan Gesture Methods

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    
    if (fabsf(translation.x) > fabsf(translation.y))
    {
        return YES;
    }
    return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.originalCenter = self.center;
        [self hideMenu];
    }
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(self.originalCenter.x + translation.x, self.originalCenter.y);
        self.softDismissOnDragRelease = self.frame.origin.x < -self.frame.size.width / 4;
        if (self.frame.origin.x < -self.frame.size.width / 2)
        {
            self.hardDismissOnDragRelease = YES;
            self.softDismissOnDragRelease = NO;
        }
        else
            self.hardDismissOnDragRelease = NO;

        self.recentTouchOnDragRelease = self.frame.origin.x > self.frame.size.width / 4;
        
        float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 2);
        self.tickLabel.alpha = cueAlpha;
        self.crossLabel.alpha = cueAlpha;
        
        
        
        
        self.tickLabel.textColor = self.recentTouchOnDragRelease ? [UIColor purpleColor] : [UIColor whiteColor];
        self.crossLabel.textColor = self.softDismissOnDragRelease ? [UIColor blueColor] : [UIColor whiteColor];
        self.crossLabel.textColor = self.hardDismissOnDragRelease ? [UIColor redColor] : self.crossLabel.textColor;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
 
        if (self.softDismissOnDragRelease)
        {
            [self.delegate contactSoftDismissed:self.contact];
        }
        
        else if (self.hardDismissOnDragRelease)
        {
            ;
        }
        
        else if (self.recentTouchOnDragRelease)
        {
            ;
        }
        
        else
        {
            [UIView animateWithDuration:0.2 animations:^{self.frame = originalFrame;}];
        }
    }
}


@end
