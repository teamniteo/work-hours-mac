test:
	xcodebuild -project "Work Hours.xcodeproj" -clonedSourcePackagesDirPath SourcePackages -scheme "Work Hours" -configuration Debug -resultBundlePath test.xcresult -destination platform=macOS test 

build:
	xcodebuild -project "Work Hours.xcodeproj" -clonedSourcePackagesDirPath SourcePackages -scheme "Work Hours" -configuration Debug -destination platform=macOS build

libSetapp:
	wget "https://developer-api.setapp.com/v1/applications/496/kevlar?token=${SETAPP_TOKEN}&type=libsetapp_silicon" -O libsetapp.zip
	unzip libsetapp.zip
	rm libsetapp.zip

archive-debug:
	xcodebuild -project "Work Hours.xcodeproj" -clonedSourcePackagesDirPath SourcePackages -scheme "Work Hours" -destination platform=macOS archive -archivePath app.xcarchive -configuration Debug -allowProvisioningUpdates
	xcodebuild -exportArchive -archivePath app.xcarchive -exportPath Export -exportOptionsPlist exportOptionsDev.plist

archive-debug-setapp: libSetapp
	xcodebuild -project "Work Hours.xcodeproj" -clonedSourcePackagesDirPath SourcePackages -scheme "Work Hours SetApp" -destination platform=macOS archive -archivePath setapp.xcarchive -configuration Debug -allowProvisioningUpdates
	xcodebuild -exportArchive -archivePath setapp.xcarchive -exportPath SetAppExport -exportOptionsPlist exportOptionsDev.plist
	mv SetAppExport/Pareto\ Security\ SetApp.app SetAppExport/Work\ Hours.app

archive-release:
	xcodebuild -project "Work Hours.xcodeproj" -clonedSourcePackagesDirPath SourcePackages -scheme "Work Hours" -destination platform=macOS archive -archivePath app.xcarchive -configuration Release -allowProvisioningUpdates
	xcodebuild -exportArchive -archivePath app.xcarchive -exportPath Export -exportOptionsPlist exportOptions.plist


archive-release-setapp: libSetapp
	rm -rf SetAppExport
	xcodebuild -project "Work Hours.xcodeproj" -clonedSourcePackagesDirPath SourcePackages -scheme "Work Hours SetApp" -destination platform=macOS archive -archivePath setapp.xcarchive -configuration Release -allowProvisioningUpdates
	xcodebuild -exportArchive -archivePath setapp.xcarchive -exportPath SetAppExport -exportOptionsPlist exportOptions.plist
	mv SetAppExport/Pareto\ Security\ SetApp.app SetAppExport/Work\ Hours.app

build-release-setapp:
	# rm -f WorkHoursSetApp.app.zip
	# rm -rf SetAppExport/Release
	# mkdir -p SetAppExport/Release
	# cp assets/Mac_512pt@2x.png SetAppExport/Release/AppIcon.png
	# cp -vr SetAppExport/Work\ Hours.app SetAppExport/Release/Work\ Hours.app
	# cd SetAppExport; ditto -c -k --sequesterRsrc --keepParent Release ../WorkHoursSetApp.app.zip
	cp -f assets/Mac_512pt@2x.png AppIcon.png
	zip -u WorkHoursSetApp.app.zip AppIcon.png
	rm -f AppIcon.png

dmg:
	create-dmg --overwrite Export/Work\ Hours.app Export && mv Export/*.dmg WorkHours.dmg

lint:
	swiftlint .

fmt:
	swiftformat --swiftversion 5 .
	swiftlint . --fix

notarize:
	xcrun notarytool submit WorkHours.dmg --team-id PM784W7B8X --progress --wait

clean:
	rm -rf SourcePackages
	rm -rf Export
	rm -rf SetAppExport

sentry-debug-upload:
	sentry-cli --auth-token ${SENTRY_AUTH_TOKEN} upload-dif app.xcarchive --org niteoweb --project pareto-mac

sentry-debug-upload-setapp:
	sentry-cli --auth-token ${SENTRY_AUTH_TOKEN} upload-dif setapp.xcarchive --org niteoweb --project pareto-mac