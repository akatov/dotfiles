(use-package org
  :elpaca nil
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

(use-package ob-restclient
  :ensure t)

(use-package ob-http
  :ensure t)

(use-package ob-sql-mode
  :ensure t)

;; todo: find a better location for this
(setq org-ditaa-jar-path
      "/usr/local/Cellar/ditaa/0.10/libexec/ditaa0_10.jar")

(setq org-plantuml-jar-path
      "/opt/homebrew/Cellar/plantuml/1.2023.12/libexec/plantuml.jar")


;; ** org-babel

(org-babel-do-load-languages 'org-babel-load-languages
			     '((emacs-lisp . t)
			       (plantuml   . t)
			       (python     . t)
			       (ditaa      . t)
			       (clojure    . t)
			       (shell      . t)
			       ;; (http       . t)
			       (sql        . t)))

;; Use cider as the clojure execution backend
(setq org-babel-clojure-backend 'cider)

;; Let's have pretty source code blocks
(setq org-edit-src-content-indentation 0
      org-src-tab-acts-natively        t
      org-src-fontify-natively         t
      org-confirm-babel-evaluate       nil)

(use-package ox-reveal
  :after (org)
  :ensure t)

;; (use-package org-plus-contrib
;; 	     :ensure t)

;; ** TODO org-drill

(provide 'init-org)
