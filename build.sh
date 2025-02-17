#!/bin/bash

function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G
export ARCH=arm64
export KBUILD_BUILD_HOST=ok
export KBUILD_BUILD_USER="kardebayan"
git clone --depth=1 https://github.com/techyminati/android_prebuilts_clang_host_linux-x86_clang-6443078.git clang
git clone --depth=1 https://github.com/DrtSinX98/prebuilts_gcc_linux-x86_aarch64_aarch64-linaro-7 los-4.9-64
git clone --depth=1 https://github.com/DrtSinX98/linaro_arm-linux-gnueabihf-7.5 los-4.9-32

make O=out ARCH=arm64 oppo6833_defconfig

PATH="${PWD}/clang/bin:${PATH}:${PWD}/los-4.9-32/bin:${PATH}:${PWD}/los-4.9-64/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE="${PWD}/los-4.9-64/bin/aarch64-linux-gnu-" \
                      CROSS_COMPILE_ARM32="${PWD}/los-4.9-32/bin/arm-linux-gnueabihf-" \
                      CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zupload()
{
git clone --depth=1 https://github.com/DrtSinX98/AnyKernel3.git -b apollow AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 Cyanide-kernel-1.0-apollow.zip *
curl -sL https://git.io/file-transfer | sh
./transfer wet Stormbreaker-kernel-1.0-apollow.zip
}

compile
zupload
