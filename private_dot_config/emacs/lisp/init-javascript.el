(use-package js-comint
  :ensure t
  :bind
  (:map
   js-comint-mode-map
   ("C-x C-e" . js-send-last-sexp)
   ("C-c b"   . js-send-buffer)))

;; (use-package js2-highlight-vars
;;   :init
;;   (add-hook 'js2-mode-hook 'js2-highlight-vars-mode))

(use-package js2-mode
  :ensure t
  :mode (("\\.js\\'" . js2-mode)
	 ("\\.json\\'" . js2-mode))
  :interpreter "node"
  ;; :custom
  ;; (inferior-js-program-command "node")
  )

(use-package prettier-js
  :ensure t
  ;; :init
  ;; (add-hook 'js2-mode-hook 'prettier-js-mode)
  :custom
  (prettier-js-args '("--print-width" "70"
		      "--tab-width" "2"
		      "--single-quote"
		      "--trailing-comma" "es5")))

(use-package typescript-mode
  :ensure t
  :custom
  (typescript-indent-level 2))



(provide 'init-javascript)
