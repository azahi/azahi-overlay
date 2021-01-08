# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eth-p/bat-extras.git"
fi

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/eth-p/bat-extras/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Scripts that integrate bat with various command line tools"
HOMEPAGE="https://github.com/eth-p/bat-extras"

LICENSE="MIT"
SLOT="0"
IUSE="+ripgrep"

RDEPEND="
	sys-apps/bat
	ripgrep? ( sys-apps/ripgrep )
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_compile() {
	./build.sh
}

src_install() {
	dobin bin/batdiff
	dobin bin/batman
	dobin bin/batwatch
	dobin bin/prettybat
	use ripgrep && dobin bin/batgrep

	dodoc README.md
	dodoc doc/batdiff.md
	dodoc doc/batman.md
	dodoc doc/batwatch.md
	dodoc doc/prettybat.md
	use ripgrep && dodoc doc/batgrep.md
}
