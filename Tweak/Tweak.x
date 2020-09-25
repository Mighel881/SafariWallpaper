#import "SafariWallpaper.h"

BOOL enabled;

// iOS 13 & 14

%group SafariWallpaper

%hook CatalogViewController

- (void)viewDidAppear:(BOOL)animated { // add wallpaper

	%orig;

	if (!wallpaperView) {
		wallpaperView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
		[wallpaperView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
		if (!useDifferentInterfaceWallpapersSwitch && !useSpringBoardWallpaperSwitch) {
			NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImage"];
			wallpaper = [UIImage imageWithData:data];
		} else if (!useDifferentInterfaceWallpapersSwitch && useSpringBoardWallpaperSwitch) {
			NSData* homeWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"];
			CFDataRef homeWallpaperDataRef = (__bridge CFDataRef)homeWallpaperData;
			NSArray* imageArray = (__bridge NSArray *)CPBitmapCreateImagesFromData(homeWallpaperDataRef, NULL, 1, NULL);
			wallpaper = [UIImage imageWithCGImage:(CGImageRef)imageArray[0]];
		} else {
			if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight) {
				NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImageLight"];
				wallpaper = [UIImage imageWithData:data];
			} else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark) {
				NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImageDark"];
				wallpaper = [UIImage imageWithData:data];
			}
		}
	}

	[wallpaperView setImage:wallpaper];
	if (![wallpaperView isDescendantOfView:[self view]]) [[self view] insertSubview:wallpaperView atIndex:0];

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // transition when changing interface mode

	%orig;

	if (!useDifferentInterfaceWallpapersSwitch) return;
	if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight) {
		NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImageLight"];
		wallpaper = [UIImage imageWithData:data];
		[UIView transitionWithView:wallpaperView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[wallpaperView setImage:wallpaper];
		} completion:nil];
	} else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark) {
		NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImageDark"];
		wallpaper = [UIImage imageWithData:data];
		[UIView transitionWithView:wallpaperView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[wallpaperView setImage:wallpaper];
		} completion:nil];
	}

}

%end

%end

// iOS 12

%group SafariWallpaper12

%hook BookmarksNavigationController

- (void)viewDidAppear:(BOOL)animated { // add wallpaper

	%orig;

	if (!wallpaperView) {
		wallpaperView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
		[wallpaperView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
		if (!useDifferentInterfaceWallpapersSwitch && !useSpringBoardWallpaperSwitch) {
			NSData* data = [[NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/love.litten.safariwallpaperpreferences.plist"] objectForKey:@"wallpaperImage"];
			wallpaper = [UIImage imageWithData:data];
		} else if (!useDifferentInterfaceWallpapersSwitch && useSpringBoardWallpaperSwitch) {
			NSData* homeWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"];
			CFDataRef homeWallpaperDataRef = (__bridge CFDataRef)homeWallpaperData;
			NSArray* imageArray = (__bridge NSArray *)CPBitmapCreateImagesFromData(homeWallpaperDataRef, NULL, 1, NULL);
			wallpaper = [UIImage imageWithCGImage:(CGImageRef)imageArray[0]];
		}
	}
	
	[wallpaperView setImage:wallpaper];
	if (![wallpaperView isDescendantOfView:[self view]]) [[self view] insertSubview:wallpaperView atIndex:0];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.safariwallpaperpreferences"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	// Wallpaper
	[preferences registerBool:&useSpringBoardWallpaperSwitch default:NO forKey:@"useSpringBoardWallpaper"];

	// User Interface Based Wallpaper
	[preferences registerBool:&useDifferentInterfaceWallpapersSwitch default:NO forKey:@"useDifferentInterfaceWallpapers"];

	if (enabled) {
		if (!SYSTEM_VERSION_LESS_THAN(@"13")) %init(SafariWallpaper);
		if (SYSTEM_VERSION_LESS_THAN(@"13")) %init(SafariWallpaper12);
	}

}