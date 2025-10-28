;; @see https://www.masteringemacs.org/article/how-to-get-started-tree-sitter

(defun aka/remove-treesit-sexp-changes ()
  (when (eq forward-sexp-function #'treesit-forward-sexp)
    (setq forward-sexp-function nil))
  ;; (when (eq transpose-sexps-function #'treesit-transpose-sexps)
  ;;   (setq transpose-sexps-function #'transpose-sexps-default-function))
  (when (eq forward-sentence-function #'treesit-forward-sentence)
    (setq forward-sentence-function #'forward-sentence-default-function)))

(use-package treesit
  :elpaca nil
  :init
  (setq
   treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
  ;; TODO: only do this if not already installed
  ;; (mapc
  ;;  #'treesit-install-language-grammar
  ;;  (mapcar #'car treesit-language-source-alist))
  :custom
  (major-mode-remap-alist
   '((bash-mode . bash-ts-mode)
     (css-mode . css-ts-mode)
     (js2-mode . js-ts-mode)
     (json-mode . json-ts-mode)
     (python-mode . python-ts-mode)
     (typescript-mode . typescript-ts-mode)))
  ;; :hook
  ;; (prog-mode . aka/remove-treesit-sexp-changes)
  )

(provide 'init-treesitter)
