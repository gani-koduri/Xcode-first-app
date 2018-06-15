//
//  ViewController.m
//  PaddyField
//
//  Created by Gani Koduri on 15/12/17.
//  Copyright © 2017 Gani. All rights reserved.
//

#import "ViewController.h"
#include <PubNub/PubNub.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *TempLabel;
@property (weak, nonatomic) IBOutlet UILabel *TempValue;
@property (weak, nonatomic) IBOutlet UIButton *OffButton;
@property (weak, nonatomic) IBOutlet UIButton *OnButton;

// Stores reference on PubNub client to make sure what it won't be released.
@property (nonatomic, strong) PubNub *client;
@property (weak, nonatomic) IBOutlet UILabel *TimeStamp;
@property (weak, nonatomic) IBOutlet UILabel *Sravya;
@property (weak, nonatomic) IBOutlet UILabel *Anvika;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Initialize and configure PubNub client instance
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-1b38815d-40e6-4a36-b002-8c77b2d7ded5" subscribeKey:@"sub-c-28a36826-49b8-11e8-a061-3a3a847bebcf"];
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
    
    // Subscribe to demo channel with presence observation
    [self.client subscribeToChannels: @[@"FarmEasy.PaddyField"] withPresence:NO];

}
- (IBAction)off:(UIButton *)sender {
    
    [self.client publish: @"GeneratorOFF"
               toChannel: @"FarmEasy.PaddyField" withCompletion:^(PNPublishStatus *status) {
                   
                   if (!status.isError) {
                       // Message successfully published to specified channel.
                       NSLog(@"Publishing Generator Off: Success");
                       
                       self.Sravya.hidden = TRUE;
                       self.Anvika.hidden = FALSE;
                   }
                   else {
                       
                       /**
                        Handle message publish error. Check 'category' property to find
                        out possible reason because of which request did fail.
                        Review 'errorData' property (which has PNErrorData data type) of status
                        object to get additional information about issue.
                        
                        Request can be resent using: [status retry];
                        */
                       
                       NSLog(@"Publishing Generator Off: Failed");

                   }
               }];
    
}
- (IBAction)lighton:(UIButton *)sender {
    
    [self.client publish: @"GeneratorON"
               toChannel: @"FarmEasy.PaddyField" withCompletion:^(PNPublishStatus *status) {
                   
                   if (!status.isError) {
                       // Message successfully published to specified channel.
                       NSLog(@"Publishing Generator On: Success");
                       self.Sravya.hidden = FALSE;
                       self.Anvika.hidden = TRUE;
                   }
                   else {
                       
                       /**
                        Handle message publish error. Check 'category' property to find
                        out possible reason because of which request did fail.
                        Review 'errorData' property (which has PNErrorData data type) of status
                        object to get additional information about issue.
                        
                        Request can be resent using: [status retry];
                        */
                       
                       NSLog(@"Publishing Generator On: Failed");
                       
                   }
               }];
}

- (BOOL) ifContainsString: (NSString*) substring source:(NSString *)sourceString{
    return [sourceString rangeOfString:substring].location != NSNotFound;
}

// Handle new message from one of channels on which client has been subscribed.
- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    // Handle new message stored in message.data.message

    if (![message.data.channel isEqualToString:message.data.subscription]) {
        
        
        // Message has been received on channel group stored in message.data.subscription.

    }
    else {
     /*
        NSString *obj = NULL;
        //obj = [(NSString*)[message.data.message valueForKey:@"Temperature"] lowercaseString];
        //obj = [(NSString*)message.data.message. lowercaseString];

        BOOL result = [self ifContainsString:@"Generator" source:(NSString*)message.data.message];
        if(!result)
        {
*/
        @try {
            NSObject *obj= [message.data.message valueForKey:@"Temperature"];
            obj=NULL;
            self.TempValue.text = [NSString stringWithFormat:@"%@ %@%@", [message.data.message valueForKey:@"Temperature"], @"\u00B0", @"C"];
            
            //[message.data.message valueForKey:@"Temperature"];
            
            NSDate * now = [NSDate date];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH:mm:ss"];
            NSString *newDateString = [outputFormatter stringFromDate:now];
            
            
            self.TimeStamp.text =  [NSString stringWithFormat:@"%@ : %@", @"Last updated at: ", newDateString];
            
            NSLog(@"Updating Temperature at timestamp : %@", newDateString);
        }
        @catch (NSException * e) {
            // Key did not exist
            NSLog(@"Ignoring SELF Command");
        }
        
        // Message has been received on channel stored in message.data.channel.
    }
    
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message,
          message.data.channel, message.data.timetoken);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
