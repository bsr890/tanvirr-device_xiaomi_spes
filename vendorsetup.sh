# ROM source patches

color="\033[0;32m"
end="\033[0m"

echo -e "${color}Applying patches${end}"
sleep 1

# Remove pixel headers to avoid conflicts
rm -rf hardware/google/pixel/kernel_headers/Android.bp

# Remove hardware/lineage/compat to avoid conflicts
rm -rf hardware/lineage/compat/Android.bp

# Sepolicy fix for imsrcsd
echo -e "${color}Switch back to legacy imsrcsd sepolicy${end}"
rm -rf device/qcom/sepolicy_vndr/legacy-um/qva/vendor/bengal/ims/imsservice.te
cp device/qcom/sepolicy_vndr/legacy-um/qva/vendor/bengal/legacy-ims/hal_rcsservice.te device/qcom/sepolicy_vndr/legacy-um/qva/vendor/bengal/ims/hal_rcsservice.te

# Vendor & Kernel Sources
git clone https://github.com/tanvirr007/vendor_xiaomi_spes -b 14.0 vendor/xiaomi/spes
git clone https://github.com/muralivijay/kernel_xiaomi_sm6225 kernel/xiaomi/sm6225

# Lineage-21 Hardware Source
git clone https://github.com/LineageOS/android_hardware_xiaomi.git -b lineage-21 hardware/xiaomi

# Fix Miuicamera
CAMERA_DIR="vendor/xiaomi/camera"
PROPRIETARY_DIR="proprietary/system/priv-app/MiuiCamera"
URL="https://sourceforge.net/projects/muralivijay/files/fixes/spes/camera/MiuiCamera.apk"

# Remove vendorsetup script of MiuiCamera
if [ -d "$CAMERA_DIR" ]; then
rm -rf ${CAMERA_DIR}/vendorsetup.sh

# Calculate the checksum of MiuiCamera.apk
current_checksum=$(md5sum "${CAMERA_DIR}/${PROPRIETARY_DIR}/MiuiCamera.apk" | awk '{ print $1 }')

# Expected MiuiCamera checksum
expected_checksum="8f1d2365de634363c74a1c9434e633e2"

# Compare the current checksum with the expected checksum
 if [ "$current_checksum" != "$expected_checksum" ]; then
   echo -e "${color}Fixing MiuiCamera Please Wait ${end}"
   rm -rf ${CAMERA_DIR}/${PROPRIETARY_DIR}/MiuiCamera.apk
   wget ${URL} -O ${CAMERA_DIR}/${PROPRIETARY_DIR}/MiuiCamera.apk
 fi
fi
