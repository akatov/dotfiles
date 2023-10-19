(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred))

(provide 'init-python)
