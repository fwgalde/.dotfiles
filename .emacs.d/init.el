(setq gc-cons-threshold (* 2 1000 1000))

(setq delete-by-moving-to-trash t)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
    (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-verbose t)
(use-package diminish)
(diminish 'org-indent-mode)
(diminish 'eldoc-mode)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-create-definer leader-keys
                          :keymaps '(normal insert visual emacs)
                          :prefix "SPC"
                          :global-prefix "C-SPC")
  (leader-keys
    "t" '(:ignore t :which-key "toggles theme")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(setq inhibit-startup-message t) ;; Desactiva la pantalla de inicio.
(setq toggle-truncate-lines nil) ;; Trunca las lineas para que sean visibles.
(scroll-bar-mode -1)        ; Disable scroll bar
(tooltip-mode -1)           ; Disable tooltips.
(tool-bar-mode -1)          ; Disable tool bar.
(set-fringe-mode 10)        ; Give some breathing room.
(fset 'yes-or-no-p 'y-or-n-p) ;; Change yes - y and no - n
(setq confirm-kill-emacs nil) ;; Confirm kill buffer
(menu-bar-mode -1)          ; Disable the menu bar

(set-face-attribute 'default nil :font "Jetbrains Mono" :height 120) ;; default font
(set-face-attribute 'fixed-pitch nil :font "Jetbrains Mono" :height 110) ;; programming font
(set-face-attribute 'variable-pitch nil :font "Cabin" :height 120 :weight 'regular) ;; notes font

(use-package doom-themes)

;; Loading theme based on the time.
(let ((hour (string-to-number (substring (current-time-string) 11 13))))
  (if (< hour 9)
      (load-theme 'doom-moonlight t)
    (load-theme 'doom-tomorrow-day t)))

(use-package all-the-icons
  :if (display-graphic-p))

(require 'dired)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
(setq dired-listing-switches
      "-AFghov --group-directories-first --time-style=long-iso")
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(use-package all-the-icons-dired
  :diminish
  :hook (dired-mode . all-the-icons-dired-mode))
(use-package dired-subtree
  :ensure t
  :after dired
  :bind (:map dired-mode-map
              ("<tab>" . dired-subtree-toggle)
              ("<C-tab>" . dired-subtree-cycle)
              ("<S-iso-lefttab>" . dired-subtree-remove)))

(use-package which-key
  :diminish which-key-mode
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 1))

(use-package centered-cursor-mode
  :diminish
  :demand
  :config
  (global-centered-cursor-mode))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("M-s l" . consult-line)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless))
  (completion-category-overrides '(
                                   (file (styles basic string))
                                   (buffer (styles basic string))
                                   (info-menu (styles basic string)))))

(defun org-setup ()
  (org-indent-mode t)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (diminish 'org-indent-mode)
  (diminish 'buffer-face-mode))

(use-package org :pin gnu
  :diminish org-src-mode
  :diminish visual-line-mode
  :hook (org-mode . org-setup)
  :hook (org-mode . org-font-setup)
  :custom
  (org-ellipsis " ▾ ") ;Other options  ⬎ ⤵
  :config
  (setq org-cycle-separator-lines 2
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-startup-folded t
        org-pretty-entities t ;; simbolos de org
        org-src-preserve-indentation nil
        org-hide-block-startup t
        org-hidden-keywords (quote(title author date email)))

  ;; org-agenda configuration
  (setq org-agenda-window-setup 'current-widow
        org-agenda-start-with-log-mode t
        org-log-done 'time
        org-log-into-drawer t)

  ;; org-agenda destinatin file
  (setq org-agenda-files
        '("~/Documents/OrgFiles/Tasks.org"))

  ;; org-agenda status
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n" "|" "DONE(d!)")
          (sequence "|" "WAIT(w)" "BACK(b)")))

  ;; Colors of own to-do items.
  (setq org-todo-faces
        '(("NEXT" . (:foreground "orange red" :weight bold))
          ("WAIT" . (:foreground "HotPink2" :weight bold))
          ("BACK" . (:foreground "MediumPurple3" :weight bold))))
  (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
          ("Tasks.org" :maxlevel . 1)))
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;; Tags of org-agenda
  (setq org-tag-alist
        '((:startgroup)
          (:endgroup)
          ("@homework" . ?H)
          ("@exams" . ?E)
          ("note" . ?n)
          ("idea" . ?i)))
  )

(with-eval-after-load 'org-faces
  (defun org-font-setup ()
    ;; Set faces for heading levels
    (dolist (face '(
                    (org-document-title . 1.7)
                    (org-document-info . 1.3)
                    (org-level-1 . 1.5)
                    (org-level-2 . 1.3)
                    (org-level-3 . 1.25)
                    (org-level-4 . 1.2)
                    (org-level-5 . 1.15)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.05)
                    (org-level-8 . 1.05)))
      (set-face-attribute (car face) nil :font "Montserrat" :weight 'bold :height (cdr face)))))

(with-eval-after-load 'org-faces
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode))
(setq org-hide-leading-stars nil
      org-superstar-leading-bullet ?\s
      org-indent-mode-turns-on-hiding-stars nil)

(setq org-list-allow-alphabetical t)
(setq org-list-demote-modify-bullet
      '(("+" . "*") ("*" . "-") ("-" . "+")))

(defun org-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . org-visual-fill))

(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-hide-emphasis-markers t)
  (setq org-appear-autoemphasis t)
  (setq org-appear-autolinks t))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("jv" .  "src java"))
(add-to-list 'org-structure-template-alist '("lua" .  "src lua"))
(add-to-list 'org-structure-template-alist '("r" . "src R"))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (java . t)
     (R . t)
     (python . t))))

(defun tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.dotfiles/.emacs.d/init.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'tangle-config)))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/RoamNotes")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n")
      :unnarrowed t)
     ("c" "Clase")
     ("ca" "Álgebra Lineal" plain
      (file "~/Documents/RoamNotes/Templates/ClassTemplate.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title} \n#+AUTHOR: Ugalde Ubaldo, Fernando. <f.ugalde@ciencias.unam.mx> \n#+DATE: %<%Y-%m-%d %a> \n#+filetags: AL1")
      :unnarrowed t)
     ("cc" "Matemáticas para las Ciencias Aplicadas" plain
      (file "~/Documents/RoamNotes/Templates/ClassTemplate.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title} \n#+AUTHOR: Ugalde Ubaldo, Fernando. <f.ugalde@ciencias.unam.mx> \n#+DATE: %<%Y-%m-%d %a> \n#+filetags: MCA3")
      :unnarrowed t)
     ("cy" "Modelado y Programación" plain
      (file "~/Documents/RoamNotes/Templates/ClassTemplate.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title} \n#+AUTHOR: Ugalde Ubaldo, Fernando. <f.ugalde@ciencias.unam.mx> \n#+DATE: %<%Y-%m-%d %a> \n#+filetags: MyP")
      :unnarrowed t)
     ("cp" "Probabilidad" plain
      (file "~/Documents/RoamNotes/Templates/ClassTemplate.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title} \n#+AUTHOR: Ugalde Ubaldo, Fernando. <f.ugalde@ciencias.unam.mx> \n#+DATE: %<%Y-%m-%d %a> \n#+filetags: P1")
      :unnarrowed t)
     ("cr" "R Programming Fundamentals" plain
      (file "~/Documents/RoamNotes/Templates/ClassTemplate.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title} \n#+AUTHOR: Ugalde Ubaldo, Fernando. <f.ugalde@ciencias.unam.mx> \n#+DATE: %<%Y-%m-%d %a> \n#+filetags: edx programming course")
      :unnarrowed t)
     )
   )
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i" . completion-at-point))
  :config (org-roam-setup))

(use-package magit
  :commands magit-status
  :ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)
;; Disable line number for some modes
(dolist (mode '(org-mode-hook
                dired-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)) ;; prog-mode es el modo de programación

(add-to-list 'before-save-hook 'delete-trailing-whitespace)

(defun setup-java-mode
    (subword-mode))
(add-hook 'java-mode-hook 'setup-java-mode)

(use-package ess)

(use-package company
  :diminish
  :hook
  (java-mode . company-mode)
  (emacs-lisp-mode . company-mode)
  (python-mode . company-mode)
  (lua-mode . company-mode)
  (R-mode . company-mode)

  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection))
  :custom
  (company-minimum-prefix-length 3)
  (company-idle-delay 0.0))

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (setq yas-snippet-dirs '("~/.dotfiles/.emacs.d/snippets"))
  (yas-global-mode 1))

(electric-pair-mode 1)
