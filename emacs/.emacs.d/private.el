(use-package editorconfig
  :diminish
  :config
  (editorconfig-mode 1))

;; LSP
(use-package eglot
  :after
  (js2-mode rjsx-mode)
  :commands
  eglot-ensure
  :bind (:map eglot-mode-map
              ("C-c h" . eglot-help-at-point)
              ("C-c a" . eglot-code-actions)
              ("C-c r" . eglot-rename))
  :hook ((rjsx-mode . eglot-ensure))
  :config
  (setq eglot-server-programs
        '(((js-mode js2-mode rjsx-mode) . ("flow-language-server" "--stdio" "--try-flow-bin"))))
  )

(use-package json-mode)
(use-package yaml-mode)
(use-package markdown-mode)

;; Bazel
(use-package bazel-mode)

;; Clojure
(use-package clojure-mode)
(use-package cider)
(use-package rainbow-mode
  :diminish)


;; Paredit
(use-package paredit
  :diminish
  :commands paredit-mode
  :hook
  ((emacs-lisp-mode
    lisp-mode
    lisp-interaction-mode
    scheme-mode
    clojure-mode)
   . paredit-mode))

;; Javascript
(use-package rjsx-mode)

;; Prettier
(use-package prettier-js
  :commands
  (prettier-js-mode prettier-js)
  :hook ((rjsx-mode . prettier-js-mode)
	 (js-mode . prettier-js-mode)))

(use-package add-node-modules-path
  :commands (add-node-modules-path)
  :hook (prettier-js-mode . add-node-modules-path))


;; Web-mode is an autonomous emacs major-mode for editing web templates.
;; HTML documents can embed parts (CSS / JavaScript) and blocks (client / server side).
(use-package web-mode
  :mode ("\\.html\\'" "\\.css?\\'")
  :hook (add-node-modules-path prettier-js))
