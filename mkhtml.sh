#!/bin/bash

package=$(awk '/^PackageName:/ {print $2}' LICENSE.spdx)
version=$(awk '/^PackageVersion:/ {print $2}' LICENSE.spdx)
name="${package}-html-${version}"

make clean html
cd _build
tar Jcf ../${name}.tar.xz --exclude */.buildinfo html

echo Success
