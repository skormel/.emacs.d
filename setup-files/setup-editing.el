;; Time-stamp: <2016-10-08 08:06:38 csraghunandan>
;; all the editing configuration for emacs

;; configuration for all the editing stuff in emacs
;; Kill ring
(setq kill-ring-max 200
      kill-do-not-save-duplicates t
      save-interprogram-paste-before-kill t)
(setq select-enable-primary t)
(setq select-enable-clipboard t)

(setq-default indent-tabs-mode nil)
(setq-default fill-column 80) ;; default is 70

;; By default, Emacs thinks a sentence is a full-stop followed by 2 spaces.
(setq sentence-end-double-space nil)

;;;; Pull Up Line
;; http://emacs.stackexchange.com/q/7519/115
(defun rag/pull-up-line ()
  "Join the following line onto the current one (analogous to `C-e', `C-d') or
`C-u M-^' or `C-u M-x join-line'.
If the current line is a comment and the pulled-up line is also a comment,
remove the comment characters from that line."
  (interactive)
  (join-line -1)
  ;; If the current line is a comment
  (when (nth 4 (syntax-ppss))
    ;; Remove the comment prefix chars from the pulled-up line if present
    (save-excursion
      ;; Delete all comment-start and space characters
      (while (looking-at (concat "\\s<" ; comment-start char as per syntax table
                                 "\\|" (substring comment-start 0 1) ; first char of `comment-start'
                                 "\\|" "\\s-")) ; extra spaces
        (delete-forward-char 1))
      (insert-char ? )))) ; insert space

(defun rag/smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun rag/smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun xah-copy-line-or-region ()
  "Copy current line, or text selection.
When called repeatedly, append copy subsequent lines.
When `universal-argument' is called first, copy whole buffer (respects `narrow-to-region')."
  (interactive)
  (let (-p1 -p2)
    (if current-prefix-arg
        (setq -p1 (point-min) -p2 (point-max))
      (if (use-region-p)
          (setq -p1 (region-beginning) -p2 (region-end))
        (setq -p1 (line-beginning-position) -p2 (line-end-position))))
    (if (eq last-command this-command)
        (progn
          (progn ; hack. exit if there's no more next line
            (end-of-line)
            (forward-char)
            (backward-char))
          ;; (push-mark (point) "NOMSG" "ACTIVATE")
          (kill-append "\n" nil)
          (kill-append (buffer-substring-no-properties (line-beginning-position) (line-end-position)) nil)
          (message "Line copy appended"))
      (progn
        (kill-ring-save -p1 -p2)
        (if current-prefix-arg
            (message "Buffer text copied")
          (message "Text copied"))))
    (end-of-line)
    (forward-char)))

(defun xah-cut-line-or-region ()
  "Cut current line, or text selection.
When `universal-argument' is called first, cut whole buffer (respects `narrow-to-region')."
  (interactive)
  (if current-prefix-arg
      (progn ; not using kill-region because we don't want to include previous kill
        (kill-new (buffer-string))
        (delete-region (point-min) (point-max)))
    (if (use-region-p)
        (kill-region (region-beginning) (region-end) t)
      (progn
        (kill-region (line-beginning-position) (line-beginning-position 2))
        (back-to-indentation)))))

(defun rag/select-inside-line ()
  "Select the current line."
  (interactive)
  (smarter-move-beginning-of-line 1)
  (set-mark (line-end-position))
  (exchange-point-and-mark))

(defun rag/select-around-line ()
  "Select line including the newline character"
  (interactive)
  (rag/select-inside-line)
  (next-line 1)
  (rag/smarter-move-beginning-of-line 1))

;; align commands
(defun rag/align-whitespace (start end)
  "Align columns by whitespace"
  (interactive "r")
  (align-regexp start end
                "\\(\\s-*\\)\\s-" 1 1 t))
(defun rag/align-equals (start end)
  "Align columns by equals sign"
  (interactive "r")
  (align-regexp start end
                "\\(\\s-*\\)=" 1 1 t))
(defun rag/align-columns (begin end)
  "Align text columns"
  (interactive "r")
  ;; align-regexp syntax:  align-regexp (beg end regexp &optional group spacing repeat)
  (align-regexp begin end "\\(\\s-+\\)[a-zA-Z0-9=(),?':`\.{}]" 1 1 t)
  (indent-region begin end)) ; indent the region correctly after alignment

(defun rag/kill-rectangle-replace-with-space (start end)
  "Kill the rectangle and replace it with spaces."
  (interactive "r")
  (setq killed-rectangle (extract-rectangle start end))
  (clear-rectangle start end)
  (setq deactivate-mark t)
  (if (called-interactively-p 'interactive)
      (indicate-copied-region (length (car killed-rectangle)))))

;; go to the last changed cursor position
;; https://www.emacswiki.org/emacs/GotoChg
(use-package goto-chg
  :bind* (("C-c g l" . goto-last-change)
          ("C-c g r" . goto-last-change-reverse)))

;; expand region semantically
;; https://www.emacswiki.org/emacs/GotoChg
(use-package expand-region
  :bind* ("C-c e" . er/expand-region)
  :config
  (progn
    (setq expand-region-contract-fast-key "|")
    (setq expand-region-reset-fast-key "<ESC><ESC>")))

;; allow forward and backword movements to move between camelCase words
(use-package subword
  :diminish subword-mode
  :config (subword-mode +1))

;; save and restore the previous cursor position when the buffer was killed
(use-package saveplace
  :defer t
  :init (save-place-mode 1))

;; wait for electric operator author to push haskell fix onto master branch <2016-10-07 23:16:59>
;; (use-package electric-operator
;; :config (electric-operator-add-rules-for-mode 'haskell-mode (cons "|" "| ")))

(defun xah-clean-whitespace (*begin *end)
  "Delete trailing whitespace, and replace repeated blank lines into just 1.
Only space and tab is considered whitespace here.
Works on whole buffer or text selection, respects `narrow-to-region'.

URL `http://ergoemacs.org/emacs/elisp_compact_empty_lines.html'
Version 2016-10-04"
  (interactive
   (if (region-active-p)
       (list (region-beginning) (region-end))
     (list (point-min) (point-max))))
  (save-excursion
    (save-restriction
      (narrow-to-region *begin *end)
      (progn
        (goto-char (point-min))
        (while (search-forward-regexp "[ \t]+\n" nil "noerror")
          (replace-match "\n")))
      (progn
        (goto-char (point-min))
        (while (search-forward-regexp "\n\n\n+" nil "noerror")
          (replace-match "\n\n")))
      (progn
        (goto-char (point-max))
        (while (equal (char-before) 32) ; ascii 32 is space
          (delete-char -1))))))

;; remove the buffer of trailing whitespaces and multiple blank lines are collapsed to 1
(add-hook 'before-save-hook '(lambda() (xah-clean-whitespace (point-min) (point-max))))

;; Update the timestamp before saving a file
(add-hook 'before-save-hook #'time-stamp)

(bind-keys*
 ("C-o" . rag/smart-open-line)
 ("C-S-o" . rag/smart-open-line-above)
 ("M-j" . rag/pull-up-line)
 ("s-j" . delete-indentation)
 ("C-M-SPC" . cycle-spacing)
 ("M-?" . mark-paragraph)
 ("C-h" . delete-backward-char)
 ("C-M-h" . backward-kill-word)
 ("C-w" . xah-cut-line-or-region)
 ("M-w" . xah-copy-line-or-region)
 ("M-;" . comment-line)
 ("C-c s l" . rag/select-inside-line)
 ("C-c s n" . rag/select-around-line)
 ("C-x C-S-o" . xah-clean-whitespace))

(provide 'setup-editing)
