#! /bin/sh

source_dir=`dirname $0`

${source_dir}/build.d/01.make.base.filesystem.sh || exit 1

${source_dir}/build.d/02.install.nxos.sh || exit 1

${source_dir}/build.d/03.clean.filesystem.sh || exit 1

${source_dir}/build.d/04.compress.filesystem.sh || exit 1

${source_dir}/build.d/05.configure.iso.sh || exit 1

${source_dir}/build.d/06.create.iso.sh || exit 1
