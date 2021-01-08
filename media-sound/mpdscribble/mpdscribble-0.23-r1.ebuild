# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/MusicPlayerDaemon/mpdscribble.git"
fi

inherit meson ${SCM}

DESCRIPTION="An MPD client that submits information to Audioscrobbler"
HOMEPAGE="https://www.musicpd.org/clients/mpdscribble"

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/MusicPlayerDaemon/mpdscribble/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="syslog systemd test"

RDEPEND="
	syslog? ( virtual/logger )
	systemd? ( sys-apps/systemd )
	>=dev-libs/boost-1.62
	>=media-libs/libmpdclient-2.5
	>=net-misc/curl-7.18
	dev-libs/libgcrypt
"
DEPEND="${RDEPEND}"
BDEPEND=""

DOCS=( "README.rst" "doc/mpdscribble.conf" )

src_prepare() {
	default
	sed -e '/^install_data/{N;N;N;d;}' \
		-i meson.build || die
}

src_configure() {
	default
	local emesonargs=(
		$(meson_feature syslog)
		$(meson_feature systemd)
		$(meson_use test)
	)
	meson_src_configure
}

src_install() {
	default
	meson_src_install
	doman doc/mpdscribble.1
	newinitd "${FILESDIR}/mpdscribble" mpdscribble
}
