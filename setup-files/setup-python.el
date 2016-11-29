;; Time-stamp: <2016-11-29 14:03:15 csraghunandan>

;; Python configuration
(use-package python
  :bind (:map python-mode-map
              (("C-c C-t" . anaconda-mode-show-doc)
               ("M-." . anaconda-mode-find-definitions)
               ("M-," . anaconda-mode-go-back-definitions)))
  :config
  (setq python-shell-interpreter "python3")
  (add-hook 'python-mode-hook 'company-mode)
  (add-hook 'python-mode-hook 'flycheck-mode)

  ;; anaconda-mode :- bring IDE like features for python-mode
  ;; https://github.com/proofit404/anaconda-mode
  (use-package anaconda-mode
    :diminish anaconda-mode
    :config
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

  ;; company backend for anaconda-mode
  ;; https://github.com/proofit404/company-anaconda
  (use-package company-anaconda
    :config
    (defun my-anaconda-mode-hook ()
      "Hook for `web-mode'."
      (set (make-local-variable 'company-backends)
           '((company-anaconda company-files))))
    (add-hook 'python-mode-hook 'my-anaconda-mode-hook))

  ;; for testing python code
  ;; https://github.com/ionrock/pytest-el
  (use-package pytest :defer t))

(provide 'setup-python)
