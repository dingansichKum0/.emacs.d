;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom))

;; Title
(setq frame-title-format
      '("Emacs " emacs-version "@" user-login-name " : "
        (:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))
(setq icon-title-format frame-title-format)


;; Menu/Tool/Scroll bars
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))
(setq inhibit-startup-message t)
(setq-default initial-scratch-message nil)

;; paren hl
(show-paren-mode 1)
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
	(t (save-excursion
	     (ignore-errors (backward-up-list))
	     (funcall fn)))))


(defvar after-load-theme-hook nil
  "Hook run after a color theme is loaded using `load-theme'.")
(defadvice load-theme (after run-after-load-theme-hook activate)
  "Run `after-load-theme-hook'."
  (run-hooks 'after-load-theme-hook))


;;;;;;;;;;;;;;;;
;; Color Theme
;;;;;;;;;;;;;;;;
(setq kumo-current-theme kumo-theme)


;; theme factory macro
(defmacro theme-factory-macro (name load-name &rest config)
  "theme factory macro"
  `(use-package ,name
    :init
    (disable-theme kumo-current-theme)
    (load-theme (quote ,load-name) t)
    (setq kumo-current-theme (quote ,load-name))
    ,@config)
)


;; doom-theme-one
(defun doom-theme-one ()
  "doom-theme-one"
  (interactive)
  (theme-factory-macro doom-themes doom-one
                       :preface (defvar region-fg nil)
                       :config
                       (doom-themes-visual-bell-config)
                       (doom-themes-org-config)
                       (doom-themes-treemacs-config)))

(defun doom-theme-vibrant ()
  "doom-theme-vibrant"
  (interactive)
  (theme-factory-macro doom-themes doom-vibrant
                       :preface (defvar region-fg nil)
                       :config
                       (doom-themes-visual-bell-config)
                       (doom-themes-org-config)
                       (doom-themes-treemacs-config)))

;; monoka-theme
(defun monokai-theme ()
  "monokai-theme"
  (interactive)
  (theme-factory-macro monokai-theme monokai))

;; dracula-theme
(defun dracula-theme ()
  "dracula-theme"
  (interactive)
  (theme-factory-macro dracula-theme dracula))

;; material-theme
(defun material-theme ()
  "material-theme"
  (interactive)
  (theme-factory-macro material-theme material))

;; material-theme-light
(defun material-theme-light ()
  "material-theme-light"
  (interactive)
  (theme-factory-macro material-theme material-light))

;; srcery-theme
(defun srcery-theme ()
  "srcery-theme"
  (interactive)
  (theme-factory-macro srcery-theme srcery))

;; flucui-theme
(defun flucui-theme ()
  "flucui-theme"
  (interactive)
  (theme-factory-macro flucui-themes flucui-dark))

;; flucui-theme-light
(defun flucui-theme-light ()
  "flucui-theme-light"
  (interactive)
  (theme-factory-macro flucui-themes flucui-light))


;; init default theme
(cond
 ((eq kumo-theme 'doom-one)
  (doom-theme-one))

 ((eq kumo-theme 'doom-vibrant)
  (doom-theme-vibrant))
 
 ((eq kumo-theme 'monokai)
  (monokai-theme))

 ((eq kumo-theme 'dracula)
  (dracula-theme))

 ((eq kumo-theme 'material)
  (material-theme))

 ((eq kumo-theme 'material-light)
  (material-theme-light))

 ((eq kumo-theme 'srcery)
  (srcery-theme))

 ((eq kumo-theme 'flucui)
  (flucui-theme))

 ((eq kumo-theme 'flucui-light)
  (flucui-theme-light))

 (t
  (ignore-errors (load-theme kumo-theme t))))

;; change theme keymap
(with-eval-after-load 'general
  (general-define-key
    :prefix "C-c"
    "t0" 'doom-theme-one
    "t1" 'doom-theme-vibrant
    "t2" 'monokai-theme
    "t3" 'dracula-theme
    "t4" 'material-theme
    "t5" 'material-theme-light
    "t6" 'srcery-theme
    "t7" 'flucui-theme 
    "t8" 'flucui-theme-light 
    )
)


;;;;;;;;;;;;;;;;
;; Mode Line
;;;;;;;;;;;;;;;;
;; (use-package doom-modeline
;;       :ensure t
;;       :hook
;;       (after-init . doom-modeline-mode)
;;       :config
;;       (setq find-file-visit-truename t)
;;       (setq doom-modeline-project-detection 'project)
;;       ;; (setq doom-modeline-height 20)
;;       ;; (setq doom-modeline-major-mode-icon t)
;;       ;; (setq doom-modeline-major-mode-color-icon t)
;;       (setq doom-modeline-buffer-modification-icon t)
;;       (setq doom-modeline-height 1)
;;       (set-face-attribute 'mode-line nil :height 100)
;;       (set-face-attribute 'mode-line-inactive nil :height 100))

(use-package moody
  :ensure t
  :hook
  (after-init . moody-mode)
  :config
  (setq x-underline-at-descent-line t)
  (setq moody-mode-line-height 24)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
)


;; nyan-mode
(use-package nyan-mode
  :init 
  (nyan-mode t)
  :config
  (setq nyan-animate-nyancat t)
  (setq nyan-wavy-trail nil))



;; Line and Column
;;(setq-default fill-column 80)
;;(setq column-number-mode t)

(use-package smooth-scrolling
  :init (add-hook 'after-init-hook #'smooth-scrolling-mode)
  :config (setq smooth-scroll-margin 0
                scroll-conservatively 100000
                scroll-preserve-screen-position 1))

;; Misc
(fset 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-screen t)
(size-indication-mode 1)
(setq track-eol t)                      ; Keep cursor at end of lines. Require line-move-visual is nil.
(setq line-move-visual nil)

;; Don't open a file in a new frame
(when (boundp 'ns-pop-up-frames)
  (setq ns-pop-up-frames nil))

;; Don't use GTK+ tooltip
(when (boundp 'x-gtk-use-system-tooltips)
  (setq x-gtk-use-system-tooltips nil))

;; highlight
(use-package symbol-overlay)
(global-hl-line-mode t)

;; icons
(use-package all-the-icons
  :if (display-graphic-p)
  :init (unless (or sys/win32p (member "all-the-icons" (font-family-list)))
          (all-the-icons-install-fonts t))
  :config
  (add-to-list 'all-the-icons-mode-icon-alist
               '(vterm-mode all-the-icons-octicon "terminal" :v-adjust 0.2))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.xpm$" all-the-icons-octicon "file-media" :v-adjust 0.0 :face all-the-icons-dgreen))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.lua$" all-the-icons-fileicon "lua" :face all-the-icons-dblue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(lua-mode all-the-icons-fileicon "lua" :face all-the-icons-dblue))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.go$" all-the-icons-fileicon "go" :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(go-mode all-the-icons-fileicon "go" :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(help-mode all-the-icons-faicon "info-circle" :height 1.1 :v-adjust -0.1 :face all-the-icons-purple))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(Info-mode all-the-icons-faicon "info-circle" :height 1.1 :v-adjust -0.1))
  (add-to-list 'all-the-icons-icon-alist
               '("NEWS$" all-the-icons-faicon "newspaper-o" :height 0.9 :v-adjust -0.2))
  (add-to-list 'all-the-icons-icon-alist
               '("Cask\\'" all-the-icons-fileicon "elisp" :height 1.0 :v-adjust -0.2 :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(cask-mode all-the-icons-fileicon "elisp" :height 1.0 :v-adjust -0.2 :face all-the-icons-blue))
  (add-to-list 'all-the-icons-icon-alist
               '(".*\\.ipynb\\'" all-the-icons-fileicon "jupyter" :height 1.2 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(ein:notebooklist-mode all-the-icons-faicon "book" :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(ein:notebook-mode all-the-icons-fileicon "jupyter" :height 1.2 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(ein:notebook-multilang-mode all-the-icons-fileicon "jupyter" :height 1.2 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.epub\\'" all-the-icons-faicon "book" :height 1.0 :v-adjust -0.1 :face all-the-icons-green))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(nov-mode all-the-icons-faicon "book" :height 1.0 :v-adjust -0.1 :face all-the-icons-green))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(gfm-mode all-the-icons-octicon "markdown" :face all-the-icons-blue)))


(setq-default initial-scratch-message
              (concat ";; Happy hacking, " user-login-name " - Emacs ♥ you!\n\n"))

(provide 'init-ui)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-ui.el ends here
