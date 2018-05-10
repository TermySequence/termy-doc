#!/bin/bash

commit=${1:-HEAD}
package=$(awk '/^PackageName:/ {print $2}' LICENSE.spdx)
version=$(awk '/^PackageVersion:/ {print $2}' LICENSE.spdx)
name="${package}-${version}"
tarfile=/tmp/${name}.tar

git archive --prefix=${name}/ -o ${tarfile} ${commit} || exit 3
xz <${tarfile} >${name}.tar.xz || exit 6

rm ${tarfile}

echo Success
