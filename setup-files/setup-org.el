;; Time-stamp: <2017-07-08 13:25:09 csraghunandan>

;; Org-mode configuration - Make sure you install the latest org-mode with `M-x' RET `org-plus-contrib'
;; http://orgmode.org/
(use-package org
  :preface
  ;; If `org-load-version-dev' is non-nil, remove the older versions of org
  ;; from the `load-path'.
  (when (bound-and-true-p org-load-version-dev)
    (>= "25.0" ; `directory-files-recursively' is not available in older emacsen
        (let ((org-stable-install-path (car (directory-files-recursively
                                             package-user-dir
                                             "org-plus-contrib-[0-9]+"
                                             :include-directories))))
          (setq load-path (delete org-stable-install-path load-path))
          ;; Also ensure that the associated path is removed from Info search list
          (setq Info-directory-list (delete org-stable-install-path
                                            Info-directory-list))

          ;; Also delete the path to the org directory that ships with emacs
          (dolist (path load-path)
            (when (string-match-p (concat "emacs/"
                                          (replace-regexp-in-string
                                           "\\.[0-9]+\\'" "" emacs-version)
                                          "/lisp/org\\'")
                                  path)
              (setq load-path (delete path load-path)))))))

  ;; Modules that should always be loaded together with org.el.
  ;; `org-modules' default: '(org-w3m org-bbdb org-bibtex org-docview org-gnus
  ;;                          org-info org-irc org-mhe org-rmail)
  (setq org-modules '(org-info org-irc org-drill org-habit))

  ;; Set my default org-export backends. This variable needs to be set before
  ;; org.el is loaded.
  (setq org-export-backends '(ascii html latex md gfm odt))



  :mode ("\\.org\\'" . org-mode)

  :config

  ;; settings for org-refile
  (setq org-refile-use-outline-path nil
        org-refile-targets '((org-agenda-files :level . 1)
                             (org-agenda-files :level . 2)))
  (add-to-list
   'ivy-completing-read-handlers-alist
   '(org-capture-refile . completing-read-default))

  ;; override `avy-goto-char-timer' to C-' in org-mode-map
  (bind-key "C-'" 'avy-goto-char-timer org-mode-map)

  ;; add a tag to make ordered tasks more visible
  (setq org-track-ordered-property-with-tag t)

  ;; make sure all checkboxes under a todo is done before marking the parent
  ;; task as done.
  (setq org-enforce-todo-checkbox-dependencies t)

  ;; clock into a drawer called CLOCKING
  (setq org-clock-into-drawer "CLOCKING")

  ;; (setq org-babel-python-command "python3")
  ;; TODO: Add more languages here to the list: rust, typescript, C++
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (C . t)
     (haskell . t)
     (js . t)
     (python . t)))

;;; Org Variables
  ;; this looks better in my opinion
  (setq org-ellipsis " ")
  ;; no underlines for org-ellipse
  (set-face-attribute 'org-ellipsis nil :underline nil :foreground "#E0CF9F")
  ;; hide emphasis markup characters
  (setq org-hide-emphasis-markers t)
  ;; Non-nil means insert state change notes and time stamps into a drawer.
  (setq org-log-into-drawer t)
  ;; insert a note after changing deadline for a TODO
  (setq org-log-redeadline 'note)
  ;; insert a note after rescheduling a TODO
  (setq org-log-reschedule 'note)
  ;; Insert only timestamp when closing an org TODO item
  (setq org-log-done 'timestamp)

  (setq org-agenda-archives-mode nil) ; required in org 8.0+
  (setq org-agenda-skip-comment-trees nil)
  (setq org-agenda-skip-function nil)

  ;; Display entities like \tilde, \alpha, etc in UTF-8 characters
  (setq org-pretty-entities t)

  ;; Render subscripts and superscripts in org buffers
  (setq org-pretty-entities-include-sub-superscripts t)
  ;; Allow _ and ^ characters to sub/super-script strings but only when
  ;; string is wrapped in braces
  (setq org-use-sub-superscripts '{}) ; in-buffer rendering

  (setq org-use-speed-commands t) ; ? speed-key opens Speed Keys help
  (setq org-speed-commands-user '(("m" . org-mark-subtree)))
  ;; heading leading stars for headlines
  (setq org-hide-leading-stars t)

  ;; Prevent auto insertion of blank lines before headings and list items
  (setq org-blank-before-new-entry '((heading)
                                     (plain-list-item)))

  (bind-key "C-c C-j" 'counsel-org-agenda-headlines org-mode-map)

  ;; make tabs act like they would in the major mode for the source block
  (setq org-src-tab-acts-natively t)

  ;; enable org-indent mode on startup
  (setq org-startup-indented t)

  (use-package org-indent :ensure nil
    :diminish (org-indent-mode . "𝐈"))

  ;; strike through done headlines
  (setq org-fontify-done-headline t)

  ;; Block entries from changing state to DONE while they have children
  ;; that are not DONE - http://orgmode.org/manual/TODO-dependencies.html
  (setq org-enforce-todo-dependencies t)

  ;; http://emacs.stackexchange.com/a/17513/115
  (setq org-special-ctrl-a/e '(t ; For C-a. Possible values: nil, t, 'reverse
                               . t)) ; For C-e. Possible values: nil, t,
                                        ; 'reverse
  ;; special keys for killing headline
  (setq org-special-ctrl-k t)
  ;; don't split items when pressing `C-RET'. Always create new item
  (setq org-M-RET-may-split-line nil)
  ;; preserve indentation inside of source blocks
  (setq org-src-preserve-indentation t)

  (setq org-catch-invisible-edits 'smart) ; http://emacs.stackexchange.com/a/2091/115
  (setq org-indent-indentation-per-level 1) ; default = 2

  ;; Prevent renumbering/sorting footnotes when a footnote is added/removed.
  ;; Doing so would create a big diff in an org file containing lot of
  ;; footnotes even if only one footnote was added/removed.
  (setq org-footnote-auto-adjust nil)

  ;; Do NOT try to auto-evaluate entered text as formula when I begin a field's
  ;; content with "=" e.g. |=123=|. More often than not, I use the "=" to
  ;; simply format that field text as verbatim. As now the below variable is
  ;; set to nil, formula will not be automatically evaluated when hitting TAB.
  ;; But you can still using ‘C-c =’ to evaluate it manually when needed.
  (setq org-table-formula-evaluate-inline nil) ; default = t

  ;; imenu should use a depth of 3 instead of 2
  (setq org-imenu-depth 3)

  ;; blank lines are removed when exiting code edit buffer
  (setq org-src-strip-leading-and-trailing-blank-lines t)



  ;; http://sachachua.com/blog/2013/01/emacs-org-task-related-keyboard-shortcuts-agenda/
  (defun sacha/org-agenda-done (&optional arg)
    "Mark current TODO as done.
This changes the line at point, all other lines in the agenda referring to
the same tree node, and the headline of the tree node in the Org-mode file."
    (interactive "P")
    (org-agenda-todo "DONE"))

  (defun sacha/org-agenda-mark-done-and-add-followup ()
    "Mark the current TODO as done and add another task after it.
Creates it at the same level as the previous task, so it's better to use
this with to-do items than with projects or headings."
    (interactive)
    (org-agenda-todo "DONE")
    (org-agenda-switch-to)
    (org-capture 0 "t")
    (org-metadown 1)
    (org-metaright 1))

  (defun sacha/org-agenda-new ()
    "Create a new note or task at the current agenda item.
Creates it at the same level as the previous task, so it's better to use
this with to-do items than with projects or headings."
    (interactive)
    (org-agenda-switch-to)
    (org-capture 0))

  ;; add key bindings for agenda mode
  (add-hook 'org-agenda-mode-hook
            (lambda ()
              (bind-keys
               :map org-agenda-mode-map
               ("x" . sacha/org-agenda-done)
               ("X" . sacha/org-agenda-mark-done-and-add-followup)
               ("N" . sacha/org-agenda-new))))

  ;; Bind the "org-table-*" command ONLY when the point is in an org table.
  (bind-keys
   :map org-mode-map
   :filter (org-at-table-p)
   ("C-c ?" . org-table-field-info)
   ("C-c SPC" . org-table-blank-field)
   ("C-c +" . org-table-sum)
   ("C-c =" . org-table-eval-formula)
   ("C-c `" . org-table-edit-field)
   ("C-#" . org-table-rotate-recalc-marks)
   ("C-c }" . org-table-toggle-coordinate-overlays)
   ("C-c {" . org-table-toggle-formula-debugger))

  (bind-keys
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c i" . org-store-link))

  (setq org-todo-keywords '((sequence
                             "TODO(t@/!)"
                             "NEXT(n@/!)"
                             "SOMEDAY(s/!)"
                             "WAITING(w@/!)"
                             "|" "CANCELED(c)"
                             "DONE(d@)")))
  (setq org-todo-keyword-faces
        '(("TODO" . org-todo)
          ("NEXT" . (:foreground "CadetBlue3" :weight bold))
          ("WAITING" . (:foreground "pink" :weight bold))
          ("SOMEDAY"  . (:foreground "#FFEF9F" :weight bold))
          ("CANCELED" . (:foreground "red" :weight bold :strike-through t))
          ("DONE"     . (:foreground "SeaGreen4" :weight bold))))

  (use-package langtool :defer 1
    :config
    ;; place the language-tool directory in $HOME
    (setq langtool-language-tool-jar (concat user-home-directory "LanguageTool-3.7/languagetool-commandline.jar"))
    (setq langtool-default-language "en-GB")

    ;; hydra for langtool check
    (defhydra hydra-langtool (:color pink
                                     :hint nil)
      "
_c_: check    _n_: next error
_C_: correct  _p_: prev error _d_: done checking
"
      ("n"  langtool-goto-next-error)
      ("p"  langtool-goto-previous-error)
      ("c"  langtool-check)
      ("C"  langtool-correct-buffer)
      ("d"  langtool-check-done :color blue)
      ("q" nil "quit" :color blue))
    (bind-key "C-c h l" 'hydra-langtool/body org-mode-map))



  (define-key org-mode-map "\"" #'endless/round-quotes)

  (defun endless/round-quotes (italicize)
    "Insert “” and leave point in the middle.
With prefix argument ITALICIZE, insert /“”/ instead
\(meant for org-mode).
Inside a code-block, just call `self-insert-command'."
    (interactive "P")
    (if (and (derived-mode-p 'org-mode)
             (org-in-block-p '("src" "latex" "html")))
        (call-interactively #'self-insert-command)
      (if (looking-at "”[/=_\\*]?")
          (goto-char (match-end 0))
        (when italicize
          (if (derived-mode-p 'markdown-mode)
              (insert "__")
            (insert "//"))
          (forward-char -1))
        (insert "“”")
        (forward-char -1))))

  (define-key org-mode-map "'" #'endless/apostrophe)

  (defun endless/apostrophe (opening)
    "Insert ’ in prose or `self-insert-command' in code.
With prefix argument OPENING, insert ‘’ instead and
leave point in the middle.
Inside a code-block, just call `self-insert-command'."
    (interactive "P")
    (if (and (derived-mode-p 'org-mode)
             (org-in-block-p '("src" "latex" "html")))
        (call-interactively #'self-insert-command)
      (if (looking-at "['’][=_/\\*]?")
          (goto-char (match-end 0))
        (if (null opening)
            (insert "’")
          (insert "‘’")
          (forward-char -1)))))



  ;; http://emacs.stackexchange.com/a/10712/115
  (defun modi/org-delete-link ()
    "Replace an org link of the format [[LINK][DESCRIPTION]] with DESCRIPTION.
If the link is of the format [[LINK]], delete the whole org link.
In both the cases, save the LINK to the kill-ring.
Execute this command while the point is on or after the hyper-linked org link."
    (interactive)
    (when (derived-mode-p 'org-mode)
      (let ((search-invisible t) start end)
        (save-excursion
          (when (re-search-backward "\\[\\[" nil :noerror)
            (when (re-search-forward "\\[\\[\\(.*?\\)\\(\\]\\[.*?\\)*\\]\\]"
                                     nil :noerror)
              (setq start (match-beginning 0))
              (setq end   (match-end 0))
              (kill-new (match-string-no-properties 1)) ; Save link to kill-ring
              (replace-regexp "\\[\\[.*?\\(\\]\\[\\(.*?\\)\\)*\\]\\]" "\\2"
                              nil start end)))))))
  (bind-key "C-c d l" 'modi/org-delete-link org-mode-map)

  ;; Org Cliplink: insert the link in the clipboard as an org link. Adds the
  ;; title of the page as the description
  ;; https://github.com/rexim/org-cliplink
  (use-package org-cliplink
    :bind (:map org-mode-map
                ;; "C-c C-l" is bound to `org-insert-link' by default
                ;; "C-c C-L" is bound to `org-cliplink'
                ("C-c C-S-l" . org-cliplink)))

  ;; org-download: easily add images to org buffers
  ;; https://github.com/abo-abo/org-download
  (use-package org-download)

  ;; ox-gfm: export to github flavored markdown
  ;; https://github.com/larstvei/ox-gfm
  (use-package ox-gfm)

  ;; pomodoro implementation in org
  ;; https://github.com/lolownia/org-pomodoro
  (use-package org-pomodoro
    :bind ("C-c o p" . org-pomodoro))

  (defun rag/copy-id-to-clipboard()
    "Copy the ID property value to killring,
if no ID is there then create a new unique ID.
This function works only in org-mode buffers.

The purpose of this function is to easily construct id:-links to
org-mode items. If its assigned to a key it saves you marking the
text and copying to the killring."
         (interactive)
         (when (eq major-mode 'org-mode) ; do this only in org-mode buffers
           (setq mytmpid (funcall 'org-id-get-create))
           (kill-new mytmpid)
           (message "Copied %s to killring (clipboard)" mytmpid)))
  (bind-key "s-i" 'rag/copy-id-to-clipboard org-mode-map)

  (bind-key "C-c h c" 'hydra-org-clock/body org-mode-map)
  (defhydra hydra-org-clock (:color blue
                                    :hint nil)
"
^Clock:^ ^In/out^     ^Edit^   ^Summary^    | ^Timers:^ ^Run^           ^Insert
-^-^-----^-^----------^-^------^-^----------|--^-^------^-^-------------^------
(_?_)   _i_n         _e_dit    _g_oto entry | (_z_)     _r_elative      ti_m_e
^ ^     _c_ontinue   _q_uit    _d_isplay    |  ^ ^      cou_n_tdown     i_t_em
^ ^     _o_ut        ^ ^       _r_eport     |  ^ ^      _p_ause toggle
^ ^     ^ ^          ^ ^       ^ ^          |  ^ ^      _s_top
"
  ("i" org-clock-in)
  ("c" org-clock-in-last)
  ("o" org-clock-out)
  ("e" org-clock-modify-effort-estimate)
  ("q" org-clock-cancel)
  ("g" org-clock-goto)
  ("d" org-clock-display)
  ("r" org-clock-report)
  ("?" (org-info "Clocking commands"))
  ("r" org-timer-start)
  ("n" org-timer-set-timer)
  ("p" org-timer-pause-or-continue)
  ("s" org-timer-stop)
  ("m" org-timer)
  ("t" org-timer-item)
  ("z" (org-info "Timers"))))

(defadvice org-archive-subtree (around fix-hierarchy activate)
  (let* ((fix-archive-p (and (not current-prefix-arg)
                             (not (use-region-p))))
         (afile (org-extract-archive-file (org-get-local-archive-location)))
         (buffer (or (find-buffer-visiting afile) (find-file-noselect afile))))
    ad-do-it
    (when fix-archive-p
      (with-current-buffer buffer
        (goto-char (point-max))
        (while (org-up-heading-safe))
        (let* ((olpath (org-entry-get (point) "ARCHIVE_OLPATH"))
               (path (and olpath (split-string olpath "/")))
               (level 1)
               tree-text)
          (when olpath
            (org-mark-subtree)
            (setq tree-text (buffer-substring (region-beginning) (region-end)))
            (let (this-command) (org-cut-subtree))
            (goto-char (point-min))
            (save-restriction
              (widen)
              (-each path
                (lambda (heading)
                  (if (re-search-forward
                       (rx-to-string
                        `(: bol (repeat ,level "*") (1+ " ") ,heading)) nil t)
                      (org-narrow-to-subtree)
                    (goto-char (point-max))
                    (unless (looking-at "^")
                      (insert "\n"))
                    (insert (make-string level ?*)
                            " "
                            heading
                            "\n"))
                  (cl-incf level)))
              (widen)
              (org-end-of-subtree t t)
              (org-paste-subtree level tree-text))))))))

;; A journaling tool with org-mode: `org-journal'
;; https://github.com/bastibe/org-journal
;; Quick summary:
;; To create a new journal entry: C-c C-j
;; To open today’s journal without creating a new entry: C-u C-c C-j
;; In calendar view:
;; * j to view an entry in a new buffer
;; * C-j to view an entry but not switch to it
;; * i j to add a new entry
;; * f w to search in all entries of the current week
;; * f m to search in all entries of the current month
;; * f y to search in all entries of the current year
;; * f f to search in all entries of all time
;; * [ to go to previous entry
;; * ] to go to next ;entr
;; When viewing a journal entry:
;; * C-c C-f to view next entry
;; * C-c C-b to view previous entry
(use-package org-journal :defer 2
  :config
  (bind-key "C-c o j" 'org-journal-new-entry)

  ;; remove unnecessary modes in org-journal
  (add-hook 'org-journal-mode-hook (lambda ()
                                     (visual-line-mode -1))))

(provide 'setup-org)
