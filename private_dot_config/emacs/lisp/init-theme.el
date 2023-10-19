(defun switch-theme (theme)
  "Disables any currently active themes and loads THEME."
  ;; This interactive call is taken from `load-theme'
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapc 'symbol-name
                                   (custom-available-themes))))))
  (let ((enabled-themes custom-enabled-themes))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme theme t)))

(defun disable-active-themes ()
  "Disables any currently active themes listed in `custom-enabled-themes'."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))

(bind-key "s-<f12>" 'switch-theme)
(bind-key "s-<f11>" 'disable-active-themes)

(use-package cyberpunk-theme
  :if (window-system)
  :ensure t
  :init
  (add-to-list
   'custom-safe-themes
   "77fac25c0276f636e3914636c45f714c2fd688fe1b1d40259be7ce84b8b5ab1e")
  (progn
    (load-theme 'cyberpunk t)
    (set-face-attribute `mode-line nil
			:box nil)
    (set-face-attribute `mode-line-inactive nil
			:box nil)))

(use-package solarized-theme
  :ensure t
  :defer 10
  :custom
  (solarized-use-variable-pitch nil))

(use-package waher-theme
  :if (window-system)
  :ensure t
  :init
  (load-theme 'waher))

;; (use-package tron-legacy-theme
;;   :quelpa (tron-legacy-theme :fetcher github :repo "ianpan870102/tron-legacy-emacs-theme")
;;   ;; :init (load-theme 'tron-legacy)
;;   )

(provide 'init-theme)
