//
//  PlayListViewController.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListViewController.h"
#import "Macro.h"

#import "PlayerVideoWindowController.h"
@interface PlayListViewController ()

@end

@implementation PlayListViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect playerVideoFrame = [PlayerVideoWindowController getPlayerVideoWindowController].window.frame;
        self.view.frame = NSMakeRect(0, 0,300, playerVideoFrame.size.height-20);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:CColor(200, 10, 150, 1).CGColor];

}

@end
