# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="https://megous.com/git/megatools"
fi

if [[ ${PV} != *9999 ]]; then
	BUILDSYS="autotools"
else
	BUILDSYS="meson"
fi

inherit ${BUILDSYS} ${SCM}

DESCRIPTION="Open-source command line tools for accessing Mega.co.nz cloud storage"
HOMEPAGE="https://megatools.megous.com"

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://megatools.megous.com/builds/megatools-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="libressl symlinks"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/glib:2
	net-misc/curl
"
RDEPEND="${DEPEND}
	net-libs/glib-networking[ssl]
"
BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig
"

src_prepare() {
	default
	if [[ ${PV} != *9999 ]]; then
		sed -e "/^AC_PROG_CC/ a AM_PROG_AR" -i configure.ac || die
		eautoreconf
	else
		sed -e '/^install_data/{N;N;d;}' -i meson.build || die
	fi
}

src_configure() {
	default
	if [[ ${PV} != *9999 ]]; then
		econf \
			--disable-maintainer-mode \
			--disable-warnings
	else
		local emesonargs=$(meson_use symlinks)
		meson_src_configure
	fi
}
