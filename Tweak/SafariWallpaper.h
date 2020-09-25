#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences;

UIImageView* wallpaperView;
UIImage* wallpaper;

extern BOOL enabled;

// miscellaneous
BOOL useDifferentInterfaceWallpapersSwitch = NO;

@interface CatalogViewController : UIViewController
@end