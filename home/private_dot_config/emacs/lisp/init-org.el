(use-package org
  :ensure t

  :bind
  (("C-c l" . org-store-link)
   ("C-c a" . org-agenda))

  :custom
  (org-log-done t)
  (org-use-speed-commands t)
  (org-return-follows-link t)
  (org-src-preserve-indentation t)
  (org-agenda-custom-commands
   '(("w" todo "WAITING" nil)
     ("n" todo "NEXT" nil)
     ("d" "Agenda + Next Actions" ((agenda) (todo "NEXT")))))

  (org-ditaa-jar-path
	"/usr/local/Cellar/ditaa/0.10/libexec/ditaa0_10.jar")
  (org-plantuml-jar-path
	"/opt/homebrew/Cellar/plantuml/1.2023.12/libexec/plantuml.jar")

  ;; Use cider as the clojure execution backend
  (org-babel-clojure-backend 'cider)

  ;; Let's have pretty source code blocks
  (org-edit-src-content-indentation 0)
  (org-src-tab-acts-natively        t)
  (org-src-fontify-natively         t)
  (org-confirm-babel-evaluate       nil)

  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (plantuml   . t)
     (python     . t)
     (ditaa      . t)
     (clojure    . t)
     (shell      . t)
     ;; (http       . t)
     (sql        . t))))


(use-package ob-restclient
  :ensure t)

(use-package ob-http
  :ensure t)

(use-package ob-sql-mode
  :ensure t)


(use-package ox-reveal
  :after (org)
  :ensure t)

;; (use-package org-plus-contrib
;; 	     :ensure t)

;; ** TODO org-drill

(provide 'init-org)
