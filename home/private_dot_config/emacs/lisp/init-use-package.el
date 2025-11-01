;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
  (elpaca-use-package-mode))

;; Block until current queue processed.
(elpaca-wait)

(provide 'init-use-package)
