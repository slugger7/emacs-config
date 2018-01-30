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
(scroll-bar-mode -1)
(show-paren-mode 1)
(menu-bar-mode 0)
(subword-mode 1)
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

;;rest client
(load-file "~/.emacs.d/restclient.el")

;;org mode
(setq inhibit-splash-screen t)
;; Enable transient mark mode
(transient-mark-mode 1)
;; Enable Org mode
(require 'org)
;; Add more states
(setq org-todo-keyword-faces
      '(
        ("IN-POGRESS" . (:background "orange" :foreground "orange" :weight bold))
        ))
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "DONE")))
;;org theme
;;(org-beautify)

;; editorconfig(
(editorconfig-mode 1)
(eval-when-compile
 (require 'cl))

(defun quiescent-nuke-fringe (&optional window)
 "Remove the fringes in WINDOW."
 (set-window-fringes window 0 0))

(defun quiescent-setup-shell-like ()
 "Setup shell mode to my liking."
 (progn
   (quiescent-nuke-fringe)
   (setq mode-line-format nil)))

(add-hook 'shell-mode-hook       #'quiescent-setup-shell-like)
(add-hook 'eshell-mode-hook      #'quiescent-setup-shell-like)
(add-hook 'compilation-mode-hook #'quiescent-setup-shell-like)

(defun quiescent-in-a-mode (window modes)
 "Produce t if buffer in WINDOW is in mode contained in MODES."
 (cl-some (apply-partially #'quiescent-window-contains-buffer-in-mode window)
          modes))

(defvar quiescent-kill-fringes-modes '(shell-mode compilation-mode eshell-mode)
 "The modes in which fringes should be killed.")

(defun quiescent-setup-fringe-widths ()
 "Make the fringe width 0 in windows with certain modes active."
 (walk-windows (lambda (window)
                 (when (quiescent-in-a-mode window quiescent-kill-fringes-modes)
                   (quiescent-nuke-fringe window)))
               nil
               'visible))

(defun quiescent-window-contains-buffer-in-mode (window mode)
 "Produce t if WINDOW displays a buffer in mode MODE."
 (eq (buffer-local-value 'major-mode
                         (window-buffer window))
     mode))

(add-hook 'buffer-list-update-hook #'quiescent-setup-fringe-widths)
