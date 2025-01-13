;;; -*- lexical-binding: t -*-
;;; init.el --- Emacs first Configuration.

(setq debug-on-error t)

(when (version< emacs-version "29")
  (error "This requires Emacs 29 and above!"))

;;;  Auto compile
(defun auto-compile-inits ()
  "Byte compile Lisp files modified in the directory."
  (interactive)
  (byte-recompile-directory (expand-file-name "inits/" default-directory) 0))

(add-hook 'kill-emacs-hook 'auto-compile-inits)

;; Init loader
(defvar main-dir user-emacs-directory
  "The root directory of my Emacs configuration.")

;; This help with Warning:
;; Your ‘load-path’ seems to contain your ‘user-emacs-directory’: .
;; This is likely to cause problems... Consider using a subdirectory instead
(setq user-emacs-directory (expand-file-name "savefiles/" main-dir))

;; Add user directory "elisp" to load-path
(push (expand-file-name "inits/" main-dir) load-path)

;;; System type
(defvar is-gui (eq window-system 'x) "Detect if we can run gui")
(defvar is-work-pc (if (string-match-p "ant.amazon.com\\'" system-name) t nil) "detect if this is the work laptop by hostname")
(defvar is-work-pc-cloud (if (string-match-p "^dev-dsk" system-name) t nil) "detect if this is the work cloud desktop")
(defvar is-android (eq system-type 'android) "detect if this is running on android")

;;; mu4e
;; pacman -Ql | grep mu4e
(when (not is-android)
  (add-to-list 'load-path 
  "/usr/share/emacs/site-lisp/mu4e"))

;; create a machine id field
(if (not is-android)
    (defconst machine-id (substring (string-trim-right (with-temp-buffer (insert-file-contents "/etc/machine-id") (buffer-string))) -4 nil)))

;; Faster to disable these here (before they've been initialized)
(when is-gui
  (push '(fullscreen . maximized) default-frame-alist))

;; Set transparency for gui
(when is-gui
  (push '(alpha . (90 . 90)) default-frame-alist))

(load "android")
(load "package-manager")

(use-package init-loader
  :functions init-locader-load
  :init (setq init-loader-byte-compile t)
  :config (init-loader-load (expand-file-name "inits/" main-dir)))

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((init-loader :url "https://github.com/emacs-jp/init-loader"
		  :lisp-dir (expand-file-name "lisps/" main-dir)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 ;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; init.el ends here
