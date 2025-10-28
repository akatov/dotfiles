(use-package fira-code-mode
  :ensure t
  :if (window-system)
  :custom
  (fira-code-mode-disabled-ligatures '("[]" "x"))
  :hook prog-mode)

(provide 'init-font)
