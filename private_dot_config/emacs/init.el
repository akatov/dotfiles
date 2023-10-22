(custom-set-variables
 '(debug-on-error t))

(add-to-list
 'load-path
 (expand-file-name "lisp" user-emacs-directory))

(require 'init-elpaca)
(require 'init-use-package)

(require 'init-private)
(require 'init-files)

(require 'init-font)
(require 'init-theme)
(require 'init-window)
(require 'init-movement)

(require 'init-treesitter)

(require 'init-javascript)
(require 'init-clojure)
(require 'init-elixir)
(require 'init-python)

;; * Built-in Packages

(use-package dired
  :elpaca nil
  :custom
  (dired-dwim-target t))

(use-package hl-line
  :elpaca nil
  :config
  (set-face-background 'hl-line "#073642"))

(use-package js
  :elpaca nil
  :custom
  (js-indent-level 2))

(use-package subword
  :elpaca nil
  :hook ((haskell-mode
	  coffee-mode
	  js-mode
	  js2-mode
	  typescript-mode) . subword-mode))

;; * Default Config

;; ** TODO Frame - put this inside use-package

(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

;; ** TODO General - put this inside use-package

;; just answer `y' or `n'.

(fset 'yes-or-no-p 'y-or-n-p)


;; ** TODO General Customizations - put this inside use-package

;; These are the customizations that may have lived in the custom file,
;; and don't have anything to do with any specific mode refered to
;; from use-package...

(ido-mode 'buffers)    ;; I only like ido-mode for switching buffers.
(blink-cursor-mode)    ;; turn blinking on
(column-number-mode t) ;; show columns
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount
      '((nil . 1)
	((control) . 3)
	((shift) . 5)
	((control shift) . 7)
	((meta) . 9)
	((meta control) . 11)
	((meta shift) . 13)
	((meta shift control) . 1.0)))

;; ** TODO Global Keybindings - put this inside use-package

;; Some global keybindings I like to use...

(bind-keys ("M-g h" . windmove-left)
           ("M-g j" . windmove-down)
           ("M-g k" . windmove-up)
           ("M-g l" . windmove-right)
           ("M-g M-h" . windmove-left)
           ("M-g M-j" . windmove-down)
           ("M-g M-k" . windmove-up)
           ("M-g M-l" . windmove-right)
           ("C-h" . delete-backward-char) ; like in the terminal
           ("M-h" . help-command)) ; rebind the help command
(bind-key "<s-return>" 'toggle-frame-fullscreen)

;; * Custom Config

;; ** Edit Config

;; quickly edit this file

(defun config ()
  (interactive)
  (switch-to-buffer
     (find-file
      (expand-file-name "init.el" user-emacs-directory))))

;; * Downloaded Packages

;; ** TODO avy
;; ** TODO ivy

(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package ace-jump-mode
  :ensure t
  :bind
  (("C-;" . ace-jump-mode)
   ("C-c SPC" . ace-jump-mode)
   ("C-c C-SPC" . ace-jump-mode)))

(use-package ag
  :ensure t)

(use-package async
  :ensure t)

(use-package auto-complete
  :ensure t)

(use-package auto-highlight-symbol
  :ensure t)

;; ** TODO configure this

(use-package company
  :ensure t
  ;; :init
  ;; (global-company-mode)
  )

;; (use-package company-emoji
;;   :if (window-init)
;;   :system
;;   (defun --set-emoji-font (frame)
;;     "Adjust the font settings of FRAME so Emacs can display emoji properly."
;;     (if (eq system-type 'darwin)
;; 	;; For NS/Cocoa
;; 	(set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame 'prepend)
;;       ;; For Linux
;;       (set-fontset-font t 'symbol (font-spec :family "Symbola") frame 'prepend)))

;;   ;; For when Emacs is started in GUI mode:
;;   (--set-emoji-font nil)
;;   ;; Hook for when a frame is created with emacsclient
;;   ;; see https://www.gnu.org/software/emacs/manual/html_node/elisp/Creating-Frames.html
;;   :config
;;   (add-to-list 'company-backends 'company-emoji)
;;   (add-hook 'after-make-frame-functions '--set-emoji-font)
;;   (setq company-emoji-insert-unicode nil))

(use-package company-quickhelp
  :ensure t
  ;; :init
  ;; (company-quickhelp-mode 1)
  )

(use-package diminish
  :ensure t)

(use-package discover-my-major
  :ensure t
  :bind
  (("M-h M-m" . discover-my-major)
   ("M-h M-M" . discover-my-mode)))

(use-package edts
  :ensure t)

(use-package erlang
  :ensure t)

;; (use-package eslint-fix
;;   :init
;;   (add-hook 'js2-mode-hook
;;             (lambda () 
;;               (add-hook 'after-save-hook 'eslint-fix nil t)
;;               ))
;;   (add-hook 'js-mode-hook
;;             (lambda () 
;;               (add-hook 'after-save-hook 'eslint-fix nil t)
;;               )))


;; In NextStep (OSX) window mode load the path settings from the shell

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :custom
  (exec-path-from-shell-variables
   '("PATH"
     "MANPATH"
     "GOPATH"
     "MAVEN_OPTS"))
  :init
  (exec-path-from-shell-initialize))

(use-package handlebars-sgml-mode
  :ensure t)

;; (use-package jabber
;;              ;; :ensure t
;;              )

;; TODO - use :hooks

(use-package less-css-mode
  :ensure t)

(use-package lua-mode
  :ensure t)

(use-package magit
  :ensure t
  :bind
  ("C-x g" . magit-status))

(use-package magit-popup
  :ensure t)

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")

(use-package neotree
  :ensure t
  :init
  (bind-key [f8] 'neotree-toggle))

(use-package ob-restclient
  :ensure t)

(use-package ob-http
  :ensure t)

(use-package ob-sql-mode
  :ensure t)

;; TODO put this in use-package

(use-package org
  :ensure t)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-use-speed-commands t)
(setq org-return-follows-link t)
(setq org-src-preserve-indentation t)
(setq org-agenda-custom-commands
      '(("w" todo "WAITING" nil)
        ("n" todo "NEXT" nil)
        ("d" "Agenda + Next Actions" ((agenda) (todo "NEXT")))))


;; todo: find a better location for this
(setq org-ditaa-jar-path
      "/usr/local/Cellar/ditaa/0.10/libexec/ditaa0_10.jar")
(setq org-plantuml-jar-path
      "/usr/local/Cellar/plantuml/1.2017.14/libexec/plantuml.jar")


;; ** org-babel

;; (org-babel-do-load-languages 'org-babel-load-languages
;; 			     '((emacs-lisp . t)
;; 			       (plantuml   . t)
;; 			       (python     . t)
;; 			       (ditaa      . t)
;; 			       (clojure    . t)
;; 			       (shell      . t)
;; 			       (http       . t)
;; 			       (sql        . t)))

;; Use cider as the clojure execution backend
(setq org-babel-clojure-backend 'cider)

;; Let's have pretty source code blocks
(setq org-edit-src-content-indentation 0
      org-src-tab-acts-natively        t
      org-src-fontify-natively         t
      org-confirm-babel-evaluate       nil)

;; (use-package org-plus-contrib
;; 	     :ensure t)

(use-package origami
  :ensure t
  ;; TODO: keybindings
  )

(use-package ox-reveal
  :ensure t)

;; ** TODO org-drill

;; ** TODO package-build

;; ** TODO pallet

;; (use-package paredit
;; 	     :ensure t
;; 	     :init

;; 	     (autoload 'enable-paredit-mode "paredit"
;; 	       "Turn on pseudo-structural editing of Lisp code."
;; 	       t)

;; 	     (defvar electrify-return-match
;; 	       "[\]}\)\"]"
;; 	       "If this regexp matches the text after the cursor, do an \"electric\"
;;     return.")

;; 	     (defun electrify-return-if-match (arg)
;; 	       "If the text after the cursor matches `electrify-return-match' then
;;     open and indent an empty line between the cursor and the text.  Move the
;;     cursor to the new line."
;; 	       (interactive "P")
;; 	       (let ((case-fold-search nil))
;; 		 (if (looking-at electrify-return-match)
;; 		     (save-excursion (newline-and-indent)))
;; 		 (newline arg)
;; 		 (indent-according-to-mode)))

;; 	     (defun activate-electrify-return ()
;; 	       (local-set-key (kbd "RET") 'electrify-return-if-match))

;; 	     (defun activate-clojure-paredit-curly ()
;; 	       (define-key clojure-mode-map "{" 'paredit-open-curly)
;; 	       (define-key clojure-mode-map "}" 'paredit-close-curly))

;; 	     (defun setup-paredit-eldoc-commands ()
;; 	       (turn-on-eldoc-mode)
;; 	       (eldoc-add-command 'paredit-backward-delete
;; 				  'paredit-close-round
;; 				  'electrify-return-if-match))

;; 	     (add-hook 'clojure-mode-hook 'activate-clojure-paredit-curly)

;; 	     (add-hooks '(emacs-lisp-mode-hook)
;; 			'(activate-electrify-return
;; 			  setup-paredit-eldoc-commands))

;;   ;;; paredit doesn't do this automatically
;; 	     (add-hooks
;; 	      '(clojure-mode-hook
;; 		emacs-lisp-mode-hook
;; 		lisp-interaction-mode-hook
;; 		lisp-mode-hook
;; 		scheme-mode-hook)
;; 	      '(enable-paredit-mode))

;;   ;;; paredit for javascript

;; 	     (defun my-paredit-nonlisp ()
;; 	       "Turn on paredit mode for non-lisps."
;; 	       (interactive)
;; 	       (set (make-local-variable 'paredit-space-for-delimiter-predicates)
;; 		    '((lambda (endp delimiter) nil)))
;; 	       (paredit-mode 1))

;; 	     (defun activate-js2-paredit-curly ()
;; 	       (define-key js2-mode-map "{" 'paredit-open-curly)
;; 	       (define-key js2-mode-map "}" 'paredit-close-curly))

;; 	     (add-hook 'js2-mode-hook 'activate-js2-paredit-curly)

;; 	     ;; (add-hooks
;; 	     ;;  '(js-mode-hook js2-mode-hook)
;; 	     ;;  '(my-paredit-nonlisp))
;;              )

;; ** TODO popup


(defun aka/init-lsp-mode ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . aka/init-lsp-mode)
  :custom
  (lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  ;; :config
  ;; (lsp-enable-which-key-integration t)
  )

(use-package lsp-ui
  :custom
  (lsp-ui-doc-position 'bottom)
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-treemacs
  :after lsp)

;; ** queue

;; ** TODO shut-up

;; (use-package slack)

(defun aka/smartparens-mode ()
  (smartparens-strict-mode)
  (show-smartparens-mode))

(use-package smartparens
  :ensure t
  :hook
  ((cider-repl-mode
    clojure-mode
    elixir-mode
    emacs-lisp-mode
    haskell-interactive-mode
    haskell-mode
    js-mode
    js2-mode
    ruby-mode
    typescript-mode) . aka/smartparens-mode)
  :config
  (require 'smartparens-config)
  (sp-use-paredit-bindings))

;; (use-package tagedit
;; 	     :ensure t
;; 	     :init
;; 	     (tagedit-add-paredit-like-keybindings)
;; 	     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))
;; 	     (add-hook 'handlebars-mode-hook (lambda () (tagedit-mode 1))))

;; ** TODO toml-mode

;; ** TODO ts-comint

(use-package wakatime-mode
  :ensure t
  :custom
  ;; see init-private
  (wakatime-cli-path "/opt/homebrew/bin/wakatime-cli")
  :config
  (global-wakatime-mode))

(use-package weblorg
  :ensure t)

(use-package yaml-mode
  :ensure t)

;; ** TODO hydra

;; ** TODO treesitter

;; ** TODO combobulate

(provide 'init)
