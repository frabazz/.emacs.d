;; disable toolbar and menu bar
(server-start) 
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq-default cursor-type 'bar)
;;(global-display-line-numbers-mode 1)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq make-backup-files nil) ;; no backup files
(setq backup-directory-alist            '((".*" . "~/.Trash")))
(set-face-attribute 'default nil :height 130)
;; TODO: check if font exists, should add ttf?
;;(set-frame-font "-JB-JetBrains Mono-regular-normal-normal-*-15-*-*-*-m-0-iso10646-1" nil t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(setq package-enable-at-startup nil)
(use-package vterm
  :config
  (setq vterm-shell "zsh")
  (add-hook 'vterm-set-title-functions 'vterm--rename-buffer-as-title))
;; MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(setq +format-with-lsp nil)
(setq-default tab-width 1)
(setq-default indent-tabs-mode nil)
;;(setq lsp-keymap-prefix "C-c l")

;(require 'lsp-mode)
;(add-hook 'c++-mode-hook #'lsp)

(use-package corfu
  ;; Optional customizations
  ;; :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches

  ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode))

;;TODO: fix
;;(use-package eglot-booster
;;	:after eglot
;;	:config	(eglot-booster-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  ;:custom
  ; (kind-icon-blend-background t)
  ; (kind-icon-default-face 'corfu-default) ; only needed with blend-background
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; M-X completion and other stuff
(use-package vertico
  :init
  (vertico-mode)
  )

(setq corfu-auto t)

(use-package recentf
  :init
  (setq
    recentf-max-saved-items 10000
    recentf-max-menu-items 5000
    )
  (recentf-mode 1)
  (run-at-time nil (* 5 60) 'recentf-save-list)
  )

(setq recentf-max-saved-items 5)
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Support opening new minibuffers from inside existing minibuffers.
  (setq enable-recursive-minibuffers t)

  ;; Emacs 28 and newer: Hide commands in M-x which do not work in the current
  ;; mode.  Vertico commands are hidden in normal buffers. This setting is
  ;; useful beyond Vertico.
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  :custom
  (text-mode-ispell-word-completion nil)
)


(use-package projectile
  :ensure t
  :init
  (setq projectile-project-search-path '("~/projects/" "~/work/" "~/playground"))
  :config
  ;; I typically use this keymap prefix on macOS
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  ;; On Linux, however, I usually go with another one
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(setq TeX-PDF-mode t)
(setq TeX-default-mode #'LaTeX-mode ;; should already be the default mode
      TeX-force-default-mode t)
;;(setq TeX-command-default nil)
(defun my-auto-compile-latex ()
  "Compila automaticamente il documento LaTeX quando viene salvato."
  (when (eq major-mode 'LaTeX-mode)
    (TeX-command TeX-command-default 'TeX-master-file)))
(eval-after-load "latex"
(add-hook 'after-save-hook #'my-auto-compile-latex))

(use-package yasnippet
  :ensure t
  :hook ((text-mode
          prog-mode
          conf-mode
          snippet-mode) . yas-minor-mode-on) 
  :config
  (define-key yas-minor-mode-map (kbd "SPC") yas-maybe-expand)
  (yas-reload-all)
  :init
  (setq yas-snippet-dir "~/.emacs.d/snippets/")
  
  )

(load (expand-file-name "welcome.el" (file-name-directory user-init-file)))

;;which-key
(require 'which-key)
(which-key-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   '(((output-dvi has-no-display-manager) "dvi2tty")
     ((output-dvi style-pstricks) "dvips and gv")
     (output-dvi "Zathura") (output-pdf "Zathura")
     (output-html "xdg-open")))
 '(company-minimum-prefix-length 1)
 '(custom-enabled-themes '(doom-horizon))
 '(custom-safe-themes
   '("4990532659bb6a285fee01ede3dfa1b1bdf302c5c3c8de9fad9b6bc63a9252f7"
     "dc8285f7f4d86c0aebf1ea4b448842a6868553eded6f71d1de52f3dcbc960039"
     default))
 '(package-selected-packages
   '(auctex company direnv doom-modeline doom-themes eglot-booster
            fancy-compilation format-all lsp-java magit mood-line mvn
            nix-mode projectile sudo-edit vertico vterm which-key
            yasnippet))
 '(package-vc-selected-packages
   '((eglot-booster :vc-backend Git :url
                    "https://github.com/jdtsmith/eglot-booster"))))



(use-package doom-modeline
  :ensure t
 :init (doom-modeline-mode 1))


;;custom key bindings



(define-prefix-command 'custom-window-prefix)
;; Bind C-w to the custom prefix command
(global-set-key (kbd "C-w") 'custom-window-prefix)

(global-set-key (kbd "C-w v") #'split-window-right)
(global-set-key (kbd "C-w h") #'split-window-below)
(global-set-key (kbd "C-w k") #'delete-window)
(global-set-key (kbd "C-w <right>") #'windmove-right)
(global-set-key (kbd "C-w <left>")  #'windmove-left)
(global-set-key (kbd "C-w <up>") #'windmove-up)
(global-set-key (kbd "C-w <down>") #'windmove-down)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq inhibit-startup-message t)     ;; Disabilita il messaggio di benvenuto
(setq inhibit-startup-screen t)      ;; Disabilita lo splash screen
(setq initial-buffer-choice nil)
(setq initial-buffer-choice (lambda () 
                              (welcomeBuffer)   ;; Chiama la funzione che crea il buffer
                              (get-buffer "welcomebuffer")))  ;; Restituisce il buffer creato
(switch-to-buffer "welcomebuffer")

