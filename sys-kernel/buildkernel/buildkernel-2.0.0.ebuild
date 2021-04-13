# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Build secure boot EFI kernel with LUKS and LVM"
HOMEPAGE="https://github.com/azahi/buildkernel"
SRC_URI="https://github.com/azahi/buildkernel/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=sys-apps/gptfdisk-0.8.8
	>=sys-fs/cryptsetup-1.6.2
	>=app-shells/bash-4.2:*
"
RDEPEND="${DEPEND}
	>=sys-libs/ncurses-5.9-r2
	>=app-crypt/sbsigntools-0.6-r1
	>=sys-kernel/genkernel-next-58[cryptsetup]
	>=sys-boot/efibootmgr-0.5.4-r1
	>=sys-apps/debianutils-4.9.1[installkernel(+)]
"
BDEPEND="
	>=virtual/linux-sources-3
"

src_install() {
	dosbin "${PN}"
	insinto "/etc"
	doins "${PN}.conf"
}

pkg_preinst() {
	if [ -e "${ROOT}/etc/${PN}.conf" ]; then
		elog "/etc/${PN}.conf already exists, not overwriting."
		cp "${ROOT}/etc/${PN}.conf" "${D}/etc/${PN}.conf"
	fi
}
