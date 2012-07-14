//
//  HelloWorldDetailViewController.h
//  ComeGetMe
//
//  Created by Brian Anderson on 7/13/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloWorldDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
