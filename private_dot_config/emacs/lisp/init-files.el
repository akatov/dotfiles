;; ** TODO Custom File - can we put add-hook inside use-package

;; keep custom settings in a separate custom file
;; try to keep that file empty, and instead put all the customizations directly
;; in init.el

(use-package cus-edit
  :elpaca nil
  :custom
  (custom-file (expand-file-name "custom.el" user-emacs-directory)))
(add-hook 'elpaca-after-init-hook (lambda () (load custom-file 'noerror)))

;; Place backup files in emacs's temp directory

(use-package files
  :elpaca nil
  :custom
  (backup-directory-alist
   (list (cons "." (expand-file-name "temp" user-emacs-directory)))))

;; Lock files will interfere with some auto-build tools

(use-package emacs
  :elpaca nil
  :custom
  (create-lockfiles nil))

(provide 'init-files)
