(setq welcome-buffer-quotes '(
                     "\"Would it save you a lot of time if I just gave up and went mad now?\""
                     "\"Ford... you're turning into a penguin. Stop it.\""
                     "\"So long, and thanks for all the fish.\""
                     "\"Ford!\" he said, \"there's an infinite number of monkeys outside who want to talk to us about this script for Hamlet they've worked out.\""
                     ))

(defun insert-ascii-art ()
  (interactive)
  (let ((ascii-art "
    ____             _  __                         _     
   / __ \\____  ____ ( )/ /_     ____  ____ _____  (_)____
  / / / / __ \\/ __ \\|// __/    / __ \\/ __ \`/ __ \\/ / ___/
 / /_/ / /_/ / / / / / /_     / /_/ / /_/ / / / / / /__  
/_____/\\____/_/ /_/  \\__/    / .___/\\__,_/_/ /_/_/\\___/  
                            /_/                          
"))
    (let ((start (point)))  
      (let ((ascii-lines (split-string ascii-art "\n")))
        (dolist (line ascii-lines)  
          (let ((padding (calc-padding line))) 
            (insert (make-string padding ?\s) line "\n")))) 

      (let ((end (point)))  
        (put-text-property start end 'face '(:foreground "purple"))))))


(defun split-text (text tlen)
  (if (<= (length text) tlen)
      (list text)
    (let* ((last_space -1))
      (dotimes (i tlen)
	(when (eq (aref text i) ?\s)
	     (setq last_space i)))
      (if (eq last_space -1)
	  (cons
	   (substring text 0 tlen)
	   (split-text (substring text tlen) tlen))
	(cons
	 (substring text 0 (+ last_space 1))
	 (split-text (substring text (+ last_space 1)) tlen))
	)
      )))

(defun calc-padding (text)
  (let* ((buffw (window-width (selected-window)))
         (text-len (length text))
         (padding (max 0 (/ (- buffw text-len) 2))))
    padding))

(defun center-text (text)
  (let* ((phrases (split-text text 85))
         (padding (calc-padding (car phrases))))
    (progn
      (dotimes (i (length phrases))
               (progn
                 (insert (make-string padding ?\s))
                 (insert (nth i phrases))
                 (newline)
                 )))))

(defun center-image (path w h)
  (let* ((image (create-image path nil nil :width w :height h))
	 (ims (image-size image))
	 (imw (car ims))
	 (buffw (window-width (selected-window)))
	 (left-padding (max 0 (/ (- buffw imw) 2))))
    (insert (make-string (floor left-padding) ?\s))
    (insert-image image)
    )
  )



(defun add-text-icon-link (link_text icon link_value)
  (let* ((padding (- (calc-padding link_text) 1))) ;; add 2 to padding to account for icon space
    (progn
      (insert (make-string padding ?\s))
      (insert (propertize (concat link_text " ") 'face '(:height 1.2 :weight bold :foreground "purple")))
      (insert (nerd-icons-faicon icon))
      ;;(insert link_text " ")
      ;;(insert (nerd-icons-faicon icon))
      (make-text-button (- (point) (+ 2 (length link_text))) (- (point) 2)
          'action `(lambda (_) (browse-url ,link_value))
          'follow-link t))
    ))

(defun add-text-icon (link_text icon)
  (let* ((padding (- (calc-padding link_text) 1))) ;; add 2 to padding to account for icon space
    (progn
      (insert (make-string padding ?\s))
      (insert (propertize (concat link_text " ") 'face '(:height 1.2 :weight bold :foreground "purple")))
      (insert (nerd-icons-faicon icon))
    )))

(defun add-text-project (project_path title_padding)
  (let* ((padding (max 0(- (calc-padding project_path) 1)))) ;; add 2 to padding to account for icon space
    (progn
      (insert (make-string padding ?\s))
      (insert (concat project_path " "))
      (insert (nerd-icons-faicon "nf-fa-book"))
      ;;(insert link_text " ")
      ;;(insert (nerd-icons-faicon icon))
      (make-text-button (- (point) (+ 2 (length project_path))) (- (point) 2)
          'action `(lambda (_) (dired , project_path))
          'follow-link t))
      (newline)
    ))


(defun add-text-recent-file (project_path title_padding)
  (let* ((padding (max 0 (- (calc-padding project_path) 1)))) ;; add 2 to padding to account for icon space
    (progn
      (insert (make-string padding ?\s))
      (insert (concat project_path " "))
      (insert (nerd-icons-faicon "nf-fa-file"))
      ;;(insert link_text " ")
      ;;(insert (nerd-icons-faicon icon))
      (make-text-button (- (point) (+ 2 (length project_path))) (- (point) 2)
          'action `(lambda (_) (find-file , project_path))
          'follow-link t))
      (newline)
    ))
                                                                                  

;;(insert (propertize (nerd-icons-faicon "nf-fa-book") 'face '(:foreground "purple")))

(defun fetch-recent-projects ()
  (projectile-load-known-projects)
  projectile-known-projects)


(defun welcomeBuffer()
  (setq image-use-external-converter t)
  (with-current-buffer (get-buffer-create "welcomebuffer")
    (font-lock-mode -1)
    (erase-buffer)
    ;(insert "This is a test again")
    ;(insert-image
    ; (create-image "/home/buzz/Desktop/elisp/test.png" nil nil :width 200 :height 200))
    (newline 5)
    (insert-ascii-art)
    (newline)
    (center-text (nth (random (length welcome-buffer-quotes)) welcome-buffer-quotes))
    (newline 2)
    (add-text-icon-link "github" "nf-fa-github_alt" "https://github.com/frabazz")
    (newline 5)
    (setq-local project-text "Projects")
    (setq-local recent-files-text "Recent Files")
    (add-text-icon project-text "nf-fa-rocket")
    (newline 2)
    (dolist (x (fetch-recent-projects))
      (add-text-project x (- (calc-padding project-text) 1)))
    (newline 2)
    (add-text-icon recent-files-text "nf-fa-clock")
    (newline 2)
    (dolist (x recentf-list)
      (add-text-recent-file x (- (calc-padding project-text) 1)))
    (setq-local buffer-read-only t)
    ))


;;(welcomeBuffer)



;;(my-make-text-link "nf-fa-github" "https://github.com/frabazz")


(defun my-welcome-buffer ()
  "Crea e mostra il buffer di benvenuto dopo l'avvio completo di Emacs."
  (when (require 'nerd-icons nil t)  ;; Verifica che nerd-icons sia caricato
    (welcomeBuffer)  ;; Funzione che crea il buffer
    (switch-to-buffer "welcomebuffer")))

(add-hook 'emacs-startup-hook #'my-welcome-buffer)


