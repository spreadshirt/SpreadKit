//
//  SKProductViewController.m
//  SpreadKit
//
//  Created by Sebastian Marr on 04.09.12.
//
//

#import "SKProductViewController.h"

#import "SKProductView.h"

@interface SKProductViewController ()

@property SKProductView *productView;

@end

@implementation SKProductViewController

- (void)setProduct:(SKProduct *)product
{
    _product = product;
    self.productView = nil;
    self.productView = [[SKProductView alloc] initWithProduct:product andFrame:self.view.bounds];
    self.productView.appearanceChooserView.appearances = self.product.productType.appearances;
    self.productView.appearanceChooserView.delegate = self;
    [self.view addSubview:self.productView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)appearanceChooser:(SKAppearanceChooserView *)appearanceChooser didSelectAppearance:(SKAppearance *)appearance
{
    _product.appearance = appearance;
    self.productView.product = _product;
}

@end
