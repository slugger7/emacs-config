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
(tool-bar-mode -1)
(add-hook 'prog-mode-hook #'electric-pair-mode)
;; javascript
(add-hook 'js-mode-hook #'tern-mode)
(defun kevin-turn-on-eslint ()
  "Turn on eslint."
  (flycheck-select-checker 'javascript-eslint))
(add-hook 'js-mode-hook #'kevin-turn-on-eslint)
(add-hook 'js-mode-hook #'flycheck-mode)
;; Mini buffer completion (helm) (ivy) (ido)
(icomplete-mode)
(define-key icomplete-minibuffer-map (kbd "C-'")
  'icomplete-force-complete-and-exit)
(define-key icomplete-minibuffer-map (kbd "M-'")
  'icomplete-force-complete-and-exit)
(define-key icomplete-minibuffer-map [?\M-.] 'icomplete-forward-completions)
(define-key icomplete-minibuffer-map [?\M-,] 'icomplete-backward-completions)
(setq icomplete-delay-completions-threshold 400)
(setq icomplete-compute-delay 0)
(setq icomplete-show-matches-on-no-input t)
;; Custom
(setq custom-file "~/.emacs.d/custom.el")
