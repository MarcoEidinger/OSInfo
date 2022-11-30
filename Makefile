test:
	xcodebuild -scheme OSInfo -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 13' clean build test
	xcodebuild -scheme OSInfo -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPad Air (5th generation)' clean build test
	xcodebuild -scheme OSInfo -sdk macosx -destination 'platform=macOS,variant=Mac Catalyst' clean build test
	xcodebuild -scheme OSInfo -sdk macosx -destination 'platform=macOS' clean build test
