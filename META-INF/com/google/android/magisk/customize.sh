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
disable='
   .locals 1
   const/4 v0, 0x0
   return v0
'

dummy='
   .registers 6
   return-void
'

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

# Patch
for jar_dir in "/system/framework" "/system_ext/framework"; do
   for jar_name in "services" "miui-services"; do
      
      jar_path="$jar_dir/$jar_name.jar"

      if exist file "$jar_path"; then
         # For modules, the standard path $MODPATH/system/... must be guaranteed
         if is_substring "/system/" "$jar_path"; then
            system_prefix=true
            mod_jar_path="$MODPATH$jar_path"
         else
            system_prefix=false
            mod_jar_path="$MODPATH/system$jar_path"
         fi
      else
         continue
      fi

      #Check Deodex
      if ! check_content classes.dex "$jar_path"; then
         ui_print " "
         abort " You need a deodexed $jar_name.jar"
      fi

      #Making magisk space
      create_dir "$(dirname "$mod_jar_path")"

      #Decompiling
      ui_print " >> Decompiling $jar_name.jar..."
      dynamic_apktool -decompile "$jar_path" -o "$TMP/services"
      ui_print " "

      #Smali patch with Smali Tool Kit
      PATCH=false
      ui_print " >> Disabling Flag Secure..."
      smali_kit -c -m "isSecureLocked" -re "$disable" -d "$TMP/services" -name "WindowManagerService*" -name "WindowState*" && PATCH=true
      smali_kit -c -m "notAllowCaptureDisplay" -re "$disable" -d "$TMP/services" -name "WindowManagerService*" -name "WindowState*" && PATCH=true
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
      ui_print " >> Recompiling $jar_name.jar..."
      dynamic_apktool -preserve-signature -recompile "$TMP/services" -o "$mod_jar_path"

      #Check build
      if is_valid "$mod_jar_path"; then
         #Removing native odex (Stock firmwares)
         if exist folder "$jar_dir/oat"; then
            for arm in "$jar_dir/oat"/*; do
               if $system_prefix; then
                  mod_oat_path="$MODPATH$arm"
               else
                  mod_oat_path="$MODPATH/system$arm"
               fi
               for oat in $jar_name.art $jar_name.odex $jar_name.vdex; do
                  if exist file "$arm/$oat"; then
                     create_dir "$mod_oat_path"
                     # KSU Support
                     mknod "$mod_oat_path/$oat" c 0 0
                  fi
               done
            done
         fi
      else
         abort "   Some ERROR occurred during the recompilation of $jar_name.jar ! "
      fi

      #Permissions / Contexts
      set_perm 0 0 0644 "$mod_jar_path"
      set_context "$jar_path" "$mod_jar_path"

      #Clean up for the next JAR
      delete_recursive "$TMP/services"
      ui_print " "
   done
done

ui_print " "
ui_print " >> Done "
ui_print " "
ui_print " "
ui_print " "
