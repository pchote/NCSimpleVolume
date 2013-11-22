/*
* Copyright (c) 2012, Paul Chote
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this
* list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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