(use-package cider
  :ensure t
  :init
  (custom-set-variables
   '(nrepl-hide-special-buffers t)
   '(cider-repl-pop-to-buffer-on-connect nil)
   '(cider-popup-stacktraces nil)
   '(cider-repl-popup-stacktraces t)))

(use-package clojure-mode
  :ensure t)

;; TODO - set this up properly
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(safe-local-variable-values
;;    '((eval progn
;; 	   (make-variable-buffer-local 'cider-jack-in-nrepl-middlewares)
;; 	   (add-to-list 'cider-jack-in-nrepl-middlewares "shadow.cljs.devtools.server.nrepl/middleware"))
;;      (cider-repl-display-help-banner)
;;      (cider-prefer-build-tool . clojure-cli))))

(provide 'init-clojure)
