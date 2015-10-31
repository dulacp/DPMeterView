test:
	xctool -workspace Example/Example.xcworkspace -scheme DPMeterViewTests test

citest:
	set -o pipefail && xcodebuild -workspace Example/Example.xcworkspace -scheme DPMeterViewTests -configuration Release -sdk iphonesimulator -destination platform='iOS Simulator',OS=7.1,name='iPhone Retina (4-inch)' clean test | xcpretty -c
