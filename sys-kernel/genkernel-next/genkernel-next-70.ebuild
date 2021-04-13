# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="An improved and modern remake of Gentoo genkernel"
HOMEPAGE="https://github.com/Sabayon/genkernel-next"
SRC_URI="
	https://github.com/Sabayon/genkernel-next/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://www.busybox.net/downloads/busybox-1.32.0.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cryptsetup dmraid gpg iscsi mdadm plymouth selinux"

DEPEND="
	!sys-fs/eudev[-kmod,modutils]
	app-text/asciidoc
	selinux? ( sys-libs/libselinux )
	sys-fs/e2fsprogs
"
RDEPEND="${DEPEND}
	!<sys-apps/openrc-0.9.9
	!sys-kernel/genkernel
	>=app-misc/pax-utils-0.6
	app-arch/cpio
	app-portage/portage-utils
	cryptsetup? ( sys-fs/cryptsetup )
	dmraid? ( >=sys-fs/dmraid-1.0.0_rc16 )
	gpg? ( app-crypt/gnupg )
	iscsi? ( sys-block/open-iscsi )
	mdadm? ( sys-fs/mdadm )
	plymouth? ( sys-boot/plymouth )
	sys-apps/util-linux
	sys-block/thin-provisioning-tools
	sys-fs/lvm2
"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/genkernel-next-70_old_busybox.patch"
)

src_prepare() {
	default
	sed -i "/^GK_V=/ s:GK_V=.*:GK_V=${PV}:g" "${S}/genkernel" || die

	portage_distdir=$(dirname $(readlink "${DISTDIR}"/${P}.tar.gz))
	sed -i 's:'"/usr/portage/distfiles"':'"${portage_distdir}"':g' "${S}/genkernel.conf" || die
}

src_install() {
	default

	doman "${S}"/genkernel.8

	newbashcomp "${S}"/genkernel.bash genkernel
}
