;; disable toolbar and menu bar
(server-start) 
(menu-bar-mode 0)
(tool-bar-mode 0)
(setq-default cursor-type 'bar)
(global-display-line-numbers-mode 1)
;; TODO: check if font exists, should add ttf?
(set-frame-font "-JB-JetBrains Mono-regular-normal-normal-*-15-*-*-*-m-0-iso10646-1" nil t)

;; MELPA
(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;;(setq lsp-keymap-prefix "C-c l")

;(require 'lsp-mode)
;(add-hook 'c++-mode-hook #'lsp)



(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-idle-delay 0.0))


(require 'company)
(company-mode 1)
(add-hook 'after-init-hook 'global-company-mode)
;;(setq company-minimum-prefix-length 1)
;;(use-package company-box
;;  :hook (company-mode . company-box-mode))

;; M-X completion and other stuff
(use-package vertico
  :init
  (vertico-mode)
  )

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
  (setq read-extended-command-predicate #'command-completion-default-include-p))



;;which-key
(require 'which-key)
(which-key-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-minimum-prefix-length 1)
 '(custom-enabled-themes '(doom-horizon))
 '(custom-safe-themes
   '("dc8285f7f4d86c0aebf1ea4b448842a6868553eded6f71d1de52f3dcbc960039" "02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" "631c52620e2953e744f2b56d102eae503017047fb43d65ce028e88ef5846ea3b" "a138ec18a6b926ea9d66e61aac28f5ce99739cf38566876dc31e29ec8757f6e2" default))
 '(package-selected-packages
   '(doom-themes list-packages-ext lsp-ui lsp-mode company which-key vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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
