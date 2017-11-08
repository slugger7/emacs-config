(require 'recentf)
(recentf-mode t)
(defun quiescent-open-recent-file ()
  "Open a recent file use recentf for completion."
  (interactive)
  (find-file (completing-read "Recent file: " recentf-list)))

(setq recentf-max-saved-items 50)
(run-at-time nil (* 5 60) 'recentf-save-list)
(add-hook 'emacs-startup-hook #'recentf-open-files)
(global-set-key (kbd "C-h C-f") #'quiescent-open-recent-file)

