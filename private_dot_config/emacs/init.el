;;; init.el --- start here

(org-babel-load-file
 (expand-file-name "readme.org"
                   user-emacs-directory))

(add-to-list 'load-path
             (expand-file-name "lisp"
                               user-emacs-directory))

(require 'init-wakatime)

(provide 'init)

;;; init.el ends here
