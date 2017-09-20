;; ===Package===
;; Loaded here because of overrides.
(setq package-archive-priorities '((marmalade    . 0)
				   (gnu          . 1)
				   (melpa        . 2)
				   (org          . 3)
				   (melpa-stable . 4)))
(setq package-archives
      (quote
       (("gnu"          . "http://elpa.gnu.org/packages/")
	("org"          . "http://orgmode.org/elpa/")
	("melpa-stable" . "http://stable.melpa.org/packages/")
	("melpa"        . "http://melpa.org/packages/")
	("marmalade"    . "http://marmalade-repo.org/packages/"))))
(require 'package)
(package-initialize)
(zerodark-setup-modeline-format)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (zerodark)))
 '(custom-safe-themes
   (quote
    ("6570843991e40121f854432826e9fd175aec6bd382ef217b2c0c46da37f3af18" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
