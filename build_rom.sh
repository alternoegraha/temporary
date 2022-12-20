# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/LineageOS/android.git -b lineage-20.0 -g default,-mips,-darwin,-notdefault
git clone https://github.com/alternoegraha/local_manifest.git --depth 1 -b lineage-20.0-fog .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build roms
. build/envsetup.sh
lunch lineage_fog-userdebug
export KBUILD_BUILD_USER=alternoegraha
export KBUILD_BUILD_HOST=cirrus
export BUILD_USERNAME=alternoegraha
export BUILD_HOSTNAME=cirrus
export TZ=Asia/Jakarta #put before last build command
m bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
