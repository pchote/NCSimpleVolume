#import "BBWeeAppController-Protocol.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MPVolumeView.h>
#import <UIKit/UIButton.h>

@interface SimpleVolumeSliderController : NSObject <BBWeeAppController>
{
    UIView *mainView;
}

+ (void)initialize;
- (UIView *)view;

@end

@implementation SimpleVolumeSliderController

+ (void)initialize {}
- (float)viewHeight { return 34; }

- (UIView *)view 
{
    if (mainView == nil)
    {
        CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
        mainFrame.size.height = [self viewHeight];

        mainView = [[UIView alloc] initWithFrame:mainFrame];
        mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        float margin = 44;

        // Volume slider
        {
            UIImage *trackThumb = [UIImage imageNamed:@"SwitcherSliderThumb.png"];
            UIImage *trackMin = [[UIImage imageNamed:@"SwitcherSliderTrackMin.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 5, 0, 5)];
            UIImage *trackMax = [[UIImage imageNamed:@"SwitcherSliderTrackMax.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 5, 0, 5)];

            MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(margin, 8, mainFrame.size.width - 2*margin, mainFrame.size.height)];
            volumeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [mainView addSubview: volumeView];

            // Search the MPVolumeView subviews to find the slider to skin, and airplay button to fix broken touch events
            for (UIView *view in [volumeView subviews])
            {
                if ([view isKindOfClass:[UISlider class]])
                {
                    UISlider *a = (UISlider *)view;
                    [a setThumbImage: trackThumb forState:UIControlStateNormal];
                    [a setMinimumTrackImage:trackMin forState:UIControlStateNormal];
                    [a setMaximumTrackImage:trackMax forState:UIControlStateNormal];
                }
                if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton *airplayButton = (UIButton *)view;
                    [airplayButton setShowsTouchWhenHighlighted:NO];
            
                    UILongPressGestureRecognizer *lpgr = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(airplayPressed:)] autorelease];
                    [lpgr setMinimumPressDuration: 0.0];
                    [airplayButton addGestureRecognizer:lpgr];
                }
            }

            [volumeView release];
        }

        // 'Quieter' icon
        {
            UIImageView *lessIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SimpleVolumeSlider.bundle/SpeakerMin.png"]];
            lessIcon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            lessIcon.frame = CGRectMake((margin - 9)/2, ([self viewHeight] - 24)/2, 9, 24);
            [mainView addSubview:lessIcon];
            [lessIcon release];
        }

        // 'Louder' icon
        {
            UIImageView *moreIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SimpleVolumeSlider.bundle/SpeakerMax.png"]];
            moreIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            moreIcon.frame = CGRectMake(mainFrame.size.width - (margin + 24)/2, ([self viewHeight] - 24)/2, 24, 24);
            [mainView addSubview:moreIcon];
            [moreIcon release];
        }
    }
    return mainView;
}

- (void)dealloc
{
    [mainView release];
    [super dealloc];
}

@end