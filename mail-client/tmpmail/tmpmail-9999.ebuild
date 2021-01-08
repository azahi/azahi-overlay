# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sdushantha/tmpmail.git"
fi

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/sdushantha/tmpmail/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A temporary email right from your terminal written in POSIX sh"
HOMEPAGE="https://github.com/sdushantha/tmpmail"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	app-misc/jq
	net-misc/curl[ssl]
	www-client/w3m
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README.md
}
