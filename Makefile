test:
	gem install cocoapods
	cd Example; pod install
	cd Example; sh build_and_run_unit_tests.sh Example DPMeterViewTests Tests Example.xcworkspace
