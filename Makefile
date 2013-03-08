test:
	cd Example; bundle install
	cd Example/WaxSim; xcodebuild install DSTROOT=/ INSTALL_PATH=/usr/local/bin
	cd Example; pod install
	cd Example; sh build_and_run_unit_tests.sh Example DPMeterViewTests Tests Example.xcworkspace
