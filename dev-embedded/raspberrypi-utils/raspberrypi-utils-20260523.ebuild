# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 cmake

COMMIT="a9af6dba7094359aea3803aff3e88c8040d5f8c3"

DESCRIPTION="Raspberry Pi userspace utilities"
HOMEPAGE="https://github.com/raspberrypi/utils"
SRC_URI="https://github.com/raspberrypi/utils/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/utils-${COMMIT}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~arm64"

DEPEND="
	sys-apps/dtc
"

RDEPEND="
	${DEPEND}
	dev-lang/perl
	!media-libs/raspberrypi-userland
	!media-libs/raspberrypi-userland-bin
"

PATCHES=(
	"${FILESDIR}"/${PF}-werror.patch
)

src_configure() {
	local mycmakeargs=( -DBUILD_SHARED_LIBS=OFF )
	cmake_src_configure
}

src_install() {
	cmake_src_install

	local SRC
	rm -r "${ED}"/usr/share/bash-completion/ || die
	for SRC in */*-completion.bash; do
		local DEST=${SRC%-completion.bash}
		newbashcomp "${SRC}" "${DEST##*/}"
	done
}
