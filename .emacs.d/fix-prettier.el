;; TODO account for multiple checkers reporting on the current line
(defun quiescent-correct-linting-errors-at-point (point)
  "Correct linting errors reported by Eslint via Flycheck at POINT."
  (interactive "d")
  (let* ((error-overlay (car (flycheck-overlays-at (point))))
         (lint-suggestion (flycheck-error-message
                           (overlay-get error-overlay
                                        'flycheck-error))))
    (pcase (split-string lint-suggestion)
      (`("Delete" ,to-delete) (quiescent-correct-linting-delete to-delete
                                                                error-overlay))
      (`("Replace" ,string "with" ,replacement)
       (quiescent-correct-linting-replace string replacement error-overlay))
      (`("Insert" ,string)
       (quiescent-correct-linting-insert string error-overlay)))))

(defun quiescent-correct-linting-insert (string error-overlay)
  "Insert STRING at the start of ERROR-OVERLAY."
  (save-excursion
    (goto-char (overlay-start error-overlay))
    (insert (quiescent-eslint-string-to-regexp
             (quiescent-get-string-out-of-eslint-quotes string)))))

(defun quiescent-correct-linting-compute-search-string (raw-search-string)
  "Escape RAW-SEARCH-STRING from Eslint so that it can be searched for."
  (regexp-quote
   (quiescent-get-string-out-of-eslint-quotes
    (quiescent-eslint-string-to-regexp raw-search-string))))

(defun quiescent-correct-linting-replace (string replacement error-overlay)
  "Replace STRING with REPLACEMENT at the start of ERROR-OVERLAY."
  (let ((regexp-to-delete (quiescent-correct-linting-compute-search-string string)))
    (save-excursion
      (goto-char (overlay-start error-overlay))
      (when (re-search-forward regexp-to-delete
                               nil
                               t)
        (replace-match (quiescent-get-string-out-of-eslint-quotes
                        (quiescent-eslint-string-to-regexp replacement)))))))

(defun quiescent-get-string-out-of-eslint-quotes (eslint-string-in-quotes)
  "Get the ESLINT-STRING-IN-QUOTES from out of it's `` quotes."
  (substring eslint-string-in-quotes 1 (1- (length eslint-string-in-quotes))))

(defun quiescent-eslint-string-to-regexp (eslint-string)
  "Transform ESLINT-STRING to a regexp."
  (replace-regexp-in-string "⏎" "\n"
                            (replace-regexp-in-string "·" " "
                                                      eslint-string)))

(defun quiescent-correct-linting-delete (to-delete error-overlay)
  "Find and delete the string TO-DELETE in the bounds of ERROR-OVERLAY."
  (let ((regexp-to-delete (quiescent-correct-linting-compute-search-string to-delete)))
    (save-excursion
      (goto-char (overlay-start error-overlay))
      (when (re-search-forward regexp-to-delete
                               nil
                               t)
        (replace-match "")))))
(require 'js2-mode)

(define-key js2-mode-map (kbd "M-q") #'quiescent-correct-linting-errors-at-point)
