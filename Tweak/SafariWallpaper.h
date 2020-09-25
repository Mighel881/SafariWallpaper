#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences;

UIImageView* wallpaperView;
UIImage* wallpaper;

extern BOOL enabled;

// user interface based wallpaper
BOOL useDifferentInterfaceWallpapersSwitch = NO;

@interface CatalogViewController : UIViewController
@end