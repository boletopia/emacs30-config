;;; init.el --- Emacs first Configuration. -*- lexical-binding: t -*-
;;; Commentary:
;;
;;; Code:
(setq debug-on-error t)

(when (version< emacs-version "29")
  (error "This requires Emacs 29 and above!"))

;; Bootstrap straight.el
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

;;;  Auto compile
(defun auto-compile-inits ()
  "Byte compile Lisp files modified in the directory."
  (interactive)
  (byte-recompile-directory (expand-file-name "elisp/" default-directory) 0)
  (byte-recompile-directory (expand-file-name "inits/" default-directory) 0))
(add-hook 'kill-emacs-hook 'auto-compile-inits)

;; Init loader
(defvar main-dir user-emacs-directory
  "The root directory of my Emacs configuration.")

;; This help with Warning:
; Your ‘load-path’ seems to contain your ‘user-emacs-directory’: .
; This is likely to cause problems... Consider using a subdirectory instead
(setq user-emacs-directory (expand-file-name "savefiles/" main-dir))

;; Add user directory "elisp" to load-path
; (push (expand-file-name "elisp/" main-dir) load-path)
(push (expand-file-name "inits/" main-dir) load-path)

(use-package init-loader :ensure t
  :straight '(init-loaderc
              :type git
              :host github
              :repo "emacs-jp/init-loader")
  :config
  (custom-set-variables
   '(init-loader-show-log-after-init 'error-only))
  (init-loader-load (concat main-dir "inits"))
  (setq custom-file (locate-user-emacs-file (expand-file-name "tmp/custom.el" main-dir))))


;;; System type
;; detect if we can run gui
(defconst is-gui (eq window-system 'x))


;; detect if this is the work laptop by hostname
(defconst is-work-pc (if (string-match-p "ant.amazon.com\\'" system-name)
    t nil))


;; detect if this is the work cloud desktop
(defconst is-work-pc-cloud (if (string-match-p "^dev-dsk" system-name)
                         t nil))


;; detect if this is running on android
(defconst is-android (eq system-type 'android))


;; create a machine id field
(if (not is-android)
    (defconst machine-id (substring (string-trim-right (with-temp-buffer (insert-file-contents "/etc/machine-id") (buffer-string))) -4 nil)))


;; Faster to disable these here (before they've been initialized)
(when is-gui
  (push '(fullscreen . maximized) default-frame-alist))


;; Set transparency for gui
(when is-gui
  (push '(alpha . (90 . 90)) default-frame-alist))


(provide 'init)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; init.el ends here
