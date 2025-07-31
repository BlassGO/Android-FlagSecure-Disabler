#Magisk modules use $MODPATH as main path
#Your script starts here:

if is_equal $CUSTOM_SETUP 0; then
   print "
      <box>
         <center>
            Flag Secure Disabler
         </center>
         <linebox/>
         <center>
            by @BlassGO      |   Version: 1.2.1
         </center>
         <linebox/>
         Support ALL Android Devices
      </box>
   " 50
fi
ui_print " "

#Needed variables
stock_services="/system/framework/services.jar"
mod_services="$MODPATH/system/framework/services.jar"

disable='
    .locals 1

    const/4 v0, 0x0

    return v0
'

dummy='
    .registers 6
    return-void
'

#Check Deodex
if ! check_content classes.dex "$stock_services"; then
    ui_print " "
    abort " You need a deodexed services.jar"
fi

#Making magisk space
ui_print " >> Making magisk space "
create_dir "$(dirname "$mod_services")"

#Flags
SS_OBSERVER=false
print "
      <box>
         <center>
            Disable the Screenshot Observer
         </center>
         <linebox/>
         <center>
            Yes = Volume Up
            No = Volume Down
         </center>
         <linebox/>
         Press a button to continue...
      </box>
" 30
if $yes; then
   SS_OBSERVER=true
fi

#Decompiling
ui_print " >> Decompiling services.jar..."
dynamic_apktool -decompile "$stock_services" -o "$TMP/services"
ui_print " "

#Smali patch with Smali Tool Kit
PATCH=false
ui_print " >> Disabling Flag Secure..."
smali_kit -c -m "isSecureLocked" -re "$disable" -d "$TMP/services" -name "WindowManagerService*" -name "WindowState*" && PATCH=true
if $SS_OBSERVER; then
   smali_kit -c -m "registerScreenCaptureObserver" -re "$dummy" -d "$TMP/services" -name "IActivityTaskManager*" -name "ActivityTaskManagerService*" && PATCH=true
fi
smali_kit -c -m "preventTakingScreenshotToTargetWindow" -re "$disable" -d "$TMP/services" -name "ScreenshotController*" && PATCH=true
ui_print " "

#Check Patchs
if not $PATCH; then
   abort "    No compatible patches"
fi

#Recompiling
ui_print " >> Recompiling services.jar..."
dynamic_apktool -preserve-signature -recompile "$TMP/services" -o "$mod_services"

#Check build
if is_valid "$mod_services"; then
    #Removing native odex (Stock firmwares)
    if exist folder /system/framework/oat; then
       for arm in /system/framework/oat/*; do
          for oat in services.art services.odex services.vdex; do
              if exist file "$arm/$oat"; then
                 create_dir "$MODPATH$arm"
                 # KSU Support
                 mknod "$MODPATH$arm/$oat" c 0 0
              fi
          done
       done
    fi
else
    abort "   Some ERROR occurred during the recompilation of services.jar ! "
fi

#Permissions / Contexts
set_perm 0 0 0644 "$mod_services"
set_context "$stock_services" "$mod_services"

ui_print " "
ui_print " >> Done "
ui_print " "
ui_print " "
ui_print " "
