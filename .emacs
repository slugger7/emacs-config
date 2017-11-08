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
(show-paren-mode 1)
(menu-bar-mode 0)
(setq-default indent-tabs-mode nil)
(add-hook 'prog-mode-hook #'electric-pair-mode)
;; javascript
(add-hook 'js2-mode-hook #'tern-mode)
(defun slugger7-turn-on-eslint ()
  "Turn on eslint."
  (flycheck-select-checker 'javascript-eslint))
(add-hook 'js2-mode-hook #'slugger7-turn-on-eslint)
(add-hook 'js2-mode-hook #'flycheck-mode)
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
;; Project
(global-set-key (kbd "s-f") #'project-find-file)
;; Custom
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
(load-file "~/.emacs.d/fix-prettier.el")
(load-file "~/.emacs.d/recent-f.el")

;;js2
(add-hook #'js2-mode-hook #'js2-highlight-vars-mode)
(defun js2-highlight-vars-post-command-hook ()
  (ignore-errors
    (let* ((overlays (overlays-at (point)))
           (ovl (and overlays
                     (catch 'found
                       (dolist (ovl overlays)
                         (when (overlay-get ovl 'js2-highlight-vars)
                           (throw 'found ovl)))
                       nil))))
      (if (and ovl
               (string= js2--highlight-vars-current-token-name
                        (buffer-substring (overlay-start ovl)
                                          (overlay-end ovl))))
          (setq js2--highlight-vars-current-token (overlay-start ovl))
        (js2--unhighlight-vars)
        (when js2--highlight-vars-post-command-timer
          (cancel-timer js2--highlight-vars-post-command-timer))
        (setq js2--highlight-vars-post-command-timer
              (run-with-timer 0 nil 'js2--do-highlight-vars))))))

;;ts hook
(defun quiescent-setup-tide-mode ()
    "Setup TIDE mode."
    (tide-setup)
    (define-key tide-mode-map (kbd "M-?") 'tide-references)
    (tide-hl-identifier-mode +1)
    (setq company-backends '(company-tide)))
(add-hook 'typescript-mode-hook #'quiescent-setup-tide-mode)


;; fix regex compile
(add-to-list 'compilation-error-regexp-alist-alist
             '(node "^[  ]+at \\(?:[^\(\n]+ \(\\)?\\([a-zA-Z\.0-9_/-]+\\):\\([0-9]+\\):\\([0-9]+\\)\)?$"
                    1 ;; file
                    2 ;; line
                    3 ;; column
                    ))
(add-to-list 'compilation-error-regexp-alist
             'node)

(add-to-list 'compilation-error-regexp-alist-alist
             '(npm "(\\(.*\..*?\\):\\([0-9]*\\):\\([0-9]*\\)"
                   1 ;; file
                   2 ;; line
                   3 ;; column
                   ))
(add-to-list 'compilation-error-regexp-alist
             'npm)

(add-to-list 'compilation-error-regexp-alist-alist
             '(jest "(\\(.*\..*?\\):\\([0-9]*\\):\\([0-9]*\\)"
                   1 ;; file
                   2 ;; line
                   3 ;; column
                   ))
(add-to-list 'compilation-error-regexp-alist
             'jest)

(add-to-list 'compilation-error-regexp-alist-alist
             '(mocha "(\\(.*\..*?\\):\\([0-9]*\\):\\([0-9]*\\)"
                     1 ;; file
                     2 ;; line
                     3 ;; column
                     ))
(add-to-list 'compilation-error-regexp-alist
             'mocha)

(add-to-list 'compilation-error-regexp-alist-alist
             '(webpack "\\(\\./[/_-a-zA-Z0-9]+\\.[a-z]+\\) ?\\([0-9]+:[0-9]+\\|$\\)"
                       1 ;; file
                       2 ;; line
                       3 ;; column
                       ))

(add-to-list 'compilation-error-regexp-alist
             'webpack)

(add-to-list 'compilation-error-regexp-alist-alist
             '(eslint "\\(^/.*\\.jsx?$\\)\n +\\([0-9]+\\):\\([0-9]+\\)"
                      1 ;; file
                      2 ;; line
                      3 ;; column
                      ))

(add-to-list 'compilation-error-regexp-alist
             'eslint)
