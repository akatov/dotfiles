(use-package wakatime-mode
  :ensure t
  :init
  (setq
   ;; wakatime-api-key  "..."
   wakatime-cli-path "/opt/homebrew/bin/wakatime-cli"
   )
  :config
  (global-wakatime-mode)
  )
