;; Time-stamp: <2016-12-30 18:04:54 csraghunandan>

;; racket-mode
;; https://github.com/greghendershott/racket-mode
(use-package racket-mode
  :config
  (defun my-racket-mode-hook ()
    (set (make-local-variable 'company-backends)
         '((company-capf company-dabbrev-code company-files company-yasnippet)))
    (company-quickhelp-mode 0))
  (defun my-racket-mode-hook2 ()
    (set (make-local-variable 'company-backends)
         '((company-capf company-dabbrev-code company-yasnippet)))
    (company-quickhelp-mode 0))
  (add-hook 'racket-mode-hook 'my-racket-mode-hook)
  (add-hook 'racket-mode-hook 'company-mode)
  (add-hook 'racket-repl-mode-hook 'my-racket-mode-hook2)
  (add-hook 'racket-repl-mode-hook 'company-mode))

(provide 'setup-racket)
