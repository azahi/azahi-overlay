# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 git-r3 elisp-common

DESCRIPTION="Stores, retrieves, generates, and synchronizes passwords securely"
HOMEPAGE="https://www.passwordstore.org/"
EGIT_REPO_URI="https://git.zx2c4.com/password-store"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="+git X bash-completion zsh-completion fish-completion emacs dmenu"

RDEPEND="
	>=app-text/tree-1.7.0
	X? ( x11-misc/xclip )
	app-crypt/gnupg
	emacs? ( >=app-editors/emacs-23.1:* )
	fish-completion? ( app-shells/fish )
	git? ( dev-vcs/git )
	media-gfx/qrencode
	zsh-completion? ( app-shells/gentoo-zsh-completions )
"

src_compile() {
	:;
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		WITH_BASHCOMP=$(usex bash-completion) \
		WITH_ZSHCOMP=$(usex zsh-completion) \
		WITH_FISHCOMP=$(usex fish-completion)

	if use dmenu; then
		dobin contrib/dmenu/passmenu
	fi

	if use emacs; then
		elisp-install ${PN} contrib/emacs/password-store.el
		elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
