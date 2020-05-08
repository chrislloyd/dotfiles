;;; -*- lexical-binding: t -*-

;; ====
;; INIT
(setq gc-cons-threshold (* 100 1024 1024))

;; Package system and sources.
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; We will use 'use-package' to install and configure packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))


;; No need to out 'ensure' everywhere, since we don't use anything else to install packages.
(setq use-package-always-ensure t)


;; Pass system shell environment to Emacs. This is important primarily for shell inside Emacs, but also things like Org mode export to Tex PDF don't work, since it relies on running external command pdflatex, which is loaded from PATH.
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)))


;; Store custom-file separately, don't freak out when it's not found
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Set path for private config. private.el is not part of Castlemacs and you can use it for your personal
;; additions. Do not change init.el yourself, it will make updates harder.
(add-hook
 'after-init-hook
 (lambda ()
   (let ((private-file (concat user-emacs-directory "private.el")))
     (when (file-exists-p private-file)
       (load-file private-file)))))


;; =============
;; MODIFIER KEYS


;; Both command keys are 'Super'
(setq mac-right-command-modifier 'super)
(setq mac-command-modifier 'super)


;; Option or Alt is naturally 'Meta'
(setq mac-option-modifier 'meta)


;; Right Alt (option) can be used to enter symbols like em dashes '—' and euros '€' and stuff.
(setq mac-right-option-modifier 'nil)



;; =============
;; SANE DEFAULTS

;; Don't bother with auto save and backups.
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
)


;; Warn only when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)


;; Move file to trash instead of removing.
(setq-default delete-by-moving-to-trash t)


;; Revert (update) buffers automatically when underlying files are changed externally.
(global-auto-revert-mode t)

(setq
 inhibit-startup-message t         ; Don't show the startup message...
 inhibit-startup-screen t          ; ... or screen
 cursor-in-non-selected-windows t  ; Hide the cursor in inactive windows

 echo-keystrokes 0.1               ; Show keystrokes right away, don't show the message in the scratch buffer
 initial-scratch-message nil       ; Empty scratch buffer
 initial-major-mode 'org-mode      ; Org mode by default
 sentence-end-double-space nil     ; Sentences should end in one space, come on!
 confirm-kill-emacs 'y-or-n-p      ; y and n instead of yes and no when quitting
 help-window-select t              ; Select help window so it's easy to quit it with 'q'
 ring-bell-function 'ignore        ; Never ring that damned bell
 frame-inhibit-implied-resize t
 indicate-buffer-boundaries nil
 visible-cursor nil
)

(fset 'yes-or-no-p 'y-or-n-p)      ; y and n instead of yes and no everywhere else
(delete-selection-mode 1)          ; Delete selected text when typing
(global-unset-key (kbd "s-p"))     ; Don't print


;; Things you'd expect from macOS app.
(global-set-key (kbd "s-s") 'save-buffer)             ;; save
(global-set-key (kbd "s-S") 'write-file)              ;; save as
(global-set-key (kbd "s-q") 'save-buffers-kill-emacs) ;; quit
(global-set-key (kbd "s-a") 'mark-whole-buffer)       ;; select all


;; Delete trailing spaces and add new line in the end of a file on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)


;; `ls' on MacOS doesn't dupport the `--dired' flag, this silences the warning
;; when using dired-mode.
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))


;; =======
;; VISUALS

;; Font

(cond ((find-font (font-spec :name "PragmataPro Liga"))
       (set-face-attribute 'default nil :font "PragmataPro Liga-16")
       ;; Set the `fixed-pitch' face to PragmataPro as it is available, instead of
       ;; defaulting to the system monospace font.  This face is used by
       ;; `markdown-code-face' and other "fixed pitch" faces in Markdown.  Setting
       ;; `fixed-pitch' family to PragmataPro ensures that all ligatures work as set in
       ;; this file.  Below also increases the font-size of `fixed-pitch' face by 2
       ;; points to distinguish them from the rest of the text.
       (set-face-attribute 'fixed-pitch nil
                           :family "PragmataPro Liga"
                           :height (* (+ 16 2) 10))

       (add-to-list 'load-path (expand-file-name "~/.emacs.d/pragmata-pro"))
       (load-file "~/.emacs.d/pragmata.el")
       (global-prettify-symbols-mode +1))
      ((find-font (font-spec :name "Menlo"))
       (set-face-attribute 'default nil :font "Menlo 16")
       (setq-default line-spacing 2)))


;; Nice and simple default light theme.
(use-package atom-dark-theme)


;; Hide toolbar and scroll bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;; Always wrap lines
(global-visual-line-mode 1)


;; Highlight current line
(global-hl-line-mode 1)


;; Always show line numbers
(global-display-line-numbers-mode)
(setq display-line-numbers-width 3)


;; Show parens and other pairs.
(use-package smartparens
  :diminish
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  (show-smartparens-global-mode t))


;; Hide minor modes from modeline
(use-package diminish
  :config
  (diminish 'flycheck-mode)
  (diminish 'flyspell-mode)
  (diminish 'eldoc-mode)
  (diminish 'visual-line-mode))
(use-package delight)

(use-package smart-mode-line
  :init
  (sml/setup)
  :config
  (add-to-list 'sml/replacer-regexp-list '("^~/src/" ":src:") t)
  (add-to-list 'sml/replacer-regexp-list '("^:src:chrislloyd/tools/dotfiles/" ":dot:") t)
  (add-to-list 'sml/replacer-regexp-list '("^:src:chrislloyd/\(.*\)/" ":\1:") t)
  (add-to-list 'sml/replacer-regexp-list '("^:src:\(.*\)/" ":src/\1:") t)
  (set-face-attribute 'mode-line nil :box '(:line-width 4 :color "#000"))
  (set-face-attribute 'mode-line-inactive nil :box '(:line-width 4 :color "#404045"))
  (setq sml/shorten-modes t))


;; File tree
(use-package neotree
  :bind
  ("s-B" . neotree-toggle)
  :config
  (setq neo-window-width 32
        neo-create-file-auto-open t
        neo-banner-message nil
        neo-show-updir-line t
        neo-window-fixed-size nil
        neo-vc-integration nil
        neo-mode-line-type 'neotree
        neo-smart-open t
        neo-show-hidden-files t
        neo-mode-line-type 'none
        neo-auto-indent-point t)
  (setq neo-theme (if (display-graphic-p) 'nerd 'arrow))
  (setq neo-hidden-regexp-list
        '("venv" "\\.pyc$" "~$" "\\.git" "__pycache__" ".DS_Store"))
  (setq projectile-switch-project-action 'neotree-projectile-action))


;; Show full path in the title bar.
(setq-default frame-title-format "%b (%f)")


;; Show keybindings cheatsheet
(use-package which-key
  :diminish
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))


;; ============
;; TEXT EDITING

;; Comment line or region.
(global-set-key (kbd "s-/") 'comment-line)


;; Visually find and replace text
(use-package visual-regexp
  :config
  (define-key global-map (kbd "M-s-f") 'vr/replace)
  (define-key global-map (kbd "s-r") 'vr/replace))  ;; Cmd+r find and replace

;; =================
;; WINDOW MANAGEMENT

(use-package golden-ratio
  :diminish
  :config
  (golden-ratio-mode 1))

;; Go to other windows easily with one keystroke Cmd-something.
(global-set-key (kbd "s-1") (kbd "C-x 1"))  ;; Cmd-1 kill other windows (keep 1)
(global-set-key (kbd "s-2") (kbd "C-x 2"))  ;; Cmd-2 split horizontally
(global-set-key (kbd "s-3") (kbd "C-x 3"))  ;; Cmd-3 split vertically
(global-set-key (kbd "s-0") (kbd "C-x 0"))  ;; Cmd-0...
(global-set-key (kbd "s-w") `kill-current-buffer)  ;; ...and Cmd-w to close current window


;; ==================
;; PROJECT MANAGEMENT


;; Use Projectile for project management.
(use-package projectile
  :diminish
  :bind
  (:map projectile-mode-map
        ("C-s-p" . projectile-command-map))
  :config
  (projectile-mode 1))


;; ==========================================
;; MENUS AND COMPLETION (not code completion)


;; Use minimalist Ivy for most things.
(use-package ivy
  :diminish                             ;; don't show Ivy in minor mode list
  :bind
  (("s-b" . ivy-switch-buffer)          ;; Cmd+b show buffers and recent files
   ("M-s-b" . ivy-resume))              ;; Alt+Cmd+b resume whatever Ivy was doing
  :config
  (ivy-mode 1)                          ;; enable Ivy everywhere
  (setq ivy-use-virtual-buffers t)      ;; show bookmarks and recent files in buffer list
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  (setq ivy-re-builders-alist
      '((swiper . ivy--regex-plus)
        (t      . ivy--regex-fuzzy))))  ;; enable fuzzy searching everywhere except for Swiper



;; Swiper is a better local finder.
(use-package swiper
  :bind
  (("\C-s" . swiper)   ;; Default Emacs Isearch forward...
   ("\C-r" . swiper)   ;; ... and Isearch backward replaced with Swiper
   ("s-f " . swiper))) ;; Cmd+f find text


(use-package smex)  ;; show recent commands when invoking Alt-x (or Cmd+Shift+p)
(use-package flx)   ;; enable fuzzy matching
(use-package avy)   ;; enable avy for quick navigation


;; Make Ivy a bit more friendly by adding information to ivy buffers, e.g. description of commands in Alt-x, meta info when switching buffers, etc.
(use-package ivy-rich
  :config
  (ivy-rich-mode 1)
  (setq ivy-rich-path-style 'abbrev)) ;; Abbreviate paths using abbreviate-file-name (e.g. replace “/home/username” with “~”)


;; Integrate Projectile with Counsel
(use-package counsel-projectile
  :config
  (counsel-projectile-mode 1)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "s-p") 'counsel-projectile-find-file)         ;; Cmd+p open file in current project
  (global-set-key (kbd "s-F") 'counsel-projectile-ag))     ;; Cmd+Shift+F search in current git repository


(setq projectile-completion-system 'ivy)             ;; Use Ivy in Projectile


;; ========================
;; VERSION CONTROL WITH GIT


;; Magit
(use-package magit
  :config
  (global-set-key (kbd "s-g") 'magit-status))   ;; Cmd+g for git status


;; Show changes in the gutter
(use-package git-gutter
  :diminish
  :config
  (global-git-gutter-mode 't)
  (set-face-background 'git-gutter:modified 'nil)   ;; background color
  (set-face-foreground 'git-gutter:added "green4")
  (set-face-foreground 'git-gutter:deleted "red"))


;; ========
;; TERMINAL


(use-package shell-pop
  :config
  (custom-set-variables
   '(shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
   '(shell-pop-universal-key "s-=")))


;; ===============
;; CODE COMPLETION


(use-package company
  :diminish
  :config
  (setq company-idle-delay 0.1)
  (setq company-global-modes '(not org-mode))
  (setq company-minimum-prefix-length 1)
  (add-hook 'after-init-hook 'global-company-mode))


;; Set the company completion vocabulary to css and html when in web-mode.
(defun my-web-mode-hook ()
  (set (make-local-variable 'company-backends) '(company-css company-web-html company-yasnippet company-files)))


;; ========
;; ORG MODE


;; Some basic Org defaults
(use-package org
  :config
  (setq org-startup-indented t)         ;; Visually indent sections. This looks better for smaller files.
  (setq org-src-tab-acts-natively t)    ;; Tab in source blocks should act like in major mode
  (setq org-src-preserve-indentation t)
  (setq org-log-into-drawer t)          ;; State changes for todos and also notes should go into a Logbook drawer
  (setq org-src-fontify-natively t)     ;; Code highlighting in code blocks
  (setq org-log-done 'time)             ;; Add closed date when todo goes to DONE state
  (setq org-support-shift-select t)     ;; Allow shift selection with arrows.
  (setq org-directory "~/Dropbox/Notes") ;; Store all my org files in ~/org.
  (setq org-agenda-files '("~/Dropbox/Notes"))) ;; And all of those files should be in included agenda.


;; Open config file by pressing C-x and then c
(global-set-key (kbd "C-x c") (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

(use-package csv-mode
  :mode "\\.csv\\'")

(use-package ledger-mode
  :bind (:map ledger-mode-map
              ("RET" . newline)
  	      ("C-o" . open-line))
  :mode "\\.(ledger|journal)\\'"
  :config
  (setq ledger-use-iso-dates t))

(use-package flycheck-ledger
  :after (flycheck ledger-mode))


;; Pain & suffering

(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))
(global-unset-key (kbd "<C-left>"))
(global-unset-key (kbd "<C-right>"))
(global-unset-key (kbd "<C-up>"))
(global-unset-key (kbd "<C-down>"))
(global-unset-key (kbd "<M-left>"))
(global-unset-key (kbd "<M-right>"))
(global-unset-key (kbd "<M-up>"))
(global-unset-key (kbd "<M-down>"))

;; =======
;; THE END
