(setq inhibit-startup-message t
      visible-bell t)

(menu-bar-mode -1)

;; Emacs.app visual options
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (fringe-mode '(0 . 0)))

(setq default-frame-alist
      (append (list
               '(min-height . 1)
               '(height . 45)
               '(min-width . 1)
               '(width . 81)
               '(vertical-scroll-bars . nil)
               '(internal-border-width . 12)
               '(left-fringe . 0)
               '(right-fringe . 0)
               '(tool-bar-lines . 0)
               '(menu-bar-lines . 0))))

;; Vertical window divider
(setq window-divider-default-right-width 0)
(setq window-divider-default-places 'right-only)
(window-divider-mode)

;; Line cursor
(setq-default cursor-in-non-selected-windows nil
              cursor-type '(bar . 2)
              cursor-intangible-mode t)

;; No sound
(setq ring-bell-function 'ignore)
(setq widget-image-enable nil)

;; --
;; Modus theme with system appearance switching

(setq modus-themes-mode-line '(accented borderless (padding 6)))
(setq modus-themes-region '(bg-only))
(setq modus-themes-italic-constructs t)
(setq modus-themes-paren-match '(bold))
(setq modus-themes-org-blocks 'tinted-background)

(add-hook 'ns-system-appearance-change-functions
          (lambda (appearance)
            (mapc #'disable-theme custom-enabled-themes)
            (pcase appearance
              ('light (load-theme 'modus-operandi t))
              ('dark (load-theme 'modus-vivendi t)))))

;; --
;; Completion

(setq completion-auto-help t)
(setq completion-auto-select t)

;; Line numbers in prog modes
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; --
;; Font

(set-face-attribute 'default nil
                    :font "PragmataPro Mono Liga"
                    :height 140)
(setq-default line-spacing 6)

;; --
;; Custom modeline

(defun my/modeline (status name primary secondary)
  (let* ((left (concat status " " name))
         (right (concat primary " " secondary))
         (spacer-width (max 1 (- (window-width)
                                 (length left)
                                 (length right))))
         (spacer (make-string spacer-width ?\s)))
    (concat left spacer right)))

(setq-default mode-line-format
              '((:eval
                 (my/modeline
                  (let ((read-only buffer-read-only)
                        (modified (and buffer-file-name (buffer-modified-p))))
                    (cond (modified "**") (read-only "RO") (t "RW")))
                  (format-mode-line "%b")
                  (if (listp mode-name) (car mode-name) mode-name)
                  (format-mode-line "%l:%c")))))
