//
//  SKAppearanceChooserView.m
//  SpreadKit
//
//  Created by Sebastian Marr on 24.08.12.
//
//

#import "SKAppearanceChooserView.h"
#import "SKClient.h"
#import "SKImageLoader.h"
#import "SKAppearance.h"

@interface SKAppearanceChooserView ()

@property (nonatomic)  NSArray * appearances;

@end

@implementation SKAppearanceChooserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithProductView:(SKProductView *)productView andDelegate:(id<SKAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame
{
    if (self = [self initWithFrame:frame]) {
        self.productView = productView;
        self.delegate = delegate;
    }
    return self;
}

+ (SKAppearanceChooserView *)appearanceChooserWithProductView:(SKProductView *)productView andDelegate:(id<SKAppearanceChooserViewDelegate>)delegate andFrame:(CGRect)frame
{
    return [[self alloc] initWithProductView:productView andDelegate:delegate andFrame:frame];
}

- (void)setDelegate:(id<SKAppearanceChooserViewDelegate>)delegate
{
    _delegate = delegate;
    
    // ask the delegate for appearances to display
    self.appearances = [NSArray arrayWithArray:[delegate appearanceChooserDidRequestAppearances:self]];
}

- (void)setAppearances:(NSArray *)appearances
{
    _appearances = appearances;
    
    // display the appearances
    [self displayAppearances];
}

- (void)displayAppearances
{
    // remove everything to start again
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    GMGridView *grid = [[GMGridView alloc] initWithFrame:self.bounds];
    grid.style = GMGridViewStylePush;
    grid.centerGrid = NO;
    grid.itemSpacing = 2;
    grid.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    grid.scrollEnabled = NO;
    [self addSubview:grid];
    grid.dataSource = self;
    grid.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(20, 20);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
    }
    
    UIImageView *colorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    colorView.backgroundColor = [UIColor redColor];
    cell.contentView = colorView;
    
    SKAppearance *appearance = [self.appearances objectAtIndex:index];
    
    SKImageLoader *loader = [[SKImageLoader alloc] initWithApiKey:[SKClient sharedClient].apiKey
                                                        andSecret:[SKClient sharedClient].secret];
    [loader loadImageFromUrl:[[appearance.resources objectAtIndex:0] url] withSize:size completion:^(UIImage *image, NSURL *imageUrl, NSError *error) {
        colorView.image = image;
    }];
    
    return cell;
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.appearances.count;
}

@end
