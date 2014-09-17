;; Load up package management, setup Marmalade, and load default package set
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/")
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(defvar my-packages '(ido-ubiquitous
		      clojure-mode
		      clojure-test-mode
		      paredit
		      org
		      nrepl
		      ruby-electric
		      rinari
		      flymake
		      flymake-ruby
		      color-theme-solarized))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Turn off the menu, toolbar, and scroll bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;; Load the solarized color theme
(custom-set-variables
 '(custom-safe-themes (quote ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default))))
(load-theme 'solarized-dark)


;; I like C-h for backspace (and 'M-x help' is good enough for help)
(global-set-key [(control h)] 'backward-delete-char-untabify)


;; Enable mouse and configure the scroll-wheel
(xterm-mouse-mode)
(global-set-key [(mouse-5)] '(lambda () (interactive) (scroll-up 1)))
(global-set-key [(mouse-4)] '(lambda () (interactive) (scroll-down 1)))


;; Save all backup and autosave files in one place (~/.saves)
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.saves"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)
(setq
 auto-save-file-name-transforms '((".*" "~/.saves" t)))


;; Enable IDO Mode Ubiquitously
(ido-mode t)
(ido-ubiquitous-mode t)
(setq ido-everywhere t)


;; Paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)


;; Some extras for Ruby
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (flymake-ruby-load)))


;; Speedbar hacks
(add-hook 'speedbar-mode-hook
	  (lambda ()
	    (speedbar-add-supported-extension "\\.rb")
	    (speedbar-add-supported-extension "\\.ru")
	    (speedbar-add-supported-extension "\\.erb")
	    (speedbar-add-supported-extension "\\.rjs")
	    (speedbar-add-supported-extension "\\.rhtml")
	    (speedbar-add-supported-extension "\\.rake")))


;; Dired hacks
(add-hook 'dired-mode-hook
	  (lambda ()
	    (define-key dired-mode-map (kbd "<return>")
	      'dired-find-alternate-file)
	    (define-key dired-mode-map (kbd "^")
	      (lambda () (interactive) (find-alternate-file "..")))))


;; A clever little buffer cycler...
(defvar LIMIT 1)
(defvar time 0)
(defvar mylist nil)

(defun time-now () 
  (cadr (current-time)))

(defun bubble-buffer () 
  (interactive) 
  (if (or (> (- (time-now) time) 1) (null mylist)) 
      (progn (setq mylist (copy-alist (buffer-list))) 
	     (delq (get-buffer " *Minibuf-0*") mylist)  
	     (delq (get-buffer " *Minibuf-1*") mylist))) 
  (bury-buffer (car mylist)) 
  (setq mylist (cdr mylist)) 
  (setq newtop (car mylist)) 
  (switch-to-buffer (car mylist)) 
  (setq rest (cdr (copy-alist mylist))) 
  (while rest 
    (bury-buffer (car rest)) 
    (setq rest (cdr rest))) 
  (setq time (time-now)))

(global-set-key (kbd "M-`") 'bubble-buffer)


;; Autoindent on return
(define-key global-map (kbd "RET") 'newline-and-indent)
(defun open-below ()
  (interactive)
  (next-line)
  (newline-and-indent))

(define-key global-map (kbd "C-m") 'open-below)

(defun line-start ()
  (interactive)
  (let ((cur-pos (point)))
    (back-to-indentation)
    (if (eq cur-pos (point))
	(move-beginning-of-line nil))))

(define-key global-map (kbd "C-a") 'line-start)

;; Autoindent on paste
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
	   (and (not current-prefix-arg)
		(member major-mode '(emacs-lisp-mode lisp-mode
						     clojure-mode    scheme-mode
						     haskell-mode    ruby-mode
						     rspec-mode      python-mode
						     c-mode          c++-mode
						     objc-mode       latex-mode
						     plain-tex-mode))
		(let ((mark-even-if-inactive transient-mark-mode))
		  (indent-region (region-beginning) (region-end) nil))))))
(put 'dired-find-alternate-file 'disabled nil)
