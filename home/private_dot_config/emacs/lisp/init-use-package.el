(elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (custom-set-variables
   '(elpaca-use-package-by-default t)))

;; Block until current queue processed.
(elpaca-wait)


(provide 'init-use-package)
