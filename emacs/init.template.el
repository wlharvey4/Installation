;;; -*- mode: emacs-lisp; -*-

;;; ~/.emacs.d/init.el
;;; Time-stamp: <2023-01-01 19:17:39 minilolh3>

(defconst +INIT-FILE+  (expand-file-name
			(locate-user-emacs-file "init.el"))
  "The location of this file.")

;;; Initial Frame setup and Global features

;;; Specifying  (fullscreen  .  fullboth)  results  in  garbage  being
;;; written  to the  terminal  when  this Emacs  is  started from  the
;;; terminal, so don't do that.
(setq initial-frame-alist
      '((left . 0)
	(top . 0)
	(width . 200)
	(fullscreen . fullheight))) ; maximize initial frame height
(setq inhibit-startup-screen t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)
(add-hook 'before-save-hook 'time-stamp)
(global-display-line-numbers-mode)


;;; Packages
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


;;; Server
;;; Call `emacsclient` to use this server
(require 'server)
(when (display-graphic-p)
  (unless (server-running-p)
    (server-start)
    (message "server started.")))


;;; Org Mode
;; Enable global keybindings
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(require 'org-tempo)


;; Disable confirmation of evaluation requests
(setq org-confirm-babel-evaluate nil) ; disable confirmation requests
(setq org-link-shell-confirm-link-function nil) ; disable confirmation requests
(setq org-link-elisp-confirm-function nil) ; disable confirmation requests


;;; Org Babel
;; Activate additional languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((scheme . t)
   (lisp . t)))


;;; Slime
;; TODO: Utilize ENVIRONMENT VARIABLES instead of hard-coding all of these in.
(add-to-list 'load-path
	     (expand-file-name
	      (file-name-concat user-emacs-directory "src/slime")))
(require 'slime-autoloads)
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-lisp-implementations
      '((sbcl ("/usr/local/bin/sbcl" "--noinform") :coding-system utf-8-unix)
	(ccl ("/usr/local/ccl/ccl-1.12/ccl-1.12.1/dx86cl64"))
        (clisp ("/opt/local/bin/clisp"))))
(slime-setup  '(slime-repl slime-asdf slime-fancy slime-banner))


;;; ParEdit customizations
;; Start Paredit Mode on the fly with `M-x enable-paredit-mode RET',
;; To ennable it in a major mode
;; (add-hook 'M-mode-hook 'enable-paredit-mode)

;; Use ParEdit with Emacs’ Lisp modes:
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
; (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1))) ; why not 'enable-paredit-mode?

;; NOTE: consider experimenting with this code.
;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('
;; (defun override-slime-repl-bindings-with-paredit ()
;;   (define-key slime-repl-mode-map
;;               (read-kbd-macro paredit-backward-delete-key) nil))
;; (add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

;;; ElDoc customization
;; ElDoc is enabled by default.
;; To use ParEdit with ElDoc, you should make ElDoc aware of ParEdit’s
;; most used commands.   Whenever the listed commands  are used, ElDoc
;; will automatically refresh the minibuffer.
(eldoc-add-command
 'paredit-backward-delete
 'paredit-close-round)

;;; CLHS Use Local
(load "/usr/local/quicklisp/quicklisp/clhs-use-local.el" t)
;; Use C-c C-d h make-instance RET to test if the change was successful.

;;; Backup Configuration
(setf make-backup-files t
      backup-by-copying t
      version-control t
      delete-old-versions 'never
      backup-directory-alist '(("init.*.el" . "./.~/")))


;;; INIT-FILE Functions
(defun init-open ()
  "Open init.el into a buffer quickly."
  (interactive)
  (find-file +INIT-FILE+))

(defun init-eval ()
  "Evaluate the init.el file anew."
  (interactive)
  (with-current-buffer (find-file-noselect +INIT-FILE+)
    (eval-buffer)))

(defconst +INIT-TEMPLATE+ "/usr/local/dev/programs/shell/installation/emacs/init.template.el"
  "The place to save the template file.")

(defun template-to-init ()
  "Save the init-template file as the new init-file.  Backup the init-file first.
Evaluate it anew."
  (interactive)
  (file-backup +INIT-FILE+)
  (copy-file +INIT-TEMPLATE+ +INIT-FILE+)
  (find-file +INIT-FILE+))

(defun init-to-template ()
  "Save this init.el file as a template.
Currently it will be saved as:
/usr/local/dev/programs/shell/installation/emacs/init.template.el."
  (interactive)
  (file-backup +INIT-TEMPLATE+)
  (copy-file +INIT-FILE+ +INIT-TEMPLATE+ t))

(defun file-backup (file)
  "Backup a file into using `backup-directory-alist` after giving it a new time-stamp."
  (with-current-buffer (find-file-noselect file)
    (time-stamp)
    (save-buffer 64)
    (kill-buffer)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(paredit geiser-guile geiser))
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Local Variables:
;; End:
