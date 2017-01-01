;; Time-stamp: <2017-01-01 14:22:05 csraghunandan>

;; All the highlight stuff config

;; highlight the currently active symbol + move to next/previous occurrence of symbol
;; https://github.com/nschum/highlight-symbol.el
(use-package highlight-symbol
  :diminish highlight-symbol-mode
  :bind (("M-n" . highlight-symbol-next)
	 ("M-p" . highlight-symbol-prev)
	 ("C-c h s" . highlight-symbol))
  :config
  (highlight-symbol-nav-mode))

;; highlight specific operations like undo, yank
;; https://github.com/k-talo/volatile-highlights.el
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config
  (volatile-highlights-mode t))

;; configure hl-line-mode
(use-package hl-line
  :config
  (global-hl-line-mode))

;; best solution for highlighting indent guides so far in emacs
;; https://github.com/DarthFennec/highlight-indent-guides
(use-package highlight-indent-guides
  :config
  (add-hook 'prog-mode-hook (lambda ()
                              (unless (eq major-mode 'web-mode)
                                (highlight-indent-guides-mode))))
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character ?∣)
  ;; make indent guides a bit more brighter
  (setq highlight-indent-guides-auto-character-face-perc 15))

;; colorize color names in buffers
;; https://github.com/emacsmirror/rainbow-mode/blob/master/rainbow-mode.el
(use-package rainbow-mode
  :diminish (rainbow-mode . "𝐑𝐚"))

;; beacon :-  blink the cursor whenever scrolling or switching between windows
;; https://github.com/Malabarba/beacon
(use-package beacon
  :defer 1
  :diminish beacon-mode
  :bind (("C-!" . beacon-blink))
  :config
  (beacon-mode 1)
  (setq beacon-size 25)
  ;; don't blink in shell-mode
  (add-to-list 'beacon-dont-blink-major-modes 'comint-mode))

(provide 'setup-highlight)
