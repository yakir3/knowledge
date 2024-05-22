#!/bin/bash
echo 'loading......'
	sed -i "" "s/bianliang1/$LOGNAME/g" micool_macconfig/JetBrains/*.*/*.vmoptions
	sleep 1s
	sed -i "" "s/bianliang1/$LOGNAME/g" micool_macconfig/JetBrainsold/*.*/*.vmoptions
	#cp -f micool_macconfig/_auto/micool2017.jar ~/Library/micool2017.jar
	#cp -f micool_macconfig/_auto/micool2018.jar ~/Library/micool2018.jar
	#cp -f micool_macconfig/_auto/micool2019.jar ~/Library/micool2019.jar
	cp -f micool_macconfig/_auto/micool.jar ~/Library/micool.jar
	cp -f micool_macconfig/_auto/janf_config.txt ~/Library/janf_config.txt
	cp -fR micool_macconfig/_auto/plugins ~/Library/

	sleep 1s
	cp -fR micool_macconfig/JetBrains ~/Library/Application\ Support/
	#sleep 1s
	#cp -fR micool_macconfig/JetBrainsold/ ~/Library/Preferences/
echo 'nice.succ!'
